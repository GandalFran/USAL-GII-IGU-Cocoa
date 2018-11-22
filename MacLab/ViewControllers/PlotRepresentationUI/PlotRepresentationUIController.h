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
    
    Model * model;
    FunctionTableUIController * functionTableUIController;
}

/*----------------Notifications--------------*/
-(void) handleAddRepresentation:(NSNotification *)aNotification;
/*--------------Bussines logic-------------*/
-(void) addRepresentationWithFunctionArray: (NSArray *) aFunctionArray;
-(IBAction)exportProject:(id)sender;
-(IBAction)importProject:(id)sender;
@end

NS_ASSUME_NONNULL_END
