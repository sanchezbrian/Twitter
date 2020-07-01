//
//  ComposeViewController.h
//  twitter
//
//  Created by Brian Sanchez on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

- (void)didTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController <ComposeViewControllerDelegate>

@end



NS_ASSUME_NONNULL_END
