//
//  SBViewController.m
//  SimpleBrowser
//
//  Created by Carl Li on 14-7-26.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import "SBViewController.h"
#import "SBFavoriteManager.h"

@interface SBViewController (){
    SBFavoriteManager* favoriteManager;
}
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property bool canAccessNet;
@property NSString* lastUrl;
@property NSString *homeUrl;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItemView;

@end

@implementation SBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoadUrlNitficationReceived:) name:@"LoadUrlNotification" object:nil];
    
    _homeUrl = @"www.baidu.com";
    
    favoriteManager = [SBFavoriteManager getInstance];
    
	[self onHomeClick:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLoadUrlNitficationReceived: (NSNotification*) notification{
    NSDictionary* datas = [notification userInfo];
    NSString* url = [datas objectForKey:@"url"];
    [self loadUrl:url];
}

- (void)loadUrl: (NSString*)urlInput{
    _lastUrl = urlInput;
    NSLog(@"load url:%@", urlInput);
    if([self checkCanAccessNet]){
        NSString *urlString = nil;
        if([urlInput hasPrefix:@"http://"]){
            urlString = urlInput;
        }else{
            urlString = [NSString stringWithFormat:@"http://%@", urlInput];
        }
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (BOOL)checkCanAccessNet{
    if(_canAccessNet){
        return YES;
    }
    UIAlertView *accessNetView = [[UIAlertView alloc] initWithTitle:@"网络访问" message:@"是否允许访问网络？" delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"允许", nil];
    [accessNetView show];
    return NO;
}

- (IBAction)onHomeClick:(id)sender {
    [self loadUrl:_homeUrl];
}

- (IBAction)onHomeDoubleClick:(id)sender {
    UIActionSheet *homeSelectSheet = [[UIActionSheet alloc] initWithTitle:@"选择主页" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"百度", @"谷歌", @"必应", nil];
    [homeSelectSheet showInView:self.view];
}
- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}


//实现UITextFieldDelegate接口中的方法
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.urlField){
        [self loadUrl:textField.text];
        [textField resignFirstResponder];
    }
    return YES;
}
- (IBAction)goQuickUI:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *quickController = [storyboard instantiateViewControllerWithIdentifier:@"quickViewController"];
    quickController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:quickController animated:YES completion:^{
        NSLog(@"open quick view");
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)onKeyboardShow: (NSNotification *)notif{
    NSLog(@"键盘打开");
}

- (void)onKeyboardHide: (NSNotification *)notif{
    NSLog(@"键盘收起");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    self.titleView.text = @"接受请求";
    NSLog(@"接受请求");
    self.urlField.text = request.URL.absoluteString;
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
//    self.titleView.text = @"开始加载";
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    NSLog(@"开始加载");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.titleItemView.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = YES;
    NSLog(@"加载完成");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    self.titleView.text = @"加载失败";
    NSLog(@"加载失败");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        _canAccessNet = false;
    }else{
        _canAccessNet = true;
        [self loadUrl:_lastUrl];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            _homeUrl = @"www.baidu.com";
            break;
        case 1:
            _homeUrl = @"www.google.com";
            break;
        case 2:
            _homeUrl = @"www.bing.com";
            break;
        default:
            break;
    }
}
- (IBAction)addFavorite:(id)sender {
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    int res = [favoriteManager addFavoriteUrl:_lastUrl title:title fatherId: -1];
}

@end
