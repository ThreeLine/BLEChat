//
//  PickerDialogController.h
//  Christmaslight
//
//  Created by Eleven Chen on 15/8/13.
//  Copyright (c) 2015年 Hunuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PickerDialogController;

typedef void (^Block)(PickerDialogController*);

@interface PickerDialogController : UIViewController

+ (PickerDialogController*) dialogPickerWithTitle:(NSString*) title cancelTitle:(NSString*) cancelTitle cancelBlock: (Block)cancelBlock doneTitle:(NSString*) doneTitle doneBlock: (Block) doneBlock customView: (UIView*) view;

- (void) show;

- (void) dismiss;

@end
