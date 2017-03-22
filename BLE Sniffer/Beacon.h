//
//  Beacon.h
//  BLE Sniffer
//
//  Created by Jovan Powar on 08/01/2017.
//  Copyright © 2017 Jovan Powar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Scanner.h"

#define SNIFFER_SERVICE_UUID @"F259DCD0-DF8D-485E-925E-137B082F1BC1"

@interface Beacon : NSObject <CBPeripheralManagerDelegate>

@property CBPeripheralManager *peripheralManager;
@property CBUUID *snifferServiceUUID;
@property BOOL advertising;

+(instancetype)sharedInstance;
-(void)start;
-(void)stop;

@end
