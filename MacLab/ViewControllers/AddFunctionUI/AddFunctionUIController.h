//
//  AddFunctionUIController.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddFunctionUIController : NSWindowController <NSWindowDelegate, NSComboBoxDelegate, NSTextFieldDelegate>{
    IBOutlet NSTextField * nameTextField;
    IBOutlet NSTextField * aValueTextField;
    IBOutlet NSTextField * bValueTextField;
    IBOutlet NSTextField * cValueTextField;
    IBOutlet NSColorWell * colorWell;
    IBOutlet NSComboBox * typeCombobox;
    IBOutlet NSTextField * cValueLabel;
    IBOutlet NSButton * addButton;
}

//----------------Initializers---------------------
-(id)initWithComboBoxDataSource:(NSArray *) anArray;
//----------------Graphic logic--------------------
-(IBAction)sendFunctionDataAndCloseWindow:(id)sender;

@end

NS_ASSUME_NONNULL_END
