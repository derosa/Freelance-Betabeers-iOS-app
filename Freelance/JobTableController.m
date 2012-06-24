//
//  JobTableController.m
//  Freelance
//
//  Created by Miquel Camps Ortea on 22/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobTableController.h"
#import "JobViewController.h"

#import "JobsDataProvider.h"

@interface JobTableController () <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet JobsDataProvider *jobsDataProvider;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *jobs;

@end

@implementation JobTableController
@synthesize jobsDataProvider;
@synthesize jobs = _jobs;

@synthesize tableView;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataIfVisible) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self refreshData];
    
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"getJob"]) 
    {
        JobViewController *destination = [segue destinationViewController];
        NSIndexPath * indexPath = (NSIndexPath*)sender;
        
        destination.job = [self.jobs objectAtIndex:[indexPath row]];
    }
}


#pragma mark -
#pragma mark Custom Methods

- (void)refreshData{
    
    //TODO: check connection only on request fail, it's not a flight ticket :)
    if ([self connectedToNetwork] ) {
        
        [SVProgressHUD show];
        
        __weak JobTableController *weakSelf = self;
        [self.jobsDataProvider requestJobsWithCompletionBlock:^(NSArray *jobs) {
            weakSelf.jobs = jobs;
            
            [weakSelf.tableView reloadData];
            
            [SVProgressHUD dismiss];
        }];
        
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


- (IBAction)info:(id)sender
{
    UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Información" message: @"Las ofertas de empleo se dan de alta en http://dir.betabeers.com" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [someError show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0){
        [self viewDidAppear:YES];
    }
}



#pragma mark -
#pragma mark UITableViewdataSource & UITableViewDelegate


// tabla
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.jobs count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static const CGFloat kCellMinHeight = 44.f;
    static const CGFloat kJobTitleLabelFontSize = 20.f;
    static const CGFloat kJobTitleWidth = 300.f;
    static const CGFloat kJobTitleVerticalMargin = 10.f;
    
    NSString *jobTitle = [[self.jobs objectAtIndex:indexPath.row] objectForKey:@"title"];
    CGSize size = [jobTitle sizeWithFont:[UIFont systemFontOfSize:kJobTitleLabelFontSize] constrainedToSize:CGSizeMake(kJobTitleWidth, CGFLOAT_MAX)];
    
    return MAX(kCellMinHeight, size.height + kJobTitleVerticalMargin);
}


- (UITableViewCell *)tableView:(UITableView *)tabla cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tabla dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    
	NSString *cellValue =[[self.jobs objectAtIndex:indexPath.row] objectForKey:@"title"];
	cell.textLabel.text = cellValue ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"getJob" sender:indexPath];
}



@end