//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"
#import "AFNetworking.h"

NSString const * BASE_URL_SPOTIFY = @"https://api.spotify.com/v1/search";
NSString const * ECHONEST_API_KEY = @"DXRM3NA4WII8WVHGF";
NSString const * BASE_URL_ECHONEST = @"http://developer.echonest.com/api/v4/artist/biographies";

@implementation SARequestManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)getArtistsWithQuery:(NSString *)query
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure {
    if ([query isEqualToString:@""]){
        success(nil);
    }
    else{
        NSString * request = [NSString stringWithFormat:@"%@?q=%@&type=artist",BASE_URL_SPOTIFY,[query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:request parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray * artistArray = [[NSMutableArray alloc] init];
            NSArray * responseArray = responseObject[@"artists"][@"items"];
            for (NSDictionary *artistDict in responseArray){
                SAArtist * artist =[[SAArtist alloc] initWithDictionary:artistDict];
                [artistArray addObject:artist];
            }
            success(artistArray);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            failure(error);
        }];
    }
}
- (void) getFullArtistFromArtist:(SAArtist *)artist
                         success:(void (^)(SAArtist *artist))success
                         failure:(void (^)(NSError *error))failure


{
    
    NSString * request = [NSString stringWithFormat:@"%@?api_key=%@&id=%@&results=1",BASE_URL_ECHONEST,ECHONEST_API_KEY,artist.spotifyURI];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:request parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * bioData = responseObject[@"response"][@"biographies"];
        NSDictionary * bioDict = [bioData firstObject];
        NSString * bio = bioDict[@"text"];
        artist.bio = bio;
        success(artist);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
    
}

@end
