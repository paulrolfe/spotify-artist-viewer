//
//  SATrackViewController.m
//  spotify-artist-viewer
//
//  Created by Paul Rolfe on 6/10/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SATrackViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+SAColors.h"

CGFloat const cornerRatio = 0.2;

@interface SATrackViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *trackImageView;
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
    [self.openInSpotifyButton setBackgroundColor:[UIColor spotifyGreen]];
    [self.openInSpotifyButton.layer setCornerRadius:15];
    [self.trackImageView.layer setCornerRadius:self.trackImageView.frame.size.height * cornerRatio];
    [self.trackImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.trackImageView.layer setBorderWidth:1.0];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.track.spotifyExternalURL]]){
        [self.openInSpotifyButton setEnabled:NO];
    }
}
- (void) displayInfo{
    [self.trackNameLabel setText:self.track.name];
    [self.artistNameLabel setText:self.track.artistName];
    [self.artistNameLabel sizeToFit];
    [self.albumNameLabel setText:self.track.albumAppearsOn];
    [self.trackImageView sd_setImageWithURL:[NSURL URLWithString:self.track.imageURL] placeholderImage:[UIImage imageNamed:@"track-placeholder"]];
}


- (IBAction)backTouched:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)openSpotify:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.track.spotifyExternalURL]];
}
- (IBAction)tappedImage:(id)sender{
    //add an image to view.
    UIImageView * bigView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bigView.contentMode = UIViewContentModeScaleAspectFit;
    bigView.backgroundColor = [UIColor blackColor];
    [bigView sd_setImageWithURL:[NSURL URLWithString:self.track.imageURL] placeholderImage:[UIImage imageNamed:@"track-placeholder"]];
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
