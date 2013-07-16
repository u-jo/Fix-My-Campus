//
//  FMCFeedCell.h
//  FMC
//
//  Created by Lee Yu Zhou on 15/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCProfilePictureFeedView.h"
@interface FMCFeedCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *addDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *addedByLabel;
@property (strong, nonatomic) IBOutlet UITextView *comment;
@property (strong, nonatomic) IBOutlet FMCProfilePictureFeedView *userProfilePictureView;


@end
