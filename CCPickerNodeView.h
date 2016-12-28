//
//  CCPickerNodeView.h
//  CCCodeBank
//
//  Created by 成才 向 on 15/11/17.
//  Copyright © 2015年 成才 向. All rights reserved.
//

#import "CCPopoverView.h"
@class CCPickerNode;

/**
 *  多级联动picker
 */

@interface CCPickerNodeView : CCPopoverView
<UIPickerViewDataSource,
UIPickerViewDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) CCPickerNode* dataSouce;

@property (nonatomic, copy) void (^didSelect)(CCPickerNodeView *pick);
@property (nonatomic, copy) void (^didSelectWithPath)(NSIndexPath *path);

@end

/*
 *
 */


@interface CCPickerNode : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<CCPickerNode*> *children;

@property (nonatomic, assign) NSInteger selectIdx;
@property (nonatomic, assign) NSInteger descendantLen;
@property (nonatomic, assign, readonly) NSIndexPath *selectPath;

+ (instancetype)nodeWithDictionary:(id)dict;
+ (instancetype)nodeWithName:(NSString *)name children:(NSArray<CCPickerNode*>*)children;
+ (instancetype)nodeWithName:(NSString *)name;

- (void)addChild:(CCPickerNode *)node;

- (CCPickerNode *)selectedChild;

- (CCPickerNode *)childAtLength:(NSInteger)length;

@end
