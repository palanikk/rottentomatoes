//
//  MovieCell.h
//  rottentomatoes
//
//  Created by Palanisamy Kozhanthaiappan on 9/13/14.
//  Copyright (c) 2014 Palanisamy Kozhanthaiappan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *mpaaLabel;

@property (weak, nonatomic) IBOutlet UILabel *runtimeLabel;

@end
