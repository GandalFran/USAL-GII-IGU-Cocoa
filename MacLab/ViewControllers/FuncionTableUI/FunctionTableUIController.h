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

NS_ASSUME_NONNULL_BEGIN

@interface FunctionTableUIController : NSWindowController<NSWindowDelegate, NSTextDelegate, NSComboBoxDelegate, NSTableViewDelegate, NSTableViewDataSource>{

    IBOutlet NSTextField * xminTextField;
    IBOutlet NSTextField * xmaxTextField;
    IBOutlet NSTextField * yminTextField;
    IBOutlet NSTextField * ymaxTextField;
    IBOutlet NSButton * saveSettingsButton;
    
    IBOutlet NSTableView * functionTableView;
}
//----------------Initializers---------------------
-(id) initWithModel: (Model *) aModel;
//----------------Notifications--------------------
-(void) handlFunctionAdded:(NSNotification *)aNotification;
//----------------Graphic logic--------------------
-(IBAction)showAddFunctionPanel:(id)sender;
-(IBAction)removeFunction:(id)sender;
-(IBAction)removeAllModelElements:(id)sender;
-(IBAction)representSelectedFunctions:(id)sender;
-(IBAction)setNewRepresentationParameters:(id)sender;

-(IBAction)tableViewEditNameColumn:(id)sender;
-(IBAction)tableViewEditTypeColumn:(id)sender;
-(IBAction)tableViewEditAValueColumn:(id)sender;
-(IBAction)tableViewEditBValueColumn:(id)sender;
-(IBAction)tableViewEditCValueColumn:(id)sender;
-(IBAction)tableViewEditColorColumn:(id)sender;
//----------------Bussines logic-------------------
-(void) reloadData;

-(IBAction)TEST:(id)sender;

@end

NS_ASSUME_NONNULL_END
