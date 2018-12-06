//
//  NSPlotViewDataSource.h
//  MacLab
//
//  Created by alumno5 on 30/11/18.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#ifndef NSPlotViewDataSource_h
#define NSPlotViewDataSource_h

@class NSPlotView;

@protocol NSPlotViewDataSource <NSObject>
@optional
/**
 *  @brief requests for the number of elements to represent
 */
- (NSInteger) numberOfElements;
/**
 *  @brief asks that the element in the element index be represented.
 */
- (void) plotView:(NSPlotView *)aPlotView drawElement:(NSInteger) element inBoudns:(NSRect)bounds withParameters:(NSRect)parameters withGraphicsContext:(NSGraphicsContext *)aGraphicContext;
@end

#endif /* NSPlotViewDataSource_h */
