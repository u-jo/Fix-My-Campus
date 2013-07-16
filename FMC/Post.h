//
//  Post.h
//  FMC
//
//  Created by Lee Yu Zhou on 14/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject
@property (strong, nonatomic) NSString *postUserName;
@property (strong, nonatomic) NSString *postUserID;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *postMessage;
@property (strong, nonatomic) NSString *postLikeCount;
@property (strong, nonatomic) NSString *comments;
@property (strong, nonatomic) UIImage *image;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
