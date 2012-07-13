//
//  PresupuestoController.m
//  Freelance
//
//  Created by Miquel Camps Ortea on 22/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PresupuestoController.h"

#import "NSString+Base64String.h"

@interface PresupuestoController () <MFMailComposeViewControllerDelegate> {
    IBOutlet UIScrollView *scrollview;
}

@property (strong, nonatomic) IBOutlet UISwitch *switchIRPF;

@property (strong, nonatomic) IBOutlet UIStepper *ourStepper1;
@property (strong, nonatomic) IBOutlet UIStepper *ourStepper2;
@property (strong, nonatomic) IBOutlet UIStepper *ourStepper3;
@property (strong, nonatomic) IBOutlet UIStepper *ourStepper4;
@property (strong, nonatomic) IBOutlet UIStepper *ourStepper5;
@property (strong, nonatomic) IBOutlet UIStepper *ourStepper6;

@property (strong, nonatomic) IBOutlet UITextField *stepperValueText1;
@property (strong, nonatomic) IBOutlet UITextField *stepperValueText2;
@property (strong, nonatomic) IBOutlet UITextField *stepperValueText3;
@property (strong, nonatomic) IBOutlet UITextField *stepperValueText4;
@property (strong, nonatomic) IBOutlet UITextField *stepperValueText5;
@property (strong, nonatomic) IBOutlet UITextField *stepperValueText6;

@property (strong, nonatomic) IBOutlet UILabel *txtHoras;
@property (strong, nonatomic) IBOutlet UILabel *txtBase;
@property (strong, nonatomic) IBOutlet UILabel *txtIVA;
@property (strong, nonatomic) IBOutlet UILabel *txtIRPF;
@property (strong, nonatomic) IBOutlet UILabel *txtTotal;

@property (strong, nonatomic) IBOutlet UILabel *lblIVA;
@property (strong, nonatomic) IBOutlet UILabel *lblIRPF;

- (IBAction)sendEmail:(id)sender;
- (IBAction)stepperValueChanged1:(id)sender;
- (IBAction)stepperValueChanged2:(id)sender;
- (IBAction)stepperValueChanged3:(id)sender;
- (IBAction)stepperValueChanged4:(id)sender;
- (IBAction)stepperValueChanged5:(id)sender;
- (IBAction)stepperValueChanged6:(id)sender;

- (IBAction)switchIRPFValueChanged:(id)sender;

@end

@implementation PresupuestoController

@synthesize
    ourStepper1, ourStepper2, ourStepper3,ourStepper4, ourStepper5, ourStepper6,
    stepperValueText1, stepperValueText2, stepperValueText3, stepperValueText4, stepperValueText5, stepperValueText6,
    txtHoras, txtBase, txtIVA, txtIRPF, txtTotal, lblIVA, lblIRPF, switchIRPF;

// http://cocoadev.com/wiki/NSLog
// http://www.ioslearner.com/uistepper-tutorial-example-sample-cod/
// http://blog.twg.ca/2010/11/retina-display-icon-set/
// http://stackoverflow.com/questions/1949475/iphone-code-change-the-tabbar-badge-value-from-the-viewcontrollers
// http://stackoverflow.com/questions/1113408/limit-a-double-to-two-decimal-places

- (void)sumar
{
    int precio_hora, horas;
    float sum_irpf;
        
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];    
    int iva = [prefs integerForKey:@"iva"];
    int irpf = [prefs integerForKey:@"irpf"];
    NSString *divisa = [prefs stringForKey:@"divisa"];
    
    float p1 = ((float)iva / 100);
    float p2 = ((float)irpf / 100);    
    
    precio_hora = ourStepper1.value;
    
    horas = [self.stepperValueText2.text intValue];
    horas += [self.stepperValueText3.text intValue];
    horas += [self.stepperValueText4.text intValue];
    horas += [self.stepperValueText5.text intValue];
    horas += [self.stepperValueText6.text intValue];
    self.txtHoras.text = [NSString stringWithFormat:@"%d", horas];

    self.txtBase.text = [NSString stringWithFormat:@"%d %@", (horas * precio_hora), divisa];
    self.txtIVA.text = [NSString stringWithFormat:@"%.2lf %@", ([self.txtBase.text floatValue] * p1), divisa ];
    self.txtIRPF.text = [NSString stringWithFormat:@"%.2lf %@", ([self.txtBase.text floatValue] * p2), divisa ];
        
    if (self.switchIRPF.on)
        sum_irpf = [self.txtIRPF.text floatValue];
    else
        sum_irpf = 0;
    
    self.txtTotal.text = [NSString stringWithFormat:@"%.2lf %@", (([self.txtBase.text floatValue] + [self.txtIVA.text floatValue]) - sum_irpf) , divisa];
}

