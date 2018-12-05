//
//  NSPlotViewMouseEventsDelegate.h
//  MacLab
//
//  Created by GandalFran on 05/12/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#ifndef NSPlotViewMouseEventsDelegate_h
#define NSPlotViewMouseEventsDelegate_h
@class NSPlotView;

@protocol NSPlotViewMouseEventsDelegate <NSObject>
@optional

-(void)mouseEnteredInPlotView:(NSPlotView *) plotView;
-(void)mouseMovedIntPlotView:(NSPlotView *) plotView AtX:(double)x Y:(double)y;
-(void)mouseExitedInPlotView:(NSPlotView *) plotView;
@end

#endif /* NSPlotViewMouseEventsDelegate_h */
