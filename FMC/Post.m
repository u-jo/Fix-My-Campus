//
//  Post.m
//  FMC
//
//  Created by Lee Yu Zhou on 14/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import "Post.h"

@implementation Post
#define POST_USER_NAME @"postUserName"
#define POST_USER_ID @"postUserID"
#define CREATED_TIME @"createdTime"
#define POST_MESSAGE @"postMessage"
#define POST_LIKE_COUNT @"postLikeCount"
#define COMMENTS_COUNT @"commentsCount"
#define IMAGE @"imageOfUser"

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        self.postUserName = dictionary[POST_USER_NAME];
        self.postUserID = dictionary[POST_USER_ID];
        self.postMessage = dictionary[POST_MESSAGE];
        self.createTime = dictionary[CREATED_TIME];
        self.postLikeCount = dictionary[POST_LIKE_COUNT];
        self.comments = dictionary[COMMENTS_COUNT];
        self.image = dictionary[IMAGE];
    }
    return self; 
}
@end
