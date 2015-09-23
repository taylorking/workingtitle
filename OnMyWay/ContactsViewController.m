
//
//  ContactsViewController.m
//  OnMyWay
//
//  Created by Taylor King on 9/4/15.
//  Copyright (c) 2015 omwltd. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

#pragma mark - Property synthesis
@synthesize panGestureRecognizer, clockIcon, timeLabel;
@synthesize bottomBar, addAContactButton;
@synthesize clockHider, contactsTableView, parentController;
@synthesize appDelegate;
BOOL hamburgerMenuOpened = false;
NSMutableArray *checkedArray;
CGPoint originalClockCenter;

#pragma mark - UIViewController delegates
NSMutableArray *unconfirmedFriends, *friends, *addedMe;

- (void)viewDidLoad {
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
   
    [contactsTableView setDataSource:self];
    [contactsTableView setDelegate:self];
    [contactsTableView reloadData];
    parentController = (NavigationTabBarController*)[self parentViewController];
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hamburgerMenuOpened) name:@"hamburgerMenuOpened" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hamburgerMenuClosed) name:@"hamburgerMenuClosed" object:nil];
    // Do any additional setup after loading the view.
    [panGestureRecognizer setDelegate:self];
    
    originalClockCenter = CGPointMake(13 + 25, 30);
    [[self navigationItem] setTitle:@"Contacts"];
    [[self navigationItem] setHidesBackButton:true]
    ;

    [timeLabel setFont:[UIFont fontWithName:@"Proxima Nova" size:17]];
    [addAContactButton setCornerRadius:25];
    [addAContactButton setRippleBeyondBounds:true];

    [addAContactButton setTapHandler:^(CGPoint tap){
        //Define code that will run when the user hits the button with the + on it.
        [parentController goToContactSearch];
        // This will just segue to a screen with a search bar on it, allowing them to search contacts.
    }];
    
    [bottomBar setTapCircleBurstAmount:0];
    [bottomBar setTapCircleDiameter:0];
    [bottomBar setLiftedShadowRadius:3];
    [bottomBar setTapHandler:^(CGPoint tap){
        [parentController goToMapView];
    }];
    
    
    [[self view] bringSubviewToFront:bottomBar];
    [[self view] bringSubviewToFront:addAContactButton];
    [clockIcon setCornerRadius:25];
    [addAContactButton setNeedsLayout];
    dispatch_async(dispatch_get_main_queue(), ^{
        [contactsTableView
         reloadData];
    });
}

-(void)hamburgerMenuOpened {
    hamburgerMenuOpened = true;
}
-(void)hamburgerMenuClosed {
    hamburgerMenuOpened = false;
}
-(void)coreDataReady {
    
}
-(void)viewDidLayoutSubviews {
    [[self view] bringSubviewToFront:addAContactButton];
}
-(void)viewWillAppear:(BOOL)animated {
    [contactsTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Clock icon pan gesture recognizer delegates
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if([[touches anyObject] view] == addAContactButton) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:bottomBar];
    if(touchLocation.x < originalClockCenter.x) {
        return;
    }
    float percentageOfScreen = touchLocation.x / [[self view] frame].size.width;
    int clockX = touchLocation.x;
    
    CGPoint newClockLocation = CGPointMake(clockX, originalClockCenter.y);
    if((touchLocation.x / [[self view] frame].size.width) > .9) {
        newClockLocation = CGPointMake(.9 * [[self view] frame].size.width, originalClockCenter.y);
        [clockIcon setCenter:newClockLocation];
        [timeLabel setText:@"Forever"];
        return;
    }
    [clockIcon setCenter:newClockLocation];

    int clockMinutes = (int)(((pow(2, percentageOfScreen) - 1) * 400 /** 400 is a magic number, it's a constant we use for our log scale **/) + .5);
    if(clockMinutes > 60) {
        int clockHours = (int)((clockMinutes / 60.0) + .5);
        if(clockHours > 1) {
            [timeLabel setText:[NSString stringWithFormat:@"%d Hours", clockHours]];
        }
        else {
            [timeLabel setText:@"1 Hour"];
        }
    }
    else {
        if(clockMinutes > 1 && clockMinutes != 0 ){
            [timeLabel setText:[NSString stringWithFormat:@"%d Minutes", clockMinutes]];
        } else {
            [timeLabel setText:[NSString stringWithFormat:@"1 Minute"]];
            
        }
    }

}
-(void)performFadeButtonsAnimation {
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([[touches anyObject] view] == addAContactButton) {
        return;
    }
    [clockIcon setCenter:originalClockCenter];
    [timeLabel setText:@"Share Location"];
    [parentController goToMapView];
    // The user has let go of the clock

}

#pragma mark - Table View Delegates

/**
 
 What I want the table to look like
 
 Contacts
 
 Added You
 +----------------------+
 |                      |
 | +Jon Jonson          |
 | +Jeeves              |
 |                      |
 |                      |
 +----------------------+
 Friends
 +----------------------+
 |                      |
 |  Taylor King         |
 |                      |
 |                      |
 |                      |
 |                      |
 |                      |
 |                      |
 +----------------------+
 Waiting Confirmation
 +----------------------+
 |                      |
 |  Dig Bigelow         |
 |                      |
 |                      |
 |                      |
 |                      |
 +----------------------+
**/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *possesiveContact = (Contact*)[[[appDelegate contactsManagement] friends] objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    for(UIView *view in [[cell contentView]  subviews]) {
        if([view isKindOfClass:[BFPaperCheckbox class]]) {
            [view removeFromSuperview];
        }
    }
    BFPaperCheckbox *checkBox = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(5, [[cell contentView] frame].size.height / 2 - (bfPaperCheckboxDefaultRadius / 2), bfPaperCheckboxDefaultRadius, bfPaperCheckboxDefaultRadius)];
    [checkBox setTag:4];
    [checkBox setDelegate:self];
    if([possesiveContact selected]) {
        [checkBox checkAnimated:false];
    }
    else {
        [checkBox uncheckAnimated:false];
    }
    [[cell contentView]addSubview:checkBox];
    
    UILabel *displayNameLabel = (UILabel*)[cell viewWithTag:2];
    UILabel *userNameLabel = (UILabel*)[cell viewWithTag:3];
    
    [displayNameLabel setText:[possesiveContact displayName]];
    [userNameLabel setText:[possesiveContact userName]];
    [[self view] bringSubviewToFront:addAContactButton];
    return cell;
    
}
-(void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox {

}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    #warning Incomplete implementation
    
    // Move one cell from one section of the table to the other when the user either confirms a friend request
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if(hamburgerMenuOpened) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerMenuNeedsClosing" object:nil];
        return false;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BFPaperCheckbox *checkBox = (BFPaperCheckbox*)[cell viewWithTag:4];
    if(![checkBox isChecked]) {
        [checkBox checkAnimated:true];
        Contact *currentContact = (Contact*)[[[appDelegate contactsManagement] friends] objectAtIndex:[indexPath row]];
        [currentContact setSelected:[NSNumber numberWithBool:true]];
    } else {
        [checkBox uncheckAnimated:true];
        Contact *currentContact = (Contact*)[[[appDelegate contactsManagement] friends] objectAtIndex:[indexPath row]];
        [currentContact setSelected:nil];
    }
    return false;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows in each section
    NSUInteger count = [[[appDelegate contactsManagement] friends] count];
    checkedArray = [[NSMutableArray alloc] initWithCapacity:count];
    return count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
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
