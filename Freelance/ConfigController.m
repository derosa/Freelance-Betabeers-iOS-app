//
//  ConfigController.m
//  Freelance
//
//  Created by Miquel Camps Ortea on 22/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigController.h"

#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>

#import "ActionSheetStringPicker.h"

@interface ConfigController () <MFMailComposeViewControllerDelegate,UITextFieldDelegate>  {
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

@implementation ConfigController

@synthesize ourStepper1 = _ourStepper1;
@synthesize ourStepper2 = _ourStepper2;
@synthesize txt_iva = _txt_iva;
@synthesize txt_irpf = _txt_irpf;
@synthesize txt_email = _txt_email;
@synthesize txt_linkedin = _txt_linkedin;
@synthesize txt_name = _txt_name;
@synthesize txt_cif = _txt_cif;
@synthesize txt_currency = _txt_currency;
@synthesize scrollview = _scrollview;



///////

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];    
    int iva = [prefs integerForKey:@"iva"];
    int irpf = [prefs integerForKey:@"irpf"];
    NSString *name = [prefs stringForKey:@"name"];
    NSString *cif = [prefs stringForKey:@"cif"];
    NSString *email = [prefs stringForKey:@"email"];
    NSString *linkedin = [prefs stringForKey:@"linkedin"];
    
    
    
    self.txt_iva.text = [NSString stringWithFormat:@"%d", iva];
    self.ourStepper1.value = iva;
    self.txt_irpf.text = [NSString stringWithFormat:@"%d", irpf];
    self.ourStepper2.value = irpf;
    
    self.txt_name.text = name;
    self.txt_cif.text = cif;
    self.txt_email.text = email;
    self.txt_linkedin.text = linkedin;    
    self.txt_currency.text = [prefs objectForKey:@"divisa"];
    
    self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width,380);
    
}

- (void)viewDidUnload {    
    self.ourStepper1 = nil;
    self.ourStepper2 = nil;
    self.txt_iva = nil;
    self.txt_irpf = nil;
    self.txt_email = nil;
    self.txt_linkedin = nil;
    self.txt_name = nil;
    self.txt_cif = nil;
    self.txt_currency = nil;
    self.scrollview = nil;

    [super viewDidUnload];
}



#pragma mark -
#pragma mark Custom Methods

- (void)showCurrencyPicker{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *curencies = [NSLocale commonISOCurrencyCodes];
    NSInteger initialSelection = ([curencies containsObject:[prefs objectForKey:@"divisa"]]) ? [curencies indexOfObject:[prefs objectForKey:@"divisa"]] : 0;
    [ActionSheetStringPicker showPickerWithTitle:@"Divisa" rows:curencies initialSelection:initialSelection doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.txt_currency.text = selectedValue;
        [prefs setObject:self.txt_currency.text forKey:@"divisa"];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.tabBarController.view];
    
}



#pragma mark -
#pragma mark IBActions


- (IBAction)stepperValueChanged1:(id)sender 
{
    int iva = self.ourStepper1.value;
    self.txt_iva.text = [NSString stringWithFormat:@"%d", iva];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:iva forKey:@"iva"];
}

- (IBAction)stepperValueChanged2:(id)sender 
{
    int irpf = self.self.ourStepper2.value;
    self.txt_irpf.text = [NSString stringWithFormat:@"%d", irpf];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:irpf forKey:@"irpf"];
}


- (IBAction)stepperValueChanged4:(id)sender 
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.txt_email.text forKey:@"email"];
}

- (IBAction)stepperValueChanged5:(id)sender 
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.txt_linkedin.text forKey:@"linkedin"];
}


- (IBAction)stepperValueChanged6:(id)sender 
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.txt_name.text forKey:@"name"];
}


- (IBAction)stepperValueChanged7:(id)sender 
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.txt_cif.text forKey:@"cif"];
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
} 

////////////////

- (IBAction)rateApp:(id)sender
{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=535827516"]];

}

- (IBAction)sendEmailFeedback:(id)sender
{

    
    if ([MFMailComposeViewController canSendMail]) {

        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setSubject:@"Sugerencias Freelance Betabeers"];
        [controller setToRecipients:[NSArray arrayWithObject:@"gafeman@gmail.com"]];
        [self presentModalViewController:controller animated:YES];
        controller.mailComposeDelegate = self;

    }else{
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Para enviar sugerencias antes tienes que configurar una cuenta de correo" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [someError show];
        
    }
    
}



#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}




#pragma mark -
#pragma mark UITextFieldDelegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == self.txt_currency) {
        [self showCurrencyPicker];
        return NO;
    }
    
    return YES;
    
}
@end
