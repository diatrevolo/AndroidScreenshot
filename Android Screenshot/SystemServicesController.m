//
//  SystemServicesController.m
//  Android Screenshot
//
//  Created by Roberto Osorio on 6/27/14.
//  Copyright (c) 2014 Roberto Osorio. All rights reserved.
//

#import "SystemServicesController.h"

@interface SystemServicesController ()

@end

@implementation SystemServicesController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (IBAction)takeScreenshot:(id)sender {
    NSString * scriptPath = [[NSBundle mainBundle] pathForResource: @"adb" ofType: nil];
    NSLog(@"Resource is %@", scriptPath);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd-hhmmss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    NSString *filename = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
    NSTask *task = [NSTask new];
    [task setLaunchPath:scriptPath];
    [textField setStringValue:@"Taking screenshot..."];
    [task setArguments:@[@"shell", @"screencap", @"-p", [NSString stringWithFormat:@"/sdcard/%@", filename]]];
    [task launch];
    [task waitUntilExit];
    task = [NSTask new];
    [task setLaunchPath:scriptPath];
    [textField setStringValue:@"Pulling screenshot..."];
    [task setArguments:@[@"pull", [NSString stringWithFormat:@"/sdcard/%@", filename]]];
    [task setCurrentDirectoryPath:@"~/Desktop/"];
    [task launch];
    [task waitUntilExit];
    task = [NSTask new];
    [task setLaunchPath:scriptPath];
    [textField setStringValue:@"Removing screenshot from device..."];
    [task setArguments:@[@"shell", @"rm", [NSString stringWithFormat:@"/sdcard/%@", filename]]];
    [task launch];
    [task waitUntilExit];
    [textField setStringValue:@"Ready!"];
    
    NSString * filePath = [NSString stringWithFormat:@"open ~/Desktop/%@", filename];
    system([filePath cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
