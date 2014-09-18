//
//  MoviesViewController.h
//  rottentomatoes
//
//  Created by Palanisamy Kozhanthaiappan on 9/12/14.
//  Copyright (c) 2014 Palanisamy Kozhanthaiappan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic) NSString *dataUrl;

@end
