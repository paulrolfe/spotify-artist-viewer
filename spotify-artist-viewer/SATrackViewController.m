//
//  SATrackViewController.m
//  spotify-artist-viewer
//
//  Created by Paul Rolfe on 6/10/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SATrackViewController.h"
#import <APAvatarImageView.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface SATrackViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet APAvatarImageView *trackImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *openInSpotifyButton;

@end

@implementation SATrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self displayInfo];
}
- (void) setupViews{
    [self.backButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.backButton.layer setCornerRadius:4];
    [self.openInSpotifyButton setBackgroundColor:[UIColor colorWithRed:0.66 green:0.81 blue:0 alpha:1]];
    [self.openInSpotifyButton.layer setCornerRadius:15];
}
- (void) displayInfo{
    [self.trackNameLabel setText:self.track.name];
    [self.artistNameLabel setText:self.track.artistName];
    [self.albumNameLabel setText:self.track.albumAppearsOn];
    [self.trackImageView sd_setImageWithURL:[NSURL URLWithString:self.track.imageURL] placeholderImage:[UIImage imageNamed:@"track-placeholder"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backTouched:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
