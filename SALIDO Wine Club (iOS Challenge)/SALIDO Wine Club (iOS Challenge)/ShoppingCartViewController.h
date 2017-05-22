//
//  ShoppingCartViewController.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/9/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface ShoppingCartViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,SlideNavigationControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *cartTableView;

@end
