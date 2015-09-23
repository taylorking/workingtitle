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
    [navigationHeaderView setLiftedShadowRadius:4];
    [pinpointButton setCornerRadius:25];
    [pinpointButton setTapHandler:^(CGPoint point) {
        [self pinpointUserLocation];
    }];
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithTarget:[appDelegate currentLocation].coordinate zoom:10];
    [contentCard setBackgroundColor:[UIColor whiteColor]];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0,0, contentCard.bounds.size.width, contentCard.bounds.size.height - 100) camera:cameraPosition];
    
    [contentCard addSubview:mapView];
    [contentCard setCornerRadius:2];
    [contentCard setLiftedShadowRadius:1];
    sharingWith = [[UIScrollView alloc] initWithFrame:CGRectMake(0, contentCard.bounds.size.height - 100, contentCard.bounds.size.width, 100)];
    [contentCard addSubview:sharingWith];
    [contentCard setNeedsLayout];
    [pinpointButton setNeedsLayout];
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
- (void)newLocationRecieved:(NSNotification*)notification {
    CLLocation *location = (CLLocation*)[(NSArray*)[notification object] lastObject];

    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithTarget:[location coordinate] zoom:10];
    [mapView setCamera:cameraPosition];
        [appDelegate setFirstLocation:location];
        firstLocationFound = true;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Location"];
    NSArray *result = [[appDelegate mainObjectContext] executeFetchRequest:fetchRequest error:&error];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:[appDelegate mainObjectContext]];
    Location *myLocation = (Location*)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[appDelegate mainObjectContext]];
    [myLocation setLatitude:[NSNumber numberWithDouble:[location coordinate].latitude]];
    [myLocation setLongitude:[NSNumber numberWithDouble:[location coordinate].longitude]];
    [[appDelegate mainObjectContext] save:&error];

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
