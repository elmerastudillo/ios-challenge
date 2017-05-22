//
//  ShoppingCartTableViewCell.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/18/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cartImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;
@property (strong, nonatomic) IBOutlet UIButton *deleteItemButton;



@end
