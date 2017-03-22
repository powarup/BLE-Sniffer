//
//  Sighting.h
//  BLE Sniffer
//
//  Created by Jovan Powar on 28/12/2016.
//  Copyright © 2016 Jovan Powar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sighting : NSObject

@property NSDate *time;
@property NSNumber *RSSI;
@property NSDictionary<NSString *,id> *advertisementData;

-(NSString*)getAdvertisedLocalName;

@end
