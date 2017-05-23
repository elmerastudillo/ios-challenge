//
//  LeftMenuViewController.m
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/17/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "WineCartList.h"
#import "WineRealm.h"


@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
    
    return [super initWithCoder: aDecoder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.separatorColor = [UIColor lightGrayColor];

    [self.menuTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate & Datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.menuTableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return  view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    switch (indexPath.row)
    {
        case 0:
            
            cell.textLabel.text = @"Home";
            break;
        
        case 1:
            
            cell.textLabel.text = @"All Employees";
            break;
            
        case 2:
            
            cell.textLabel.text = @"Shopping Cart";
            break;
            
        case 3:
            
            cell.textLabel.text = @"Log Out";
            break;
            
        default:
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *vc;
    
    switch (indexPath.row)
    {
        case 0:
            
            vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            break;
        
        case 1:
            
            vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"EmployeesTableViewController"];
            break;
        
        case 2:
            
            vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ShoppingCartViewController"];
            break;
            
        case 3:
            
            [self.menuTableView deselectRowAtIndexPath:[self.menuTableView indexPathForSelectedRow] animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                //WineRealm *wineRealm = [[WineRealm alloc] init];
                WineCartList *wineList = [[WineCartList alloc] init];
                RLMArray <WineCartList *> *wineLists = (RLMArray <WineCartList *> *) [WineCartList allObjects];
                wineList = wineLists.firstObject;
                [realm deleteObjects:[WineCartList allObjects]];
                [realm commitWriteTransaction];
            });
            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
            return;
            break;
    }
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:self.slideOutAnimationEnabled andCompletion:nil];
    
}


@end
