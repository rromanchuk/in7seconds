#import "Location.h"
#import "Flurry.h"
#import <AddressBook/AddressBook.h>

@interface Location ()

@end


@implementation Location


- (id)init
{
    self = [super init];
    
    if (self) {
        self.locationManager                 = [[CLLocationManager alloc] init];
        self.locationManager.delegate        = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter  = 250;
        self.geoCoder = [[CLGeocoder alloc] init];
    }
    
    return self;
}

- (NSNumber *)getLatitude {
    return _latitude;
    
}

- (NSNumber *)getLongitude {
    return _longitude;
}


- (void)update
{
    [self.locationManager startUpdatingLocation];
}

+ (Location *)sharedLocation
{
    static dispatch_once_t pred;
    static Location *sharedLocation;
    
    dispatch_once(&pred, ^{
        sharedLocation = [[Location alloc] init];
    });
    
    return sharedLocation;
}

// CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)aLocationManager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    
    // test the measurement to see if it is more accurate than the previous measurement
    if (self.bestEffortAtLocation == nil || self.bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            //
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation:@"Found a location that is within our desiredAccuracy"];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
            
            self.desiredLocation = newLocation;
            CLLocationCoordinate2D coordinate = [newLocation coordinate];
            self.latitude  = @(coordinate.latitude);
            self.longitude = @(coordinate.longitude);
            
            [Flurry setLatitude:newLocation.coordinate.latitude
                      longitude:newLocation.coordinate.longitude
             horizontalAccuracy:newLocation.horizontalAccuracy
               verticalAccuracy:newLocation.verticalAccuracy];
            
            [self.delegate didGetBestLocationOrTimeout];
        }
    }
    // update the display with the new location data
}

- (void)updateUntilDesiredOrTimeout:(NSTimeInterval)timeout {
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    [self performSelector:@selector(stopUpdatingLocation:) withObject:@"TimedOut" afterDelay:timeout];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.delegate failedToGetLocation:error];
}


- (void)stopUpdatingLocation: (NSString *)state {
    DLog(@"Stoping location update with state: %@", state);
    DLog(@"delegate is %@", self.delegate);
    [self.locationManager stopUpdatingLocation];
    
    if ([state isEqualToString:@"TimedOut"]) {
#warning all delgates should implement this
        ALog(@"delegate is %@", self.delegate);
        // Even though we didn't get a desired location and we have to timeout, make sure the location is still valid. Location manager may not fail, but return
        // an invalid location like 0,0. We should intercept this and call failedToGetLocation: on our delegate so we don't try to fetch from the server
        if (![self isLocationValid] && [self.delegate respondsToSelector:@selector(failedToGetLocation:)]) {
            [self.delegate failedToGetLocation:[NSError errorWithDomain:@"com.Ostronaut.location" code:-1000 userInfo:@{NSLocalizedDescriptionKey : @"Problem aquiring valid location"}]];
        } else if (self.delegate && [self.delegate respondsToSelector:@selector(locationStoppedUpdatingFromTimeout)]) {
            [self getCityCountryWithLat:self.locationManager.location.coordinate.latitude
                                 andLon:self.locationManager.location.coordinate.longitude
                                success:^(NSString* cityCountry){
                                    self.cityCountryString = cityCountry;
                                    
                                }];
            [self.delegate locationStoppedUpdatingFromTimeout];
        }
        
    }
}

- (void)resetDesiredLocation {
    self.desiredLocation = nil;
    self.bestEffortAtLocation = nil;
}

- (BOOL)isLocationValid {
    if (!self.longitude || ![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorized) {
        return NO;
    } else {
        return YES;
    }
    
}

- (void)getCityCountryWithLat:(double)lat andLon:(double)lon success:(void (^)(NSString *cityCountry))success {
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = placemarks[0];
            NSString *cityCountryString = [NSString stringWithFormat:@"%@, %@", (placemark.addressDictionary)[(NSString*)kABPersonAddressCityKey], (placemark.addressDictionary)[(NSString*)kABPersonAddressCountryKey]];
            ALog(@"got address %@", cityCountryString);
            success(cityCountryString);
        }
    }];
    
}
@end