- (IBAction)stepperValueChanged1:(id)sender 
{
    int stepperValue = ourStepper1.value;
    self.stepperValueText1.text = [NSString stringWithFormat:@"%d", stepperValue];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:stepperValue forKey:@"precio_hora"];
    
    [self sumar];
}

- (IBAction)stepperValueChanged2:(id)sender 
{
    int stepperValue = ourStepper2.value;
    self.stepperValueText2.text = [NSString stringWithFormat:@"%d", stepperValue];
    [self sumar];
}

- (IBAction)stepperValueChanged3:(id)sender 
{
    int stepperValue = ourStepper3.value;
    self.stepperValueText3.text = [NSString stringWithFormat:@"%d", stepperValue];
    [self sumar];
}

- (IBAction)stepperValueChanged4:(id)sender 
{
    int stepperValue = ourStepper4.value;
    self.stepperValueText4.text = [NSString stringWithFormat:@"%d", stepperValue];
    [self sumar];
}

- (IBAction)stepperValueChanged5:(id)sender 
{
    int stepperValue = ourStepper5.value;
    self.stepperValueText5.text = [NSString stringWithFormat:@"%d", stepperValue];
    [self sumar];
}

- (IBAction)stepperValueChanged6:(id)sender 
{
    int stepperValue = ourStepper6.value;
    self.stepperValueText6.text = [NSString stringWithFormat:@"%d", stepperValue];
    [self sumar];
}

- (IBAction)switchIRPFValueChanged:(id)sender 
{
    [self sumar];
}  

- (IBAction)sendEmail:(id)sender
{        
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];    
    int iva = [prefs integerForKey:@"iva"];
    int irpf = [prefs integerForKey:@"irpf"];
    NSString *name = [prefs stringForKey:@"name"];
    NSString *cif = [prefs stringForKey:@"cif"];
    NSString *divisa = [prefs stringForKey:@"divisa"];

    if (!switchIRPF.on)
        irpf = 0;
    
    NSString *values = [[NSString stringWithFormat:@"%@;%@;%@;%d;%d;%@;%@;%@;%@;%@;%@", name, cif, self.stepperValueText1.text, iva, irpf, self.stepperValueText2.text, self.stepperValueText3.text, self.stepperValueText4.text, self.stepperValueText5.text, self.stepperValueText6.text, divisa] base64String];
    NSLog(@"%@",values);

    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setSubject:@"Presupuesto"];
        NSString *url = @"http://migueldev.com/freelance/presupuesto.php?v=";
        [controller setMessageBody:[NSString stringWithFormat:@"<br/><br/><a href=\"%@%@\">descargar presupuesto en pdf</a>", url, values] isHTML:YES];
        [self presentModalViewController:controller animated:YES];
        controller.mailComposeDelegate = self;
        
    } else {
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Para enviar sugerencias antes tienes que configurar una cuenta de correo" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [someError show];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //warning esto es una chapuza.... este controlador no tiene por que saber que otros controladores hay y en que orden estan...
    [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:@"1"];
    
    [self sumar];
    
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width,250);
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];    
    int iva = [prefs integerForKey:@"iva"];
    int irpf = [prefs integerForKey:@"irpf"];
    int precio_hora = [prefs integerForKey:@"precio_hora"];
    NSString *divisa = [prefs objectForKey:@"divisa"];
    
    if( !iva ){
        iva = 18;
        irpf = 15;
        precio_hora = 30;
        divisa = @"EUR";
        
        [prefs setInteger:iva forKey:@"iva"];
        [prefs setInteger:irpf forKey:@"irpf"];
        [prefs setObject:divisa forKey:@"divisa"];
        [prefs setObject:@"" forKey:@"email"];
        [prefs setObject:@"" forKey:@"linkedin"];
        [prefs setInteger:precio_hora forKey:@"precio_hora"];
    }
    
    
    self.lblIVA.text = [NSString stringWithFormat:@"IVA %d%%", iva];
    self.lblIRPF.text = [NSString stringWithFormat:@"IPRF %d%%", irpf];
    
    self.stepperValueText1.text = [NSString stringWithFormat:@"%d", precio_hora];
    self.ourStepper1.value = precio_hora;
    
    [self sumar];
}

@end
