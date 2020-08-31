//
//  ViewController.m
//  OpenGL_ES_Filter_04
//
//  Created by tlab on 2020/8/17.
//  Copyright © 2020 yuanfangzhuye. All rights reserved.
//

#import "ViewController.h"
#import "LongLegView.h"

//获取导航栏+状态栏的高度
#define rectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height
 
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<LongLegViewViewDelegate>

@property (nonatomic, strong) LongLegView *springView;

@property (nonatomic, strong) UIView *lineTopView;
@property (nonatomic, strong) UIView *lineBottomView;

@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UISlider *bottonSlider;

// 上方横线距离纹理顶部的高度
@property (nonatomic, assign) CGFloat currentTop;
// 下方横线距离纹理顶部的高度
@property (nonatomic, assign) CGFloat currentBottom;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
    [self.view addSubview:self.springView];
    self.springView.springDelegate = self;
    
    [self.springView updateImage:[UIImage imageNamed:@"YM.png"]];
}


- (void)setupUI {
    
    [self.view addSubview:self.lineTopView];
    
    [self.view addSubview:self.topButton];
    [self.topButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanTop:)]];
    
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
    
}

- (void)actionPanTop:(UIPanGestureRecognizer *)pan {
    
}

- (void)actionPanBottom:(UIPanGestureRecognizer *)pan {
    
}


#pragma mark ------ setter、getter

- (LongLegView *)springView {
    if (!_springView) {
        _springView = [[LongLegView alloc] initWithFrame:CGRectMake(0, rectNavAndStatusHight, kScreenWidth, kScreenHeight - rectNavAndStatusHight)];
    }
    
    return _springView;
}

- (UIView *)lineTopView {
    if (!_lineTopView) {
        _lineTopView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, kScreenWidth - 60, 1)];
        _lineTopView.backgroundColor = [UIColor redColor];
    }
    
    return _lineTopView;
}

- (UIButton *)topButton {
    if (!_topButton) {
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.frame = CGRectMake(kScreenWidth - 60, 80, 40, 40);
        _topButton.layer.cornerRadius = 20.0f;
        _topButton.clipsToBounds = YES;
        _topButton.backgroundColor = [UIColor redColor];
        _topButton.layer.borderWidth = 1;
        _topButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    return _topButton;
}

- (UIView *)lineBottomView {
    if (!_lineBottomView) {
        _lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(20, 150, kScreenWidth - 60, 1)];
        _lineBottomView.backgroundColor = [UIColor redColor];
    }
    
    return _lineBottomView;
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.backgroundColor = [UIColor redColor];
        _bottomButton.frame = CGRectMake(kScreenWidth - 60, 130, 40, 40);
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
        _saveButton.frame = CGRectMake(50, kScreenHeight - 60, 40, 40);
        _saveButton.backgroundColor = [UIColor redColor];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    return _saveButton;
}

- (UISlider *)bottonSlider {
    if (!_bottonSlider) {
        _bottonSlider = [[UISlider alloc] initWithFrame:CGRectMake(100, kScreenHeight - 50, kScreenWidth - 200, 20)];
        
    }
    
    return _bottonSlider;
}


@end
