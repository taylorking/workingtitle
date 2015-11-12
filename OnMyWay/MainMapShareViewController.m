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

@synthesize headsPaperView;
@synthesize containerView;
@synthesize groupsTableView;
@synthesize headsCollectionView;
NSMutableDictionary *heads;
NSMutableDictionary *userPoints;
BOOL initialCamera = false;
 BOOL nibloaded = false;
CGRect viewFrame;
CGRect originalCollectionViewFrame;
NSArray *selectedGroups;

- (void)viewDidLoad {
       appDelegate = [[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    selectedGroups = [[NSMutableArray alloc] init];
    userPoints = [[NSMutableDictionary alloc] init];
    appDelegate = [[UIApplication sharedApplication] delegate];
    heads = [[NSMutableDictionary alloc] init];
    [containerView setScrollEnabled:false];
    userPoints = [[NSMutableDictionary alloc] init];
    friendMarkers = [[NSMutableDictionary alloc] init];
    [[[appDelegate locationsManagement] updaterDaemon] startPolling];

    // GMSUISettings *uiSettings = [[GMSUISettings alloc] init];

    [headsCollectionView setBackgroundColor:LIGHTSECONDARY_COLOR];
    [headsPaperView setBackgroundColor:LIGHTSECONDARY_COLOR];
    [containerView setBackgroundColor:ALMOSTWHITE_COLOR];
    [self setAutomaticallyAdjustsScrollViewInsets:false];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initialCameraSetup) name:@"lmdLocationUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawFriendHeads) name:@"lmGroupDataChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawAllMapMarkers) name:@"lmGroupDataChanged" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawFriendHeads) name:@"lmInitialGroupsRecieved" object:nil];
    [containerView setNeedsLayout];
    //[containerView addSubview:headsPaperView];
    //[containerView bringSubviewToFront:headsCollectionView];

    
}


-(void)viewDidLayoutSubviews {
 /** if([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] ==  UIInterfaceOrientationLandscapeRight) {
    [mapView setFrame:CGRectMake(0, 0, W([self view]), H([self view]) - 100)];
    } else {
        [mapView setFrame:CGRectMake(0, 0, W([self view]), H([self view]) - 100)];
    }**/
//    [self redrawFriendHeads];

    if(viewFrame.size.width == 0) {
        viewFrame = [[self view] frame];
        [self initialViewConfig];
    }
     // [containerView bringSubviewToFront:headsPaperView];
}
-(void)initialViewConfig {
    headsPaperView = [[BFPaperView alloc] initWithFrame:CGRectMake(0,viewFrame.size.height - 100, viewFrame.size.width, 100)];
    [containerView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [containerView setContentSize:CGSizeMake(W(containerView), H(containerView) * 2)];
    mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0,0,W(containerView),H(containerView))];
    
    groupsTableView = [[GroupsTableView alloc] initWithFrame:CGRectMake(0, H([self view]), W([self view]), H([self view]) - 100)];
    
    [containerView addSubview:groupsTableView];
    [containerView addSubview:mapView];
    
    if([[appDelegate locationsManagement] currentLocation]) {
        userMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake([[[[appDelegate locationsManagement] currentLocation] latitude] floatValue],[[[[appDelegate locationsManagement] currentLocation] longitude] floatValue])];
        [mapView setCamera:[GMSCameraPosition cameraWithLatitude:[[[[appDelegate locationsManagement] currentLocation] latitude] floatValue] longitude:[[[[appDelegate locationsManagement] currentLocation] longitude] floatValue]  zoom:10]];
        [userMarker setMap:mapView];
    }

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setItemSize:CGSizeMake(72,72)];
    headsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,viewFrame.size.width, 100) collectionViewLayout:flowLayout];
    [headsCollectionView setBackgroundColor:[UIColor clearColor]];
    [headsCollectionView setDataSource:self];
    [headsCollectionView setDelegate:self];
    
    [headsPaperView addSubview:headsCollectionView];
    [headsPaperView bringSubviewToFront:headsCollectionView];
    [headsPaperView setBackgroundColor:MAIN_COLOR];
    [headsPaperView setAlpha:.8f];
    [containerView addSubview:headsPaperView];
    [self redrawFriendHeads];
    [self redrawAllMapMarkers];
}
-(void)redrawFriendHeads {
    
    heads = [[NSMutableDictionary alloc] init];
    for (NSString *key in [[[appDelegate locationsManagement] groupDescriptions] allKeys]) {
        NSDictionary *group = [[[appDelegate locationsManagement] groupDescriptions] valueForKey:key];
        for(NSString *user in [group allKeys]) {
            [heads setValue:[group valueForKey:user] forKey:user];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [headsCollectionView reloadData];
        [groupsTableView reloadData];
    });
}
-(void)redrawAllMapMarkers {
    for(NSString *gid in [[appDelegate locationsManagement] acceptedGroups]) {
        [self redrawMapMarkers:gid];
    }
    for(NSString *gid in [[appDelegate locationsManagement] unacceptedGroups]) {
        [self redrawMapMarkers:gid];
    }
}
-(void)didReceieveGroupUpdate:(NSNotification*)notification {
    [self redrawMapMarkers:[notification object]];
}
-(void)redrawMapMarkers:(NSString*)gid  {
    NSDictionary *groupInformation = [[[appDelegate locationsManagement] groupDescriptions] valueForKey:gid];
    for(NSString *key in groupInformation) {
        if(![[groupInformation valueForKey:key] valueForKey:@"latitude"]) {
            continue;
        }
        NSNumber *latitudeNumber = [[groupInformation valueForKey:key] valueForKey:@"latitude"];
        [[heads valueForKey:key] setValue:latitudeNumber forKey:@"latitude"];
        NSNumber *longitudeNumber = [[groupInformation valueForKey:key] valueForKey:@"longitude"];
        [[heads valueForKey:key] setValue:longitudeNumber forKey:@"longitude"];
        GMSMarker *newMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake([latitudeNumber floatValue], [longitudeNumber floatValue])];
        UIImage *icon = [self renderMapMarkerForUser:key inGroup:gid];
        [newMarker setIcon:icon];
        [newMarker setFlat:true];
        if([userPoints valueForKey:key]) {
            GMSMarker *marker = (GMSMarker*)[userPoints valueForKey:key];
            [marker setMap:nil];
            [userPoints setValue:newMarker forKey:key];
            [newMarker setMap:mapView];
        } else {
            [newMarker setAppearAnimation:kGMSMarkerAnimationPop];
            [newMarker setMap:mapView];
            [userPoints setValue:newMarker forKey:key];
        }
    }
