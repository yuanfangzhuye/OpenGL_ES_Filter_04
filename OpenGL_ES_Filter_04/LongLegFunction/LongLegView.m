//
//  LongLegView.m
//  OpenGL_ES_Filter_04
//
//  Created by tlab on 2020/8/31.
//  Copyright © 2020 yuanfangzhuye. All rights reserved.
//

#import "LongLegView.h"
#import "LongLegHelper.h"
#import "LongLegVertexAttribArrayBuffer.h"

//初始纹理高度占控件高度的比例
static CGFloat const kDefaultOriginTExtureHeight = 0.7f;

//顶点数量
static NSInteger const kVerticesCount = 8;

//结构体
typedef struct {
    GLKVector3 positionCoord;  //顶点坐标
    GLKVector2 textureCoord;  //纹理坐标
} SenceVertex;

@interface LongLegView ()<GLKViewDelegate>

//Effect
@property (nonatomic, strong) GLKBaseEffect *baseEffect;

//顶点
@property (nonatomic, assign) SenceVertex *vertices;

//顶点数组缓冲区
@property (nonatomic, strong) LongLegVertexAttribArrayBuffer *vertexAttribArrayBuffer;

//当前图片 size
@property (nonatomic, assign) CGSize currentImageSize;

//是否有发现修改
@property (nonatomic, assign, readwrite) BOOL hasChange;

//当前纹理的 width
@property (nonatomic, assign) CGFloat currentTextureWidth;

//临时创建的帧缓存和纹理缓存
@property (nonatomic, assign) GLuint tmpFrameBuffer;
@property (nonatomic, assign) GLuint tmpTexture;

// 用于重新绘制纹理
//当前纹理Y的开始位置;
@property (nonatomic, assign) CGFloat currentTextureStartY;
//当前纹理Y的结束位置;
@property (nonatomic, assign) CGFloat currentTextureEndY;
//当前纹理新的高度;
@property (nonatomic, assign) CGFloat currentNewHeight;

@end

@implementation LongLegView

