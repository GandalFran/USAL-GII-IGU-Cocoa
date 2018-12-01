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
- (NSRect) parameters;
- (NSInteger) numberOfElements;
- (void) plotView:(NSPlotView *)aPlotView drawElement:(NSInteger) element inRect:(NSRect)bounds withParameters:(NSRect)parameters withGraphicsContext:(NSGraphicsContext *)aGraphicContext;
@end

#endif /* NSPlotViewDataSource_h */
