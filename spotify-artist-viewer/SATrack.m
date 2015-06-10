//
//  SATrack.m
//  spotify-artist-viewer
//
//  Created by Paul Rolfe on 6/10/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SATrack.h"

@implementation SATrack

- (instancetype) initWithDictionary:(NSDictionary *)trackDictionary{
    if (self = [super init]){
        //setup here
        self.name = trackDictionary[@"name"];
        self.trackURI = trackDictionary[@"uri"];
        self.imageURL = [(NSDictionary *)[(NSArray *)trackDictionary[@"album"][@"images"] firstObject] objectForKey:@"url"];
        self.artistName = [(NSDictionary *)[(NSArray *)trackDictionary[@"artists"] firstObject] objectForKey:@"name"];
        self.albumAppearsOn = trackDictionary[@"album"][@"name"];
        self.artistURI = [(NSDictionary *)[(NSArray *)trackDictionary[@"artists"] firstObject] objectForKey:@"uri"];
        self.popularity = trackDictionary[@"popularity"];
    }
    return self;
}

@end
