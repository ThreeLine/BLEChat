//
//  UIView+Extend.m
//  Pods
//
//  Created by Eleven Chen on 15/7/31.
//
//

#import "UIView+Extend.h"

@implementation UIView (Extend)

+ (id) loadFromNibWithName: (NSString*) name
{
    return [UIView loadFromNibWithName:name ower:self];
}

+ (id) loadFromNibWithName:(NSString *)name ower:(id)ower
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:name owner:ower options:nil];
    if (nib == nil) {
        NSLog(@"%@.xib is not exist", name);
    }
    return [nib objectAtIndex:0];
    
}

- (void) centerYInSuperView
{
    if (!self.superview) {
        return;
    }
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.superview
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0f
                                                                constant:0]];
}

- (void) centerXInSuperView
{
    if (!self.superview) {
        return;
    }
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0f
                                                                constant:0]];
}

- (void) centerInSuperView
{
    [self centerXInSuperView];
    [self centerYInSuperView];
}
- (void) centerXTo: (UIView*) view
{
    if (!self.superview) {
        return;
    }
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                                constant:0]];
}

- (void) centerYTo: (UIView*) view
{
    if (!self.superview) {
        return;
    }
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:view
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0]];
}

- (void) centerTo: (UIView*) view
{
    [self centerXTo:view];
    [self centerYTo:view];
}

- (void) constraintWidth: (CGFloat) width
{
    NSDictionary* views = @{@"self": self};
    NSDictionary* metrics = @{@"width": @(width)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(width)]"
                                                                         options:0
                                                                         metrics:metrics
                                                                            views:views]];
}

- (void) constraintHeight: (CGFloat) height
{
    NSDictionary* views = @{@"self": self};
    NSDictionary* metrics = @{@"height": @(height)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]"
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:views]];
}

- (void) constraintSize: (CGSize) size
{
    [self constraintWidth:size.width];
    [self constraintHeight:size.height];
}

#pragma mark - layouts

- (void) layoutWidthMatchSuperView
{
    if (!self.superview) {
        return;
    }
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.superview
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0f
                                                                constant:0]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0f
                                                                constant:0]];
}

- (void) layoutHeightMatchSuperView
{
    if (!self.superview) {
        return;
    }
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0f
                                                                constant:0]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0f
                                                                constant:0]];
}

- (void) layoutMatchSuperView
{
    [self layoutWidthMatchSuperView];
    [self layoutHeightMatchSuperView];
}

- (NSLayoutConstraint*) layoutMarginTopSuperView: (CGFloat) dis
{
    if (!self.superview) {
        return nil;
    }
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:dis];
    [self.superview addConstraint: constraint];
    return constraint;
}

- (NSLayoutConstraint*) layoutMarginBottomSuperView: (CGFloat) dis
{
    if (!self.superview) {
        return nil;
    }
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:-dis];
    [self.superview addConstraint: constraint];
    return constraint;
}

- (NSLayoutConstraint*) layoutMarginLeftSuperView: (CGFloat) dis
{
    if (!self.superview) {
        return nil;
    }
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0
                                                                   constant:dis];
    [self.superview addConstraint: constraint];
    return constraint;
}

- (NSLayoutConstraint*) layoutMarginRightSuperView: (CGFloat) dis
{
    if (!self.superview) {
        return nil;
    }
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:-dis];
    [self.superview addConstraint:constraint];
    return constraint;
}

- (NSArray*) layoutMarginSuperView: (CGFloat ) dis
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObject:[self layoutMarginTopSuperView:dis]];
    [array addObject:[self layoutMarginBottomSuperView:dis]];
    [array addObject:[self layoutMarginLeftSuperView:dis]];
    [array addObject:[self layoutMarginRightSuperView:dis]];
    return [array copy];
}

#pragma mark - Align

- (NSLayoutConstraint*) alignLeftTo: (UIView*) view
{
    if (!self.superview) {
        return nil;
    }
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f
                                                                   constant:0];
    [self.superview addConstraint: constraint];
    return constraint;
}

- (NSLayoutConstraint*) alignRightTo: (UIView*) view
{
    if (!self.superview) {
        return nil;
    }
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0f
                                                                   constant:0];
    [self.superview addConstraint: constraint];
    return constraint;
}

- (NSLayoutConstraint*) alignTopTo: (UIView*) view
{
    if (!self.superview) {
        return nil;
    }
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:0];
    [self.superview addConstraint: constraint];
    return constraint;
}

- (NSLayoutConstraint*) alignBottomTo: (UIView*) view
{
    if (!self.superview) {
        return nil;
    }
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:0];
    [self.superview addConstraint: constraint];
    return constraint;
}

#pragma mark - Position relative to other view

- (NSArray*) leftTo: (UIView*) view distance:(CGFloat) dis
{
    if (!self.superview) {
        return nil;
    }
    NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[self]-dis-[view]"
                                                                             options:0
                                                                             metrics:@{@"dis": @(dis)}
                                                                               views:NSDictionaryOfVariableBindings(self, view)];
    [self.superview addConstraints: constraints];
    return constraints;
}

- (NSArray*) rightTo: (UIView*) view distance:(CGFloat) dis
{
    if (!self.superview) {
        return nil;
    }
    NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-dis-[self]"
                                                                   options:0
                                                                   metrics:@{@"dis": @(dis)}
                                                                     views:NSDictionaryOfVariableBindings(self, view)];
    [self.superview addConstraints: constraints];
    return constraints;
}

- (NSArray*) topTo: (UIView*) view distance:(CGFloat) dis
{
    if (!self.superview) {
        return nil;
    }
    NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[self]-dis-[view]"
                                                                   options:0
                                                                   metrics:@{@"dis": @(dis)}
                                                                     views:NSDictionaryOfVariableBindings(self, view)];
    [self.superview addConstraints: constraints];
    return constraints;
}

- (NSArray*) bottomTo: (UIView*) view distance:(CGFloat) dis
{
    if (!self.superview) {
        return nil;
    }
    NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-dis-[self]"
                                                                   options:0
                                                                   metrics:@{@"dis": @(dis)}
                                                                     views:NSDictionaryOfVariableBindings(self, view)];
    [self.superview addConstraints: constraints];
    return constraints;
}

@end
