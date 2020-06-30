//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchTweets];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Get timeline
//    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
//        if (tweets) {
//            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            self.tweets = tweets.mutableCopy;
//            [self.tableView reloadData];
//        } else {
//            NSLog(@"😫😫😫 Error getting home timeline  : %@", error.localizedDescription);
//        }
//    }];
}

- (void)fetchTweets {

    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets.mutableCopy;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline  : %@", error.localizedDescription);
        }
    }];

           // Reload the tableView now that there is new data

           // Tell the refreshControl to stop spinning
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)self.tweets.count);
    return self.tweets.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet =self.tweets[indexPath.row];
    [cell.likeButton setTitle:[NSString stringWithFormat:@"%d",tweet.favoriteCount] forState:UIControlStateNormal];
    [cell.retweetButton setTitle:[NSString stringWithFormat:@"%d",tweet.retweetCount] forState:UIControlStateNormal];
    cell.nameLabel.text = tweet.user.name;
    cell.userNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    cell.dateLabel.text = tweet.createdAtString;
    cell.tweetLabel.text = tweet.text;
    [cell.profileView setImageWithURL:tweet.user.profileURL];
    
    return cell;
    
    
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
