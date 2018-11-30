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

@interface NSPlotView :NSView{
    IBOutlet __weak id <NSPlotViewDataSource> datasource;
}

@end

NS_ASSUME_NONNULL_END
