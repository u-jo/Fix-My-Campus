//
//  FMCFeedPostViewController.m
//  FMC
//
//  Created by Lee Yu Zhou on 27/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import "FMCFeedPostViewController.h"
#import "FMCFeedCell.h"
#import "FMCMainPostCell.h"
@interface FMCFeedPostViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FMCFeedPostViewController

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
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshControl];
	[FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@",self.post.postID] parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"%@",result);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return [self.post.comments integerValue];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Comments";
    }
    return @"";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *postCellIdentifier = @"Main Post";
    NSString *commentCellIdentifier = @"Comment Cell";
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:postCellIdentifier];
        FMCMainPostCell *postCell = (FMCMainPostCell *)cell;
        
        
        NSMutableParagraphStyle *centerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        centerParagraphStyle.alignment = NSTextAlignmentCenter;
        
        NSMutableParagraphStyle *justifiedParagraphStyle = [[NSMutableParagraphStyle alloc]init];
        justifiedParagraphStyle.alignment = NSTextAlignmentJustified;
        UIFont *nameFont = [UIFont fontWithName:@"LucidaGrande-Bold" size:12.0];
        UIFont *commentFont = [UIFont fontWithName:@"LucidaGrande" size:12.0];
        UIFont *countFont = [UIFont fontWithName:@"LucidaGrande" size:11.0];
        NSDictionary *attributesForNameLabel = @{NSFontAttributeName : nameFont};
        NSDictionary *attributesForCommentLabel = @{NSFontAttributeName : commentFont};
        NSDictionary *attributesForCountLabel = @{NSFontAttributeName : countFont, NSParagraphStyleAttributeName: centerParagraphStyle};
        NSAttributedString *userName = [[NSAttributedString alloc] initWithString:self.post.postUserName attributes:attributesForNameLabel];
        NSAttributedString *message = [[NSAttributedString alloc] initWithString:self.post.postMessage attributes:attributesForCommentLabel];
        NSAttributedString *likeCount;
        if ([self.post.postLikeCount isEqualToString:@"1"]) {
            likeCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ Like",self.post.postLikeCount] attributes:attributesForCountLabel];
        } else {
            likeCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ Likes",self.post.postLikeCount] attributes:attributesForCountLabel];
        }
        NSAttributedString *commentCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ Comments",self.post.comments] attributes:attributesForCountLabel];
        postCell.profileView.image = self.post.image;
        postCell.profileName.attributedText = userName;
        [postCell.profileName sizeToFit];
        postCell.postLikes.attributedText = likeCount;
        postCell.mainPost.attributedText = message;
        
        
        return postCell;
    } else if (indexPath.section == 1) {
        FMCFeedCell *commentCell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
    
        return commentCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 300;
    } else if (indexPath.section == 1) {
        return 200;
    }
    return 0;
}

@end
