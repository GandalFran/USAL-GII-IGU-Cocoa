//
//  NSPlotView.h
//  MacLab
//
//  Created by GandalFran on 13/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSPlotViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSPlotView :NSView

@property (nonatomic, weak) IBOutlet id<NSPlotViewDataSource>  datasource;

-(void) reloadData;
-(BOOL) exportViewToPath:(NSString *) path;

@end

NS_ASSUME_NONNULL_END
