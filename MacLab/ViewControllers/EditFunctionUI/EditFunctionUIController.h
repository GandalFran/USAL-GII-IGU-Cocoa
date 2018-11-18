//
//  EditFunctionUIController.h
//  MacLab
//
//  Created by GandalFran on 19/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class Model;
@class Function;

@interface EditFunctionUIController : NSWindowController<NSWindowDelegate, NSComboBoxDelegate, NSTextFieldDelegate>{

    IBOutlet NSTextField * nameTextField;
    IBOutlet NSTextField * aValueTextField;
    IBOutlet NSTextField * bValueTextField;
    IBOutlet NSTextField * cValueTextField;
    IBOutlet NSColorWell * colorColorWell;
    IBOutlet NSComboBox * typeCombobox;
    IBOutlet NSTextField * cValueLabel;
    IBOutlet NSButton * editButton;

    Function * function;
    Model * model;
}

/*----------------Notifications--------------*/
-(void) handleSendModel:(NSNotification *)aNotification;
-(void) handleSendFunction:(NSNotification *)aNotification;
/*--------------Bussines logic-------------*/
-(IBAction)editFunction:(id)sender;
@end

NS_ASSUME_NONNULL_END
