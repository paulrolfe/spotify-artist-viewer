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


- (instancetype) initWithDictionary:(NSDictionary *)artistDictionary;

@end
