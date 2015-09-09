//
//  ViewController.m
//  OnMyWay
//
//  Created by Taylor King on 8/25/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize sharing;
@synthesize shareButton;
@synthesize appDelegate;
@synthesize mapView;
@synthesize mapHolder;
BOOL firstLocationFound;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view, typically from a nib.
    //load of the initial view controller.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newLocationRecieved:) name:@"notificationManagerRecievedNewLocation" object:nil];
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithTarget:[appDelegate currentLocation].coordinate zoom:10];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0,0, [self view].bounds.size.width, 400) camera:cameraPosition];
    [[self view] addSubview:mapView];
}
-(void)drawPathForMovementOnLocation:(CLLocation*)location previousLocation:(CLLocation*)previousLocation {
    GMSOverlay *overlay = [[GMSOverlay alloc]init];

    
}
- (void)newLocationRecieved:(NSNotification*)notification {
    CLLocation *location = (CLLocation*)[(NSArray*)[notification object] lastObject];
    
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithTarget:[location coordinate] zoom:10];
    [mapView setCamera:cameraPosition];
    if(!firstLocationFound) {
        [appDelegate setFirstLocation:location];
        firstLocationFound = true;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
- (IBAction)shareButtonPressed:(id)sender {
    sharing = !sharing;
    if(sharing) {
        [shareButton setTitle:@"Stop sharing location" forState:UIControlStateNormal];
        [appDelegate startSharingLocation];


    }
    else {
        [shareButton setTitle:@"Start sharing location" forState:UIControlStateNormal];
        [appDelegate stopSharingLocation];
    }
}
@end
