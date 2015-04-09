//
//  SystemServicesController.m
//  Android Screenshot
//
//  Created by Roberto Osorio on 6/27/14.
//  Copyright (c) 2014 Roberto Osorio. All rights reserved.
//

#import "SystemServicesController.h"

@interface SystemServicesController () {
    NSString *filename;
    NSTask *videoTask;
}

@property (nonatomic, strong) NSNumber *isRecording;

@end

@implementation SystemServicesController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self setIsRecording:@false];
    }
    return self;
}

- (IBAction)takeScreenshot:(id)sender {
    [videoButton setEnabled:false];
    NSString * scriptPath = [[NSBundle mainBundle] pathForResource: @"adb" ofType: nil];
    NSLog(@"Resource is %@", scriptPath);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd-hhmmss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    filename = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
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
    [videoButton setEnabled:true];
//    NSString * filePath = [NSString stringWithFormat:@"open ~/Desktop/%@", filename];
//    system([filePath cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (IBAction)toggleRecording:(id)sender {
    if (!self.isRecording.boolValue) {
        [screenshotButton setEnabled:false];
        [videoButton setTitle:@"Preparing..."];
        NSString * scriptPath = [[NSBundle mainBundle] pathForResource: @"adb" ofType: nil];
        
        [videoButton setTitle:@"Recording..."];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-mm-dd-hhmmss"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        filename = [NSString stringWithFormat:@"%@.mp4", [formatter stringFromDate:[NSDate date]]];
        videoTask = [NSTask new];
        [videoTask setLaunchPath:scriptPath];
        [textField setStringValue:@"Recording video..."];
        [videoTask setArguments:@[@"shell", @"screenrecord", [NSString stringWithFormat:@"/sdcard/%@", filename]]];
        [videoTask launch];
        [self setIsRecording:@true];
    } else {
        [videoButton setTitle:@"Start recording"];
        kill([videoTask processIdentifier], SIGTERM);
        [videoTask waitUntilExit];
        NSString * scriptPath = [[NSBundle mainBundle] pathForResource: @"adb" ofType: nil];
        NSTask *task = [NSTask new];
        [task setLaunchPath:scriptPath];
        [textField setStringValue:@"Stopping recording..."];
        [task setArguments:@[@"pull", [NSString stringWithFormat:@"/sdcard/%@", filename]]];
        [task setCurrentDirectoryPath:@"~/Desktop/"];
        [task launch];
        [task waitUntilExit];
        task = [NSTask new];
        [task setLaunchPath:scriptPath];
        [textField setStringValue:@"Removing video from device..."];
        [task setArguments:@[@"shell", @"rm", [NSString stringWithFormat:@"/sdcard/%@", filename]]];
        [task launch];
        [task waitUntilExit];
        [textField setStringValue:@"Ready!"];
        [screenshotButton setEnabled:true];
        [self setIsRecording:false];
//        NSString * filePath = [NSString stringWithFormat:@"open ~/Desktop/%@", filename];
//        system([filePath cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

@end
