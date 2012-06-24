//
//  TwitterTableController.m
//  Freelance
//
//  Created by Miquel Camps Ortea on 22/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterTableController.h"

#import <Twitter/Twitter.h>

#import "TweetCell.h"

#import "TwitterDataProvider.h"

@interface TwitterTableController ()  <UIAlertViewDelegate>{
    BOOL isRetina;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet TwitterDataProvider *twitterDataProvider;
@property (nonatomic, retain) NSArray *tweets;
@end

@implementation TwitterTableController
@synthesize twitterDataProvider;

@synthesize tableView;
@synthesize tweets = _tweets;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isRetina = ([[UIScreen mainScreen] scale] == 2);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataIfVisible) name:UIApplicationDidBecomeActiveNotification object:nil];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshData];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidUnload {
    [self setTwitterDataProvider:nil];
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


#pragma mark -
#pragma mark CustomMethods

- (void)refreshData{
    
    if ( [self connectedToNetwork] ) {
        [self refreshTweet:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Hace falta conexión a internet" delegate: self cancelButtonTitle: @"Cancelar" otherButtonTitles: @"Reintentar", nil];
        [alert show];
    }
    
}

- (void)refreshDataIfVisible{
    
    if (self.tabBarController.selectedViewController == self.navigationController) {
        [self refreshData];
    }
}


#pragma mark -
#pragma mark IBActions

- (IBAction)newTweet:(id)sender
{
    
    if( [TWTweetComposeViewController canSendTweet] ){
        
        TWTweetComposeViewController *tweet = [[TWTweetComposeViewController alloc] init];
        [tweet setInitialText:@"#freesos "];
        [self presentModalViewController:tweet animated:YES];
        
    }else{
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Para publicar en twitter tienes que configurar una cuenta" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [someError show];
        
    }
    
}
- (IBAction)refreshTweet:(id)sender{
    static BOOL requestInProgress = NO;
    
    if (!requestInProgress)
    {    
        [SVProgressHUD show];
        
        NSString *hashtag = @"freesos";
        int limit = 30;
        
        __weak TwitterTableController *weakSelf = self;
        [self.twitterDataProvider requestTweetSearchWithQueryString:hashtag limit:limit completionBlock:^(NSArray *tweets) {
            weakSelf.tweets = tweets;
            [weakSelf.tableView reloadData];
            [SVProgressHUD dismiss];
            
            requestInProgress = NO;
        }];
        
        requestInProgress = YES;
    }
}



#pragma mark -
#pragma mark UItableViewDataSource & UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tabla cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    TweetCell *cell = (TweetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];        
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TweetCell class]) owner:self options:nil];
        cell = [nib objectAtIndex:0];
    } 
    
    NSString *avatar_url = [[_tweets objectAtIndex:indexPath.row] objectForKey:@"profile_image_url"];
    
    if( isRetina == YES ){
        avatar_url = [avatar_url stringByReplacingOccurrencesOfString:@"_normal" withString:@"_reasonably_small"];
    }
    
//    NSLog(@"%@",avatar_url);
    
    [cell setTweet:[self.tweets objectAtIndex:indexPath.row]];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [TWTweetComposeViewController canSendTweet] ){
        
        NSString *mensaje = [NSString stringWithFormat:@"@%@ ", [[self.tweets objectAtIndex:indexPath.row] objectForKey:@"from_user"]];
        TWTweetComposeViewController *tweet = [[TWTweetComposeViewController alloc] init];
        [tweet setInitialText:mensaje];
        [self presentModalViewController:tweet animated:YES];
        
    }else{
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Para publicar en twitter tienes que configurar una cuenta" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [someError show];
        
    }
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static const CGFloat kCellMinHeight = 64.0f;
    static const CGFloat kTweetLabelFontSize = 15.0f;
    static const CGFloat kTweetLabelWidth = 240.0f;
    static const CGFloat kCellHeightOffset = 35.0f;
    
    NSString *cellValue = [[self.tweets objectAtIndex:indexPath.row] objectForKey:@"text"];
    
    CGSize size = [cellValue 
                   sizeWithFont:[UIFont systemFontOfSize:kTweetLabelFontSize]
                   constrainedToSize:CGSizeMake(kTweetLabelWidth, CGFLOAT_MAX)];
    
    
    return MAX(kCellMinHeight, size.height + kCellHeightOffset);
    
}



#pragma mark -
#pragma mark UIAlertViewDelegate


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        //consejo.text = @"Error no se pudieron cargar los contenidos";
    }else{
        [self refreshData];
    }
}



@end
