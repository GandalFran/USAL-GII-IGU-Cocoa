//
//  NSPlotView.m
//  MacLab
//
//  Created by GandalFran on 13/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "NSPlotView.h"

@interface NSPlotView(){
    struct{
        BOOL method1;
    } delegateRespondsTo;
    NSMutableDictionary * bezierPanelsToDraw;
}

@end

@implementation NSPlotView

-(id) initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(nil == self)
        return self;
    
    bezierPanelsToDraw = [[NSMutableDictionary alloc] init];
    
    delegateRespondsTo.method1 = [datasource respondsToSelector:@selector(example:)];
    //...
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
    //deletage drawing code in controller : args-> nsRect with bacround and NSGrahicContext (currentContext)
    
        //in the controller method
            //foeach funcion draw in crect with graptic context
                //calculs of each function in the power point
    
}

@end
