//
//  TwitterDataProvider.h
//  Freelance
//
//  Created by Javier Soto on 6/23/12.
//  Copyright (c) 2012 Javier Soto. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TwitterDataProviderCompletionBlock) (NSArray *tweets);

@interface TwitterDataProvider : NSObject

/**
 * @param queryString the hashtag you want to search
 * @param limit the max number of tweets you want to return
 * @param completionBlock a block that will be called with an array or nil if an error occured
 */
- (void)requestTweetSearchWithQueryString:(NSString *)queryString
                                    limit:(NSUInteger)limit
                          completionBlock:(TwitterDataProviderCompletionBlock)completionBlock;

@end
