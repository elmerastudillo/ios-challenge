//
//  EmployeesTableViewController.m
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/17/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "EmployeesTableViewController.h"
#import "EmployeesTableViewCell.h"
#import "UserRealm.h"

@interface EmployeesTableViewController ()

@property RLMResults *results;

@end

@implementation EmployeesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Employees List";
    
    _results = [UserRealm allObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SlideNavigationControllerDelegate methods

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"employeeCell";
    EmployeesTableViewCell *cell = (EmployeesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[EmployeesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UserRealm *userRealm = self.results[[indexPath item]];
    
    cell.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", userRealm.firstName, userRealm.lastName];
    cell.dateLabel.text = userRealm.registrationDate;
    
    return cell;
}


@end
