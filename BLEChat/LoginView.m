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
    self.backgroundColor = [UIColor grayColor];
    self.userInteractionEnabled = YES;
    [self initView];
    return self;
}

-(void) initView
{
    CGSize s = [UIScreen mainScreen].bounds.size;
    //添加背景
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgimageView.image = [UIImage imageNamed:@"loginBg"];
    [self addSubview:bgimageView];
    
    UILabel* lab1 = [[UILabel alloc] init];
    lab1.adjustsFontSizeToFitWidth = YES;
    lab1.textColor = [UIColor whiteColor];
    lab1.font = [UIFont systemFontOfSize:18];
    lab1.text = NSLocalizedString(@"Name:", nil);
    [self addSubview:lab1];
    lab1.frame = CGRectMake(s.width*0.15, s.height*0.4, 67, 30);
    lab1.textAlignment = UITextAlignmentRight;
    
    UILabel* lab2 = [[UILabel alloc] init];
    lab2.adjustsFontSizeToFitWidth = YES;
    lab2.textColor = [UIColor whiteColor];
    lab2.font = [UIFont systemFontOfSize:18];
    lab2.text = NSLocalizedString(@"Sex:", nil);
    [self addSubview:lab2];
    lab2.frame = CGRectMake(s.width*0.1, s.height*0.5, 67, 30);
    lab2.textAlignment = UITextAlignmentRight;
    
    UILabel* lab3 = [[UILabel alloc] init];
    lab3.adjustsFontSizeToFitWidth = YES;
    lab3.textColor = [UIColor whiteColor];
    lab3.font = [UIFont systemFontOfSize:18];
    lab3.text = NSLocalizedString(@"Age:", nil);
    [self addSubview:lab3];
    lab3.frame = CGRectMake(s.width*0.5, s.height*0.5, 67, 30);
    lab3.textAlignment = UITextAlignmentRight;
    
    
    
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(s.width*0.38, s.height*0.4, 150, 30)];
    [textField setBackgroundColor:[UIColor clearColor]];
    textField.textColor = [UIColor whiteColor];
    [self addSubview:textField];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.font = [UIFont fontWithName:@"Arial" size:20.0f];
    self.nameField = textField;
    textField.delegate = self;
    
