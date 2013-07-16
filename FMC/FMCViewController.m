//
//  FMCViewController.m
//  FMC
//
//  Created by Lee Yu Zhou on 8/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import "FMCViewController.h"
#import "FMCLoginViewController.h"
#import "FMCAppDelegate.h"
@interface FMCViewController ()

@end

@implementation FMCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (NSString *)accessToken
{
    NSString *accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    return accessToken;
}

- (IBAction)logOut:(id)sender {

    [FBSession.activeSession closeAndClearTokenInformation];
    FMCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
    UINavigationController *selectedViewController = (UINavigationController *)[tabBarController selectedViewController];
    FMCViewController *viewController = (FMCViewController *)[selectedViewController topViewController];
    if (![[viewController presentedViewController] isKindOfClass:[FMCLoginViewController class]]) {
        NSLog(@"Dismissing FMC Login View Controller with no animations");
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        FMCLoginViewController *loginViewController = [sb instantiateViewControllerWithIdentifier:@"FMCLoginViewController"];
        loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [viewController presentViewController:loginViewController animated:YES completion:nil];
    }
}

- (void)updateUI
{
    FMCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
    UINavigationController *selectedViewController = (UINavigationController *)[tabBarController selectedViewController];
    FMCViewController *viewController = (FMCViewController *)[selectedViewController topViewController];
    if (![[viewController presentedViewController] isKindOfClass:[FMCLoginViewController class]] && ![FBSession.activeSession isOpen]) {
            NSLog(@"Presenting FMC Login View Controller with no animations");
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            FMCLoginViewController *loginViewController = [sb instantiateViewControllerWithIdentifier:@"FMCLoginViewController"];
            loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [viewController presentViewController:loginViewController animated:NO completion:nil];
        }
}


@end
