//
//  HYPopUpView.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCNibLoadView.h"

typedef NS_ENUM(NSUInteger, CCPopoverDirection) {
    CCPopoverFromBottom,
    CCPopoverFromCenter,
    CCPopoverFromTop,
    CCPopoverFromLeft,
};

@protocol CCPopoverViewDelegate <NSObject>


@end

@interface CCPopoverView : CCNibLoadView
{
}

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, assign) CGFloat dimAlpha;
@property (nonatomic, assign) BOOL floatShow;   //是否浮动在边界上


/**
 *  初始化, 无论是否给出位置, 视图位置均没有效果, 而是根据动画自动去设置位置
 *
 *  @param size
 *
 *  @return
 */
- (instancetype)initWithSize:(CGSize)size;
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  方向
 */
@property (nonatomic, assign) CCPopoverDirection popDirection;

/**
 *  显示, 隐藏
 *
 *  @param animation <#animation description#>
 */
- (void)showWithAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;

@property (nonatomic, weak) id<CCPopoverViewDelegate> delegate;

@end
