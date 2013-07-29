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
#import "FMCFeedPostViewController.h"

@interface FMCFeedViewController ()
@property (strong, nonatomic) NSMutableArray *postsArray;
@property (strong, nonatomic) NSMutableArray *addedPosts;
@property (strong, nonatomic) FBGraphObject *graphObject;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL firstLoad;
@property (nonatomic) BOOL loading;
@property (nonatomic) int count;
@property (nonatomic) int offset;
@property (nonatomic) BOOL triggeredByScrollingToBottom;
@end

@implementation FMCFeedViewController
#define POST_USER_NAME @"postUserName"
#define POST_USER_ID @"postUserID"
#define CREATED_TIME @"createdTime"
#define POST_MESSAGE @"postMessage"
#define POST_LIKE_COUNT @"postLikeCount"
#define IMAGE @"imageOfUser"
#define COMMENTS_COUNT @"commentsCount"
#define POST_ID @"postID"
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Indiv Post Segue"]) {
        if ([segue.destinationViewController isKindOfClass:[FMCFeedPostViewController class]]) {
            FMCFeedPostViewController *feedPostViewController = (FMCFeedPostViewController *)segue.destinationViewController;
            if ([sender isKindOfClass:[FMCFeedCell class]]) {
                FMCFeedCell *feedCell = (FMCFeedCell *)sender;
                feedPostViewController.post = feedCell.post;
                
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor colorWithRed:245 green:245 blue:20 alpha:0.6];
    FMCFeedCell *feedCell = (FMCFeedCell *)cell;
    Post *post = self.postsArray[indexPath.row];
    feedCell.userProfilePictureView.image = post.image;
    feedCell.postID = post.postID;
    if (!post.image) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@?fields=picture",post.postUserID] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                dispatch_queue_t photoQueue = dispatch_queue_create("photoQueue", nil);
                dispatch_async(photoQueue, ^{
                    NSURL *url = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImage *image = [UIImage imageWithData:data];
                        post.image = image;
                        self.postsArray[indexPath.row] = post;
                        feedCell.userProfilePictureView.image = image;
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                      //  [self.tableView reloadData];
                    });
                });
            } else {
                NSLog(@"%@",[error description]);
            }
        }];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feed Post" forIndexPath:indexPath];
    
    FMCFeedCell *feedCell = (FMCFeedCell *)cell;
    Post *post = self.postsArray[indexPath.row];
    feedCell.post = post;
    UIFont *nameFont = [UIFont fontWithName:@"LucidaGrande-Bold" size:12.0];
    UIFont *commentFont = [UIFont fontWithName:@"LucidaGrande" size:12.0];
    UIFont *countFont = [UIFont fontWithName:@"LucidaGrande" size:11.0];
    NSDictionary *attributesForNameLabel = @{NSFontAttributeName : nameFont};
    NSDictionary *attributesForCommentLabel = @{NSFontAttributeName : commentFont};
    NSDictionary *attributesForCountLabel = @{NSFontAttributeName : countFont};
    NSAttributedString *userName = [[NSAttributedString alloc] initWithString:post.postUserName attributes:attributesForNameLabel];
    NSAttributedString *message = [[NSAttributedString alloc] initWithString:post.postMessage attributes:attributesForCommentLabel];
    NSAttributedString *likeCount;
    if ([post.postLikeCount isEqualToString:@"1"]) {
        likeCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ Like",post.postLikeCount] attributes:attributesForCountLabel];
    } else {
        likeCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ Likes",post.postLikeCount] attributes:attributesForCountLabel];
    }
    NSAttributedString *commentCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ Comments",post.comments] attributes:attributesForCountLabel];
    
    feedCell.userProfilePictureView.image = post.image;
    
    feedCell.addedByLabel.attributedText = userName;
    [feedCell.addDateLabel sizeToFit];
    
    feedCell.comment.attributedText = message;
    
    feedCell.likeCount.attributedText = likeCount;
    [feedCell.likeCount sizeToFit];
    feedCell.commentCount.attributedText = commentCount;
    [feedCell.commentCount sizeToFit];
    
    if (!post.image){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@?fields=picture&type=large",post.postUserID] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                dispatch_queue_t photoQueue = dispatch_queue_create("photoQueue", nil);
                dispatch_async(photoQueue, ^{
                    NSURL *url = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImage *image = [UIImage imageWithData:data];
                        post.image = image;
                        self.postsArray[indexPath.row] = post;
                        feedCell.userProfilePictureView.image = image;
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        [feedCell setNeedsDisplay];
                 //       [self.tableView reloadData];
                    });
                });
            } else {
                NSLog(@"%@",[error description]);
            }
        }];
    }
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(likePost:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [feedCell addGestureRecognizer:swipeRight];
    return feedCell;
}

