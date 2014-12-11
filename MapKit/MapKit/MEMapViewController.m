//
//  MEMapViewController.m
//  MapKit
//
//  Created by Jason Anderson on 7/24/13.
//  Copyright (c) 2013 Jason Anderson. All rights reserved.
//

#import "MEMapViewController.h"

#import <MapKit/MapKit.h>

@interface MEMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation MEMapViewController

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
    [self setMapView:[[MKMapView alloc] initWithFrame:self.view.bounds]];
    [self.view addSubview:self.mapView];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 2000, 2000) animated:YES];
    
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    [searchRequest setNaturalLanguageQuery:@"pub"];
    [searchRequest setRegion:MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 3500, 3500)];
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count > 0) {
            for (MKMapItem *mapItem in response.mapItems) {
                MKPlacemark *placemark = mapItem.placemark;
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = placemark.coordinate;
                annotation.title = mapItem.name;
                annotation.subtitle = placemark.title;
                [self.mapView addAnnotation:annotation];
                NSLog(@"%@", mapItem.name);
            }
        } else {
            NSLog(@"no results");
        }
    }];
    
    [self.mapView setShowsUserLocation:NO];
}

@end
