//
//  PlotRepresentationUIController.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSPlotViewDataSource.h"
#import "NSPlotViewMouseEventsDelegate.h"

@class NSPlotView;

NS_ASSUME_NONNULL_BEGIN

@interface PlotRepresentationUIController : NSObject <NSWindowDelegate, NSPlotViewDataSource, NSPlotViewMouseEventsDelegate>{
    IBOutlet NSPlotView * plotView;
    IBOutlet NSTextField * coordinatesLabel;
}

//----------------Notifications--------------------
-(void) handleReloadRepresentation:(NSNotification *)aNotification;
-(void) handleAddNewParameters:(NSNotification *)aNotification;
//----------------Graphic logic--------------------
-(IBAction)exportProject:(id)sender;
-(IBAction)importProject:(id)sender;
-(IBAction)exportPanel:(id)sender;
-(IBAction)resetZoom:(id)sender;

@end

NS_ASSUME_NONNULL_END
