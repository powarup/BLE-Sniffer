//
//  ViewController.m
//  BLE Sniffer
//
//  Created by Jovan Powar on 28/12/2016.
//  Copyright © 2016 Jovan Powar. All rights reserved.
//

#import "ViewController.h"
#import "Scanner.h"
#import "SeenDeviceTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:0.2f target:self selector:@selector(update) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)update {
    Scanner *scanner = [Scanner sharedInstance];
    [_devicesTableView reloadData];
    [_scanButton setTitle:([scanner isScanning] ? @"Stop scanning" : @"Start scanning") forState:UIControlStateNormal];
}

- (IBAction)mark:(id)sender {
    [[Scanner sharedInstance] mark];
    UIView *flashView = [[UIView alloc] initWithFrame:self.view.frame];
    flashView.backgroundColor = [UIColor redColor];
    flashView.alpha = 0.5;
    [self.view addSubview:flashView];
    [UIView animateWithDuration: 0.2
                     animations: ^{
                         flashView.alpha = 0.0;
                     }
                     completion: ^(BOOL finished) {
                         [flashView removeFromSuperview];
                     }
     ];
    NSLog(@"added mark");
}

- (IBAction)scan:(id)sender {
    Scanner *scanner = [Scanner sharedInstance];
    if (scanner.isScanning) {
        [scanner stop];
        [_scanButton setTitle:@"Start scanning" forState:UIControlStateNormal];
    } else {
        if ([scanner canScan]) {
        [scanner start];
        [_scanButton setTitle:@"Start scanning" forState:UIControlStateNormal];
        } else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Can't scan"
                                                                           message:@"Bluetooth may be turned off, or this device may not support BLE."
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"[TableView] setting number of rows");
    Scanner *scanner = [Scanner sharedInstance];
    return scanner.seenDevices.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"[TableView] creating cell");
    SeenDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeenDeviceCell"];
    NSArray *keyArray = [Scanner sharedInstance].seenDevices.allKeys;
    NSArray *sortedArray = [keyArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    SeenDevice *thisDevice = [[Scanner sharedInstance].seenDevices objectForKey:[sortedArray objectAtIndex:indexPath.row]];
    
    Sighting *lastSighting = [thisDevice.sightings objectAtIndex:([thisDevice.sightings count] - 1)];
    
    if (thisDevice.peripheral.name) {
        UIFontDescriptor * fontD = [cell.name.font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        cell.name.font = [UIFont fontWithDescriptor:fontD size:0];

        [cell.name setText:thisDevice.peripheral.name];
    } else {
        UIFontDescriptor * fontD = [cell.name.font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        cell.name.font = [UIFont fontWithDescriptor:fontD size:0];
        [cell.name setText:@"Unnamed"];
    }
    
    
    [cell.RSSI setText:[NSString stringWithFormat:@"%idB",lastSighting.RSSI.intValue]];
    [cell.timeElapsed setText:[NSString stringWithFormat:@"%is",(-(int)[lastSighting.time timeIntervalSinceNow])]];
    
    return cell;
}

@end
