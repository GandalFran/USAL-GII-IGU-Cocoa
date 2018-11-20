//
//  FunctionTableUIController.h
//  MacLab
//
//  Created by GandalFran on 13/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Model;
@class AddFunctionUIController;
@class EditFunctionUIController;

NS_ASSUME_NONNULL_BEGIN

@interface FunctionTableUIController : NSWindowController<NSWindowDelegate, NSTextDelegate, NSComboBoxDelegate, NSTableViewDelegate, NSTableViewDataSource>{
    
    IBOutlet NSTextField * nameTextField;
    IBOutlet NSTextField * aValueTextField;
    IBOutlet NSTextField * bValueTextField;
    IBOutlet NSTextField * cValueTextField;
    IBOutlet NSColorWell * colorColorWell;
    IBOutlet NSComboBox * typeCombobox;
    IBOutlet NSTextField * cValueLabel;
    IBOutlet NSButton * editButton;
    
    IBOutlet NSTextField * xminTextField;
    IBOutlet NSTextField * xmaxTextField;
    IBOutlet NSTextField * yminTextField;
    IBOutlet NSTextField * ymaxTextField;
    IBOutlet NSButton * saveSettingsButton;
    
    IBOutlet NSTableView * tableView;
    
    Model * model;
    
    AddFunctionUIController * addFunctionUIController;
    EditFunctionUIController * editFunctionUIController;
}

/*----------------Notifications--------------*/
-(void) handleSendModel:(NSNotification *)aNotification;
-(void) handleReloadData:(NSNotification *)aNotification;
/*--------------Delegation-------------*/

/*--------------Bussines logic-------------*/
-(IBAction)addFunction:(id)sender;
-(IBAction)removeFunction:(id)sender;
-(IBAction)editFunction:(id)sender;
-(IBAction)removeAllModelElements:(id)sender;
-(IBAction)representSelectedFunctions:(id)sender;
-(IBAction)setNewRepresentationParameters:(id)sender;


-(IBAction)TEST:(id)sender;

@end

NS_ASSUME_NONNULL_END
