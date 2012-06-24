//
//  JobViewController.m
//  Freelance
//
//  Created by Miquel Camps Ortea on 22/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobViewController.h"

#import <MessageUI/MessageUI.h>

@interface JobViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> 

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *web;

@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *fecha;
@property (weak, nonatomic) IBOutlet UILabel *descripcion;
@property (weak, nonatomic) IBOutlet UIButton *btnReply;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation JobViewController


@synthesize scrollview = _scrollview;
@synthesize job, titulo, fecha, descripcion, email, web, btnReply;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titulo.text = [job objectForKey:@"title"];
    
    if( [[job objectForKey:@"interested"] isEqualToString: @"0"] )
    {
        self.fecha.text = [job objectForKey:@"date"];
    }else{
        self.fecha.text = [NSString stringWithFormat:@"%@ - %@ interesados", [job objectForKey:@"date"], [job objectForKey:@"interested"]];
    }
        
    self.title = [job objectForKey:@"company"];
        
    self.descripcion.text = [job objectForKey:@"body"];
    self.email = [job objectForKey:@"email"];
    self.web = [job objectForKey:@"url"];
    
    self.descripcion.numberOfLines = 0;
    [self.descripcion sizeToFit];
    
    self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width,
                                        descripcion.frame.size.height+110);
    
    self.btnReply.frame = CGRectMake(self.btnReply.frame.origin.x, (self.descripcion.frame.size.height + 35), self.btnReply.frame.size.width, self.btnReply.frame.size.height);
        
}


#pragma mark -
#pragma mark IBActions


- (IBAction)replyJob:(id)sender{

    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle: @"Acción" delegate: self cancelButtonTitle: @"Cancelar" destructiveButtonTitle:nil otherButtonTitles: @"Responder",@"Enviar copia",nil];

    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	
    [popupQuery showInView:self.tabBarController.view];

}



#pragma mark -
#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];    
    NSString *subject = @"";
    NSString *body = @"";
    NSString *to = @"";
    
    
    // reply
	if (buttonIndex == 0) {
        
        to = [NSString stringWithString:self.email];
        subject = [NSString stringWithFormat:@"RE: %@", self.titulo.text];
        NSString *linkedin = [prefs stringForKey:@"linkedin"];
//        NSLog(@"%@",linkedin);
        
        if( [linkedin isEqualToString: @""] )
        {
            body = [NSString stringWithFormat:@"<br/><br/><a href=\"%@\">enlace de la oferta</a>", self.web];
            
        }else{
            body = [NSString stringWithFormat:@"<br/><br/><a href=\"%@\">mi linkedin</a><br/><br/><a href=\"%@\">enlace de la oferta</a>", linkedin, self.web];
        }
        
        // copy
    } else if (buttonIndex == 1) {
		
        to = [prefs stringForKey:@"email"];
        subject = [NSString stringWithFormat:@"Fwd: %@", self.titulo.text];
        body = [NSString stringWithFormat:@"<a href=\"%@\">enlace de la oferta</a><br/><br/>%@", self.web, self.descripcion.text];
        
    }
    
    
    if (buttonIndex != 2) {
        
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            [controller setSubject: subject ];
            [controller setToRecipients:[NSArray arrayWithObject:to]];
            [controller setMessageBody:body isHTML:YES];
            controller.mailComposeDelegate = self;
            [self presentModalViewController:controller animated:YES];
            
        }else{
            
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Para enviar sugerencias antes tienes que configurar una cuenta de correo" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [someError show];
            
        }
    }
    
	
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}




@end
