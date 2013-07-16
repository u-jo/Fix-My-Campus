//
//  FMCAppDelegate.h
//  FMC
//
//  Created by Lee Yu Zhou on 8/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCViewController.h"
@interface FMCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FMCViewController *mainViewController; // to do: make all classes subclasses of fmcviewcontroller
@end
