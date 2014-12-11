//
//  MEDirectionsViewController.m
//  MapKit
//
//  Created by Jason Anderson on 8/15/13.
//  Copyright (c) 2013 Jason Anderson. All rights reserved.
//

#import "MEDirectionsViewController.h"

#import <MapKit/MapKit.h>

@interface MEDirectionsViewController ()

@property (weak,nonatomic) IBOutlet UITextField *toAddressTextField;
@property (weak,nonatomic) IBOutlet UITextField *fromAddressTextField;
@property (weak,nonatomic) IBOutlet UIButton *openInMapsButton;

@property (strong,nonatomic) MKMapItem *toLocation;
@property (strong,nonatomic) MKMapItem *fromLocation;

@end

@implementation MEDirectionsViewController

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
	// Do any additional setup after loading the view.
    self.toAddressTextField.text = @"401 East Michigan Avenue Kalamazoo, MI 49007";
    self.fromAddressTextField.text = @"	416 S Burdick St  Kalamazoo, MI 49007";
}

- (IBAction)handleButtonPress:(id)sender {
    [self geocodeFromAddress:self.fromAddressTextField.text];
}

- (void)geocodeFromAddress: (NSString *)address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (placemarks.count > 0) {
            CLPlacemark *mark = [placemarks objectAtIndex:0];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:mark];
            strongSelf.fromLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
            [strongSelf geocodeToAddress:strongSelf.toAddressTextField.text];
        }
    }];
}

- (void)geocodeToAddress: (NSString *)address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        __strong typeof(self) strongSelf = weakSelf;
        
        if (placemarks.count > 0) {
            CLPlacemark *mark = [placemarks objectAtIndex:0];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:mark];
            strongSelf.toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
            [strongSelf getDrivingDirectionsFrom:strongSelf.fromLocation To:strongSelf.toLocation];
        }
    }];
}

#pragma mark - Get Directions
- (void)getDrivingDirectionsFrom: (MKMapItem *)from To: (MKMapItem *)to {
    NSArray *mapItems = @[from, to];
    
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                              MKLaunchOptionsMapTypeKey:
                                  [NSNumber numberWithInteger:MKMapTypeStandard],
                              MKLaunchOptionsShowsTrafficKey:@YES};
    
    [MKMapItem openMapsWithItems:mapItems launchOptions:options];
}

@end
