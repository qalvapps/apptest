//
//  BiographyTableViewCell.h
//  AppBusinessTest
//
//  Created by paul calver on 10/04/2014.
//  Copyright (c) 2014 paul calver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BiographyTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *profileImage;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *roleLabel;
@property (nonatomic, weak) IBOutlet UILabel *bioLabel;

@end
