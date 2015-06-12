//
//  SAArtist.h
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAArtist : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * bio;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) NSString * spotifyURI;
@property (nonatomic, strong) NSNumber * popularity;
@property (nonatomic, strong) NSString * spotifyExternalURL;

- (instancetype) initWithDictionary:(NSDictionary *)artistDictionary;

@end
