//
//  NSPlotView.h
//  MacLab
//
//  Created by GandalFran on 13/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSPlotViewDataSource.h"
#import "NSPlotViewMouseEventsDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSPlotView :NSView{
    IBOutlet __weak id<NSPlotViewDataSource> _datasource;
    IBOutlet __weak id<NSPlotViewMouseEventsDelegate>  _mouseEventsDelegate;
}

//------------------Delegation---------------------
@property (nonatomic, weak) IBOutlet id<NSPlotViewDataSource> datasource;
@property (nonatomic, weak) IBOutlet id<NSPlotViewMouseEventsDelegate>  mouseEventsDelegate;

//----------------Bussines logic-------------------
-(void) setParameters:(NSRect) parameters;
-(void) reloadData;
-(void) resetZoom;

//----------------------IO-------------------------
-(BOOL) exportViewToPath:(NSString *) path;

@end

NS_ASSUME_NONNULL_END
