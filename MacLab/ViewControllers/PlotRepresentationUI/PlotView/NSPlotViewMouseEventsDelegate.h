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
/**
 *  @brief advises that the mouse has entered in view plotView
 */
-(void)mouseEnteredInPlotView:(NSPlotView *) plotView;
/**
 *  @brief advises that the mouse is over the point x,y
 */
-(void)mouseMovedIntPlotView:(NSPlotView *) plotView AtX:(double)x Y:(double)y;
/**
 *  @brief advises that the mouse has leaved the view plotView
 */
-(void)mouseExitedInPlotView:(NSPlotView *) plotView;
@end

#endif /* NSPlotViewMouseEventsDelegate_h */
