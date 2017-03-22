//
//  Exporter.m
//  BLE Sniffer
//
//  Created by Jovan Powar on 22/03/2017.
//  Copyright © 2017 Jovan Powar. All rights reserved.
//

#import "Exporter.h"
#import "Objective-Zip.h"
#import "Scanner.h"

@implementation Exporter

+(NSURL*)exportZip {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *fullPathToFile = [directory stringByAppendingPathComponent:@"BLE Sniffer export.zip"];

    OZZipFile *zipFile= [[OZZipFile alloc] initWithFileName:fullPathToFile
                                                       mode:OZZipFileModeCreate];
    Scanner *scanner = [Scanner sharedInstance];

    // add marks
    if (scanner.marks && scanner.marks.count > 0) {
        NSString *marksString = [self getMarksString];
        OZZipWriteStream *marksStream= [zipFile writeFileInZipWithName:@"marks.txt"
                                                      compressionLevel:OZZipCompressionLevelBest];

        [marksStream writeData:[marksString dataUsingEncoding:NSUTF8StringEncoding]];
        [marksStream finishedWriting];
    }

    // add devices
    for (NSString *key in scanner.seenDevices) {
        SeenDevice *d = [scanner.seenDevices objectForKey:key];
        NSString *sightingsCSV = [d getSightingsCSV];
        NSString *filename = [NSString stringWithFormat:@"%@.csv",d.name?:d.peripheral];
        OZZipWriteStream *stream= [zipFile writeFileInZipWithName:filename
                                                 compressionLevel:OZZipCompressionLevelBest];

        [stream writeData:[sightingsCSV dataUsingEncoding:NSUTF8StringEncoding]];
        [stream finishedWriting];
    }

    [zipFile close];

    return [NSURL fileURLWithPath:fullPathToFile];
}

+(NSString*)getMarksString {
    Scanner *scanner = [Scanner sharedInstance];
    NSMutableString *marksString = [NSMutableString new];
    for (NSDate* mark in scanner.marks) {
        [marksString appendFormat:@"%f\n",[mark timeIntervalSince1970]];
    }
    return marksString;
}

@end
