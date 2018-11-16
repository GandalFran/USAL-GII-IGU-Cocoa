//
//  AddFunctionUIController.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#import "Model.h"
#import "Function.h"

#import "AddFunctionUIController.h"
#import "FunctionTableUIController.h"


@implementation AddFunctionUIController

/*----------------------Initializers--------------------*/

-(id) init
{
    self = [super initWithWindowNibName:@"AddFunctionUI"];
    
    if (nil == self)
        return nil;
    
    //Register handlers for notifications
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

-(void) awakeFromNib{
    [cValueLabel setHidden: true];
    [cValueTextField setHidden: true];
}

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

/*--------------Delegation-------------*/

- (void) controlTextDidChange:(NSNotification *)obj{
    //TODO implement
}

/*--------------Bussinges logic-------------*/

/**
 * @brief retrieves the information from the formulary fields and
 *          instances a Function, then add it to the model.
 */
-(IBAction)addFunction:(id)sender{
    FunctionType aType;
    double aValue, bValue, cValue;
    NSColor * aColor = nil;
    NSString * aFunctionName = nil;
    Function * aFunction = nil;
    
    aValue = [aValueTextField doubleValue];
    bValue = [bValueTextField doubleValue];
    cValue = [cValueTextField doubleValue];
    aColor = [colorColorWell color];
    aFunctionName = [nameTextField stringValue];
    switch((int)[typeCombobox indexOfSelectedItem]){
        case 0: aType = COSINE; break;
        case 1: aType = SINE; break;
        case 2: aType = EXPONENTIAL; break;
        case 3: aType = LINE; break;
        case 4: aType = PARABOLA; break;
        case 5: aType = HIPERBOLA; break;
        default: aType = NONE_TYPE;
    }
    
    aFunction = [[Function alloc] initWithName:aFunctionName
                                         color:aColor
                                ExpressionType:aType
                              ExpressionAValue:aValue
                              ExpressionBValue:bValue
                              ExpressionCValue:cValue];
    
    [model addFunction:aFunction];
    //TODO cerrar ventana
}

/**
 *  @brief hides or shows the cValue label and textbox
 *          according to the type comboBox
 */
-(IBAction)showOrHideCValueTextFiledAndLabel:(id)sender{
    int selectedItem = (int)[typeCombobox indexOfSelectedItem];
    
    if( 4 != selectedItem ){
        [cValueLabel setHidden: true];
        [cValueTextField setHidden: true];
    }else{
        [cValueLabel setHidden: false];
        [cValueTextField setHidden: false];
    }
}

@end
