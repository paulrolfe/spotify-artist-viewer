//
//  SARequestManager.h
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAArtist.h"
#import "SATrack.h"


@interface SARequestManager : NSObject

+ (instancetype)sharedManager;

- (void)getArtistsWithQuery:(NSString *)query
                    success:(void (^)(NSArray *artists, NSString *query))success
                    failure:(void (^)(NSError *error))failure;

- (void)getTracksWithQuery:(NSString *)query
                   success:(void (^)(NSArray *tracks, NSString *query))success
                   failure:(void (^)(NSError *error))failure;

- (void)getAllResultsFromQuery:(NSString *)query
                        success:(void (^)(NSArray *results, NSString *query))success
                        failure:(void (^)(NSError *error))failure;

- (void)getBioForArtist:(SAArtist *)artist
                         success:(void (^)(SAArtist *artist))success
                         failure:(void (^)(NSError *error))failure;

- (void)getNextPageFromLastSearchWithOffset:(NSNumber *)offset
                                     success:(void (^)(NSArray *results, NSString *query))success
                                     failure:(void (^)(NSError *error))failure;



@end
