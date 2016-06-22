//
//  main.m
//  InputMethodKitBoilerplate
//
//  Created by Peter Kamb on 6/21/16.
//  Copyright © 2016 Peter Kamb. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <InputMethodKit/InputMethodKit.h>

const NSString *kConnectionName = @"InputMethodKit_Boilerplate_Connection";

IMKServer *server;
IMKCandidates *candidatesWindow;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        server = [[IMKServer alloc] initWithName:(NSString *)kConnectionName bundleIdentifier:[NSBundle mainBundle].bundleIdentifier];
        
        candidatesWindow = [[IMKCandidates alloc] initWithServer:server panelType:kIMKSingleColumnScrollingCandidatePanel];
        
        [[NSApplication sharedApplication] run];
    }
    
    return 0;
}
