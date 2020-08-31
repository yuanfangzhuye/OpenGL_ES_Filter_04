//
//  LongLegView.h
//  OpenGL_ES_Filter_04
//
//  Created by tlab on 2020/8/31.
//  Copyright © 2020 yuanfangzhuye. All rights reserved.
//

#import <GLKit/GLKit.h>
@class LongLegView;

@protocol LongLegViewViewDelegate <NSObject>

//代理方法(SpringView拉伸区域修改)
- (void)springViewStrethAreaDidChanged:(LongLegView *)springView;

@end

@interface LongLegView : GLKView

@property (nonatomic, weak) id<LongLegViewViewDelegate> springDelegate;
@property (nonatomic, assign, readonly) BOOL hasChange; //拉伸区域是否被拉伸

- (void)updateImage:(UIImage *)image;

@end
