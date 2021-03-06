//
//  ViewController.h
//  BLE Sniffer
//
//  Created by Jovan Powar on 28/12/2016.
//  Copyright © 2016 Jovan Powar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UITableView *devicesTableView;
@property IBOutlet UIButton *scanButton;
@property IBOutlet UIButton *markButton;
@property IBOutlet UIButton *clearButton;
@property IBOutlet UIButton *exportButton;
@property IBOutlet UIButton *beaconButton;

-(void)update;
-(IBAction)mark:(id)sender;
-(IBAction)clear:(id)sender;
-(IBAction)exportData:(id)sender;
-(IBAction)scan:(id)sender;
-(IBAction)beacon:(id)sender;

@end

