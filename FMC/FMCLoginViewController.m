//
//  FMCLoginViewController.m
//  FMC
//
//  Created by Lee Yu Zhou on 8/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import "FMCLoginViewController.h"
#import "FMCAppDelegate.h"
@interface FMCLoginViewController ()

@end

@implementation FMCLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.loginView.delegate = self; 
}


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    FMCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
    UINavigationController *navViewController = (UINavigationController *)[tabBarController selectedViewController];
    FMCViewController *selectedViewController = (FMCViewController *)[navViewController topViewController];
    if ([[selectedViewController presentedViewController] isKindOfClass:[FMCLoginViewController class]]) {
        [selectedViewController dismissViewControllerAnimated:YES completion:nil];
    }
     
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    FMCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
    UINavigationController *navViewController = (UINavigationController *)[tabBarController selectedViewController];
    FMCViewController *selectedViewController = (FMCViewController *)[navViewController topViewController];
    if (![[selectedViewController presentedViewController] isKindOfClass:[FMCLoginViewController class]]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        FMCLoginViewController *loginViewController = [sb instantiateViewControllerWithIdentifier:@"FMCLoginViewController"];
        loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [selectedViewController presentViewController:loginViewController animated:YES completion:nil];
    }
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    // Facebook SDK * error handling *
    // Error handling is an important part of providing a good user experience.
    // Since this sample uses the FBLoginView, this delegate will respond to
    // login failures, or other failures that have closed the session (such
    // as a token becoming invalid). Please see the [- postOpenGraphAction:]
    // and [- requestPermissionAndPost] on `SCViewController` for further
    // error handling on other operations.
    
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"%@",[error description]);
    } else {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (FBLoginView *)loginView
{
    if (!_loginView) _loginView = [[FBLoginView alloc]initWithPublishPermissions:@[@"basic_info",@"user_groups, publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends];
    return _loginView;
}

@end
