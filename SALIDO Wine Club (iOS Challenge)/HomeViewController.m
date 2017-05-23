//
//  HomeViewController.m
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/8/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "HomeTableViewCell.h"
#import "APIManager.h"
#import "WineRealm.h"
#import "UIImageView+AFNetworking.h"
#import "WineCartList.h"

@interface HomeViewController ()

@property (nonatomic, strong) RLMResults *wines;

@end

@implementation HomeViewController

@synthesize wineTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",[RLMRealmConfiguration defaultConfiguration].fileURL);
    
    WineListRequestModel * requestModel = [WineListRequestModel new];
    //You can set a custom request model from the Wine API here
    requestModel.sort = @"";
    requestModel.filter = @"";
    requestModel.size = [NSNumber numberWithInt:50];
    
    [[APIManager sharedManager] getWinesWithRequestModel:requestModel success:^(WineListResponseModel *responseModel) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                for(WineModel *wine in responseModel.wines){
                    WineRealm *wineRealm = [[WineRealm alloc] initWithMantleModel:wine];
                    [realm addOrUpdateObject:wineRealm];
                }
                [realm commitWriteTransaction];
                //[wineTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //RLMRealm *realmMainThread = [RLMRealm defaultRealm];
                    RLMResults *wines = [WineRealm allObjects];
                    self.wines = wines;
                    wineTableView.delegate = self;
                    wineTableView.dataSource = self;
                    //[self.wineTableView reloadData];
                });
            }
        });
        
    } failure:^(NSError *error) {
        self.wines = [WineRealm allObjects];
        [self.wineTableView reloadData];
    }];
    
    //[self.wineTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [wineTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

//Sorting wine query by name|ascending
- (IBAction)sortButtonWasPressed:(UIBarButtonItem *)sender
{
    
    WineListRequestModel * requestModel = [WineListRequestModel new];
    requestModel.sort = @"name|ascending";
    requestModel.filter = @"";
    requestModel.size = [NSNumber numberWithInt:50];
    
    [[APIManager sharedManager] getWinesWithRequestModel:requestModel success:^(WineListResponseModel *responseModel) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                //NSLog(@"RESPONSE MODEL: %@",responseModel);
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [realm deleteObjects:[WineRealm allObjects]];
                [realm commitWriteTransaction];
                
                [realm beginWriteTransaction];
                for(WineModel *wine in responseModel.wines){
                    WineRealm *wineRealm = [[WineRealm alloc] initWithMantleModel:wine];
                    [realm addOrUpdateObject:wineRealm];
                }
                [realm commitWriteTransaction];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    RLMRealm *realmMainThread = [RLMRealm defaultRealm];
                    RLMResults *wines = [WineRealm allObjectsInRealm:realmMainThread];
                    self.wines = wines;
                    [wineTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                });
            }
        });
        
    } failure:^(NSError *error) {
        self.wines = [WineRealm allObjects];
        [self.wineTableView reloadData];
    }];
}


#pragma mark - Table View Datasource & Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)self.wines.count);
    return self.wines.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"homeCell";
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    WineRealm *wineRealm = self.wines[[indexPath item]];
    NSString *wineName = wineRealm.name;
    NSString *imageURL = wineRealm.imageURL;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = wineName;
    [cell.wineImageView setImageWithURL:[NSURL URLWithString:imageURL]
                       placeholderImage:nil];
    cell.addItemToCartButton.tag = [indexPath item];
    [cell.addItemToCartButton addTarget:self action:@selector(addItemToCartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
 
    return cell;
}


//Using didSelectRowAtIndexPath to instantiate DetailVC and pass a WineRealm object with property values.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Instantiating DetailViewController to present in Navigation stack
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC = (DetailViewController*)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    WineRealm *wineRLM = [self.wines objectAtIndex:[indexPath item]];
    detailVC.name = wineRLM.name;
    detailVC.descriptionStr = wineRLM.wineDescription;
    detailVC.imageURL = wineRLM.imageURL;
    detailVC.wineID = wineRLM.wineID;
    detailVC.quantity = wineRLM.quantity;
    detailVC.wineListIndexPath =  [indexPath item];
    
    [self.navigationController presentViewController:detailVC animated:YES completion:nil];
}

#pragma mark - SlideNavigationControllerDelegate Methods
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - Helper methods

// Method to add items to cart. Checking if item is already in cart so we can just update or add new object if non existent
-(void)addItemToCartButtonClicked:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL itemIsInCart = NO;
        RLMResults *wines = [WineRealm allObjects];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        WineRealm *wineRealm = wines[sender.tag];
        
        
        WineCartList *wineList = [[WineCartList alloc] init];
        NSNumber *quantity = [NSNumber numberWithInt:[wineRealm.quantity intValue] + 1];
        wineRealm.quantity = quantity;

        RLMArray <WineCartList *> *wineLists = (RLMArray <WineCartList *> *) [WineCartList allObjects];
        
        if (!([wineLists count] == 0))
        {
            wineList = wineLists.firstObject;
        }
        
        NSUInteger index = 0;
    
        for (WineRealm *wine in wineList.wineCartList)
        {
            if([wineRealm.wineID isEqualToString: wine.wineID])
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wine Cart" message:@"Item was added to cart" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler: nil]];
            [self presentViewController:alert animated:YES completion:nil];
        });
    });
}


@end
