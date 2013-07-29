//
//  FMCMainPostCell.h
//  FMC
//
//  Created by Lee Yu Zhou on 28/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCProfilePictureFeedView.h"
@interface FMCMainPostCell : UITableViewCell
@property (strong, nonatomic) IBOutlet FMCProfilePictureFeedView *profileView;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@property (strong, nonatomic) IBOutlet UILabel *postLikes;
@property (strong, nonatomic) IBOutlet UILabel *postComments;
@property (strong, nonatomic) IBOutlet UITextView *mainPost;

@end
