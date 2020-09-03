//
//  ViewController.m
//  OpenGL_ES_Filter_04
//
//  Created by tlab on 2020/8/17.
//  Copyright © 2020 yuanfangzhuye. All rights reserved.
//

#import "ViewController.h"
#import "LongLegView.h"

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
 
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<LongLegViewViewDelegate>

@property (nonatomic, strong) LongLegView *springView;

@property (nonatomic, strong) UIView *lineTopView;
@property (nonatomic, strong) UIView *lineBottomView;

@property (nonatomic, strong) UIView *mask;

@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UISlider *bottonSlider;

// 上方横线距离纹理顶部的高度
@property (nonatomic, assign) CGFloat currentTop;
// 下方横线距离纹理顶部的高度
@property (nonatomic, assign) CGFloat currentBottom;

@property (nonatomic, assign) NSLayoutConstraint *topLineSpace;
@property (nonatomic, assign) NSLayoutConstraint *bottomLineSpace;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
    [self.view addSubview:self.springView];
    self.springView.springDelegate = self;
    
    [self.springView updateImage:[UIImage imageNamed:@"YM.png"]];
    
    [self setupStretchArea];
    [self setupInitFrame];
}


- (void)setupUI {
    
    [self.view addSubview:self.lineTopView];
    
    [self.view addSubview:self.topButton];
    [self.topButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanTop:)]];
    
    [self.view addSubview:self.mask];
    
    [self.view addSubview:self.lineBottomView];
    
    [self.view addSubview:self.bottomButton];
    [self.bottomButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanBottom:)]];
    
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.bottonSlider];
}

- (void)setupStretchArea {
    self.currentTop = 0.25f;
    self.currentBottom = 0.75f;
    
    CGFloat textureOriginHeight = 0.7f;
    self.topLineSpace.constant = ((self.currentTop * textureOriginHeight) + (1 - textureOriginHeight) / 2) * self.springView.bounds.size.height;
    self.bottomLineSpace.constant = ((self.currentBottom * textureOriginHeight) + (1 - textureOriginHeight) / 2) * self.springView.bounds.size.height;
}

- (CGFloat)stretchAreaYWithLineSpace:(CGFloat)lineSpace {
    
    return (lineSpace / self.springView.bounds.size.height - self.springView.textureTopY) / self.springView.textureHeight;
}

- (void)setupInitFrame {
    NSLog(@"1111-%f-%f-%f", self.springView.frame.origin.y, self.topLineSpace.constant, self.bottomLineSpace.constant);
    self.lineTopView.frame = CGRectMake(20, self.springView.frame.origin.y + self.topLineSpace.constant, kScreenWidth - 40, 1);
    self.topButton.frame = CGRectMake(kScreenWidth - 40, self.springView.frame.origin.y + self.topLineSpace.constant - 20, 40, 40);
    self.mask.frame = CGRectMake(20, self.springView.frame.origin.y + self.topLineSpace.constant + 1, kScreenWidth - 40, self.bottomLineSpace.constant - self.topLineSpace.constant);
    self.lineBottomView.frame = CGRectMake(20, self.springView.frame.origin.y + self.bottomLineSpace.constant, kScreenWidth - 40, 1);
    self.bottomButton.frame = CGRectMake(kScreenWidth - 40, self.springView.frame.origin.y + self.bottomLineSpace.constant - 20, 40, 40);
}

- (void)actionPanTop:(UIPanGestureRecognizer *)pan {
    
}

- (void)actionPanBottom:(UIPanGestureRecognizer *)pan {
    
}


#pragma mark - SliderAction
//当Slider的值发生改变时,直接影响springView中纹理的计算
- (void)sliderValueDidChanged:(UISlider *)sender {
   
}

//当SliderTouchDown时,则隐藏控件;
- (void)sliderDidTouchDown:(id)sender {
    [self setViewsHidden:YES];
}

//当sliderDidTouchUp时,则显示控件;
- (void)sliderDidTouchUp:(id)sender {
    [self setViewsHidden:NO];
}

//相关控件隐藏功能
- (void)setViewsHidden:(BOOL)hidden {
    self.lineTopView.hidden = hidden;
    self.lineBottomView.hidden = hidden;
    self.topButton.hidden = hidden;
    self.bottomButton.hidden = hidden;
    self.mask.hidden = hidden;
}


#pragma mark ------ setter、getter

- (LongLegView *)springView {
    if (!_springView) {
        _springView = [[LongLegView alloc] initWithFrame:CGRectMake(30, [[UIApplication sharedApplication] statusBarFrame].size.height, kScreenWidth - 60, kScreenHeight - [[UIApplication sharedApplication] statusBarFrame].size.height)];
    }
    
    return _springView;
}

- (UIView *)lineTopView {
    if (!_lineTopView) {
        _lineTopView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineTopView.backgroundColor = [UIColor redColor];
    }
    
    return _lineTopView;
}

- (UIButton *)topButton {
    if (!_topButton) {
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.frame = CGRectZero;
        _topButton.layer.cornerRadius = 20.0f;
        _topButton.clipsToBounds = YES;
        _topButton.backgroundColor = [UIColor redColor];
        _topButton.layer.borderWidth = 1;
        _topButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    return _topButton;
}

- (UIView *)mask {
    if (!_mask) {
        _mask = [[UIView alloc] initWithFrame:CGRectZero];
        _mask.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    }
    
    return _mask;
}

- (UIView *)lineBottomView {
    if (!_lineBottomView) {
        _lineBottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineBottomView.backgroundColor = [UIColor redColor];
    }
    
    return _lineBottomView;
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.backgroundColor = [UIColor redColor];
        _bottomButton.frame = CGRectZero;
        _bottomButton.layer.cornerRadius = 20.0f;
        _bottomButton.clipsToBounds = YES;
        _bottomButton.layer.borderWidth = 1;
        _bottomButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    return _bottomButton;
}


-(UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(50, kScreenHeight - (IPHONE_X ? 84 : 50) - 10, 50, 50);
        _saveButton.backgroundColor = [UIColor redColor];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    return _saveButton;
}

- (UISlider *)bottonSlider {
    if (!_bottonSlider) {
        _bottonSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, kScreenHeight - (IPHONE_X ? 84 : 50) + 5, kScreenWidth - 160, 20)];
        [_bottonSlider addTarget:self action:@selector(sliderDidTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        [_bottonSlider addTarget:self action:@selector(sliderDidTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [_bottonSlider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _bottonSlider;
}


#pragma mark - MFSpringViewDelegate
//代理方法(SpringView拉伸区域修改)
- (void)springViewStretchAreaDidChanged:(LongLegView *)springView {
    
    //拉伸结束后,更新topY,bottomY,topLineSpace,bottomLineSpace 位置;
    CGFloat topY = self.springView.bounds.size.height * self.springView.stretchAreaTopY;
    CGFloat bottomY = self.springView.bounds.size.height * self.springView.stretchAreaBottomY;
    self.topLineSpace.constant = topY;
    self.bottomLineSpace.constant = bottomY;
}


@end
