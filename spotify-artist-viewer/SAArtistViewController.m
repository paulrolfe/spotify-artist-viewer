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
#import "UIImageView+CircleCrop.h"
#import "UIImageView+WebCache.h"

@interface SAArtistViewController ()
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet APAvatarImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UITextView *artistBioTextView;

@end

@implementation SAArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.artistImageView setBorderWidth:1.0];
    [[SARequestManager sharedManager] getFullArtistFromArtist:self.artist success:^(SAArtist *artist) {
        if(artist.bio){
            self.artist = artist;
            [self setupViews];
        }
    } failure:^(NSError *error) {
        //Some error handling.
    }];
    [self setupViews];
}
- (void) setupViews{
    [self.artistBioTextView setText:self.artist.bio];
    [self.artistName setText:self.artist.name];
    [self.artistImageView sd_setImageWithURL:[NSURL URLWithString:self.artist.imageURL] placeholderImage:[UIImage imageNamed:@"artist-placeholder"]];
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
