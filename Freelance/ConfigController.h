//
//  ConfigController.h
//  Freelance
//
//  Created by Miquel Camps Ortea on 22/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>

@interface ConfigController : UIViewController <MFMailComposeViewControllerDelegate,UITextFieldDelegate>  {
}


@property (weak, nonatomic) IBOutlet UIStepper *ourStepper1;
@property (weak, nonatomic) IBOutlet UIStepper *ourStepper2;

@property (weak, nonatomic) IBOutlet UITextField *txt_iva;
@property (weak, nonatomic) IBOutlet UITextField *txt_irpf;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_linkedin;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_cif;
@property (weak, nonatomic) IBOutlet UITextField *txt_currency;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)stepperValueChanged1:(id)sender;
- (IBAction)stepperValueChanged2:(id)sender;
- (IBAction)stepperValueChanged4:(id)sender;
- (IBAction)stepperValueChanged5:(id)sender;
- (IBAction)stepperValueChanged6:(id)sender;
- (IBAction)stepperValueChanged7:(id)sender;


/////////////////

- (IBAction)rateApp:(id)sender;
- (IBAction)sendEmailFeedback:(id)sender;


@end