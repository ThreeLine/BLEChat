//
//  PickerDialog.h
//  Christmaslight
//
//  Created by Eleven Chen on 15/8/13.
//  Copyright (c) 2015年 Hunuo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CompleteBlock)();

@interface PickerDialog : UIView

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *coverView;

@property (strong, nonatomic) UIButton* doneButton;
@property (strong, nonatomic) UIButton* cancelButton;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIColor* toolbarBackgroundColor;
@property (strong, nonatomic) UIColor* contentBackgroundColor;

- (void) show:(CompleteBlock) completion;

- (void) dismiss: (CompleteBlock) completion;

@end
