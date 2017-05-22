//
//  ShoppingCartViewController.m
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/9/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartTableViewCell.h"
#import "WineCartList.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

@interface ShoppingCartViewController ()

@property (nonatomic, strong) RLMResults *results;
@property NSUInteger amountOfItemsForRows;
@property NSNumber *quantity;

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cartTableView.delegate = self;
    _cartTableView.dataSource = self;
    
    self.navigationItem.title = @"Shopping Cart";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_cartTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [_cartTableView reloadData];
}

#pragma mark - SlideNavigationControllerDelegate Methods
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - UITableViewController Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     // REALM: Fetching all objects from WineCartList model to know count in RLMArray
    RLMArray <WineCartList *> *wineLists = (RLMArray <WineCartList *> *) [WineCartList allObjects];
    WineCartList *cart = wineLists.firstObject;
    
    return cart.wineCartList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cartCell";
    
    ShoppingCartTableViewCell *cell = (ShoppingCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[ShoppingCartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    RLMArray <WineCartList *> *wineLists = (RLMArray <WineCartList *> *) [WineCartList allObjects];
    WineCartList *cart = wineLists.firstObject;
    WineRealm *realm = cart.wineCartList[[indexPath item]];
    NSNumber *quantity = realm.quantity;
    
    cell.titleLabel.text = realm.name;
                                         
    [cell.cartImageView setImageWithURL:[NSURL URLWithString:realm.imageURL]
                       placeholderImage:nil];
    cell.quantityTextField.text = [quantity stringValue];
    cell.quantityTextField.tag = [indexPath item];
    cell.deleteItemButton.tag = [indexPath item];
    [cell.deleteItemButton addTarget:self action:@selector(deleteItemButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC = (DetailViewController*)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    RLMArray <WineCartList *> *wineLists = (RLMArray <WineCartList *> *) [WineCartList allObjects];
    WineCartList *cart = wineLists.firstObject;
    WineRealm *wineRLM = cart.wineCartList[[indexPath item]];
    detailVC.name = wineRLM.name;
    detailVC.descriptionStr = wineRLM.wineDescription;
    detailVC.imageURL = wineRLM.imageURL;
    detailVC.wineID = wineRLM.wineID;
    detailVC.quantity = wineRLM.quantity;
    detailVC.wineListIndexPath =  [indexPath item];
    
    [self.navigationController presentViewController:detailVC animated:YES completion:nil];
}

#pragma mark - Helper methods 


//TextField Update Quantity
- (void)updateItemButtonWasPressed:(UITextField *)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self.quantity intValue] != 0)
        {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            RLMResults *wines = [WineRealm allObjects];
            WineRealm *wineRealm = wines[sender.tag];
            WineCartList *wineList = [[WineCartList alloc] init];
            RLMArray <WineCartList *> *wineLists = (RLMArray <WineCartList *> *) [WineCartList allObjects];
            wineList = wineLists.firstObject;
            wineRealm.quantity = self.quantity;
            [wineList.wineCartList replaceObjectAtIndex:sender.tag withObject:wineRealm];
            [realm addObject:wineList];
            [realm commitWriteTransaction];
            
            //TODO: Need to bring UI Objects to the Main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Shopping Cart" message:@"Quantity was updated for cart" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Shopping Cart" message:@"Quantity can not be 0!" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
                
            });
        }
    });
}

//Delete items from Realm
- (void)deleteItemButtonWasPressed:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        RLMResults *wines = [WineRealm allObjects];
        WineRealm *wineRealm = wines[sender.tag];
        wineRealm.quantity = 0;
        WineCartList *wineList = [[WineCartList alloc] init];
        RLMArray <WineCartList *> *wineLists = (RLMArray <WineCartList *> *) [WineCartList allObjects];
        wineList = wineLists.firstObject;
        
        NSInteger index = sender.tag;
        [wineList.wineCartList removeObjectAtIndex:index];
        [realm addObject:wineList];
        [realm commitWriteTransaction];
        [_cartTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    });
}

#pragma mark - TextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    self.quantity = [formatter numberFromString:textField.text];
    [self updateItemButtonWasPressed:textField];
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - IBAction method

//ConfirmButton =  In Background thread fetching data from Realm. Once checkout is done all items from cart are deleted.
- (IBAction)confirmOrderButtonWasPressed:(UIButton *)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        //WineRealm *wineRealm = [[WineRealm alloc] init];
        WineCartList *wineList = [[WineCartList alloc] init];
        RLMArray <WineCartList *> *wineLists = (RLMArray <WineCartList *> *) [WineCartList allObjects];
        wineList = wineLists.firstObject;
        [realm deleteObjects:[WineCartList allObjects]];
        [realm commitWriteTransaction];
        [_cartTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Order Complete" message:@"Your order is complete. Start a new order?" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString * storyboardName = @"Main";
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    });
}


@end
