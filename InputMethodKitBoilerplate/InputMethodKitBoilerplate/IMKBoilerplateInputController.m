//
//  IMKBoilerplateInputController.m
//  InputMethodKitBoilerplate
//
//  Created by Peter Kamb on 6/21/16.
//  Copyright © 2016 Peter Kamb. All rights reserved.
//

#import "IMKBoilerplateInputController.h"

@implementation IMKBoilerplateInputController

extern IMKCandidates *candidatesWindow;

- (id)initWithServer:(IMKServer *)server delegate:(id)delegate client:(id)inputClient {
    if (self = [super initWithServer:server delegate:delegate client:inputClient]) {
        
        NSDictionary *attributes = @{NSFontAttributeName: [NSFont systemFontOfSize:16],
                                     IMKCandidatesOpacityAttributeName: @(0.8),
                                     IMKCandidatesSendServerKeyEventFirst: @NO,
                                     };
        
        [candidatesWindow setAttributes:attributes];
    }
    
    return self;
}

/*!
 @protocol    IMKServerInput
 @abstract    Informal protocol which is used to send user events to an input method.
 @discussion  This is not a formal protocol by choice.  The reason for that is that there are three ways to receive events here. An input method should choose one of those ways and  implement the appropriate methods.
 
 Here are the three approaches:
 
 1.  Support keybinding.
 In this approach the system takes each keydown and trys to map the keydown to an action method that the input method has implemented.  If an action is found the system calls didCommandBySelector:client:.  If no action method is found inputText:client: is called.  An input method choosing this approach should implement
 -(BOOL)inputText:(NSString*)string client:(id)sender;
 -(BOOL)didCommandBySelector:(SEL)aSelector client:(id)sender;
 
 2. Receive all key events without the keybinding, but do "unpack" the relevant text data.
 Key events are broken down into the Unicodes, the key code that generated them, and modifier flags.  This data is then sent to the input method's inputText:key:modifiers:client: method.  For this approach implement:
 -(BOOL)inputText:(NSString*)string key:(NSInteger)keyCode modifiers:(NSUInteger)flags client:(id)sender;
 
 3. Receive events directly from the Text Services Manager as NSEvent objects.  For this approach implement:
 -(BOOL)handleEvent:(NSEvent*)event client:(id)sender;
 */

#pragma mark IMKServerInput

- (NSUInteger)recognizedEvents:(id)sender {
    return NSKeyDownMask | NSKeyUpMask | NSFlagsChangedMask;
}

- (BOOL)handleEvent:(NSEvent *)event client:(id)sender {
    
    BOOL handled = NO;
    
    switch (event.type) {
        case NSKeyDown: {
            NSLog(@"NSKeyDown event");
            break;
        }
        case NSKeyUp: {
            NSLog(@"NSKeyUp event");
            break;
        }
        case NSFlagsChanged: {
            NSLog(@"NSFlagsChanged event");
            break;
        }
        default:
            handled = NO;
            break;
    }

    BOOL useSetCandidateData = YES;
    if (useSetCandidateData) {
        NSArray *candidates = @[@"candidate #1 via `setCandidateData:`",
                                @"candidate #2 via `setCandidateData:`",
                                @"candidate #3 via `setCandidateData:`",
                                ];
        
        [candidatesWindow setCandidateData:candidates];
    }
    
    [candidatesWindow show:kIMKLocateCandidatesBelowHint];
    [candidatesWindow updateCandidates];
    
    return handled;
}

#pragma mark IMKCandidates Candidate Window

- (NSArray *)candidates:(id)sender {
    
    NSArray *candidates = @[@"candidate #1 via `candidates:`",
                            @"candidate #2 via `candidates:`",
                            @"candidate #3 via `candidates:`",
                            ];
    
    return candidates;
}

@end
