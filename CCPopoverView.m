//
//  HYPopUpView.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CCPopoverView.h"

@implementation CCPopoverView

- (void)dealloc
{
    //DebugNSLog(@"popupview is released");
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)])
    {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor whiteColor];
    _dimView = [[UIView alloc] initWithFrame:screenBounds];
    _dimView.backgroundColor = [UIColor clearColor];
    _dimView.alpha = .5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)];
    [_dimView addGestureRecognizer:tap];
    
    _floatShow = NO;
}

- (void)setDimAlpha:(CGFloat)dimAlpha
{
    _dimView.alpha = dimAlpha;
}

/**
 *  @brief  点按周围取消
 *
 *  @param tap
 */
- (void)bgTap:(UITapGestureRecognizer *)tap
{
    [self dismissWithAnimation:YES];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)showWithAnimation:(BOOL)animation
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:_dimView];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    //prepare
    //先摆好位置
    if (_popDirection == CCPopoverFromBottom)
    {
        CGRect fromFrame = self.frame;
        fromFrame.origin.x = CGRectGetWidth(frame)/2 - CGRectGetWidth(fromFrame)/2;
        fromFrame.origin.y = frame.size.height;
        self.frame = fromFrame;
    }
    else if (_popDirection == CCPopoverFromTop)
    {
        CGRect fromFrame = self.frame;
        fromFrame.origin.x = CGRectGetWidth(frame)/2 - CGRectGetWidth(fromFrame)/2;
        fromFrame.origin.y = - fromFrame.size.height;
        self.frame = fromFrame;
    }
    else if (_popDirection == CCPopoverFromCenter)
    {
        CGRect fromFrame = self.frame;
        fromFrame.origin.x = CGRectGetWidth(frame)/2 - CGRectGetWidth(fromFrame)/2;
        fromFrame.origin.y = CGRectGetHeight(frame)/2 - CGRectGetHeight(fromFrame)/2;
        self.frame = fromFrame;
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    [window addSubview:self];
    
    //背景渐隐动画
    if (animation)
    {
        [UIView beginAnimations:@"bg" context:nil];
    }
    _dimView.backgroundColor = [UIColor blackColor];
    
    if (animation)
    {
        [UIView commitAnimations];
    }
    
    //目的地
    //target!
    CGRect targetFrame = self.frame;
    if (_floatShow)
    {
        if (_popDirection == CCPopoverFromBottom)
        {
            targetFrame.origin.y = CGRectGetHeight(frame) - CGRectGetHeight(self.frame);
        }
        else if (_popDirection == CCPopoverFromTop)
        {
            targetFrame.origin.y = 0;
        }
    }
    else    //置于中间
    {
        targetFrame.origin.x = CGRectGetWidth(frame)/2 - CGRectGetWidth(targetFrame)/2;
        targetFrame.origin.y = CGRectGetHeight(frame)/2 - CGRectGetHeight(targetFrame)/2;
    }
    
    if (animation)
    {
        [UIView beginAnimations:@"showAnimation" context:nil];
    }
    
    self.frame = targetFrame;
    if (_popDirection == CCPopoverFromCenter)
    {
        self.transform = CGAffineTransformIdentity;
    }
    
    if (animation)
    {
        [UIView commitAnimations];
    }
}

- (void)dismissWithAnimation:(BOOL)animation
{
    if ([self superview])
    {
        if (animation)
        {
            [UIView animateWithDuration:.3 animations:^
             {
                 _dimView.backgroundColor = [UIColor clearColor];
             } completion:^(BOOL finished) {
                 [_dimView removeFromSuperview];
             }];
        }
        else
        {
            [_dimView removeFromSuperview];
        }
        
        CGRect windowFrame = [[UIScreen mainScreen] bounds];
        CGRect targetFrame = self.frame;
        
        if (_popDirection == CCPopoverFromBottom)
        {
            targetFrame.origin.y = CGRectGetHeight(windowFrame);
        }
        else if (_popDirection == CCPopoverFromTop)
        {
            targetFrame.origin.y = -targetFrame.size.height;
        }
        
        
        if (animation)
        {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.frame = targetFrame;
                             } completion:^(BOOL finished) {
                                 [self removeFromSuperview];
                             }];
        }
        else
        {
            [self removeFromSuperview];
        }
    }
    
}
@end
