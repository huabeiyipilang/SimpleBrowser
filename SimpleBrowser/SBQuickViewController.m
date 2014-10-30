//
//  SBQuickViewController.m
//  SimpleBrowser
//
//  Created by Carl Li on 14-8-10.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import "SBQuickViewController.h"
#import "QuickUrlCell.h"

@interface SBQuickViewController ()

@property NSArray* quickUrls;

@end

@implementation SBQuickViewController

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
    
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* filePath = [bundle pathForResource:@"quick_urls" ofType:@"plist"];
    self.quickUrls = [[NSArray alloc] initWithContentsOfFile:filePath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBack:(NSString*)url{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"quick back");
        NSDictionary* datas = [NSDictionary dictionaryWithObjectsAndKeys:url, @"url", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadUrlNotification" object:nil userInfo:datas];
    }];
}

//节数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [[self quickUrls] count];
}

//每节中的列数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

//getView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QuickUrlCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"quickcell" forIndexPath:indexPath];
    
    NSDictionary* quickUrlInfo = [self.quickUrls objectAtIndex:indexPath.section];
    NSString* title = [quickUrlInfo objectForKey:@"title"];
    NSString* url = [quickUrlInfo objectForKey:@"url"];
    
    cell.mTitleView.text = title;
    cell.mUrlView.text = url;
    return cell;
}

//点击项目
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* quickUrlInfo = [self.quickUrls objectAtIndex:indexPath.section];
    [self onBack:[quickUrlInfo objectForKey:@"url"]];
}


@end
