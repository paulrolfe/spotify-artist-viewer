//
//  SAArtist.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtist.h"

@implementation SAArtist

- (instancetype) initWithDictionary:(NSDictionary *)artistDictionary{
    if (self = [super init]){
        //setup here
        self.name = artistDictionary[@"name"];
        self.spotifyURI = artistDictionary[@"uri"];
        self.imageURL = [(NSDictionary *)[(NSArray *)artistDictionary[@"images"] firstObject] objectForKey:@"url"];
        self.bio = @"Loading...";
        self.popularity = artistDictionary[@"popularity"];
        self.spotifyExternalURL = [NSString stringWithFormat:@"spotify://artist:%@",artistDictionary[@"id"]];

    }
    return self;
}

@end
