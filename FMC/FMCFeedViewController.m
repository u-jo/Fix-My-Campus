//
//  FMCFeedViewController.m
//  FMC
//
//  Created by Lee Yu Zhou on 10/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import "FMCFeedViewController.h"
#import "Post.h"
@interface FMCFeedViewController ()
@property (strong, nonatomic) NSMutableArray *postsArray;
@property (strong, nonatomic) FBGraphObject *graphObject;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation FMCFeedViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feed Post" forIndexPath:indexPath];
    
    return cell;
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
    [self.refreshControl beginRefreshing];
    [self requestForFeed];
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
    NSDictionary *params = @{@"access_token" : self.accessToken};
    [FBRequestConnection startWithGraphPath:request parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            if ([result isKindOfClass:[FBGraphObject class]]) {
                self.graphObject = result[@"data"];
            //    NSLog(@"%@",[self.graphObject description]);
                [self createPostsArrayWith:self.graphObject];
                
            }
        } else {
            NSLog(@"error");
        }
    
    }];
    
}
#define POST_USER_NAME @"postUserName"
#define POST_USER_ID @"postUserID"
#define CREATED_TIME @"createdTime"
#define POST_MESSAGE @"postMessage"
#define POST_LIKE_COUNT @"postLikeCount"
#define IMAGE @"imageOfUser"
#define COMMENTS_COUNT @"commentsCount"
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
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@?fields=picture",postUserID] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSURL *url = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                NSDictionary *dictionary = @{POST_USER_ID: postUserID, POST_USER_NAME: postUserName, CREATED_TIME: createdTime, POST_MESSAGE: postMessage, POST_LIKE_COUNT: postLikeCount, COMMENTS_COUNT: comments, IMAGE: image};
                Post *newPost = [[Post alloc] initWithDictionary:dictionary];
                [array addObject:newPost];
                self.postsArray = array;
            } else {
                NSLog(@"%@",[error description]);
            }
        }];
    }
    [self.refreshControl endRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
            
        }
    }];
    
}
@end
