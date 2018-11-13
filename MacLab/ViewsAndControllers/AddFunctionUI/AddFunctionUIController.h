//
//  AddFunctionUIController.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Model;

NS_ASSUME_NONNULL_BEGIN

@interface AddFunctionUIController : NSObject <NSComboBoxDelegate, NSTextFieldDelegate>{
    IBOutlet NSTextField * nameTextField;
    IBOutlet NSTextField * aValueTextField;
    IBOutlet NSTextField * bValueTextField;
    IBOutlet NSTextField * cValueTextField;
    IBOutlet NSColorWell * colorColorWell;
    IBOutlet NSComboBox * typeCombobox;
    IBOutlet NSTextField * cValueLabel;
    
    Model * model;
}

-(IBAction)addFunction:(id)sender;
-(IBAction)showOrHideCValueTextFiledAndLabel:(id)sender;

- (void) controlTextDidChange:(NSNotification *)obj;

@end

NS_ASSUME_NONNULL_END
