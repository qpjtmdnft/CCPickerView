//
//  CCNibLoadView.h
//  CCCodeBank
//
//  Created by 成才 向 on 15/10/19.
//  Copyright © 2015年 成才 向. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCNibLoadView : UIView

+ (instancetype)instanciate;
+ (instancetype)instanciateWithNibName:(NSString *)nibName;

@end
