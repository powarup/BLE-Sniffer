//
//  Sighting.m
//  BLE Sniffer
//
//  Created by Jovan Powar on 28/12/2016.
//  Copyright © 2016 Jovan Powar. All rights reserved.
//

#import "Sighting.h"

@implementation Sighting

-(NSString *)getAdvertisedLocalName {
    NSString *name = nil;
    if (_advertisementData) {
        name = [_advertisementData objectForKey:@"kCBAdvDataLocalName"];
    }
    return name;
}

@end
