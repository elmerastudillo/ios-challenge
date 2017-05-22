//
//  EmployeesTableViewController.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/17/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
@interface EmployeesTableViewController : UITableViewController <SlideNavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *employeeTableView;

@end
