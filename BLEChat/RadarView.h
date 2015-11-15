//
//  RadarView.h
//  BLEChat
//
//  Created by Eleven Chen on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

IB_DESIGNABLE
@interface RadarView : UIView
@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) IBInspectable UIImage* image;
@property (assign, nonatomic) IBInspectable CGFloat whiteViewDis;
@property (assign, nonatomic) IBInspectable CGFloat radarWidthRatio; // 雷达比率
@property (assign, nonatomic) IBInspectable BOOL enableRadar;

- (void) startAnimation;

- (void) stopAnimation;

@end
