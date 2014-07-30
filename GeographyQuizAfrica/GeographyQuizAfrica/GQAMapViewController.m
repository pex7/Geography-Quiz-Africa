//
//  GQAMapViewController.m
//  GeographyQuizAfrica
//
//  Created by Tyler Pexton on 7/28/14.
//  Copyright (c) 2014 Tyler Pexton. All rights reserved.
//

#import "GQAMapViewController.h"
#import "Data.h"

@interface GQAMapViewController ()

@end

@implementation GQAMapViewController

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
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"africa" ofType:@"svg"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
