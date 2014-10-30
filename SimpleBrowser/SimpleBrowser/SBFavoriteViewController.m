//
//  SBFavoriteViewController.m
//  SimpleBrowser
//
//  Created by Carl Li on 14-7-28.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import "SBFavoriteViewController.h"
#import "SBViewController.h"
#import "SBFavoriteManager.h"
#import "BaseFavorite.h"
#import "FavoriteFolder.h"
#import "FavoriteUrl.h"


@interface SBFavoriteViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray* favoriteArray;

@end

@implementation SBFavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.favoriteArray = [[SBFavoriteManager getInstance] getFavoriteArray:-1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.favoriteArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSUInteger row = [indexPath row];
    BaseFavorite *favorite = [self.favoriteArray objectAtIndex:row];
    cell.textLabel.text = favorite.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSString *url;
    BaseFavorite *favorite = [self.favoriteArray objectAtIndex:row];
    if([favorite isMemberOfClass:[FavoriteUrl class]]){
        FavoriteUrl *favoriteUrl = (FavoriteUrl*)favorite;
        url = favoriteUrl.url;
    }
    [self goBackWithUrl:url];
}

- (void)goBackWithUrl:(NSString*)url{
    [self dismissViewControllerAnimated:YES completion:^{
        if(url != nil){
            NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:url, @"url", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadUrlNotification" object:nil userInfo:info];
        }
    }];
}

- (IBAction)onDoneClick:(id)sender {
    [self goBackWithUrl:nil];
}



@end
