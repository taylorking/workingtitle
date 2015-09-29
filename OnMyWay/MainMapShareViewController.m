//
//  MainMapShareViewController.m
//  OnMyWay
//
//  Created by Taylor King on 9/28/15.
//  Copyright © 2015 omwltd. All rights reserved.
//

#import "MainMapShareViewController.h"

@interface MainMapShareViewController ()

@end

@implementation MainMapShareViewController
@synthesize mapView;
@synthesize appDelegate;
@synthesize userMarker;
@synthesize friendMarkers;
@synthesize headsCollectionView;
NSMutableDictionary *userPoints;
BOOL initialCamera = false;
- (void)viewDidLoad {
    [super viewDidLoad];
    [headsCollectionView setDataSource:self];
    [headsCollectionView setDelegate:self];
    userPoints = [[NSMutableDictionary alloc] init];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    friendMarkers = [[NSMutableDictionary alloc] init];
    [[[appDelegate locationsManagement] updaterDaemon] startPolling];
    mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0, 0, W([self view]), H([self view]) - 200)];
    [[self view] addSubview:mapView];
    appDelegate = [[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserLocationChanged) name:@"lmCurrentUserLocationChange" object:nil];
    if([[appDelegate locationsManagement] currentLocation]) {
        userMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake([[[[appDelegate locationsManagement] currentLocation] latitude] floatValue],[[[[appDelegate locationsManagement] currentLocation] longitude] floatValue])];
        [mapView setCamera:[GMSCameraPosition cameraWithLatitude:[[[[appDelegate locationsManagement] currentLocation] latitude] floatValue] longitude:[[[[appDelegate locationsManagement] currentLocation] longitude] floatValue]  zoom:10]];
        [userMarker setMap:mapView];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anotherUsersLocationChanged:) name:@"fbLocationChanged" object:nil];
    [headsCollectionView reloadData];
}
-(void)anotherUsersLocationChanged:(NSNotification*)notification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *objects = [notification object];
    for(NSString *key in objects) {
        if(![key isEqualToString:[defaults valueForKey:@"uid"]])
        {
            NSNumber *latitude = [[objects valueForKey:key] valueForKey:@"latitude"];
            NSNumber *longitude = [[objects valueForKey:key] valueForKey:@"longitude"];
            GMSMarker *mapMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue])];
            if([userPoints valueForKey:key]) {
                GMSMarker *marker = [userPoints valueForKey:key];
                [marker setMap:nil];
            }

            [mapMarker setMap:mapView];
            [mapMarker setTitle:@"jon"];
        }
    }
}
-(void)currentUserLocationChanged {
    if(userMarker) {
        [userMarker setMap:nil];
    }
    if([[appDelegate locationsManagement] currentLocation]) {
        userMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake([[[[appDelegate locationsManagement] currentLocation] latitude] floatValue],[[[[appDelegate locationsManagement] currentLocation] longitude] floatValue])];
        
        [self initialCameraSetup];
        [userMarker setMap:mapView];
        [userMarker setIcon:[UIImage imageNamed:@"sampleImage.png"]];
    }
}
-(void)initialCameraSetup {
    if(initialCamera) {
        return;
    }
    [mapView setCamera:[GMSCameraPosition cameraWithLatitude:36.209954 longitude:-81.663831 zoom:13]];
    //[mapView setCamera:[GMSCameraPosition cameraWithLatitude:[[[[appDelegate locationsManagement] currentLocation] latitude] floatValue] longitude:[[[[appDelegate locationsManagement] currentLocation] longitude] floatValue]  zoom:15]];
    initialCamera = true;
}
- (void)didReceiveGroupLocations {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
    BFPaperView *paperView = [cell viewWithTag:4];
    [paperView setIsRaised:false];
    [paperView setBackgroundColor:[UIColor whiteColor]];
    [paperView setClipsToBounds:true];
    [paperView setCornerRadius:50];
    UIImageView *imageView = [cell viewWithTag:5];
    [imageView setImage:[UIImage imageNamed:@"sampleImage.png"]];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
