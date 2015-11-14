//
//  LoginView.m
//  BLEChat
//
//  Created by apple on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
- (instancetype) init
{
    self = [super init];
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    [self initView];
    return self;
}

-(void) initView
{
    CGSize s = [UIScreen mainScreen].bounds.size;
    
    UILabel* lab1 = [[UILabel alloc] init];
    lab1.adjustsFontSizeToFitWidth = YES;
    lab1.textColor = [UIColor blackColor];
    lab1.font = [UIFont systemFontOfSize:18];
    lab1.text = NSLocalizedString(@"Name:", nil);
    [self addSubview:lab1];
    lab1.frame = CGRectMake(s.width*0.2, s.height*0.2, 67, 30);
    lab1.textAlignment = UITextAlignmentRight;
    
    UILabel* lab2 = [[UILabel alloc] init];
    lab2.adjustsFontSizeToFitWidth = YES;
    lab2.textColor = [UIColor blackColor];
    lab2.font = [UIFont systemFontOfSize:18];
    lab2.text = NSLocalizedString(@"Sex:", nil);
    [self addSubview:lab2];
    lab2.frame = CGRectMake(s.width*0.2, s.height*0.3, 67, 30);
    lab2.textAlignment = UITextAlignmentRight;
    
    UILabel* lab3 = [[UILabel alloc] init];
    lab3.adjustsFontSizeToFitWidth = YES;
    lab3.textColor = [UIColor blackColor];
    lab3.font = [UIFont systemFontOfSize:18];
    lab3.text = NSLocalizedString(@"Age:", nil);
    [self addSubview:lab3];
    lab3.frame = CGRectMake(s.width*0.2, s.height*0.4, 67, 30);
    lab3.textAlignment = UITextAlignmentRight;
    
    UILabel* lab4 = [[UILabel alloc] init];
    lab4.adjustsFontSizeToFitWidth = YES;
    lab4.textColor = [UIColor blackColor];
    lab4.font = [UIFont systemFontOfSize:18];
    lab4.text = NSLocalizedString(@"Image:", nil);
    [self addSubview:lab4];
    lab4.frame = CGRectMake(s.width*0.2, s.height*0.5, 67, 30);
    lab4.textAlignment = UITextAlignmentRight;
    
    
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(s.width*0.5, s.height*0.2, 150, 30)];
    [textField setBackgroundColor:[UIColor redColor]];
    textField.textColor = [UIColor whiteColor];
    [self addSubview:textField];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.font = [UIFont fontWithName:@"Arial" size:12.0f];
    
    UITextField* textField1 = [[UITextField alloc] initWithFrame:CGRectMake(s.width*0.5, s.height*0.3, 150, 30)];
    [textField1 setBackgroundColor:[UIColor redColor]];
    textField1.textColor = [UIColor whiteColor];
    [self addSubview:textField1];
    textField1.translatesAutoresizingMaskIntoConstraints = NO;
    textField1.font = [UIFont fontWithName:@"Arial" size:12.0f];
    
    UITextField* textField2 = [[UITextField alloc] initWithFrame:CGRectMake(s.width*0.5, s.height*0.4, 150, 30)];
    [textField2 setBackgroundColor:[UIColor redColor]];
    textField2.textColor = [UIColor whiteColor];
    [self addSubview:textField2];
    textField2.translatesAutoresizingMaskIntoConstraints = NO;
    textField2.font = [UIFont fontWithName:@"Arial" size:12.0f];
    
    
    UIButton* sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setBackgroundImage:[UIImage imageNamed:@"sureBtn"]forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(onSureTouch:) forControlEvents:UIControlEventTouchUpInside];
    sure.titleLabel.text = @"确定";
    [self addSubview:sure];
    sure.frame = CGRectMake(s.width*0.5, s.height*0.1, 50, 50);
    
    
}

- (void) onSureTouch: (UIButton*) sender
{
    [self.delegate sureTouch];
}


@end
