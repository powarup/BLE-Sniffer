//
//  SeenDevice.h
//  BLE Sniffer
//
//  Created by Jovan Powar on 28/12/2016.
//  Copyright © 2016 Jovan Powar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Sighting.h"

@interface SeenDevice : NSObject

@property CBPeripheral *peripheral;
@property NSMutableArray *sightings;
@property NSString *name;

- (instancetype)initFromPeripheral:(CBPeripheral*)peripheral;
- (void)addSighting:(Sighting*)sighting;
- (Sighting*)getLatestSighting;
- (NSString*)getSightingsCSV;

@end
