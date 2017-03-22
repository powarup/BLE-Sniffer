//
//  Scanner.m
//  BLE Sniffer
//
//  Created by Jovan Powar on 28/12/2016.
//  Copyright © 2016 Jovan Powar. All rights reserved.
//

#import "Scanner.h"

@implementation Scanner

+(instancetype)sharedInstance
{
    // 1
    static Scanner *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Scanner alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    NSLog(@"[SCANNER] init");
    self = [super init];
    if (self) {
        // set up objects that do scanning
        _canScan = false;
        _ready = SCANNER_NOT_READY;
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        _seenDevices = [NSMutableDictionary new];
        _marks = [NSMutableArray new];
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
            [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
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

-(void)mark
{
    [_marks addObject:[NSDate date]];
}

-(bool)isScanning {
    return _centralManager.isScanning;
}

-(void)clear {
    [self stop];
    _seenDevices = [NSMutableDictionary new];
    _marks = [NSMutableArray new];
}

#pragma mark CBCentralManager delegate methods

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
    if (peripheral.name) {
    //if ([peripheral.name hasPrefix: @"raspberrypi"] || [peripheral.name hasPrefix: @"jsp50"]) {
        NSDate *timeDiscovered = [NSDate date];
        Sighting *thisSighting = [Sighting new];
        thisSighting.time = timeDiscovered;
        thisSighting.RSSI = RSSI;
        thisSighting.advertisementData = advertisementData;

        NSUUID *seenUUID = peripheral.identifier;

        bool madeNew = false;
        SeenDevice *foundDevice = [_seenDevices objectForKey:seenUUID.UUIDString];
        if (foundDevice) {
            [foundDevice addSighting:thisSighting];
        } else {
            foundDevice = [[SeenDevice alloc] initFromPeripheral:peripheral];
            [foundDevice addSighting:thisSighting];
            [_seenDevices setObject:foundDevice forKey:seenUUID.UUIDString];
            madeNew = true;
        }

        //NSLog(@"[SCANNER] did see%@ %@ aka %@, RSSI: %i", madeNew ? @" new" : @"", peripheral.identifier.UUIDString, peripheral.name, RSSI.intValue);

        NSLog(@"%@ says %@",peripheral.name, advertisementData);
    }
    
}

@end
