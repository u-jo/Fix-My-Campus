//
//  FMCFeedCell.h
//  FMC
//
//  Created by Lee Yu Zhou on 15/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCProfilePictureFeedView.h"
#import "Post.h"
@interface FMCFeedCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *addDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *addedByLabel;
@property (strong, nonatomic) IBOutlet UITextView *comment;
@property (strong, nonatomic) IBOutlet FMCProfilePictureFeedView *userProfilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *likeCount;

@property (strong, nonatomic) IBOutlet UILabel *commentCount;
@property (strong, nonatomic) NSString *postID;
@property (strong, nonatomic) Post *post; 
@end
