//
//  ViewController.m
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/6/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "UserRealm.h"
#import <Realm/Realm.h>

@interface ViewController ()

@property RLMResults *rlmResults;
@property UIAlertController *userLoginViewController;
@property UIAlertController *userSignupViewController;

-(UIAlertController *)errorAlertController:(NSString *)message;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self userLoginAlertView];
    [self newEmployeeAlertView];
    [self forgotPinAlertView];
    
    self.rlmResults = [UserRealm allObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login
-(void) userLoginAlertView
{
    //Login Action
    _userLoginViewController = [[UIAlertController alertControllerWithTitle:@"Login" message:@"Enter Pin Number" preferredStyle: UIAlertControllerStyleAlert] init];
    [_userLoginViewController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"Pin Number";
        
    }];
    
    [_userLoginViewController addAction:[UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        BOOL validPin = NO;
        RLMResults *userRlmArray = [UserRealm allObjects];
        NSLog(@"%@", userRlmArray);
        NSArray *loginTextFields = _userLoginViewController.textFields;
        NSString *pin = ((UITextField *)[loginTextFields objectAtIndex:0]).text;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *pinNumber = [formatter numberFromString:pin];
        
        for(UserRealm *user in self.rlmResults)
        {
            if ([pinNumber isEqualToNumber: user.pinNumber])
            {
                validPin = YES;
            }
        }
        
        if (validPin == YES)
        {
            [self performSegueWithIdentifier:@"toHomeViewController" sender:self];
        }
        else
        {
            UIAlertController *errorAlert = [[UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid Pin" preferredStyle:UIAlertControllerStyleAlert] init];
            [errorAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self presentViewController:_userLoginViewController animated:YES completion:nil];
            }]];
            [self presentViewController:errorAlert animated:YES completion:nil];
        }
    }]];
    
    [self presentViewController:_userLoginViewController animated:YES completion:nil];
}

#pragma mark - Sign Up
-(void) newEmployeeAlertView
{
    //New Employee Action
    [_userLoginViewController addAction:[UIAlertAction actionWithTitle:@"New Employee" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        _userSignupViewController = [[UIAlertController alertControllerWithTitle:@"New Employeee" message:@"Enter your information" preferredStyle: UIAlertControllerStyleAlert] init];
        [_userSignupViewController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"First Name";
            //Need to clean UI a BIT
            //textField.borderStyle = UITextBorderStyleBezel;
        }];
        [_userSignupViewController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Last Name";
        }];
        [_userSignupViewController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"E-mail";
        }];
        [_userSignupViewController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = @"Pin Number";
        }];
        [_userSignupViewController addAction:[UIAlertAction actionWithTitle:@"Create New Employee ID" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //Create a new employee ID variables
            NSArray *signUpTextFields = _userSignupViewController.textFields;
            NSString *firstName = ((UITextField *)signUpTextFields[0]).text;
            NSString *lastName = ((UITextField *)signUpTextFields[1]).text;
            NSString *email = ((UITextField *)signUpTextFields[2]).text;
            NSString *newPin = ((UITextField *)signUpTextFields[3]).text;
            NSNumberFormatter *pin = [[NSNumberFormatter alloc] init];
            NSNumber *pinNumber = [pin numberFromString:newPin];
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            
            //Updating and persisting UserRealm using REALM (Background thread)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool
                {
                    RLMResults *userRlmArray = [UserRealm allObjects];
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    UserRealm *newUser = [[UserRealm alloc] init];
                    newUser.firstName = firstName;
                    newUser.lastName = lastName;
                    newUser.email = email;
                    newUser.registrationDate = dateString;
                    if (!(pinNumber == nil)) {
                        newUser.pinNumber = pinNumber;
                    }
                    else
                    {
                        [self errorAlertController:@"Pin number is empty"];
                        [realm commitWriteTransaction];
                        return ;
                    }
                    
                    if (userRlmArray.count == 0)
                    {
                        [realm addObject:newUser];
                        [realm commitWriteTransaction];
                        dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:@"toHomeViewController" sender:self];
                        });
                    }
                    else
                    {
                        BOOL isUnique = YES;
                        // For Loop to check if LastName, email and newUser are unique
                        for (UserRealm *user in userRlmArray)
                        {
                            if([newUser.lastName isEqualToString:user.lastName])
                            {
                                //TODO: ADD ALERT VIEW
                                isUnique = false;
                                [self errorAlertController:@"Last name is not unique"];
                                [realm commitWriteTransaction];
                                return;
                            }
                            if ([newUser.email isEqualToString:user.email])
                            {
                                isUnique = false;
                                [self errorAlertController:@"email is not unique"];
                                [realm commitWriteTransaction];
                                return;
                                
                            }
                            if ([newUser.pinNumber isEqualToNumber:user.pinNumber])
                            {
                                isUnique = false;
                                [self errorAlertController:@"Pin number is not unique"];
                                [realm commitWriteTransaction];
                                return;
                            }
                        }
                        
                        if(isUnique == YES)
                        {
                            [realm addObject:newUser];
                            [realm commitWriteTransaction];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self performSegueWithIdentifier:@"toHomeViewController" sender:self];
                            });
                        }
                    }
                }
            });
        }]];
        
        
        [_userSignupViewController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:_userLoginViewController animated:YES completion:nil];
        }]];
        
        [self presentViewController:_userSignupViewController animated:YES completion:nil];
        
    }]];
}

