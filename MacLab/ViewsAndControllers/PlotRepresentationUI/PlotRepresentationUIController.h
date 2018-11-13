//
//  PlotRepresentationUIController.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSPlotView;

NS_ASSUME_NONNULL_BEGIN

@interface PlotRepresentationUIController : NSObject{
    IBOutlet NSPlotView * plotView;
}

@end

NS_ASSUME_NONNULL_END
