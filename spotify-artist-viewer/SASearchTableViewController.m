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

@end

@implementation SASearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController setNavigationBarHidden:YES];
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Search Delegates
- (void) updateSearchResultsFromSearchText:(NSString *)searchText{
    if ([searchText isEqualToString:@""]){
        self.searchResults=nil;
        [self.tableView reloadData];
        return;
    }
    
    if (self.searchBar.selectedScopeButtonIndex==0){
        [[SARequestManager sharedManager] getAllResultsFromQuery:searchText success:^(NSArray *results, NSString *query) {
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
            if (![query isEqualToString:self.searchBar.text])
                return;
            self.searchResults = [[NSMutableArray alloc] initWithArray:tracks];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            //TODO: Error handle.
        }];
    }
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self updateSearchResultsFromSearchText:searchText];
}
- (void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsFromSearchText:searchBar.text];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
