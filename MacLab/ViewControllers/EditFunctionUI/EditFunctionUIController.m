//
//  EditFunctionUIController.m
//  MacLab
//
//  Created by GandalFran on 19/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#import "Model.h"
#import "Function.h"

#import "FunctionTableUIController.h"
#import "EditFunctionUIController.h"

@implementation EditFunctionUIController

/*----------------------Initializers--------------------*/

-(id) init
{
    if(nil == [super initWithWindowNibName:@"EditFunctionUI"])
        return nil;
    
    //Register handlers for notifications
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleSendModel:)
                               name:sendModelToEditFunctionUI
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(handleSendFunction:)
                               name:sendFunctionToEditFunctionUI
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
    [NSApp stopModal];
    return YES;
}

-(void) awakeFromNib{

}

- (void) windowDidLoad {
    [super windowDidLoad];
}

/*----------------Notifications--------------*/

extern NSString * sendModelToEditFunctionUI;
extern NSString * sendFunctionToEditFunctionUI;
NSString * functionEdited = @"functionEdited";

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
    
    NSWindow *w = [self window];
    [NSApp runModalForWindow:w];
}

-(void) handleSendFunction:(NSNotification *)aNotification{
    NSDictionary * aDictionary = nil;
    
    aDictionary = [aNotification userInfo];
    if(nil != aDictionary){
        function = [aDictionary objectForKey:@"function"];
    }
    
    [nameTextField setStringValue:[function name]];
    [aValueTextField setFloatValue:[function aValue]];
    [aValueTextField setFloatValue:[function bValue]];
    [aValueTextField setFloatValue:[function cValue]];
    [colorColorWell setColor:[function color]];
    [typeCombobox setStringValue:@"HOLAWO"];
    [editButton setEnabled:YES];
    
    NSWindow *w = [self window];
    [NSApp runModalForWindow:w];
}

/*--------------Delegation-------------*/

/**
 *  @brief enables or disables the add button if the
 *         formulary is completed or not
 */
- (void) controlTextDidChange:(NSNotification *)obj{
    BOOL formularyCompleted = [self isFormCompleted];
    [editButton setEnabled: formularyCompleted];
}

/**
 *  @brief hides or shows the cValue label and textbox
 *         according to the type comboBox.
 *         and enables or disables the add button if the
 *         formulary is completed or not
 */
-(void)comboBoxSelectionDidChange:(NSNotification *)notification{
    BOOL selectedItem = (4 == [typeCombobox indexOfSelectedItem]);
    BOOL formularyCompleted = [self isFormCompleted];
    
    [cValueLabel setHidden: !selectedItem];
    [cValueTextField setHidden: !selectedItem];
    
    [editButton setEnabled: formularyCompleted];
}

/*--------------Bussinges logic-------------*/

/**
 * @brief retrieves the information from the formulary fields and
 *          instances a Function, then add it to the model.
 */
-(IBAction)editFunction:(id)sender{
    NSNotificationCenter * notificationCenter = nil;
    
    //Obtain the Function and add to the model
    [self takeDataFromFormulary];
    [model updateFunction: function];
    //Throw notification to advise that a function has been eddited
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:functionEdited object:self];
    
    [NSApp stopModal];
    [self close];
}

-(void) takeDataFromFormulary{
    FunctionType aType;
    double aValue, bValue, cValue;
    NSColor * aColor = nil;
    NSString * aFunctionName = nil;
    
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
    
    [function setName: aFunctionName];
    [function setAValue: aValue];
    [function setBValue: bValue];
    [function setCValue: cValue];
    [function setColor: aColor];
    [function setType: aType];
}

- (BOOL) isFormCompleted{
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    
    BOOL areAllFilled = ([[nameTextField stringValue] length] != 0
                         && [[aValueTextField stringValue] length] != 0
                         && [[bValueTextField stringValue] length] != 0
                         && ([[cValueTextField stringValue] length] != 0 || [cValueTextField isHidden] == YES)
                         && [typeCombobox selectedTag] != -1);
    
    //TODO improve the validation of numbers
    BOOL areNumberTextFieldsCorrectlyFilled = (
                                               [numberFormatter numberFromString:[aValueTextField stringValue]] != nil
                                               && [numberFormatter numberFromString:[bValueTextField stringValue]] != nil
                                               && ([numberFormatter numberFromString:[cValueTextField stringValue]] || [cValueTextField isHidden] == YES)
                                               );
    
    return (areAllFilled && areNumberTextFieldsCorrectlyFilled);
}

@end
