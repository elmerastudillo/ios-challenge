//
//  DetailViewController.m
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/12/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "WineRealm.h"
#import "WineCartList.h"

@interface DetailViewController ()
@property NSString *wineUUID;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _quantityTF.delegate = self;
    // Do any additional setup after loading the view.
    NSNumber *qty = self.quantity;
    NSString *imageURL = self.imageURL;
    
    //Setting DetailViewController UI vars
    self.nameLabel.text = self.name;
    self.wineDescription.text = self.descriptionStr;
    _wineUUID = self.wineID;
    self.quantityTF.text = [qty stringValue];
    [self.wineImageView setImageWithURL:[NSURL URLWithString:imageURL]
                       placeholderImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    //Implementing Navigation bar
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    UINavigationBar *myNav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    [self.view addSubview:myNav];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBarButtonItemWasPressed)];
    
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:@"Wine Description"];
    naviItem.rightBarButtonItem = doneItem;
    myNav.items = [NSArray arrayWithObjects:naviItem, nil];
}

#pragma mark - Helper methods
- (void)doneBarButtonItemWasPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions


- (IBAction)addToCartButtonPressed:(UIButton *)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL itemIsInCart = NO;
        RLMResults *wines = [WineRealm allObjects];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        WineRealm *wineRealm = wines[_wineListIndexPath];
        WineCartList *wineList = [[WineCartList alloc] init];
        
        NSUInteger index = 0;
        NSNumber *quantity = [NSNumber numberWithInt:[wineRealm.quantity intValue] + 1];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *amountOfItems = [formatter numberFromString:self.quantityTF.text];
        NSNumber *sum = @([quantity integerValue] + [amountOfItems integerValue]);
        wineRealm.quantity = sum;
        
        RLMArray <WineCartList *> *wineLists = (RLMArray <WineCartList *> *) [WineCartList allObjects];
        
        if (!([wineLists count] == 0))
        {
            wineList = wineLists.firstObject;
        }
        
        for (WineRealm *wine in wineList.wineCartList)
        {
            if([_wineUUID isEqualToString: wine.wineID])
            {
                itemIsInCart = YES;
                break;
            }
            index++;
        }
        
        
        if (itemIsInCart == YES)
        {
            [wineList.wineCartList replaceObjectAtIndex:index withObject:wineRealm];
        }
        else
        {
            [wineList.wineCartList addObject:wineRealm];
        }
        
        [realm addObject:wineList];
        [realm commitWriteTransaction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"You have added items to your cart!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        });
    });
}

#pragma mark - TextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}



@end
