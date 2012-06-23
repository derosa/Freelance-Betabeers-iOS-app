//
//  TwitterDataProvider.m
//  Freelance
//
//  Created by Javier Soto on 6/23/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import "TwitterDataProvider.h"

@implementation TwitterDataProvider

- (void)requestTweetSearchWithQueryString:(NSString *)queryString
                                    limit:(NSUInteger)limit
                          completionBlock:(TwitterDataProviderCompletionBlock)completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlString = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%%23%@%%20-RT&rpp=%d&include_entities=true&result_type=recent", queryString, limit];
        
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSError *error = nil;
        
        NSDictionary *tweetsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (!error) {
            
            NSArray *tweets = [tweetsDictionary objectForKey:@"results"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(tweets);
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    });
}

@end
