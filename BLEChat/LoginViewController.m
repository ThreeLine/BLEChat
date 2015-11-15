//
//  LoginViewController.m
//  BLEChat
//
//  Created by apple on 15/11/14.
//  Copyright © 2015年 Eleven. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "NetWork.h"
#import "PickerDialogController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "Globals.h"

@interface LoginViewController ()
@property(nonatomic,strong) LoginView* loginview;
@property(nonatomic,strong) UIImagePickerController* imgController;
@property(nonatomic) NSString* fileName;
@property(nonatomic) User* preUser;
@property(nonatomic) BOOL isRegisted;
@property(nonatomic,strong) Globals* globals;
@end

@implementation LoginViewController

-(UIImagePickerController*)imgController{
    if (!_imgController) {
        _imgController = [[UIImagePickerController alloc] init];
    }
    return _imgController;
}

- (Globals*) globals
{
    if (!_globals) {
        _globals = [Globals shareInstance];
    }
    return _globals;
}

- (UIPickerView*) modePickerView
{
    if (!_modePickerView) {
        _modePickerView = [[UIPickerView alloc] init];
        _modePickerView.delegate = self;
        _modePickerView.dataSource = self;
    }
    return _modePickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginview = [[LoginView alloc] init];
    self.loginview.delegate = self;
    self.view = self.loginview;
    self.preUser = [[User alloc] init];
    self.preUser.sex= YES;
    self.isRegisted = false;
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]!=nil){
        NSString* userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
        NSString* name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
        NSString* sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
        NSString* age = [[NSUserDefaults standardUserDefaults] stringForKey:@"age"];
        
        User* user = [[User alloc] init];
        user.name = name;
        user.age = [age intValue];
        if ([sex isEqualToString:@"male"]) {
            user.sex = YES;
        }else{
            user.sex = NO;
        }
        user.userId = userId;
        self.globals.mainUser = user;
        
        self.loginview.nameField.text = name;
        self.loginview.ageField.text = age;
        self.isRegisted = YES;
        self.preUser = user;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) sureTouch{
    if (self.isRegisted) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"Already regist,upload you photo please." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
        return;
    }
    self.preUser.name = self.loginview.nameField.text;
    self.preUser.age = [self.loginview.ageField.text intValue];
    NetWork* work = [[NetWork alloc] init];
    work.delegate = self;
    [work registerUser:self.preUser];
    //[work findUserFromId:@"5647520d0cf293310d57d478"];
    //[work changeStateToReady:@"5647520d0cf293310d57d478"];
    //[work get];
    //[work sendToLike:@"5647520d0cf293310d57d478"];
    NSLog(@"sdsd");
};

-(void) photoTouch{
    NSLog(@"photo");
    if (!self.isRegisted) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"Please regist first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
        return;
    }
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展
    
    
    
}


#pragma mark -
#pragma mark UIImagePickerController Method
//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self performSelector:@selector(saveImage:) withObject:image];
    
}
//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//将照片保存到disk上
-(void)saveImage:(UIImage *)image
{
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if(imageData == nil)
    {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
//    _fileName = [[[[formatter stringFromDate:date] stringByAppendingPathExtension:@"png"]] ]
    _fileName = [[formatter stringFromDate:date] stringByAppendingPathExtension:@"png"];
    
    NSURL *saveURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_fileName];
    [imageData writeToURL:saveURL atomically:YES];
    
    //[self.loginview.photo setBackgroundImage:image forState:UIControlStateNormal];
    [self.loginview.photo setImage:image];
    NetWork* work = [[NetWork alloc] init];
    work.delegate = self;
    [work postImage:image];
    self.globals.mainUser.uiimage = image;
}

-(NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void) sexTouch{
    PickerDialogController *vc = [PickerDialogController dialogPickerWithTitle:NSLocalizedString(@"ChooseMode", nil)
                                                                   cancelTitle:NSLocalizedString(@"Cancel", nil)
                                                                   cancelBlock:^(PickerDialogController *vc) {
                                                                       [vc dismiss];
                                                                   }
                                                                     doneTitle:NSLocalizedString(@"Done", nil)
                                                                     doneBlock:^(PickerDialogController *vc) {
                                                                         [vc dismiss];
                                                                         [self onSelectedMode];
                                                                     } customView:self.modePickerView];
    [vc show];
    [self.modePickerView selectRow:self.preUser.sex inComponent:0 animated:NO];
}

- (void) onSelectedMode
{
    NSLog(@"%ld", (long)[self.modePickerView selectedRowInComponent:0]);
    self.preUser.sex = [self.modePickerView selectedRowInComponent:0];
    if (self.preUser.sex) {
        self.loginview.sexButton.titleLabel.text = @"male";
    }else{
        self.loginview.sexButton.titleLabel.text = @"female";
    }

}

-(void) isFindedUserFromId:(User *)user{
    NSLog(@"user = %@",user);

}

-(void) isLiked:(BOOL) isSuc :(NSString*)otherId{
    NSLog(@"匹配成功吗%d",isSuc);
}


#pragma mark - UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

#pragma mark - UIPickerViewDelegate

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row==0) {
        return @"female";
    }else{
        return @"male";
    }
    
}

-(void) isregistered:(User *)user{
    NSLog(@"注册成功案例案例拉了");
    self.isRegisted = YES;
}

-(void) isLogined{
    NSLog(@"可以跳转了全部完成");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
