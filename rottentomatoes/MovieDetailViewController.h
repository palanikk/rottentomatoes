//
//  MovieDetailViewController.h
//  rottentomatoes
//
//  Created by Palanisamy Kozhanthaiappan on 9/13/14.
//  Copyright (c) 2014 Palanisamy Kozhanthaiappan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController

@property (nonatomic) NSString *movieTitle;
@property (nonatomic) NSString *moviePoster;
@property (nonatomic) NSString *movieDescription;
@property (nonatomic) NSString *movieBgThumbnailImageUrl;
@property (nonatomic) NSString *movieBgDetailedImageUrl;

@end