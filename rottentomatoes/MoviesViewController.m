//
//  MoviesViewController.m
//  rottentomatoes
//
//  Created by Palanisamy Kozhanthaiappan on 9/12/14.
//  Copyright (c) 2014 Palanisamy Kozhanthaiappan. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieDetailViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UILabel *errMsgLabel;
@property (nonatomic) int loadCount;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic) BOOL isSearch;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.loadCount = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 128;
    self.errMsgLabel.hidden = YES;
    self.searchBar.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
   
    // show loading icon
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Loading";

    
   
    //load movies data
    [self reloadMovies];

    

    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    //during pull down refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadMovies) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
}
     
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {
        return self.searchResult.count;
    } else {
        return self.movies.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *movie;
    
    if (self.isSearch) {
        if (self.searchResult.count > indexPath.row) {
            movie = self.searchResult[indexPath.row];
        }
    }  else {
        movie = self.movies[indexPath.row];
    }
   
    
    NSString *posterUrl = [movie valueForKeyPath:@"posters.thumbnail"];

    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    UIColor *grayColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    UIColor *blueColor = [UIColor colorWithRed:0.345 green:0.522 blue:0.953 alpha:1];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    cell.mpaaLabel.text = movie[@"mpaa_rating"];
    cell.mpaaLabel.backgroundColor = grayColor;
    cell.runtimeLabel.text = [NSString stringWithFormat:@"%@ mins",[movie[@"runtime"] stringValue]];
    
    
    [cell.posterView setImageWithURL: [NSURL URLWithString: posterUrl]];
    
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = blueColor;
    [cell setSelectedBackgroundView:bgColorView];
    
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchBar resignFirstResponder];
    
    // NSLog(@"Navigation Controller: %@", self.navigationController);
    
    MovieCell *selectedCell = (MovieCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    // save index path to restore on pop of view controller
    self.selectedIndexPath = indexPath;
    
    NSDictionary *movie = (self.isSearch) ? self.searchResult[indexPath.row] : self.movies[indexPath.row];
    
    MovieDetailViewController *mvc = [[MovieDetailViewController alloc] init];
    mvc.movieTitle = selectedCell.titleLabel.text;
    mvc.movieDescription = selectedCell.synopsisLabel.text;
    mvc.movieBgThumbnailImageUrl = movie[@"posters"][@"thumbnail"];
    
    NSString *orgImageUrl =movie[@"posters"][@"original"];
    
    //no idea why :) have to replace _tmb to _ori for large image
    orgImageUrl = [orgImageUrl stringByReplacingOccurrencesOfString:@"_tmb"
                                         withString:@"_ori"];
    
    mvc.movieBgDetailedImageUrl = orgImageUrl;
    [self.navigationController pushViewController:mvc animated:YES];
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"in search box");
    
    if([searchText isEqualToString:@""] || searchText==nil) {
        self.isSearch = NO;
        [self.tableView reloadData];
        return;
    }
    self.isSearch = YES;
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.movies filteredArrayUsingPredicate:resultPredicate]];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view DidDisppear");

    if(self.selectedIndexPath != nil) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    }
}

/*
 * When user pull down, refresh the data
 */
-(void) reloadMovies {
    
    NSString *url = self.dataUrl;
    
    // NSLog(@"count of loads %d", self.loadCount);
    if(self.loadCount % 2 == 0) {
        // set invalid url to show error message
        url = @"foo-bar";
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
        self.loadCount++;
        
        if(!connectionError) {

            self.errMsgLabel.hidden = YES;
            self.searchBar.hidden = NO;
            NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = object[@"movies"];
            [self.tableView reloadData];
            //NSLog(@"Movies: %@", self.movies);
            self.searchResult = [NSMutableArray arrayWithCapacity:[self.movies count]];

        } else {
            self.searchBar.hidden = YES;
            self.errMsgLabel.hidden = NO;
            self.errMsgLabel.text = @"Network error, please pull to retry.";
        }
    }];
    
    [self.refreshControl endRefreshing];
    
    [self.hud hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar

{
    
    self.searchBar.showsCancelButton =NO;
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [self.searchBar resignFirstResponder];
    
    
}

@end
