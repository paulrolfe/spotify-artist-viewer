//
//  NSURL+queryDictionary.m
//  spotify-artist-viewer
//
//  Created by Paul Rolfe on 6/10/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "NSURL+queryDictionary.h"

@implementation NSURL (queryDictionary)

- (NSDictionary *)queryDictionary{
    NSMutableDictionary *queryStrings = [[NSMutableDictionary alloc] init];
    for (NSString *qs in [self.query componentsSeparatedByString:@"&"]) {
        // Get the parameter name
        NSString *key = [[qs componentsSeparatedByString:@"="] objectAtIndex:0];
        // Get the parameter value
        NSString *value = [[qs componentsSeparatedByString:@"="] objectAtIndex:1];
        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        value = [value stringByReplacingOccurrencesOfString:@"*" withString:@""];
        value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        queryStrings[key] = value;
    }
    return queryStrings;
}

@end