//redraw markers
}
// Converts userdata in to a ui view, then converts it into an image with quartz.

-(UIImage*)renderMapMarkerForUser:(NSString*)uid inGroup:(NSString*)gid {
    NSDictionary *groupInformation = [[[appDelegate locationsManagement] groupDescriptions] valueForKey:gid];
    NSDictionary *userInformation = [groupInformation valueForKey:uid];

    BFPaperView *mapMarker = [[BFPaperView alloc] initWithFrame:CGRectMake(0, 0, 24, 24) raised:false];
    NSString *userName = [userInformation valueForKey:@"username"];
    //if(![userInformation valueForKey:@"avatar"]) {
        UIColor *userColor = [AppDelegate colorForUsername:userName];
        [mapMarker setBackgroundColor:userColor];
        UILabel *initialsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24,24)];
        [initialsLabel setBackgroundColor:[UIColor clearColor]];
        [initialsLabel setFont:PROXIMA_NOVA(24)];
        [initialsLabel setText:[userName substringToIndex:1]];
        [initialsLabel setTextColor:[UIColor whiteColor]];
        [initialsLabel setTextAlignment:NSTextAlignmentCenter];
        [mapMarker addSubview:initialsLabel];
    //}
    [mapMarker setCornerRadius:(24/2)];
    [mapMarker setClipsToBounds:true];
    [mapMarker setAlpha:.9f];
    UIGraphicsBeginImageContext([mapMarker frame].size);
    [[mapMarker layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

    return result;
}
-(void)initialCameraSetup {
    if(!initialCamera) {
    [mapView setCamera:[GMSCameraPosition cameraWithLatitude:[[[[appDelegate locationsManagement] currentLocation] latitude] floatValue] longitude:[[[[appDelegate locationsManagement] currentLocation] longitude] floatValue]  zoom:15]];
        initialCamera = true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(!heads) {
        return 0;
    }
    return [[heads allKeys] count];
}
-(void)moveCameraToUser:(NSString*)uid {
    if(![[heads valueForKey:uid] valueForKey:@"latitude"]) {
        return;
    }
    NSNumber *longitude = [[heads valueForKey:uid] valueForKey:@"longitude"];
    NSNumber *latitude = [[heads valueForKey:uid] valueForKey:@"latitude"];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[latitude floatValue] longitude:[longitude floatValue] zoom:15];
    [mapView setCamera:camera];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [self moveCameraToUser:[[heads allKeys] objectAtIndex:[indexPath row]]];
     return false;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(!heads) {
        return nil;
    }
    NSDictionary *dict = [heads valueForKey:[[heads allKeys] objectAtIndex:[indexPath row]]];
    if(!nibloaded) {
        UINib *nib = [UINib nibWithNibName:@"HeadsCollectionViewCellLarge" bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:@"largeHeadCell"];
        nibloaded = true;
    }
    HeadsCollectionViewCellLarge *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"largeHeadCell" forIndexPath:indexPath];
    [[cell circularView] setBackgroundColor:[UIColor clearColor]];
    [[cell containerView] setBackgroundColor:[UIColor clearColor]];
    [[cell circularView] setCornerRadius:36];
    [[cell circularView] setClipsToBounds:true];
    [cell setAlpha:1];
    if(![dict valueForKey:@"latitude"]) {
        [cell setAlpha:.5f];
    }
    if([dict valueForKey:@"avatar"]) {
        [[cell imageView] setImage:[UIImage imageNamed:@"sampleImage.png"]];
    }
    else {
        [[cell imageView] setHidden:true];
        [[cell titleLabel]setBackgroundColor:[UIColor clearColor]];
        NSString *username = [dict valueForKey:@"username"];
        [[cell titleLabel] setTextColor:[UIColor whiteColor]];
        [[cell titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[cell circularView] setBackgroundColor:[AppDelegate colorForUsername:username]];
        [[cell titleLabel] setText:[username substringToIndex:1]];
    }
    [cell bringSubviewToFront:[cell circularView]];
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

- (IBAction)didSwipeUp:(id)sender {
    [UIView animateWithDuration:.4f animations:^{
        [headsPaperView setAlpha:1];
    }];
    [containerView setContentOffset:CGPointMake(0,[self view].frame.size.height -95) animated:true];

}
- (IBAction)didSwipeDown:(id)sender {
    [UIView animateWithDuration:.4f animations:^{
        [headsPaperView setAlpha:.8f];
    }];
    [containerView setContentOffset:CGPointMake(0,0)  animated:true];
}
@end
