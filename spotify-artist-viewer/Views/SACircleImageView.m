//
//  SACircleImageView.m
//  spotify-artist-viewer
//
//  Created by Paul Rolfe on 6/11/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SACircleImageView.h"

@implementation SACircleImageView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
     CGContextRef context = UIGraphicsGetCurrentContext();
     UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:( CGRectGetWidth(self.frame)/2.0f )];
     CGContextAddPath(context, path.CGPath);
     CGContextFillPath(context);
}


@end