- (void)dealloc {
    
    //销毁conext
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    //销毁_vertices
    if (_vertices) {
        free(_vertices);
        _vertices = nil;
    }
    
    //销毁帧缓存区
    if (_tmpFrameBuffer) {
        glDeleteBuffers(1, &_tmpFrameBuffer);
        _tmpFrameBuffer = 0;
    }
    
    //销毁纹理
    if (_tmpTexture) {
        glDeleteBuffers(1, &_tmpTexture);
        _tmpTexture = 0;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    //1.初始化vertices, context
    self.vertices = malloc(sizeof(SenceVertex) * kVerticesCount);
    self.backgroundColor = [UIColor clearColor];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.delegate = self;
    
    [EAGLContext setCurrentContext:self.context];
    glClearColor(0, 0, 0, 0);
    
    //2.初始化vertexAttribArrayBuffer
    self.vertexAttribArrayBuffer = [[LongLegVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SenceVertex) numberOfVertices:kVerticesCount data:self.vertices usage:GL_STATIC_DRAW];
}

- (void)calculateOriginTextureCoordWithTextureSize:(CGSize)size startY:(CGFloat)startY endY:(CGFloat)endY newHeight:(CGFloat)newHeight {
    
    NSLog(@"%f, %f", size.height, size.width);
    
    //1.计算拉伸后的宽高比
    CGFloat ratio = (size.height / size.width) * (self.bounds.size.width / self.bounds.size.height);
    //2.宽度 = 纹理本身宽度
    CGFloat textureWidth = self.currentTextureWidth;
    //3.高度 = 纹理高度*ratio（宽高比）
    CGFloat textureHeight = textureWidth * ratio;
    NSLog(@"%f, %f, %f, %f", newHeight, endY, startY, textureHeight);
    
    //4.拉伸量（newHeight - (endY - startY)）* 纹理高度
    CGFloat delta = (newHeight - (endY - startY)) * textureHeight;
    
    //5.判断纹理高度+拉伸是否超出最大值1
    if (textureHeight + delta >= 1) {
        delta = 1 - textureHeight;
        newHeight = delta / textureHeight + (endY - startY);
    }
    
    //6.纹理4个角的顶点
    GLKVector3 pointLT = {-textureWidth, textureHeight + delta, 0}; //左上角
    GLKVector3 pointRT = {textureWidth, textureHeight + delta, 0}; //右上角
    GLKVector3 pointLB = {-textureWidth, -textureHeight - delta, 0}; //左下角
    GLKVector3 pointRB = {textureWidth, -textureHeight - delta, 0}; //右下角
    
    //中间矩形区域的顶点
    CGFloat tempStartYCoord = textureHeight - 2 * textureHeight * startY;
    CGFloat tempEndYCoord = textureHeight - 2 * textureHeight * endY;
    
    CGFloat startYCoord = MIN(tempStartYCoord, textureHeight);
    CGFloat endYCoord = MAX(tempEndYCoord, -textureHeight);
    
    GLKVector3 centerPointLT = {-textureWidth, startYCoord + delta, 0};  //中间部分左上角
    GLKVector3 centerPointRT = {textureWidth, startYCoord + delta, 0};  //中间部分右上角
    GLKVector3 centerPointLB = {-textureWidth, endYCoord - delta, 0};  //中间部分左下角
    GLKVector3 centerPointRB = {textureWidth, endYCoord - delta, 0};  //中间部分右下角
    
    //--纹理上面两个顶点
    self.vertices[0].positionCoord = pointRT;
    self.vertices[0].textureCoord = GLKVector2Make(1, 1);
    
    self.vertices[1].positionCoord = pointLT;
    self.vertices[1].textureCoord = GLKVector2Make(0, 1);
    
    //--中间区域的4个顶点
    self.vertices[2].positionCoord = centerPointRT;
    self.vertices[2].textureCoord = GLKVector2Make(1, 1 - startY);
    
    self.vertices[3].positionCoord = centerPointLT;
    self.vertices[3].textureCoord = GLKVector2Make(0, 1 - startY);
    
    self.vertices[4].positionCoord = centerPointRB;
    self.vertices[4].textureCoord = GLKVector2Make(1, 1 - endY);
    
    self.vertices[5].positionCoord = centerPointLB;
    self.vertices[5].textureCoord = GLKVector2Make(0, 1 - endY);
    
    //--纹理的下面两个顶点
    self.vertices[6].positionCoord = pointRB;
    self.vertices[6].textureCoord = GLKVector2Make(1, 0);
    
    self.vertices[7].positionCoord = pointLB;
    self.vertices[7].textureCoord = GLKVector2Make(0, 0);
    
    self.currentTextureStartY = startY;
    self.currentTextureEndY = endY;
    self.currentNewHeight = newHeight;
}

- (void)updateImage:(UIImage *)image {
    
    //记录SpringView是否发生拉伸动作
    self.hasChange = NO;
    
    //1.GLKTextureInfo 设置纹理参数
    NSDictionary *options = @{GLKTextureLoaderOriginBottomLeft: @(YES)};
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:[image CGImage] options:options error:NULL];
    
    //2.创建 GLKBaseEffect 方法
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.texture2d0.name = textureInfo.name;
    
    //3.记录当前图片的size = 图片本身的size
    self.currentImageSize = image.size;
    
    //4.计算出图片的宽高比例
    CGFloat ratio = (self.currentImageSize.height / self.currentImageSize.width) * (self.bounds.size.width / self.bounds.size.height);
    
    //5. 获取纹理的高度
    CGFloat textureHeight = MIN(ratio, kDefaultOriginTExtureHeight);
    
    //6. 根据纹理的高度以及宽度, 计算出图片合理的宽度
    self.currentTextureWidth = textureHeight / ratio;
    
    //7.根据当前控件的尺寸以及纹理的尺寸,计算纹理坐标以及顶点坐标;
    [self calculateOriginTextureCoordWithTextureSize:self.currentImageSize startY:0 endY:0 newHeight:0];
    //8. 更新顶点数组缓存区
    [self.vertexAttribArrayBuffer updateDataWithAttribStride:sizeof(SenceVertex) numberOfVertices:kVerticesCount data:self.vertices usage:GL_STATIC_DRAW];
    
    //9. 显示(绘制)
    [self display];
}

- (void)glkView:(nonnull GLKView *)view drawInRect:(CGRect)rect {
    
    //1.准备绘制GLBaseEffect
    [self.baseEffect prepareToDraw];
    
    //2.清空缓存区
    glClear(GL_COLOR_BUFFER_BIT);
    
    //3.准备绘制数据-顶点数据
    [self.vertexAttribArrayBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SenceVertex, positionCoord) shouldEnable:YES];
    
    //4.准备绘制数据-纹理坐标数据
    [self.vertexAttribArrayBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SenceVertex, textureCoord) shouldEnable:YES];
    
    //5.开始绘制
    [self.vertexAttribArrayBuffer drawArrayWithMode:GL_TRIANGLE_STRIP startVertexIndex:0 numberOfVertices:kVerticesCount];
}

@end