#pragma mark - Forgot Pin Alert Controller
-(void)forgotPinAlertView
{
    //Forgot pin action
    [_userLoginViewController addAction:[UIAlertAction actionWithTitle:@"Forgot Pin?" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *forgotPinViewController = [[UIAlertController alertControllerWithTitle:@"Forgot your Pin?" message:@"Enter your E-mail address" preferredStyle:UIAlertControllerStyleAlert] init];
        [forgotPinViewController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"E-mail address";
        }];
        
        [forgotPinViewController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            BOOL validEmail = NO;
            NSNumber *pinNumber = [[NSNumber alloc] init];
            RLMResults *userRlmArray = [UserRealm allObjects];
            NSArray *forgotEmailTextField = forgotPinViewController.textFields;
            NSString * emailString = ((UITextField *)forgotEmailTextField[0]).text;
            //** TO DO: Need for loop to search for email and then return pin **
            //Test Loop
            
            for(UserRealm *user in userRlmArray)
            {
                if ([emailString isEqualToString: user.email])
                {
                    validEmail = YES;
                    pinNumber = user.pinNumber;
                }
            }
            
            if (validEmail == YES)
            {
                UIAlertController *pinViewController = [[UIAlertController alertControllerWithTitle:@"Pin Number" message: [NSString stringWithFormat:@"%@", pinNumber] preferredStyle:UIAlertControllerStyleAlert] init];
                [pinViewController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self presentViewController:_userLoginViewController animated:YES completion:nil];
                }]];
                [self presentViewController:pinViewController animated:YES completion:nil];
            }
            else
            {
                UIAlertController *errorAlertView = [[UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid E-mail" preferredStyle:UIAlertControllerStyleAlert] init];
                [errorAlertView addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self presentViewController:forgotPinViewController animated:YES completion:nil];
                }]];
                [self presentViewController:errorAlertView animated:errorAlertView completion:nil];
            }
        }]];
        
        //Cancel Action
        [forgotPinViewController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:_userLoginViewController animated:YES completion:nil];
        }]];
        
        [self presentViewController:forgotPinViewController animated:YES completion:nil];
    
    }]];

}

#pragma mark - Helper methods


-(UIAlertController *)errorAlertController:(NSString *)message
{
    UIAlertController *errorContontroller = [[UIAlertController alertControllerWithTitle:@"ERROR" message:message preferredStyle:UIAlertControllerStyleAlert] init];
    [errorContontroller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentViewController:_userSignupViewController animated:YES completion:nil];
    }]];
    [self presentViewController:errorContontroller animated:YES completion:nil];
    return errorContontroller;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}




@end
