//
//  PlotRepresentationUIController.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NSPlotView;
@class Model;

NS_ASSUME_NONNULL_BEGIN

@interface PlotRepresentationUIController : NSWindowController <NSWindowDelegate>{
    IBOutlet NSPlotView * plotView;
    
    Model * model;
}

-(void) handleTerminateApplication:(NSNotification *)aNotification;
@end

NS_ASSUME_NONNULL_END
