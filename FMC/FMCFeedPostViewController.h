//
//  FMCFeedPostViewController.h
//  FMC
//
//  Created by Lee Yu Zhou on 27/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <FacebookSDK/FacebookSDK.h>
@interface FMCFeedPostViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Post *post;
@end
