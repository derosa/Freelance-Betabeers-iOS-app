//
//  TipsDataProvider.m
//  Freelance
//
//  Created by Javier Soto on 6/23/12.
//  Copyright (c) 2012 Javier Soto. All rights reserved.
//

#import "TipsDataProvider.h"

@implementation TipsDataProvider

- (void)requestTipWithCompletionBlock:(TipsDataProviderCompletionBlock)completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = @"http://migueldev.com/freelance/consejos.php";
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        NSString *tip = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(tip);
        });
    });
}

@end
