//
//  SAArtistViewController.m
//  spotify-artist-viewer
//
//  Created by Paul Rolfe on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtistViewController.h"
#import "APAvatarImageView.h"
#import "SARequestManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+SAColors.h"

@interface SAArtistViewController ()
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet APAvatarImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UITextView *artistBioTextView;
@property (weak, nonatomic) IBOutlet UIButton *openInSpotifyButton;

@end

@implementation SAArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[SARequestManager sharedManager] getBioForArtist:self.artist success:^(SAArtist *artist) {
        if(artist.bio){
            self.artist = artist;
            [self displayInfo];
        }
    } failure:^(NSError *error) {
        //Some error handling.
    }];
    [self setupViews];
    [self displayInfo];
}
- (void) setupViews{
    [self.artistImageView setBorderWidth:1.0];
    [self.backButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.backButton.layer setCornerRadius:4];
    [self.openInSpotifyButton setBackgroundColor:[UIColor spotifyGreen]];
    [self.openInSpotifyButton.layer setCornerRadius:15];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.artist.spotifyExternalURL]]){
        [self.openInSpotifyButton setEnabled:NO];
    }
}
- (void) displayInfo{
    [self.artistBioTextView setText:self.artist.bio];
    [self.artistName setText:self.artist.name];
    [self.artistImageView sd_setImageWithURL:[NSURL URLWithString:self.artist.imageURL] placeholderImage:[UIImage imageNamed:@"artist-placeholder"]];
}

- (IBAction)backTouched:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)openInSpotifyTouched:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.artist.spotifyExternalURL]];
}

- (IBAction)tappedImage:(id)sender{
    //add an image to view.
    UIImageView * bigView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bigView.contentMode = UIViewContentModeScaleAspectFit;
    bigView.backgroundColor = [UIColor blackColor];
    [bigView sd_setImageWithURL:[NSURL URLWithString:self.artist.imageURL] placeholderImage:[UIImage imageNamed:@"artist-placeholder"]];
    bigView.tag=333;
    bigView.userInteractionEnabled=YES;
    bigView.alpha=0;
    [self.view addSubview:bigView];
    
    [UIView animateWithDuration:0.5 animations:^{
        bigView.alpha=1.0;
    }];
    
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBigImage:)];
    [bigView addGestureRecognizer:imageTap];
}
- (void)cancelBigImage:(id)sender{
    UIView * bigImage = [self.view viewWithTag:333];
    [UIView animateWithDuration:0.5 animations:^{
        //fade out view.
        [bigImage setAlpha:0];
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:333] removeFromSuperview];
    }];
}


@end
