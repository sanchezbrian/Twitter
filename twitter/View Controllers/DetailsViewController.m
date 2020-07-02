//
//  DetailsViewController.m
//  twitter
//
//  Created by Brian Sanchez on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "Tweet.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "APIManager.h"
#import "TweetCell.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Tweet";
    [self.profileView setImageWithURL:self.tweet.user.profileURL];
    self.nameLabel.text = self.tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.tweetLabel.text = self.tweet.text;
    self.likeNum.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetNum.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.timeLabel.text = self.tweet.date.timeAgoSinceNow;
    self.dateLabel.text = self.tweet.createdAtString;
    if (self.tweet.favorited) {
        [self.likeButton setSelected:YES];
    } else {
        [self.likeButton setSelected:NO];
    }
    if (self.tweet.retweeted) {
        [self.retweetButton setSelected:YES];
    } else {
        [self.retweetButton setSelected:NO];
    }
    
}
- (IBAction)tapRetweet:(id)sender {
    if (self.retweetButton.selected) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self.retweetButton setSelected:NO];
        self.retweetNum.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        NSLog(@"%d", self.tweet.retweetCount);
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully unretweeting the following Tweet: %@", tweet.text);
            }
        }];
        
    } else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self.retweetButton setSelected:YES];
        self.retweetNum.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        NSLog(@"%d", self.tweet.retweetCount);
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully retweeting the following Tweet: %@", tweet.text);
            }
        }];
    }
}
- (IBAction)tapLike:(id)sender {
    if (self.likeButton.selected) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self.likeButton setSelected:NO];
        self.likeNum.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        NSLog(@"%d", self.tweet.favoriteCount);
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
        
    } else {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self.likeButton setSelected:YES];
        self.likeNum.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        NSLog(@"%d", self.tweet.favoriteCount);
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}
- (IBAction)tapReply:(id)sender {
    
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
