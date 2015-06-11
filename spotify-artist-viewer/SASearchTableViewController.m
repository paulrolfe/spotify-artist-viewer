//
//  SASearchTableViewController.m
//  spotify-artist-viewer
//
//  Created by Paul Rolfe on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SASearchTableViewController.h"
#import "SARequestManager.h"
#import "SAArtist.h"
#import "SAArtistViewController.h"
#import "SATrackViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomTableViewCell.h"

@interface SASearchTableViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (nonatomic) BOOL busyFetching;


@end

@implementation SASearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}
- (void) viewDidAppear:(BOOL)animated{
    [self.searchBar becomeFirstResponder];
}

#pragma mark - Query Methods
- (void) updateSearchResultsFromSearchText:(NSString *)searchText{
    if ([searchText isEqualToString:@""]){
        self.searchResults=nil;
        [self.tableView reloadData];
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    if (self.searchBar.selectedScopeButtonIndex==0){
        [[SARequestManager sharedManager] getAllResultsFromQuery:searchText success:^(NSArray *results, NSString *query) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            
            if (![query isEqualToString:self.searchBar.text])
                return;
            self.searchResults = [[NSMutableArray alloc] initWithArray:results];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            //TODO: Error handle.
        }];
    }
    else if(self.searchBar.selectedScopeButtonIndex==1){
        [[SARequestManager sharedManager] getArtistsWithQuery:searchText success:^(NSArray *artists, NSString *query) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

            if (![query isEqualToString:self.searchBar.text])
                return;
            self.searchResults = [[NSMutableArray alloc] initWithArray:artists];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            //TODO: Error handle.
        }];
    }
    else if(self.searchBar.selectedScopeButtonIndex==2){
        [[SARequestManager sharedManager] getTracksWithQuery:searchText success:^(NSArray *tracks, NSString *query) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

            if (![query isEqualToString:self.searchBar.text])
                return;
            self.searchResults = [[NSMutableArray alloc] initWithArray:tracks];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            //TODO: Error handle.
        }];
    }
    
}
- (void) fetchNextResults{
    if (self.busyFetching) return;
    self.busyFetching = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [[SARequestManager sharedManager] getNextPageFromLastSearchWithOffset:@(self.searchResults.count)
                                                                  success:^(NSArray *results, NSString *query) {
                                                                      self.busyFetching=NO;
                                                                      [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                                                                      
                                                                      if (![query isEqualToString:self.searchBar.text])
                                                                          return;
                                                                      [self.searchResults addObjectsFromArray:results];
                                                                      [self.tableView reloadData];
                                                                  }
                                                                  failure:^(NSError *error) {
                                                                      //Do something?
                                                                      
                                                                  }];
}

#pragma mark - Search Bar Delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self updateSearchResultsFromSearchText:searchText];
}
- (void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsFromSearchText:searchBar.text];
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell.imageView setClipsToBounds:YES];

    id pickedItem = [self.searchResults objectAtIndex:indexPath.row];
    if ([pickedItem isKindOfClass:[SAArtist class]]){
        SAArtist * thisArtist = (SAArtist *)pickedItem;
        [cell.mainLabel setText:thisArtist.name];
        [cell.detailLabel setText:@""];
        [cell.sideImageView sd_setImageWithURL:[NSURL URLWithString:thisArtist.imageURL] placeholderImage:[UIImage imageNamed:@"artist-placeholder"]];
    }
    else if([pickedItem isKindOfClass:[SATrack class]]){
        SATrack * thisTrack = (SATrack *)pickedItem;
        [cell.mainLabel setText:thisTrack.name];
        [cell.detailLabel setText:thisTrack.artistName];
        [cell.sideImageView sd_setImageWithURL:[NSURL URLWithString:thisTrack.imageURL] placeholderImage:[UIImage imageNamed:@"track-placeholder"]];
    }
    //background colors
    if (indexPath.row % 2 == 1){
        cell.backgroundColor = [UIColor whiteColor];
    }
    else{
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id pickedItem = [self.searchResults objectAtIndex:indexPath.row];
    if ([pickedItem isKindOfClass:[SAArtist class]]){
        SAArtist *pickedArtist = (SAArtist *)pickedItem;
        SAArtistViewController * artistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"artistVC"];
        [artistVC setArtist:pickedArtist];
        [self.navigationController pushViewController:artistVC animated:YES];
    }
    else if([pickedItem isKindOfClass:[SATrack class]]){
        SATrack *pickedTrack = (SATrack *)pickedItem;
        SATrackViewController * trackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"trackVC"];
        [trackVC setTrack:pickedTrack];
        [self.navigationController pushViewController:trackVC animated:YES];
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - Table view delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
    
    // Fetch new challenges when the bottom row is 3 away from the end of the results.
    NSIndexPath * bottomPath =(NSIndexPath *)self.tableView.indexPathsForVisibleRows.lastObject;
    if (bottomPath.row>=self.searchResults.count-3){
        [self fetchNextResults];
    }
}



@end
