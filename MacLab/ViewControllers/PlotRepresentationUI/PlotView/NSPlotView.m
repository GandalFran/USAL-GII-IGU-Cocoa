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
        unsigned int numberOfElements;
        unsigned int plotViewDrawElementInRectWithGraphicsContext;
    } delegateRespondsTo;
}

@end

@implementation NSPlotView

@synthesize datasource;

-(id) initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(nil == self)
        return self;
    
    return self;
}

- (void)setDatasource:(id)aDatasource{
    if (datasource != aDatasource) {
        datasource = aDatasource;
    }
    if(nil != datasource){
        delegateRespondsTo.numberOfElements = [datasource respondsToSelector:@selector(numberOfElements)];
        delegateRespondsTo.plotViewDrawElementInRectWithGraphicsContext = [datasource respondsToSelector:@selector(plotView:drawElement:inRect:withGraphicsContext:)];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect bounds = [self bounds];
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:bounds];
    
    int element;
    NSInteger numberOfElements = 0;

    if(delegateRespondsTo.numberOfElements)
        numberOfElements = [datasource numberOfElements];
    if(delegateRespondsTo.plotViewDrawElementInRectWithGraphicsContext){
        for(element = 0; element<numberOfElements; element++){
            [datasource plotView:self drawElement:element inRect:bounds withGraphicsContext:[NSGraphicsContext currentContext]];
        }
    }
    
    // Drawing code here.
    //deletage drawing code in controller : args-> nsRect with bacround and NSGrahicContext (currentContext)
        //in the controller method
            //foeach funcion draw in crect with graptic context
                //calculs of each function in the power point
    
    NSInteger ox,oy;
    float width, height;
    
    ox = bounds.origin.x;
    oy = bounds.origin.y;
    width = bounds.size.width;
    height = bounds.size.height;
}

-(void) reloadData{
    NSLog(@"reloading data");
    [self setNeedsDisplay:YES];
}


@end
