//
//  CCPickerNodeView.m
//  CCCodeBank
//
//  Created by 成才 向 on 15/11/17.
//  Copyright © 2015年 成才 向. All rights reserved.
//

#import "CCPickerNodeView.h"

@implementation CCPickerNodeView
{
    UILabel *_titleLab;
}


- (instancetype)init
{
    CGRect frame = [UIScreen mainScreen].bounds;
    if (self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, 300)])
    {
        self.popDirection = CCPopoverFromBottom;
        self.floatShow = YES;
        
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        pickerToolbar.barStyle = UIBarStyleDefault;
        [self addSubview:pickerToolbar];
        
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        left.width = 10;
        
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        
        UIBarButtonItem *flext = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *flext1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        right.width = 10;
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        _titleLab.font = [UIFont systemFontOfSize:15.0];
        _titleLab.backgroundColor = [UIColor clearColor];
        UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:_titleLab];
        
        [pickerToolbar setItems:@[left,cancel, flext, title, flext1, done, right]];
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.frame = CGRectMake(0, 44, frame.size.width, 300-44);
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
    }
    return self;
}

- (void)cancel
{
    [self dismissWithAnimation:YES];
}

- (void)done
{
    if (self.didSelect)
    {
        self.didSelect(self);
    }
    if (self.didSelectWithPath)
    {
        self.didSelectWithPath(self.dataSouce.selectPath);
    }
    [self dismissWithAnimation:YES];
}

- (void)setDataSouce:(CCPickerNode *)dataSouce
{
    _dataSouce = dataSouce;
    [self.pickerView reloadAllComponents];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLab.text = title;
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _dataSouce.descendantLen;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[_dataSouce childAtLength:component] children].count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    CCPickerNode *componentNode = [_dataSouce childAtLength:component];
    return [componentNode.children objectAtIndex:row].name;
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    CCPickerNode *componentNode = [_dataSouce childAtLength:component];
    componentNode.selectIdx = row;
    if (component < [pickerView numberOfComponents]-1)
    {
        [pickerView reloadComponent:component+1];
        [pickerView selectRow:0 inComponent:component+1 animated:YES];
    }
}

@end


@implementation CCPickerNode

+ (instancetype)nodeWithDictionary:(id)dict
{
    CCPickerNode *node = [[CCPickerNode alloc] init];
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        node.name = [[dict allKeys] objectAtIndex:0];
        NSArray *values = [dict allValues];
        NSMutableArray *children = [NSMutableArray array];
        for (id child in values) {
            [children addObject:[CCPickerNode nodeWithDictionary:child]];
        }
        node.children = children;
        node.selectIdx = 0;
    }
    else if ([dict isKindOfClass:[NSString class]])
    {
        node.name = dict;
        node.children = nil;
        node.selectIdx = -1;
    }
    return node;
}

+ (instancetype)nodeWithName:(NSString *)name children:(NSArray *)children
{
    CCPickerNode *node = [[CCPickerNode alloc] init];
    node.name = name;
    node.children = children;
    node.selectIdx = 0;
    return node;
}

+ (instancetype)nodeWithName:(NSString *)name
{
    return [self nodeWithName:name children:nil];
}

- (void)addChild:(CCPickerNode *)node
{
    if (!self.children) {
        self.children = [NSArray array];
    }
    NSMutableArray *children = [self.children mutableCopy];
    [children addObject:node];
    self.children = children;
}

- (NSInteger)descendantLen
{
    if (!_children || _children.count == 0 || _selectIdx < 0)
    {
        return 0;
    }
    else
    {
        CCPickerNode *child = [_children objectAtIndex:_selectIdx];
        return 1 + [child descendantLen];
    }
}

- (CCPickerNode *)childAtLength:(NSInteger)length
{
    NSInteger i = 0;
    CCPickerNode *node = self;
    while (i < length) {
        node = [node selectedChild];
        i ++;
    }
    return node;
}

- (CCPickerNode *)selectedChild
{
    if (_selectIdx >= 0 && _selectIdx < _children.count)
    {
        return [_children objectAtIndex:_selectIdx];
    }
    return nil;
}

- (NSIndexPath *)selectPath
{
    NSIndexPath *ret = [[NSIndexPath alloc] init];
    CCPickerNode *node = self;
    while (node.children != nil && node.children.count > 0 && node.selectIdx != -1)
    {
        ret  = [ret indexPathByAddingIndex:node.selectIdx];
        node = node.selectedChild;
    }
    return ret;
}

@end
