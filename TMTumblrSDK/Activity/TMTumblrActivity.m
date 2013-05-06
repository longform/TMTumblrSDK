//
//  TMTumblrActivity.m
//  TumblrAppClient
//
//  Created by Bryan Irace on 3/19/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMTumblrActivity.h"
#import "TMTumblrAppClient.h"

@interface TMTumblrActivity ()
@property (nonatomic) NSURL *linkURL;
@property (nonatomic) NSString *linkDescription;
@end

@implementation TMTumblrActivity

- (NSString *)activityType {
	return NSStringFromClass([self class]);
}

- (NSString *)activityTitle {
	return @"Tumblr";
}

- (UIImage *)activityImage {
	return [UIImage imageNamed:@"UIActivityTumblr"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (UIActivityItemProvider *item in activityItems) {
        if ([item isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id item in activityItems) {
        if ([item isKindOfClass:[NSURL class]] && !self.linkURL) {
            self.linkURL = item;
        }
        if ([item isKindOfClass:[NSString class]] && !self.linkDescription) {
            self.linkDescription = item;
        }
    }
}



- (void)performActivity {
    if ([TMTumblrAppClient isTumblrInstalled]) {
        NSString *description = [self.linkDescription length] ? self.linkDescription : @"";
        [TMTumblrAppClient createLinkPost:self.title
                                URLString:[self.linkURL absoluteString]
                              description:description
                                     tags:@[]];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tumblr App Required"
                                                        message:@"Please install the Tumblr app and try again."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Install", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [TMTumblrAppClient viewInAppStore];
    }
}

@end
