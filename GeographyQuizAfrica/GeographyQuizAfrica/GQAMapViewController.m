//
//  GQAMapViewController.m
//  GeographyQuizAfrica
//
//  Created by Tyler Pexton on 7/28/14.
//  Copyright (c) 2014 Tyler Pexton. All rights reserved.
//

#import "GQAMapViewController.h"
#import "Data.h"
#import "SVGKit.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GQAViewController.h"

@interface GQAMapViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) SVGKLayeredImageView *imageView;
@property (strong, nonatomic) CAShapeLayer *lastTappedLayer;
@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation GQAMapViewController

@synthesize lastTappedLayer = lastTappedLayer;

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
    
    SVGKImage *newImage = [SVGKImage imageNamed:@"africa"];
    newImage.size = CGSizeMake(768, 1024);
    newImage.scale = 1.38f;
    SVGKLayeredImageView *imageView = [[SVGKLayeredImageView alloc] initWithSVGKImage:newImage];
    [self.view addSubview: imageView];
    self.imageView = imageView;
    
    if( self.tapGestureRecognizer == nil )
    {
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    }
    [imageView addGestureRecognizer:self.tapGestureRecognizer];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.frame = CGRectMake(0, 500, 300, 200);
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
    
    UIButton *submitButton = [[UIButton alloc]  initWithFrame:CGRectMake(50, 675, 200, 100)];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton  setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(onSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [[submitButton titleLabel] setFont:[UIFont boldSystemFontOfSize:22]];
    [self.view addSubview:submitButton];
    
    UIButton *newGameButton = [[UIButton alloc]  initWithFrame:CGRectMake(50, 725, 200, 100)];
    [newGameButton setTitle:@"New Game" forState:UIControlStateNormal];
    [newGameButton  setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [newGameButton addTarget:self action:@selector(onSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [[newGameButton titleLabel] setFont:[UIFont boldSystemFontOfSize:22]];

}

-(void)onSubmit:(UIButton *)submitButton {
    NSString *key = [[Data map] allKeys][[self.pickerView selectedRowInComponent:0]];
    NSString *title = [Data map][key][0];
    NSString *tappedKey = NSStringFromCGPoint(lastTappedLayer.frame.origin);
    NSString *tappedTitle = [Data map][tappedKey][0];
    if ([title isEqualToString: tappedTitle]) {
        lastTappedLayer.fillColor = [UIColor orangeColor].CGColor;
        SystemSoundID SoundID;
        NSURL *soundFile = [[NSBundle mainBundle] URLForResource:@"bicycle_bell" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundFile, &SoundID);
        AudioServicesPlaySystemSound(SoundID);
        
    } else {
        SystemSoundID SoundID;
        NSURL *soundFile = [[NSBundle mainBundle] URLForResource:@"honk_x" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundFile, &SoundID);
        AudioServicesPlaySystemSound(SoundID);
    }
}

-(void)newGame:(UIButton *)newGameButton {
    
}

-(void) handleTapGesture:(UITapGestureRecognizer*) recognizer {
    CGPoint p = [recognizer locationInView:self.imageView];
    CALayer *pointerLayer = [self.imageView layer];
    CALayer *hitLayer = [pointerLayer hitTest:p];
    NSLog(@"%@", NSStringFromCGPoint(hitLayer.frame.origin));
    
    CAShapeLayer *layer = (CAShapeLayer *)hitLayer;
    
    if(lastTappedLayer) {
        if (![lastTappedLayer isKindOfClass:[SVGKLayer class]]) {
            lastTappedLayer.fillColor = [UIColor colorWithRed:94.0/255 green:211.0/255 blue:175.0/255 alpha:1].CGColor;
        }
    }
    
    lastTappedLayer = layer;
    
    if( lastTappedLayer != nil )
    {
        if (![lastTappedLayer isKindOfClass:[SVGKLayer class]]) {
            lastTappedLayer.fillColor = [UIColor yellowColor].CGColor;
        }
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[[Data map] allKeys] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
 
    NSString *key = [[Data map] allKeys][row];
    return [Data map][key][0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
