//
//  LongLegVertexAttribArrayBuffer.h
//  OpenGL_ES_Filter_04
//
//  Created by tlab on 2020/8/31.
//  Copyright © 2020 yuanfangzhuye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface LongLegVertexAttribArrayBuffer : NSObject

//初始化缓存区
- (id)initWithAttribStride:(GLsizei)stride
           numberOfVertices:(GLsizei)count
                         data:(const GLvoid *)data
                        usage:(GLenum)usage;

//准备绘制(打开通道,以及传递属性)
- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable;

//绘制
- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count;

//更新(重新开辟缓存区)
- (void)updateDataWithAttribStride:(GLsizei)stride
                  numberOfVertices:(GLsizei)count
                              data:(const GLvoid *)data
                             usage:(GLenum)usage;

@end
