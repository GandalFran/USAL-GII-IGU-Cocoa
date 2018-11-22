//
//  AddFunctionUIController.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#import "Function.h"
#import "AddFunctionUIController.h"


@implementation AddFunctionUIController{
    NSArray * comboBoxDataSource;
}

/*----------------------Initializers--------------------*/

-(id)initWithComboBoxDataSource:(NSArray *) anArray
{
    if(nil == [super initWithWindowNibName:@"AddFunctionUI"])
        return nil;
    
    //Register the combobox datasource
    comboBoxDataSource = anArray;
    
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
    [alert setMessageText:@"Atention"];
    [alert setInformativeText:@"If you close this window, the function data will be losed."];
    [alert addButtonWithTitle:@"yes"];
    [alert addButtonWithTitle:@"no"];
    [alert setAlertStyle:NSAlertStyleWarning];
    response = [alert runModal];

    if (NSAlertFirstButtonReturn == response) {
        [self cleanAndDeactivateFields];
        return YES;
    }else{
        return NO;
    }
}

-(void) awakeFromNib{
    [typeCombobox addItemsWithObjectValues: [comboBoxDataSource subarrayWithRange: NSMakeRange(0, 6)] ] ;
    [self cleanAndDeactivateFields];
}

- (void) windowDidLoad {
    [super windowDidLoad];
}

/*----------------Notifications--------------*/
NSString * functionAdded = @"functionAdded";
/*--------------Delegation-------------*/

/**
 *  @brief enables or disables the add button if the
 *         formulary is completed or not
 */
- (void) controlTextDidChange:(NSNotification *)obj{
    BOOL formularyCompleted = [self isFormCompleted];
    [addButton setEnabled: formularyCompleted];
}


/**
 *  @brief hides or shows the cValue label and textbox
 *         according to the type comboBox.
 *         and enables or disables the add button if the
 *         formulary is completed or not
 */
-(void)comboBoxSelectionDidChange:(NSNotification *)notification{
    BOOL selectedItem = (4 == [typeCombobox indexOfSelectedItem]);
    [cValueLabel setHidden: !selectedItem];
    [cValueTextField setHidden: !selectedItem];
    
    BOOL formularyCompleted = [self isFormCompleted];
    [addButton setEnabled: formularyCompleted];
}

/*--------------Bussinges logic-------------*/

/**
 * @brief retrieves the information from the formulary fields and
 *          instances a Function, then add it to the model.
 */
-(IBAction)sendFunctionDataAndCloseWindow:(id)sender{
    Function * aFunction = nil;
    NSDictionary * notificationInfo = nil;
    NSNotificationCenter * notificationCenter = nil;
    
    //Obtain the Function and add to the model
    aFunction = [self takeDataFromFormulary];
    //Throw notification to advise that a function has been aded
    notificationInfo = [NSDictionary dictionaryWithObject:aFunction
                                                   forKey:@"function"];
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:functionAdded
                                      object:self
                                    userInfo:notificationInfo];
    
    [self cleanAndDeactivateFields];
    [self close];
}

-(Function *) takeDataFromFormulary{
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
    aType = (FunctionType) [typeCombobox indexOfSelectedItem];
    
    aFunction = [[Function alloc] initWithName:aFunctionName
                                         color:aColor
                                ExpressionType:aType
                              ExpressionAValue:aValue
                              ExpressionBValue:bValue
                              ExpressionCValue:cValue];
    
    return aFunction;
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

-(void) cleanAndDeactivateFields{
    [nameTextField setStringValue:@""];
    [aValueTextField setStringValue:@""];
    [bValueTextField setStringValue:@""];
    [cValueTextField setStringValue:@""];
    [typeCombobox setStringValue:comboBoxDataSource[NONE_TYPE]];
    
    [cValueLabel setHidden: YES];
    [cValueTextField setHidden: YES];
    [addButton setEnabled: NO];
}

@end
