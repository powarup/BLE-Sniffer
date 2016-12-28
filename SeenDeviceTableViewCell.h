//
//  SeenDeviceTableViewCell.h
//  BLE Sniffer
//
//  Created by Jovan Powar on 28/12/2016.
//  Copyright © 2016 Jovan Powar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeenDeviceTableViewCell : UITableViewCell

@property IBOutlet UILabel *name;
@property IBOutlet UILabel *timeElapsed;
@property IBOutlet UILabel *RSSI;

@end
