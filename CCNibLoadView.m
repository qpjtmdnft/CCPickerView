//
//  CCNibLoadView.m
//  CCCodeBank
//
//  Created by 成才 向 on 15/10/19.
//  Copyright © 2015年 成才 向. All rights reserved.
//

#import "CCNibLoadView.h"

@implementation CCNibLoadView

+ (instancetype)instanciate
{
    return [self instanciateWithNibName:NSStringFromClass(self)];
}

+ (instancetype)instanciateWithNibName:(NSString *)nibName
{
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    if (views.count > 0)
    {
        id view = [views objectAtIndex:0];
        if ([view isKindOfClass:self])
        {
            return view;
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
