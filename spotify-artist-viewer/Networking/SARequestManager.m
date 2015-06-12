//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"
#import "AFNetworking.h"
#import "NSURL+queryDictionary.h"


NSString const * BASE_URL_SPOTIFY = @"https://api.spotify.com/v1/search";
NSString const * ECHONEST_API_KEY = @"DXRM3NA4WII8WVHGF";
NSString const * BASE_URL_ECHONEST = @"http://developer.echonest.com/api/v4/artist/biographies";

@interface SARequestManager ()

@property (nonatomic, strong) NSString *lastRequest;

@end

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
                    success:(void (^)(NSArray *artists, NSString *query))success
                    failure:(void (^)(NSError *error))failure {
    if ([query isEqualToString:@""]){
        success(nil,nil);
    }
    else{
        NSString *request = [NSString stringWithFormat:@"%@?q=%@*&type=artist&market=US",BASE_URL_SPOTIFY,[query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        self.lastRequest = request;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:request parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *queryDict = [NSURL URLWithString:responseObject[@"artists"][@"href"]].queryDictionary;
            NSMutableArray *artistArray = [[NSMutableArray alloc] init];
            NSArray * responseArray = responseObject[@"artists"][@"items"];
            for (NSDictionary *artistDict in responseArray){
                SAArtist * artist =[[SAArtist alloc] initWithDictionary:artistDict];
                [artistArray addObject:artist];
            }
            NSSortDescriptor *sortPop = [NSSortDescriptor sortDescriptorWithKey:@"popularity" ascending:NO];
            [artistArray sortUsingDescriptors:@[sortPop]];
            success(artistArray,queryDict[@"query"]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            failure(error);
        }];
    }
}
- (void)getTracksWithQuery:(NSString *)query
                    success:(void (^)(NSArray *tracks, NSString *query))success
                    failure:(void (^)(NSError *error))failure {
    if ([query isEqualToString:@""]){
        success(nil,nil);
    }
    else{
        NSString *request = [NSString stringWithFormat:@"%@?q=%@*&type=track&market=US",BASE_URL_SPOTIFY,[query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        self.lastRequest = request;

        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:request parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *queryDict = [NSURL URLWithString:responseObject[@"tracks"][@"href"]].queryDictionary;
            NSMutableArray *trackArray = [[NSMutableArray alloc] init];
            NSArray * responseArray = responseObject[@"tracks"][@"items"];
            for (NSDictionary *trackDict in responseArray){
                SATrack *track=[[SATrack alloc] initWithDictionary:trackDict];
                [trackArray addObject:track];
            }

            NSSortDescriptor *sortPop = [NSSortDescriptor sortDescriptorWithKey:@"popularity" ascending:NO];
            [trackArray sortUsingDescriptors:@[sortPop]];
            success(trackArray,queryDict[@"query"]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            failure(error);
        }];
    }
}
- (void) getAllResultsFromQuery:(NSString *)query
                        success:(void (^)(NSArray *results, NSString *query))success
                        failure:(void (^)(NSError *error))failure {
    if ([query isEqualToString:@""]){
        success(nil,query);
    }
    else{
        NSString *request = [NSString stringWithFormat:@"%@?q=%@*&type=track,artist&market=US",BASE_URL_SPOTIFY,[query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        self.lastRequest = request;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:request parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *queryDict = [NSURL URLWithString:responseObject[@"tracks"][@"href"]].queryDictionary;
            if (!queryDict)
                queryDict = [NSURL URLWithString:responseObject[@"artists"][@"href"]].queryDictionary;
            
            NSMutableArray *allArray = [[NSMutableArray alloc] init];
            NSArray *artistArray = responseObject[@"artists"][@"items"];
            for (NSDictionary *artistDict in artistArray){
                SAArtist * artist =[[SAArtist alloc] initWithDictionary:artistDict];
                [allArray addObject:artist];
            }
            NSArray *trackArray = responseObject[@"tracks"][@"items"];
            for (NSDictionary *trackDict in trackArray){
                SATrack *track=[[SATrack alloc] initWithDictionary:trackDict];
                [allArray addObject:track];
            }

            //sort by popularity
            NSSortDescriptor *sortPop = [NSSortDescriptor sortDescriptorWithKey:@"popularity" ascending:NO];
            [allArray sortUsingDescriptors:@[sortPop]];
            success(allArray,queryDict[@"query"]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            failure(error);
        }];
    }
    
}
- (void) getBioForArtist:(SAArtist *)artist
                         success:(void (^)(SAArtist *artist))success
                         failure:(void (^)(NSError *error))failure


{
    
    NSString * request = [NSString stringWithFormat:@"%@?api_key=%@&id=%@",BASE_URL_ECHONEST,ECHONEST_API_KEY,artist.spotifyURI];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:request parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *bioData = responseObject[@"response"][@"biographies"];
        NSString *bio = @"Bio not found. Sorry!";
        for (NSDictionary *bioDict in bioData){
            //Find a bio, that's not truncated.
            if (![bioDict valueForKey:@"truncated"]){
                 bio = bioDict[@"text"];
                 break;
            }
        }
        artist.bio = bio;
        success(artist);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
    
}
- (void) getNextPageFromLastSearchWithOffset:(NSNumber *)offset
                                     success:(void (^)(NSArray *results, NSString *query))success
                                     failure:(void (^)(NSError *error))failure
{
    if (!self.lastRequest)
        return;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@&offset=%@",self.lastRequest,offset] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *queryDict = [NSURL URLWithString:responseObject[@"tracks"][@"href"]].queryDictionary;
        if (!queryDict)
            queryDict = [NSURL URLWithString:responseObject[@"artists"][@"href"]].queryDictionary;
        
        NSMutableArray *allArray = [[NSMutableArray alloc] init];
        NSArray *artistArray = responseObject[@"artists"][@"items"];
        for (NSDictionary *artistDict in artistArray){
            SAArtist * artist =[[SAArtist alloc] initWithDictionary:artistDict];
            [allArray addObject:artist];
        }
        NSArray *trackArray = responseObject[@"tracks"][@"items"];
        for (NSDictionary *trackDict in trackArray){
            SATrack *track=[[SATrack alloc] initWithDictionary:trackDict];
            [allArray addObject:track];
        }
        //sort by popularity
        NSSortDescriptor *sortPop = [NSSortDescriptor sortDescriptorWithKey:@"popularity" ascending:NO];
        [allArray sortUsingDescriptors:@[sortPop]];
        success(allArray,queryDict[@"query"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
}


@end
