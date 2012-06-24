//
//  JobsDataProvider.h
//  Freelance
//
//  Created by Javier Soto on 6/24/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

typedef void (^JobsDataProviderCompletionBlock) (NSArray *jobs);

@interface JobsDataProvider : NSObject

- (void)requestJobsWithCompletionBlock:(JobsDataProviderCompletionBlock)completionBlock;

@end
