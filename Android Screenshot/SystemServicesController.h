//
//  SystemServicesController.h
//  Android Screenshot
//
//  Created by Roberto Osorio on 6/27/14.
//  Copyright (c) 2014 Roberto Osorio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SystemServicesController : NSViewController {
    IBOutlet NSTextField *textField;
}



- (IBAction)takeScreenshot:(id)sender;

@end
