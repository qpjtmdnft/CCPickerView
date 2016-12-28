//
//  CCPickerSelectView.m
//  CCCodeBank
//
//  Created by 成才 向 on 15/11/17.
//  Copyright © 2015年 成才 向. All rights reserved.
//

#import "CCPickerSelectView.h"

@implementation CCPickerSelectView
{
    UIPickerView *_picker;
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
        
        _picker = [[UIPickerView alloc] init];
        _picker.backgroundColor = [UIColor whiteColor];
        _picker.frame = CGRectMake(0, 44, frame.size.width, 300-44);
        _picker.showsSelectionIndicator = YES;
        _picker.delegate = self;
        _picker.dataSource = self;
        [self addSubview:_picker];
    }
    return self;
}

- (void)cancel
{
    [self dismissWithAnimation:YES];
}

- (void)done
{
    self.currentIndex = [_picker selectedRowInComponent:0];
    [self dismissWithAnimation:YES];
    if (self.didSelectItem)
    {
        self.didSelectItem(_currentIndex);
    }
}

- (void)setDataSouce:(NSArray *)dataSouce
{
    if (_dataSouce != dataSouce)
    {
        _dataSouce = dataSouce;
        [_picker reloadAllComponents];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLab.text = title;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_currentIndex != currentIndex)
    {
        _currentIndex = currentIndex;
        if (_currentIndex < self.dataSouce.count)
        {
            [_picker selectRow:currentIndex inComponent:0 animated:YES];
        }
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataSouce count];;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [self.dataSouce objectAtIndex:row];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
