//
//  DetailViewController.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/12/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *descriptionStr;
@property (weak, nonatomic) NSString *imageURL;
@property (weak, nonatomic) NSString *wineID;
@property (weak, nonatomic) NSNumber *quantity;
@property  NSInteger wineListIndexPath;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *wineImageView;
@property (strong, nonatomic) IBOutlet UITextField *quantityTF;
@property (strong, nonatomic) IBOutlet UITextView *wineDescription;

@end
