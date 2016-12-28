//
//  CCPickerSelectView.h
//  CCCodeBank
//
//  Created by 成才 向 on 15/11/17.
//  Copyright © 2015年 成才 向. All rights reserved.
//

#import "CCPopoverView.h"

/**
 *  底部弹出, 单选
 */
@interface CCPickerSelectView :CCPopoverView
<
UIPickerViewDelegate,
UIPickerViewDataSource
>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *dataSouce;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) void (^didSelectItem)(NSInteger idx);

@end
