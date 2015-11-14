//
//  UIView+Extend.h
//  Pods
//
//  Created by Eleven Chen on 15/7/31.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Extend)

+ (id) loadFromNibWithName: (NSString*) name;

+ (id) loadFromNibWithName:(NSString *)name ower:(id)ower;

#pragma mark - Position
- (void) centerYInSuperView;

- (void) centerXInSuperView;

- (void) centerInSuperView;

- (void) centerXTo: (UIView*) view;

- (void) centerYTo: (UIView*) view;

- (void) centerTo: (UIView*) view;

- (void) constraintWidth: (CGFloat) width;

- (void) constraintHeight: (CGFloat) height;

- (void) constraintSize: (CGSize) size;

#pragma mark - Margin
- (void) layoutWidthMatchSuperView;

- (void) layoutHeightMatchSuperView;

- (void) layoutMatchSuperView;

- (NSLayoutConstraint*) layoutMarginTopSuperView:(CGFloat) dis;

- (NSLayoutConstraint*) layoutMarginBottomSuperView:(CGFloat) dis;

- (NSLayoutConstraint*) layoutMarginLeftSuperView:(CGFloat) dis;

- (NSLayoutConstraint*) layoutMarginRightSuperView:(CGFloat) dis;

- (NSArray*) layoutMarginSuperView: (CGFloat ) dis;

#pragma mark - Align

- (NSLayoutConstraint*) alignLeftTo: (UIView*) view;

- (NSLayoutConstraint*) alignRightTo: (UIView*) view;

- (NSLayoutConstraint*) alignTopTo: (UIView*) view;

- (NSLayoutConstraint*) alignBottomTo: (UIView*) view;

#pragma mark - Position relative to other view

- (NSArray*) leftTo: (UIView*) view distance:(CGFloat) dis;

- (NSArray*) rightTo: (UIView*) view distance:(CGFloat) dis;

- (NSArray*) topTo: (UIView*) view distance:(CGFloat) dis;

- (NSArray*) bottomTo: (UIView*) view distance:(CGFloat) dis;

@end
