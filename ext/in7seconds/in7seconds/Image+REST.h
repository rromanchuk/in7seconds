//
//  Image+REST.h
//  in7seconds
//
//  Created by Ryan Romanchuk on 4/28/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "Image.h"
#import "RestImage.h"
@interface Image (REST)
+ (Image *)imageWithRestImage:(RestImage *)restImage
          inManagedObjectContext:(NSManagedObjectContext *)context;
@end
