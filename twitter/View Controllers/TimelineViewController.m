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
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

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
    [cell setCellData:tweet];
    [cell refreshData:tweet];
    return cell;
    
    
}

- (void)didTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}
- (IBAction)logout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController *)navigationController.topViewController;
    composeController.delegate = self;
}

@synthesize delegate;

@end
