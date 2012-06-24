//
//  TipsController.m
//  Freelance
//
//  Created by Miquel Camps Ortea on 22/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TipsController.h"

#import <Twitter/Twitter.h>

@interface TipsController () <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *consejo;

- (IBAction)cargarFrase:(id)sender;
- (IBAction)twittearConsejo:(id)sender;

@end

@implementation TipsController

@synthesize consejo;

- (IBAction)cargarFrase:(id)sender
{
    [self cargarFrase];
}

- (IBAction)twittearConsejo:(id)sender
{

    if( [TWTweetComposeViewController canSendTweet] ){

        TWTweetComposeViewController *tweet = [[TWTweetComposeViewController alloc] init];
        [tweet setInitialText:self.consejo.text];
        [self presentModalViewController:tweet animated:YES];
        
    }else{
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Para publicar en twitter tienes que configurar una cuenta" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [someError show];
    }
    
}

- (void) cargarFrase
{
    NSString *url = @"http://migueldev.com/freelance/consejos.php";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // si carga la misma frase, cargar otra
    if( [response isEqualToString: self.consejo.text] )
    {
        [self cargarFrase];
    }else{
        self.consejo.text = response;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
     if ([self connectedToNetwork]) {
        [self cargarFrase];
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1]  setBadgeValue:nil];
     }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Hace falta conexión a internet" delegate: self cancelButtonTitle: @"Cancelar" otherButtonTitles: @"Reintentar", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        consejo.text = @"Error no se pudieron cargar los contenidos";
    }else{
        [self viewDidAppear:YES];
    }
}

@end
