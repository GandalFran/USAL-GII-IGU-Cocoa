//
//  AddFunctionUIController.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "AddFunctionUIController.h"
#import "FunctionTableUIController.h"
#import "Model.h"
#import "Function.h"


@implementation AddFunctionUIController

/*----------------------Initializers--------------------*/
-(id) init
{
    self = [super initWithWindowNibName:@"AddFunctionUI"];
    
    if (nil == self)
        return nil;
    
    //Register handlers for the notification
    NSNotificationCenter * notificationCenter = nil;
    
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleSendModel:)
                               name:sendModelToAddFunctionUI
                             object:nil];
    
    
    return self;
}


-(instancetype) initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if(nil == self)
        return nil;
    
    return self;
}

/**
 * @brief ask the user if really want to lose the progress on the function creation
 */
-(BOOL) windowShouldClose:(NSWindow *)sender
{
    NSAlert * alert = nil;
    NSModalResponse response;
    
    alert = [[NSAlert alloc] init];
    if(nil == alert)
        return YES;
    
    [alert setMessageText:@"Atention"];
    [alert setInformativeText:@"If you close this window, the function data will be losed\nDo you really want?"];
    [alert addButtonWithTitle:@"yes"];
    [alert addButtonWithTitle:@"no"];
    [alert setAlertStyle:NSAlertStyleWarning];
    response = [alert runModal];

    if (NSAlertFirstButtonReturn == response) {
        return YES;
    }else{
        return NO;
    }
}

/**
 * @brief  for implement good coding practices
 */
- (void) windowDidLoad {
    [super windowDidLoad];
}

/*----------------Notifications--------------*/

extern NSString * sendModelToAddFunctionUI;

/**
 *  @brief handler to sendModelToAddFunctionUI notification:
 *          receives the model
 */
-(void) handleSendModel:(NSNotification *)aNotification{
    NSDictionary * aDictionary = nil;
    
    aDictionary = [aNotification userInfo];
    if(nil != aDictionary){
        model = [aDictionary objectForKey:@"model"];
    }
}

/*--------------Intern actions-------------*/
-(IBAction)addFunction:(id)sender{
    FunctionType type;
    double aValue, bValue, cValue;
    NSColor * color = nil;
    NSString * functionName = nil;
    Function * f = nil;
    
    aValue = [aValueTextField doubleValue];
    bValue = [bValueTextField doubleValue];
    cValue = [cValueTextField doubleValue];
    color = [colorColorWell color];
    functionName = [nameTextField stringValue];
    switch((int)[typeCombobox indexOfSelectedItem]){
        case 0: type = COSINE; break;
        case 1: type = SINE; break;
        case 2: type = EXPONENTIAL; break;
        case 3: type = LINE; break;
        case 4: type = PARABOLA; break;
        case 5: type = HIPERBOLA; break;
        default: type = NONE_TYPE;
    }
    
    f = [[Function alloc] initWithName:functionName color:color ExpressionType:typeArc ExpressionAValue:aValue ExpressionBValue:bValue ExpressionCValue:cValue];
    
    [model addFunction:f];
}

-(IBAction)showOrHideCValueTextFiledAndLabel:(id)sender{
    int selectedItem = (int)[typeCombobox indexOfSelectedItem];
    
    if( 4 == selectedItem ){
        [cValueLabel setHidden: true];
        [cValueTextField setHidden: true];
    }else{
        [cValueLabel setHidden: false];
        [cValueTextField setHidden: false];
    }
}

- (void) controlTextDidChange:(NSNotification *)obj{
    
}

@end
