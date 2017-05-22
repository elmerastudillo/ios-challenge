//
//  HomeViewController.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/8/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"


@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SlideNavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *wineTableView;

@end
