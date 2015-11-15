//
//  PickerDialogController.m
//  Christmaslight
//
//  Created by Eleven Chen on 15/8/13.
//  Copyright (c) 2015年 Hunuo. All rights reserved.
//

#import "PickerDialogController.h"
#import "PickerDialog.h"
#import "ECExtension.h"
#define BUTTON_NORMAL_COLOR [UIColor colorWithString:@"#9ea1a6"]
#define BUTTON_HIGHLIGHT_COLOR [UIColor colorWithString:@"#ffffff"]
@interface PickerDialogController()

@property (strong, nonatomic) PickerDialog* dialogView;
@property (strong, nonatomic) UIWindow* window;
@property (strong, nonatomic) NSString* cancelTitle;
@property (strong, nonatomic) NSString* doneTitle;
@property (strong, nonatomic) Block cancelBlock;
@property (strong, nonatomic) Block doneBlock;
@property (strong, nonatomic) UIView* customView;
@property (strong, nonatomic) UIWindow *keyWindow;
@property (assign, nonatomic) BOOL showed;
@end

@implementation PickerDialogController

+ (PickerDialogController*) dialogPickerWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle cancelBlock:(Block)cancelBlock doneTitle:(NSString *)doneTitle doneBlock:(Block)doneBlock customView:(UIView *)view
{
    PickerDialogController* vc = [[PickerDialogController alloc] init];
    
    vc.cancelTitle = cancelTitle;
    vc.doneTitle = doneTitle;
    vc.cancelBlock = cancelBlock;
    vc.doneBlock = doneBlock;
    vc.customView = view;
    vc.title = title;

    return vc;
}

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        self.dialogView = [[PickerDialog alloc] init];
        self.dialogView.toolbarBackgroundColor = [UIColor colorWithString:@"#d9dade"];
    }
    return self;
}

- (void) setCancelTitle:(NSString *)cancelTitle
{
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
    self.dialogView.cancelButton = cancelButton;
    [cancelButton setTitleColor:BUTTON_NORMAL_COLOR forState:UIControlStateNormal];
    [cancelButton setTitleColor:BUTTON_HIGHLIGHT_COLOR forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(onCancelBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setDoneTitle:(NSString *)doneTitle
{
    UIButton* doneButton = [[UIButton alloc] init];
    [doneButton setTitle:doneTitle forState:UIControlStateNormal];
    [doneButton setTitleColor:BUTTON_NORMAL_COLOR forState:UIControlStateNormal];
    [doneButton setTitleColor:BUTTON_HIGHLIGHT_COLOR forState:UIControlStateHighlighted];
    self.dialogView.doneButton = doneButton;
    [doneButton addTarget:self action:@selector(onDoneBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setCustomView:(UIView *)customView
{
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dialogView.contentView addSubview:customView];
    [customView layoutMarginSuperView:0];
}

- (void) setTitle:(NSString *)title
{
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = BUTTON_NORMAL_COLOR;
    titleLabel.font = [UIFont systemFontOfSize:25];
    self.dialogView.titleLabel = titleLabel;
}

- (UIWindow*) window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelAlert;
        _window.rootViewController = self;
    }
    
    return _window;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.dialogView.coverView addGestureRecognizer:tapGestureRecognizer];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.dialogView show:^{
        
    }];

}

- (void) loadView
{
    self.view = self.dialogView;
}

- (CATransform3D) transformZ: (CGFloat) z
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500.0;
    transform = CATransform3DTranslate(transform, 0, 0, z);
    return transform;
}

- (void) startShowAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform";
    animation.duration = 0.2;
    animation.toValue = [NSValue valueWithCATransform3D:[self transformZ: -80]];
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.keyWindow.layer addAnimation:animation forKey:nil];
}

- (void) startHideAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform";
    animation.duration = 0.2;
    animation.toValue = [NSValue valueWithCATransform3D:[self transformZ: 0]];
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.keyWindow.layer addAnimation:animation forKey:nil];

}

#pragma mark - public methods
- (void) show
{
    // Get current window
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    self.keyWindow = keyWindow;
    [self startShowAnimation];
    if (![self.window isKeyWindow]) {
        [self.window makeKeyAndVisible];
        self.window.hidden = NO;
    }
    self.showed = YES;
}

- (void) dismiss
{
    [self startHideAnimation];
    [self.dialogView dismiss:^{
        [self.customView removeFromSuperview];
        [self destroyWindow];
    }];
    self.showed = NO;
}

- (void) destroyWindow
{
    self.window.hidden = YES;
    if (self.window.isKeyWindow) {
        [self.window resignFirstResponder];
        self.window.rootViewController = nil;
        self.window = nil;
    }
}


- (void) tap: (UITapGestureRecognizer* ) tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}

- (void) onDoneBtnTouched: (UIButton*) sender
{
    if (self.doneBlock) {
        self.doneBlock(self);
    }
}

- (void) onCancelBtnTouched: (UIButton*) sender
{
    if (self.cancelBlock) {
        self.cancelBlock(self);
    }
}

@end
