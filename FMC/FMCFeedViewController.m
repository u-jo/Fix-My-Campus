//
//  FMCFeedViewController.m
//  FMC
//
//  Created by Lee Yu Zhou on 10/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import "FMCFeedViewController.h"
#import "Post.h"
#import "FMCFeedCell.h"


@interface FMCFeedViewController ()
@property (strong, nonatomic) NSMutableArray *postsArray;
@property (strong, nonatomic) FBGraphObject *graphObject;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation FMCFeedViewController
#define POST_USER_NAME @"postUserName"
#define POST_USER_ID @"postUserID"
#define CREATED_TIME @"createdTime"
#define POST_MESSAGE @"postMessage"
#define POST_LIKE_COUNT @"postLikeCount"
#define IMAGE @"imageOfUser"
#define COMMENTS_COUNT @"commentsCount"
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMCFeedCell *feedCell = (FMCFeedCell *)cell;
    Post *post = self.postsArray[indexPath.row];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@?fields=picture",post.postUserID] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            dispatch_queue_t photoQueue = dispatch_queue_create("photoQueue", nil);
            dispatch_async(photoQueue, ^{
                NSURL *url = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageWithData:data];
                    feedCell.userProfilePictureView.image = image;
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [feedCell setNeedsDisplay];
                });
            });
        } else {
            NSLog(@"%@",[error description]);
        }
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feed Post" forIndexPath:indexPath];
    FMCFeedCell *feedCell = (FMCFeedCell *)cell;
    Post *post = self.postsArray[indexPath.row];
    UIFont *lucida = feedCell.addedByLabel.font;
    NSDictionary *attributesForNameLabel = @{NSFontAttributeName : lucida};
    NSAttributedString *userName = [[NSAttributedString alloc] initWithString:post.postUserName attributes:attributesForNameLabel];
    NSAttributedString *message = [[NSAttributedString alloc] initWithString:post.postMessage attributes:attributesForNameLabel];
    feedCell.addedByLabel.attributedText = userName;
    feedCell.comment.attributedText = message;
    return feedCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.postsArray count];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(requestForFeed) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)requestForFeed
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self createGraphObject];
    
}

- (void)createGraphObject
{
    NSString *request = [NSString stringWithFormat:@"/347519535355326/feed/"];
    NSDictionary *params = @{@"access_token" : self.accessToken, @"limit":@"10"};
    [FBRequestConnection startWithGraphPath:request parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            if ([result isKindOfClass:[FBGraphObject class]]) {
                self.graphObject = result[@"data"];
            //    NSLog(@"%@",[self.graphObject description]);
                [self createPostsArrayWith:self.graphObject];
                [self.refreshControl endRefreshing];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
        } else {
            NSLog(@"error");
        }
    
    }];
    
}

- (void)createPostsArrayWith: (FBGraphObject *)graphObject 
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (id post in graphObject) {
        NSString *postUserName = post[@"from"][@"name"];
        NSString *postUserID = post[@"from"][@"id"];
        NSString *createdTime = post[@"created_time"];
        NSString *postMessage = post[@"message"];
        NSNumber *postLikeCount = post[@"likes"][@"count"];
        if (!postLikeCount) postLikeCount = @(0);
        NSString *comments = [NSString stringWithFormat:@"%d",[post[@"comments"][@"data"] count]];
        NSDictionary *dictionary = @{POST_USER_ID: postUserID, POST_USER_NAME: postUserName, CREATED_TIME: createdTime, POST_MESSAGE: postMessage, POST_LIKE_COUNT: postLikeCount, COMMENTS_COUNT: comments};
        Post *newPost = [[Post alloc] initWithDictionary:dictionary];
        [array addObject:newPost];
    }
    self.postsArray = array;
}

- (void)setPostsArray:(NSMutableArray *)postsArray
{
    _postsArray = postsArray;
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [FBSession.activeSession requestNewReadPermissions:@[@"user_groups"] completionHandler:^(FBSession *session, NSError *error) {
        if (!error) {
            [self.refreshControl beginRefreshing];
            [self requestForFeed];
        }
    }];
    
}
@end
