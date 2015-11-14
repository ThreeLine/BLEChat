//
//  PickerDialog.m
//  Christmaslight
//
//  Created by Eleven Chen on 15/8/13.
//  Copyright (c) 2015年 Hunuo. All rights reserved.
//

#import "PickerDialog.h"
#import "ECExtension.h"

@interface PickerDialog()


@property (strong, nonatomic) NSLayoutConstraint* containerViewTop;
@end

@implementation PickerDialog

- (void) setToolbarBackgroundColor:(UIColor *)toolbarBackgroundColor
{
    _toolbarBackgroundColor = toolbarBackgroundColor;
    self.toolbarView.backgroundColor = _toolbarBackgroundColor;
}

- (void) setDoneButton:(UIButton *)doneButton
{
    if (_doneButton) {
        [_doneButton removeFromSuperview];
    }
    _doneButton = doneButton;
    [self.toolbarView addSubview:_doneButton];
    _doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_doneButton layoutMarginRightSuperView:10];
    [_doneButton centerYInSuperView];
}

- (void) setCancelButton:(UIButton *)cancelButton
{
    if (_cancelButton) {
        [_cancelButton removeFromSuperview];
    }
    _cancelButton = cancelButton;
    [self.toolbarView addSubview:_cancelButton];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_cancelButton layoutMarginLeftSuperView:10];
    [_cancelButton centerYInSuperView];
}

- (void) setTitleLabel:(UILabel *)titleLabel
{
    if (_titleLabel) {
        [_titleLabel removeFromSuperview];
    }
    _titleLabel = titleLabel;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.toolbarView addSubview:_titleLabel];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_titleLabel centerInSuperView];
}

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0f];
        
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.opaque = NO;
        _coverView.alpha = 0.0f;
        _coverView.frame = [UIScreen mainScreen].bounds;
        [self addSubview:_coverView];
        
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.opaque = YES;
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [_containerView constraintHeight:240];
        [_containerView layoutMarginLeftSuperView:0];
        [_containerView layoutMarginRightSuperView:0];
        
        _containerViewTop = [NSLayoutConstraint constraintWithItem:_containerView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f
                                                           constant:240];
        [self addConstraint:_containerViewTop];
        
        // 工具类
        _toolbarView = [[UIView alloc] init];
        _toolbarView.translatesAutoresizingMaskIntoConstraints = NO;
        [_containerView addSubview:_toolbarView];
        [_toolbarView constraintHeight:50];
        [_toolbarView layoutMarginTopSuperView:0];
        [_toolbarView layoutMarginLeftSuperView:0];
        [_toolbarView layoutMarginRightSuperView:0];
        
        // contentview
        _contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_containerView addSubview:_contentView];
        [_contentView bottomTo:_toolbarView distance:0];
        [_contentView layoutMarginLeftSuperView:0];
        [_contentView layoutMarginRightSuperView:0];
        [_contentView layoutMarginBottomSuperView:0];
        
    }
    
    return self;
}

- (void) show: (CompleteBlock) completion
{
    _containerViewTop.constant = 0;

    [UIView animateWithDuration:0.3
                     animations:^{
                         _coverView.alpha = 0.5f;
                         [self layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (completion != nil) {
                             completion();
                         }
                     }];
}

- (void) dismiss: (CompleteBlock) completion
{
    _containerViewTop.constant = 240;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _coverView.alpha = 0.0f;
                         [self layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (completion != nil) {
                             completion();
                         }
                     }];
}

@end
