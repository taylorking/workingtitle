 //
//  ViewController.m
//  OnMyWay
//
//  Created by Taylor King on 8/25/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "MainMapShareViewController.h"

@interface MainMapShareViewController ()

@end

@implementation MainMapShareViewController
static float dummyLatitude = 36.216710;
static float dummyLongitude =-81.679128;
@synthesize appDelegate;
@synthesize mapView;
@synthesize sharingWith;
@synthesize contentCard, navigationHeaderView, pinpointButton, pinpointIcon;
BOOL firstLocationFound;
CGRect originalPinpointButtonFrame;
- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view, typically from a nib.
    //load of the initial view controller.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newLocationRecieved:) name:@"notificationManagerRecievedNewLocation" object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:<#(nonnull SEL)#> name:<#(nullable NSString *)#> object:<#(nullable id)#>]
    [navigationHeaderView setLiftedShadowRadius:4];
    [pinpointButton setCornerRadius:25];
    [pinpointButton setTapHandler:^(CGPoint point) {
        [self pinpointUserLocation];
    }];
    [contentCard setBackgroundColor:[UIColor whiteColor]];
    GMSCameraPosition *camera = [[GMSCameraPosition alloc] initWithTarget:CLLocationCoordinate2DMake(dummyLatitude, dummyLongitude) zoom:13 bearing:0 viewingAngle:0];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0,0, contentCard.bounds.size.width, contentCard.bounds.size.height - 100) camera:camera];
    [pinpointButton setBackgroundColor:MAIN_COLOR];
    [contentCard addSubview:mapView];
    [contentCard setCornerRadius:2];
    [contentCard setLiftedShadowRadius:1];
    sharingWith = [[UIScrollView alloc] initWithFrame:CGRectMake(0, contentCard.bounds.size.height - 100, contentCard.bounds.size.width, 100)];
    [contentCard addSubview:sharingWith];
    [contentCard setNeedsLayout];
    [pinpointButton setNeedsLayout];
    [[[appDelegate locationsManagement] updaterDaemon] startPolling];
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)viewDidLayoutSubviews {
        [mapView setFrame:CGRectMake(0,0, contentCard.bounds.size.width, contentCard.bounds.size.height - 100)];
        [contentCard bringSubviewToFront:mapView];
        [contentCard bringSubviewToFront:pinpointButton];
        [mapView setHidden:false];
        [pinpointIcon setHidden:false];
}
- (void)drawPathForMovementOnLocation:(CLLocation*)location previousLocation:(CLLocation*)previousLocation {
    GMSOverlay *overlay = [[GMSOverlay alloc]init];

    
}
- (void)groupIsReady {
    
}
- (void)newLocationRecieved:(NSNotification*)notification {

}
- (void)pinpointUserLocation{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ButtonPressed" message:@"Pinpoint pressed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


- (IBAction)swipeMapUp:(id)sender {
    CGRect originalMapFrame = [mapView frame];
    originalPinpointButtonFrame = [pinpointButton frame];
    CGRect newMapFrame = CGRectMake(0, 0, [mapView frame].size.width, 0);
    [pinpointButton setClipsToBounds:true];

    [UIView animateWithDuration:.3f animations:^{
        [pinpointIcon setHidden:true];
        [pinpointButton setFrame:CGRectMake([pinpointButton center].x, [pinpointButton center].y, 0, 0)];
        [mapView setFrame:newMapFrame];
    } completion:^(BOOL finished){
        if(finished) {
            [mapView setHidden:true];
            [mapView setFrame:originalMapFrame];
        }
    }];
}

- (IBAction)swipeMapDown:(id)sender {
    CGRect originalMapFrame = [mapView frame];
    CGRect newMapFrame = CGRectMake(0, 0, [mapView frame].size.width,0);
    [mapView setFrame:newMapFrame];
    [mapView setHidden:false];
    [pinpointButton setHidden:false];
    [UIView animateWithDuration:.3f animations:^{
        [pinpointButton setFrame:originalPinpointButtonFrame];
        [mapView setFrame:originalMapFrame];
    } completion:^(BOOL finished){
        if(finished){
            [pinpointIcon setHidden:false];
        }
    }];
}
@end
