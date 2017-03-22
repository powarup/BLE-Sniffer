//
//  Beacon.m
//  BLE Sniffer
//
//  Created by Jovan Powar on 08/01/2017.
//  Copyright © 2017 Jovan Powar. All rights reserved.
//

#import "Beacon.h"
#import <UIKit/UIDevice.h>

@implementation Beacon

+(instancetype)sharedInstance {
    // 1
    static Beacon *_sharedInstance = nil;

    // 2
    static dispatch_once_t oncePredicate;

    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Beacon alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    NSLog(@"[BEACON] init");
    self = [super init];
    if (self) {
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];

        _snifferServiceUUID = [CBUUID UUIDWithString: SNIFFER_SERVICE_UUID];

        CBMutableService *snifferService = [[CBMutableService alloc] initWithType:_snifferServiceUUID primary:YES];

        [_peripheralManager addService:snifferService];
    }
    return self;
}

-(BOOL)advertising {
    return _peripheralManager.isAdvertising;
}

-(void)setAdvertising:(BOOL)advertising {
    if (!advertising) [self stop];
}

-(void)start {
    NSLog(@"[Beacon] attempting to begin advertising");
    if (_peripheralManager.state == CBManagerStatePoweredOn) {
        NSString *serviceName = [NSString stringWithFormat:@"%@ BLE Sniffer", [[UIDevice currentDevice] name]];
        [_peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey :@[_snifferServiceUUID] , CBAdvertisementDataLocalNameKey : serviceName}];
    }
}

-(void)stop {
    [_peripheralManager stopAdvertising];
    NSLog(@"[Beacon] stopped advertising");
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    self.advertising = peripheral.isAdvertising;
    if (peripheral.state != CBManagerStatePoweredOn) {
        self.advertising = FALSE;
    }
    NSLog(@"[Beacon] changed state");
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error {

    if (error) {
        NSLog(@"Error publishing service: %@", [error localizedDescription]);
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error {

    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    } else {
        self.advertising = TRUE;
        NSLog(@"[Beacon] advertising begun");
    }
}


@end
