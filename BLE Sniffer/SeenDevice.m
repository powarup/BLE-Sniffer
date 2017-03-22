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
        _name = _peripheral.name ?: peripheral.identifier.UUIDString;
        _sightings = [NSMutableArray new];
    }
    return self;
}

- (void)addSighting:(Sighting*)sighting
{
    [_sightings addObject:sighting];
    _name = ([sighting getAdvertisedLocalName]) ?: _name;
}

-(Sighting *)getLatestSighting {
    return [_sightings objectAtIndex:([_sightings count] - 1)];
}

-(NSString *)getSightingsCSV {
    NSMutableString *csv = [NSMutableString new];
    [csv appendFormat:@"%@\n",_name];
    [csv appendString:@"time,RSSI\n"];
    for (Sighting *s in _sightings) {
        [csv appendFormat:@"%f,%@\n",[s.time timeIntervalSince1970],s.RSSI];
    }
    return csv;
}

@end
