//
//  FMCProfilePictureFeedView.m
//  FMC
//
//  Created by Lee Yu Zhou on 15/7/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import "FMCProfilePictureFeedView.h"

@implementation FMCProfilePictureFeedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define CORNER_RADIUS 14.0
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    [self.image drawInRect:self.bounds];
    
    [[UIColor clearColor] setStroke];
    [roundedRect stroke];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsDisplay];
}

@end
