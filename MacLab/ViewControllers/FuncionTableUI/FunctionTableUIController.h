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
    
    IBOutlet NSNumberFormatter * formatter;
    
    IBOutlet NSTableView * functionTableView;
}
//----------------Initializers---------------------
-(id) initWithXminValue:(double) xmin
          xmaxValue:(double) xmax
          yminValue:(double) ymin
          ymaxValue:(double) ymax;
//----------------Notifications--------------------
-(void) handlFunctionAdded:(NSNotification *)aNotification;
//----------------Graphic logic--------------------
-(IBAction)showAddFunctionPanel:(id)sender;
-(IBAction)removeFunctions:(id)sender;
-(IBAction)removeAllModelElements:(id)sender;
-(IBAction)setNewRepresentationParameters:(id)sender;

-(IBAction)tableViewEditNameColumn:(id)sender;
-(IBAction)tableViewEditTypeColumn:(id)sender;
-(IBAction)tableViewEditAValueColumn:(id)sender;
-(IBAction)tableViewEditBValueColumn:(id)sender;
-(IBAction)tableViewEditCValueColumn:(id)sender;
-(IBAction)tableViewEditColorColumn:(id)sender;
-(IBAction)tableViewEditVisibilityColumn:(id)sender;
//----------------Bussines logic-------------------
-(void) reloadData;


@end

NS_ASSUME_NONNULL_END
