//
//  ConfigController.m
//  Freelance
//
//  Created by Miquel Camps Ortea on 22/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigController.h"
#import "ActionSheetStringPicker.h"

@interface ConfigController ()

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
    
    self.scrollview.contentSize = CGSizeMake(scrollview.frame.size.width,380);
    
    [self setBackground];
    
    
}




- (void)viewDidUnload {
    [self setTxt_currency:nil];
    [super viewDidUnload];
}



#pragma mark -
#pragma mark Custom Methods


////////////////////////////

- (void)setBackground{
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"whitey.png"]];
}


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

    int appId = 535827516;
    NSString *reviewURL = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=535827516", appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
    


}

- (IBAction)sendEmailFeedback:(id)sender
{

    
    if ([MFMailComposeViewController canSendMail]) {

        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setSubject:@"Sugerencias Freelance Betabeers"];
        [controller setToRecipients:[NSArray arrayWithObject:[NSString stringWithString:@"gafeman@gmail.com"]]];
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
