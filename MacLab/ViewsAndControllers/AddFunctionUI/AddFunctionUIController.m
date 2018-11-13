//
//  AddFunctionUIController.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AddFunctionUIController.h"
#import "Model.h"
#import "Expression.h"

@implementation AddFunctionUIController

-(IBAction)addFunction:(id)sender{
    FunctionType type;
    double aValue, bValue, cValue;
    NSColor * color = nil;
    NSString * functionName = nil;
    
    aValue = [aValueTextField doubleValue];
    bValue = [bValueTextField doubleValue];
    cValue = [cValueTextField doubleValue];
    color = [colorColorWell color];
    functionName = [nameTextField stringValue];
    switch((int)[typeCombobox indexOfSelectedItem]){
        case 0: type = COSINE; break;
        case 1: type = SINE; break;
        case 2: type = EXPONENTIAL; break;
        case 3: type = LINE; break;
        case 4: type = PARABOLA; break;
        case 5: type = HIPERBOLA; break;
    }
    
    [model addFunctionWithName:functionName color:color ExpressionType:type ExpressionAValue:aValue ExpressionBValue:bValue ExpressionCValue:cValue];
}

-(IBAction)showOrHideCValueTextFiledAndLabel:(id)sender{
    int selectedItem = (int)[typeCombobox indexOfSelectedItem];
    
    if( 4 == selectedItem ){
        [cValueLabel setHidden: true];
        [cValueTextField setHidden: true];
    }else{
        [cValueLabel setHidden: false];
        [cValueTextField setHidden: false];
    }
}
-(IBAction)setNewRepresentationParameters:(id)sender{

}

@end
