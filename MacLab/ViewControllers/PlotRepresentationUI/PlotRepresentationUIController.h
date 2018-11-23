//
//  PlotRepresentationUIController.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Model;
@class NSPlotView;
@class FunctionTableUIController;

NS_ASSUME_NONNULL_BEGIN

@interface PlotRepresentationUIController : NSWindowController <NSWindowDelegate>{
    IBOutlet NSPlotView * plotView;
}

//----------------Notifications--------------------
-(void) handleAddRepresentation:(NSNotification *)aNotification;
-(void) handleAddNewParameters:(NSNotification *)aNotification;
//----------------Graphic logic--------------------
-(IBAction)showFunctionTablePanel:(id)sender;
-(IBAction)exportProject:(id)sender;
-(IBAction)importProject:(id)sender;
-(IBAction)exportPanel:(id)sender;
//----------------Bussines logic-------------------
-(void) addRepresentationWithFunctionArray: (NSArray *) aFunctionArray;

@end

NS_ASSUME_NONNULL_END