//    UITextField* textField1 = [[UITextField alloc] initWithFrame:CGRectMake(s.width*0.5, s.height*0.3, 150, 30)];
//    [textField1 setBackgroundColor:[UIColor redColor]];
//    textField1.textColor = [UIColor whiteColor];
//    [self addSubview:textField1];
//    textField1.translatesAutoresizingMaskIntoConstraints = NO;
//    textField1.font = [UIFont fontWithName:@"Arial" size:12.0f];
//    
    UITextField* textField2 = [[UITextField alloc] initWithFrame:CGRectMake(s.width*0.75, s.height*0.5, 40, 30)];
    [textField2 setBackgroundColor:[UIColor clearColor]];
    textField2.textColor = [UIColor whiteColor];
    [self addSubview:textField2];
    textField2.translatesAutoresizingMaskIntoConstraints = NO;
    textField2.font = [UIFont fontWithName:@"Arial" size:15.0f];
    self.ageField = textField2;
    textField2.delegate = self;
    
    
    UIButton* sure = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* img1= [UIImage imageNamed:@"sureBtn"];
    [sure setBackgroundImage:[UIImage imageNamed:@"sureBtn"]forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(onSureTouch:) forControlEvents:UIControlEventTouchUpInside];
    sure.titleLabel.text = @"确定";
    [self addSubview:sure];
    sure.frame = CGRectMake(s.width*0.5-img1.size.width/2, s.height*0.65-img1.size.height/2, img1.size.width, img1.size.height);
    
    UIImageView *gougou = [[UIImageView alloc] init];
    gougou.image = [UIImage imageNamed:@"gougou"];
    [self addSubview:gougou];
    gougou.frame = CGRectMake(s.width*0.5-gougou.image.size.width/2, s.height*0.65-gougou.image.size.height/2, gougou.image.size.width, gougou.image.size.height);
    
    
    UIButton* photo = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* img  = [UIImage imageNamed:@"xiaoyuan"];
    [photo setBackgroundImage:img forState:UIControlStateNormal];
    [photo addTarget:self action:@selector(onPhotoTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:photo];
    photo.frame = CGRectMake(s.width*0.5-img.size.width/2, s.height*0.2-img.size.height/2, [UIImage imageNamed:@"xiaoyuan"].size.width, [UIImage imageNamed:@"xiaoyuan"].size.height);
    
    
    UIImage * xiangji = [UIImage imageNamed:@"xiangji"];
    UIImageView* imgview22 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangji"]];
    [self addSubview:imgview22];
    imgview22.frame = CGRectMake(s.width/2-xiangji.size.width/2, s.height*0.2-xiangji.size.height/2, xiangji.size.width, xiangji.size.height);
    self.photo = imgview22;
    
    self.photo.layer.cornerRadius = photo.bounds.size.height/2;
    self.photo.layer.masksToBounds = YES;
    
    UIImage * quan = [UIImage imageNamed:@"dayuan"];
    UIImageView* imgquan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dayuan"]];
    [self addSubview:imgquan];
    imgquan.frame = CGRectMake(s.width/2-quan.size.width/2, s.height*0.2-quan.size.height/2, quan.size.width, quan.size.height);
    
    
    
    
    
    
    UIImageView *lin1 = [[UIImageView alloc] init];
    lin1.image = [UIImage imageNamed:@"changxian"];
    [self addSubview:lin1];
    lin1.frame = CGRectMake(s.width*0.5-lin1.image.size.width/2, s.height*0.46-lin1.image.size.height/2, lin1.image.size.width, lin1.image.size.height);
    
    UIImageView *lin2 = [[UIImageView alloc] init];
    lin2.image = [UIImage imageNamed:@"duanxian"];
    [self addSubview:lin2];
    lin2.frame = CGRectMake(s.width*0.3-lin2.image.size.width/2, s.height*0.55-lin2.image.size.height/2, lin2.image.size.width, lin2.image.size.height);
    
    UIImageView *lin3 = [[UIImageView alloc] init];
    lin3.image = [UIImage imageNamed:@"duanxian"];
    [self addSubview:lin3];
    lin3.frame = CGRectMake(s.width*0.7-lin3.image.size.width/2, s.height*0.55-lin3.image.size.height/2, lin3.image.size.width, lin3.image.size.height);

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(s.width*0.38-70/2, s.height*0.5-3, 70, 35);
    [btn setTitle:@"male" forState:UIControlStateNormal];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.tintColor = [UIColor whiteColor];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(onSexTouch:) forControlEvents:UIControlEventTouchUpInside];
    self.sexButton = btn;
    
    UIImage * datesss = [UIImage imageNamed:@"dateimg"];
    UIImageView* dateimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dateimg"]];
    [self addSubview:dateimage];
    dateimage.frame = CGRectMake(s.width/2-datesss.size.width/2, s.height*0.85-datesss.size.height/2, datesss.size.width, datesss.size.height);
 
}

- (void) onSureTouch: (UIButton*) sender
{
    [self.delegate sureTouch];
}

- (void) onPhotoTouch: (UIButton*) sender
{
    [self.delegate photoTouch];
}

- (void) onSexTouch: (UIButton*) sender
{
    [self.delegate sexTouch];
}

#define NUMBERS @"0123456789\n"

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == self.ageField){
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入数字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            return NO;
        }
    }
 }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //self.profess.content = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)textFieldDone:(UITextField *)sender {
    [sender resignFirstResponder];
}

-(void)textFieldDidChange:(UITextField *)textField
{
//    if (textField ==self.textField) {
//        if (textField.text.length > 3) {
//            textField.text = [textField.text substringFromIndex:3];
//        }
//    }
}



@end
