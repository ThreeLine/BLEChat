//
//  RadarView.m
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "RadarView.h"
#import "ECExtension.h"

@interface RadarView()
@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation RadarView


- (instancetype) init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    self.whiteViewDis = 20;
    self.radarWidthRatio = 1.5;
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.whiteView];
    
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    self.imageView.frame = CGRectMake(0, 0, size.width * 0.6, size.height * 0.6);
    self.imageView.center = CGPointMake(size.width/2, size.height/2);
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    self.imageView.layer.masksToBounds = YES;
    
    self.whiteView.frame = CGRectMake(0, 0, self.imageView.frame.size.width + self.whiteViewDis, self.imageView.frame.size.width + self.whiteViewDis);
    self.whiteView.center = CGPointMake(size.width/2, size.height/2);
    self.whiteView.layer.cornerRadius = self.whiteView.frame.size.width/2;
    self.whiteView.layer.masksToBounds =  YES;
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
    [self setNeedsDisplay];
}


- (void) startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(scheduleAddView:) userInfo:nil repeats:YES];
}

- (void) stopAnimation
{
    [self.timer invalidate];
}

- (void) scheduleAddView:(NSTimer*)timer
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, self.whiteView.frame.size.width, self.whiteView.frame.size.height);
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.masksToBounds = YES;
    view.center = self.whiteView.center;
    view.alpha = 0.7;
    [self insertSubview:view belowSubview:self.whiteView];

    [UIView animateWithDuration:2 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        view.alpha = 0;
        view.transform = CGAffineTransformScale(view.transform, self.radarWidthRatio, self.radarWidthRatio);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

@end
