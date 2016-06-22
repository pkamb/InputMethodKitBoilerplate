//
//  IMKBoilerplateInputController.m
//  InputMethodKitBoilerplate
//
//  Created by Peter Kamb on 6/21/16.
//  Copyright © 2016 Peter Kamb. All rights reserved.
//

#import "IMKBoilerplateInputController.h"

@implementation IMKBoilerplateInputController

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

@end
