//
//  UIImageView+CircleCrop.m
//  spotify-artist-viewer
//
//  Created by Paul Rolfe on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "UIImageView+CircleCrop.h"

@implementation UIImageView (CircleCrop)


- (void)cropToCircle{
    self.layer.cornerRadius = self.frame.size.height/2;
    [self setNeedsLayout];
}

@end
