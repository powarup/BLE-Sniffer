//
//  SeenDevice.m
//  BLE Sniffer
//
//  Created by Jovan Powar on 28/12/2016.
//  Copyright © 2016 Jovan Powar. All rights reserved.
//

#import "SeenDevice.h"

@implementation SeenDevice

- (instancetype)initFromPeripheral:(CBPeripheral*)peripheral
{
    self = [super init];
    if (self) {
        _peripheral = peripheral;
        _sightings = [NSMutableArray new];
    }
    return self;
}

- (void)addSighting:(Sighting*)sighting
{
    [_sightings addObject:sighting];
}

@end
