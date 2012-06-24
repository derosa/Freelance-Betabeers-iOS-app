//
//  TipsDataProvider.h
//  Freelance
//
//  Created by Javier Soto on 6/23/12.
//  Copyright (c) 2012 Javier Soto. All rights reserved.
//

typedef void (^TipsDataProviderCompletionBlock) (NSString *tip);

@interface TipsDataProvider : NSObject

- (void)requestTipWithCompletionBlock:(TipsDataProviderCompletionBlock)completionBlock;

@end
