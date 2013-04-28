//
//  Image+REST.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/28/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Image+REST.h"

@implementation Image (REST)
+ (Image *)imageWithRestImage:(RestImage *)restImage
       inManagedObjectContext:(NSManagedObjectContext *)context {
   
    Image *image;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    request.predicate = [NSPredicate predicateWithFormat:@"externalId = %@", [NSNumber numberWithInt:restImage.externalId]];
    
    NSError *error = nil;
    NSArray *threads = [context executeFetchRequest:request error:&error];
    //ALog(@"looking for user with externalId %d got %@ from restUser %@ with context %@", restUser.externalId, users, restUser, context);
    if (threads && ([threads count] > 1)) {
        // handle error
    } else if (![threads count]) {
        image = [NSEntityDescription insertNewObjectForEntityForName:@"Image"
                                               inManagedObjectContext:context];
        
        [image setManagedObjectWithIntermediateObject:restImage];
        
    } else {
        image = [threads lastObject];
        [image setManagedObjectWithIntermediateObject:restImage];
    }
    ALog(@"returning thread");
    return image;
}

- (void)setManagedObjectWithIntermediateObject:(RestObject *)intermediateObject {
    RestImage *restImage = (RestImage *) intermediateObject;
    
    self.externalId = [NSNumber numberWithInteger:restImage.externalId];
    self.photoUrl = restImage.photoUrl;
}
@end
