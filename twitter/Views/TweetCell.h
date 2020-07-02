//
//  TweetCell.h
//  twitter
//
//  Created by Brian Sanchez on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TweetCellDelegate;


@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) Tweet *tweet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

- (void)setCellData:(Tweet *)tweet;
- (void)refreshData:(Tweet *)tweet;

@end

@protocol TweetCellDelegate

- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;

@end

NS_ASSUME_NONNULL_END
