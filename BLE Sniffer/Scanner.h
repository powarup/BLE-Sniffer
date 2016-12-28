//
//  Scanner.h
//  BLE Sniffer
//
//  Created by Jovan Powar on 28/12/2016.
//  Copyright © 2016 Jovan Powar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#define SCANNER_NOT_READY 0
#define SCANNER_WAITING 1
#define SCANNER_READY 2

@interface Scanner : NSObject <CBCentralManagerDelegate>

@property CBCentralManager *centralManager;
@property bool canScan;
@property int ready;

-(void)start;
-(void)stop;

@end
