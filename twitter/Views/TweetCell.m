//
//  TweetCell.m
//  twitter
//
//  Created by Brian Sanchez on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"


@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)didTapLike:(id)sender {
    if (self.likeButton.selected) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self.likeButton setSelected:NO];
        [self.likeButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
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
        [self.likeButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateSelected];
        NSLog(@"%d", self.tweet.favoriteCount);
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    // TODO: Update the local tweet model
    // TODO: Update cell UI
    // TODO: Send a POST request to the POST favorites/create endpoint
}
- (IBAction)didTapRetweet:(id)sender {
    if (self.retweetButton.selected) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self.retweetButton setSelected:NO];
        [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
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
        [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateSelected];
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
- (void)setCellData:(Tweet *)tweet {
    self.tweet = tweet;
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",tweet.favoriteCount] forState:UIControlStateNormal];
    [self.retweetButton setTitle:[NSString stringWithFormat:@"%d",tweet.retweetCount] forState:UIControlStateNormal];
    self.nameLabel.text = tweet.user.name;
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.dateLabel.text = tweet.date.shortTimeAgoSinceNow;
    self.tweetLabel.text = tweet.text;
    [self.profileView setImageWithURL:tweet.user.profileURL];
}

- (void)refreshData:(Tweet *)tweet {
    if (tweet.favorited) {
        [self.likeButton setSelected:YES];
    } else {
        [self.likeButton setSelected:NO];
    }
    if (tweet.retweeted) {
        [self.retweetButton setSelected:YES];
    } else {
        [self.retweetButton setSelected:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
