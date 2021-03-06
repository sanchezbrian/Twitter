//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"I415wOtXpFyfcFi2hz2EXry2G";
static NSString * const consumerSecret = @"KMRAB3eKXcUgHsPGo6Yz304N8VachfdJi5v0CI4hPRGSRiEACw";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    NSDictionary *dictionary = @{@"include_entities": @"true"};
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:dictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       
       // Manually cache the tweets. If the request fails, restore from cache if possible.
       //NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
       //[[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];
        
       NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];

       completion(tweets, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       //NSArray *tweetDictionaries = nil;
       
       // Fetch tweets from cache if possible
       //NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
       //if (data != nil) {
       //    tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
       //}
       
       completion(nil, error);
   }];
}

- (void)loadMoreTweets:(Tweet *)lastTweet completion:(void (^)(NSArray *tweets, NSError *error))completion {
    NSString *urlString = @"1.1/statuses/home_timeline.json";
    NSDictionary *parameters = @{@"max_id": lastTweet.idStr};
    [self GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"https://api.twitter.com/1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json", tweet.idStr];
    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/unretweet/%@.json", tweet.idStr];
    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
@end