- (void)likePost:(UISwipeGestureRecognizer *)swipeRight
{
    CGPoint location = [swipeRight locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if ([cell isKindOfClass:[FMCFeedCell class]]) {
        FMCFeedCell *feedCell = (FMCFeedCell *)cell;
        NSLog(@"%@",feedCell.postID);
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/likes",feedCell.postID] parameters:nil HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@",feedCell.postID] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                NSNumber *count = result[@"likes"][@"count"];
                if (!count) {
                    count = @(0);
                }
                if ([self.postsArray[indexPath.row] isKindOfClass:[Post class]]) {
                    Post *post = self.postsArray[indexPath.row];
                    post.postLikeCount = [NSString stringWithFormat:@"%@",count];
                    self.postsArray[indexPath.row] = post;
                    UIFont *countFont = [UIFont fontWithName:@"LucidaGrande" size:11.0];
                    NSAttributedString *likeCount;
                    if ([post.postLikeCount isEqualToString:@"1"]) {
                        likeCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ Like",post.postLikeCount] attributes:@{NSFontAttributeName : countFont}];
                    } else {
                        likeCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ Likes",post.postLikeCount] attributes:@{NSFontAttributeName : countFont}];
                    }
                    feedCell.likeCount.attributedText = likeCount;
                    [feedCell.likeCount setNeedsDisplay];
                }
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }]; 
        }];
        
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.postsArray count];
}


#define COUNTER 40;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.count = COUNTER;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(requestForFeed) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:self.refreshControl];
    
   // UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookshelf.png"]];
   // [imageView setFrame:self.tableView.frame];
    
   // self.tableView.backgroundView = imageView;
    
   // [self.tableView setSeparatorColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (IBAction)requestForFeed
{
    
    self.loading = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self createGraphObject];
    [self.tableView reloadData];
    
}

- (void)createGraphObject
{
    NSString *request = [NSString stringWithFormat:@"/347519535355326/feed/"];
    NSDictionary *params = @{@"access_token" : self.accessToken, @"limit":[NSString stringWithFormat:@"%d",self.count] };
    [FBRequestConnection startWithGraphPath:request parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            if ([result isKindOfClass:[FBGraphObject class]]) {
                self.graphObject = result[@"data"];
            //    NSLog(@"%@",[self.graphObject description]);
                [self createPostsArrayWith:self.graphObject];
                [self.refreshControl endRefreshing];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                self.loading = NO;
                self.triggeredByScrollingToBottom = NO;
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"We could not access Fix My Campus" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"error");
        }
    
    }];
    
}

- (void)createPostsArrayWith: (FBGraphObject *)graphObject 
{
    NSMutableArray *addArray = [[NSMutableArray alloc] init];
    for (id post in graphObject) {
        NSString *postID = post[@"id"];
        if (![self.addedPosts containsObject:postID]) {
            [self.addedPosts addObject:postID];
            NSString *postUserName = post[@"from"][@"name"];
            NSString *postUserID = post[@"from"][@"id"];
            NSString *createdTime = post[@"created_time"];
            NSString *postMessage = post[@"message"];
            NSNumber *postLikeCountNumber = post[@"likes"][@"count"];
            NSString *postLikeCount; 
            if (!postLikeCountNumber) {
                postLikeCount = @"0";
            } else {
                postLikeCount = [NSString stringWithFormat:@"%@",post[@"likes"][@"count"]];
            }
            NSString *comments = [NSString stringWithFormat:@"%d",[post[@"comments"][@"data"] count]];
            NSDictionary *dictionary = @{POST_USER_ID: postUserID, POST_USER_NAME: postUserName, CREATED_TIME: createdTime, POST_MESSAGE: postMessage, POST_LIKE_COUNT: postLikeCount, COMMENTS_COUNT: comments, POST_ID : postID};
            Post *newPost = [[Post alloc] initWithDictionary:dictionary];
            [addArray addObject:newPost];
        }
    }
    if (self.triggeredByScrollingToBottom) {
        NSMutableArray *originalArray = self.postsArray;
        [originalArray addObjectsFromArray:addArray];
        self.postsArray = originalArray;
    } else {
        [addArray addObjectsFromArray:self.postsArray];
        self.postsArray = addArray;
    }
    
}

@synthesize postsArray = _postsArray;
- (void)setPostsArray:(NSMutableArray *)postsArray
{
    _postsArray = postsArray;
    [self.tableView reloadData];
}

- (NSMutableArray *)postsArray
{
    if (!_postsArray) _postsArray = [[NSMutableArray alloc]init];
    return _postsArray;
}

- (NSMutableArray *)addedPosts
{
    if (!_addedPosts)_addedPosts = [[NSMutableArray alloc] init];
    return _addedPosts;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    //    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.refreshControl beginRefreshing];
    [FBSession.activeSession requestNewReadPermissions:@[@"user_groups"] completionHandler:^(FBSession *session, NSError *error) {
            if (!error) {
                [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
                    [self requestForFeed];
                }];
            }
    }];
}

#define THRESHOLD 20
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.postsArray count] > THRESHOLD) {
        CGFloat height = scrollView.frame.size.height;
         
        CGFloat contentYoffset = scrollView.contentOffset.y;
      //  NSLog(@"Content Y Offset: %f",contentYoffset);
        
        CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
     //   NSLog(@"Distance From Bottom: %f        Height: %f\n",distanceFromBottom, height);
        if (distanceFromBottom < height * 3 && self.loading == NO)
        {
            NSLog(@"loading");
            self.triggeredByScrollingToBottom = YES;
            self.count += 8;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [self requestForFeed];
        }
    }
}


@end
