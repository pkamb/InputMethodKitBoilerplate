//
//  IMKBoilerplateInputController.m
//  InputMethodKitBoilerplate
//
//  Created by Peter Kamb on 6/21/16.
//  Copyright © 2016 Peter Kamb. All rights reserved.
//

#import "IMKBoilerplateInputController.h"
#import <Cocoa/Cocoa.h>

@interface IMKBoilerplateInputController ()

@property (nonatomic, assign) BOOL overrideIMKInputControllerMethodsToAvoidCrashUnderARC;

@end

@implementation IMKBoilerplateInputController

extern IMKCandidates *candidatesWindow;

- (id)initWithServer:(IMKServer *)server delegate:(id)delegate client:(id)inputClient {
    if (self = [super initWithServer:server delegate:delegate client:inputClient]) {
        
        NSDictionary *attributes = @{NSFontAttributeName: [NSFont systemFontOfSize:16],
                                     IMKCandidatesOpacityAttributeName: @(0.8),
                                     IMKCandidatesSendServerKeyEventFirst: @NO,
                                     };
        
        [candidatesWindow setAttributes:attributes];
        
        self.overrideIMKInputControllerMethodsToAvoidCrashUnderARC = NO;
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

            
            
            
            // Test for rdar://21463962
            // Type Option-E to test
            if (event.keyCode == kVK_ANSI_E) {
                if (![event.charactersIgnoringModifiers isEqualToString:@"e"] &&
                    ![event.charactersIgnoringModifiers isEqualToString:@"E"]) {
                    
                    // rdar://21463962
                    // Input Method Kit reports wrong values for NSEvent `charactersIgnoringModifiers` in `handleEvent:client:`
                    
                    // Option-E should produce the dead key "´" in U.S. QWERTY. Get this via `event.characters`.
                    // The base key value "e" or "E" should be available via `event.charactersIgnoringModifiers`.
                    
                    // But within Input Method Kit's `handleEvent:client:` method, `event.charactersIgnoringModifiers`
                    // still reports the same "´" reported by `event.characters`. Reproducable with the "dead keys" (e,i,n,u).

                    NSLog(@"rdar://21463962 - Input Method Kit reports wrong values for NSEvent `charactersIgnoringModifiers` in `handleEvent:client:`");
                    NSLog(@"event.keyCode: %hu | event.characters: %@ | event.charactersIgnoringModifiers: %@", event.keyCode, event.characters, event.charactersIgnoringModifiers);
                    NSLog(@"event.charactersIgnoringModifiers for this event should report 'e' or 'E'");
                }
            }
            
            
            
            
            // Test for rdar://
            // Type 'F' key to test
            if (event.keyCode == kVK_ANSI_F) {
                
                // If project is using ARC, the superclass implementations of `updateComposition`, `cancelComposition`, and `selectionRange`
                // will crash the Input Method Kit app. If these methods are not implemented on the IMKInputController subclass, they will
                // be called on `super` and the app will crash under ARC.
                
                // When ARC is not enabled on the project, allowing `super` to call these methods (rather than overriding via the IMKInputController
                // subclass) works as intended.
                
                // Exception Type:        EXC_BAD_ACCESS (SIGSEGV)
                // Exception Codes:       KERN_INVALID_ADDRESS at 0x000007f8bc8f0b00
                // Exception Note:        EXC_CORPSE_NOTIFY
                
                [self updateComposition];
                [self commitComposition:sender];
                
                handled = YES;
            }
            
            
            
            
            break;
        }
        case NSKeyUp: {
            
            // rdar://21376535
            // Input Method Kit cannot catch NSKeyUp events.
            
            NSLog(@"Handling Input Method Kit NSKeyUp Event! Was rdar://21376535 fixed!?!");
            
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
        
        // rdar://26868067
        // IMKCandidates `setCandidateData:` method not working in place of IMKInputController `candidates:` delegate method

        // In this case, where `useSetCandidateData = YES`, the candidates I'm setting below are not displayed.
        // The `else` case below, which calls out to the `candidates:` delegate method, does correctly display candidates.
        
        
        NSArray *candidates = @[@"candidate #1 via `setCandidateData:`! Is rdar://26868067 fixed?",
                                @"candidate #2 via `setCandidateData:`! Is rdar://26868067 fixed?",
                                @"candidate #3 via `setCandidateData:`! Is rdar://26868067 fixed?",
                                ];
        
        [candidatesWindow setCandidateData:candidates];
        
        [candidatesWindow show:kIMKLocateCandidatesBelowHint];
        
    } else {
        
        // Calling `updateCandidates` will result in a call being made to the IMKInputController's `candidates:` method.
        [candidatesWindow updateCandidates];
        
        [candidatesWindow show:kIMKLocateCandidatesBelowHint];
    }
    
    return handled;
}

#pragma mark IMKServerInput Text Composition and Input

- (id)composedString:(id)sender {
    NSString *randomCharacter = [[[NSProcessInfo processInfo] globallyUniqueString] substringWithRange:NSMakeRange(0, 1)];

    NSString *composedString = randomCharacter;
    
    return [[NSAttributedString alloc] initWithString:composedString];
}

- (void)updateComposition {
    if (!self.overrideIMKInputControllerMethodsToAvoidCrashUnderARC) {
        [super updateComposition];
        return;
    }
    
    [[self client] setMarkedText:[self composedString:self] selectionRange:[self selectionRange] replacementRange:[self replacementRange]];
}

- (void)cancelComposition {
    if (!self.overrideIMKInputControllerMethodsToAvoidCrashUnderARC) {
        [super cancelComposition];
        return;
    }
    
    [[self client] insertText:[self originalString:self] replacementRange:[self replacementRange]];
}

- (NSRange)selectionRange {
    if (!self.overrideIMKInputControllerMethodsToAvoidCrashUnderARC) {
        return [super selectionRange];
    }
    
    return NSMakeRange(NSNotFound, NSNotFound);
}

- (void)commitComposition:(id)sender {
    NSString *composition = [self composedString:sender];
    
    [[self client] insertText:composition replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
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
