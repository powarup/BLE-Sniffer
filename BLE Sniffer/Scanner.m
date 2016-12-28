//
//  Scanner.m
//  BLE Sniffer
//
//  Created by Jovan Powar on 28/12/2016.
//  Copyright © 2016 Jovan Powar. All rights reserved.
//

#import "Scanner.h"

@implementation Scanner

- (instancetype)init
{
    NSLog(@"[SCANNER] init");
    self = [super init];
    if (self) {
        // set up objects that do scanning
        _canScan = false;
        _ready = SCANNER_NOT_READY;
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

-(void)start
{
    if (_ready == SCANNER_NOT_READY) {
        NSLog(@"[SCANNER] not ready to scan, waiting");
        _ready = SCANNER_WAITING;
    } else if (_ready == SCANNER_READY) {
        if (_canScan) {
            NSLog(@"[SCANNER] starting scan");
            [_centralManager scanForPeripheralsWithServices:nil options:nil];
        } else {
            NSLog(@"[SCANNER] can't scan, Bluetooth isn't on!");
        }
    }
}

-(void)stop
{
    NSLog(@"[SCANNER] stopping scan");
    [_centralManager stopScan];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    bool startScan = false;
    if (_ready == SCANNER_WAITING) startScan = true;
    _ready = SCANNER_READY;
    
    _canScan = (central.state == CBManagerStatePoweredOn);
    if (central.isScanning && !_canScan) [self stop];
    NSLog(@"[SCANNER] central manager updated: can%@ scan",_canScan ? @"" : @" not");
    
    if (startScan) [self start];
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"[SCANNER] did discover %@, RSSI: %f", peripheral.name, RSSI.floatValue);
}

@end
