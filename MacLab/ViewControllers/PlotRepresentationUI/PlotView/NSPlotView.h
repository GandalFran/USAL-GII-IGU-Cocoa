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

@interface NSPlotView :NSView

@property (nonatomic, weak) IBOutlet id<NSPlotViewDataSource>  datasource;
@property (nonatomic, weak) IBOutlet id<NSPlotViewMouseEventsDelegate>  mouseEventsDelegate;

-(void) reloadData;
-(void) resetZoom;
-(void) setParameters:(NSRect) parameters;
-(BOOL) exportViewToPath:(NSString *) path;

@end

NS_ASSUME_NONNULL_END
