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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Search Delegates
- (void) updateSearchResultsFromSearchText:(NSString *)searchText{
    [[SARequestManager sharedManager] getArtistsWithQuery:searchText success:^(NSArray *artists) {
        self.searchResults = [[NSMutableArray alloc] initWithArray:artists];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //TODO: Error handle.
    }];
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self updateSearchResultsFromSearchText:searchText];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
    
    // Configure the cell...
    SAArtist * thisArtist = [self.searchResults objectAtIndex:indexPath.row];
    if (indexPath.row % 2 == 1){
        cell.backgroundColor = [UIColor whiteColor];
    }
    else{
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    [cell.textLabel setText:thisArtist.name];
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SAArtist *pickedArtist = [self.searchResults objectAtIndex:indexPath.row];
    SAArtistViewController * artistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"artistVC"];
    [artistVC setArtist:pickedArtist];
    [self.navigationController pushViewController:artistVC animated:YES];
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
