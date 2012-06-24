//
//  JobsDataProvider.m
//  Freelance
//
//  Created by Javier Soto on 6/24/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import "JobsDataProvider.h"

@implementation JobsDataProvider

- (void)requestJobsWithCompletionBlock:(JobsDataProviderCompletionBlock)completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = @"http://migueldev.com/freelance/trabajos.php";
        
        NSData *jobData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        NSError *parseError = nil;
        NSDictionary *jobsDictionary = [NSJSONSerialization JSONObjectWithData:jobData options:NSJSONReadingAllowFragments error:&parseError];
        
        NSArray *jobs = [jobsDictionary valueForKeyPath:@"response.jobs"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(jobs);
        });
    });
}

@end
