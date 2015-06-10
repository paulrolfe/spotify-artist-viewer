//
//  SATrack.h
//  spotify-artist-viewer
//
//  Created by Paul Rolfe on 6/10/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SATrack : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * albumAppearsOn;
@property (nonatomic, strong) NSString * artistName;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) NSString * trackURI;
@property (nonatomic, strong) NSString * artistURI;
@property (nonatomic, strong) NSNumber * popularity;



- (instancetype) initWithDictionary:(NSDictionary *)trackDictionary;


@end
