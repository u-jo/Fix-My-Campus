//
//  FMCLoginViewController.h
//  FMC
//
//  Created by Lee Yu Zhou on 8/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface FMCLoginViewController : UIViewController <FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet FBLoginView *loginView;

@end
