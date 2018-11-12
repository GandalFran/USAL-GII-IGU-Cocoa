//
//  AddFunctionUIController.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "Model/Model.h"
#import <Cocoa/Cocoa.h>

@class Model;

NS_ASSUME_NONNULL_BEGIN

@interface AddFunctionUIController : NSObject{
    IBOutlet NSTextField * nameTextField;
    IBOutlet NSTextField * aValueTextField;
    IBOutlet NSTextField * bValueTextField;
    IBOutlet NSTextField * cValueTextField;
    IBOutlet NSColorWell * colorColorWell;
    IBOutlet NSComboBox * typeCombobox;
    IBOutlet NSTextField * cValueLabel;
 
    IBOutlet NSTextField * xminTextField;
    IBOutlet NSTextField * xmaxTextField;
    IBOutlet NSTextField * yminTextField;
    IBOutlet NSTextField * ymaxTextField;
    
    Model * model;
}

-(IBAction)addFunction:(id)sender;
-(IBAction)showOrHideCValueTextFiledAndLabel:(id)sender;
-(IBAction)setNewRepresentationParameters:(id)sender;

@end

NS_ASSUME_NONNULL_END
