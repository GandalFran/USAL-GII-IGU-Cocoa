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
        unsigned int parameters;
        unsigned int numberOfElements;
        unsigned int plotViewDrawElementInRectWithGraphicsContext;
    } delegateRespondsTo;
}

-(void)drawAxysInBounds:(NSRect)boudns withParameters:(NSRect)parameters withGraphicsContext:(NSGraphicsContext*)aGraphicsContext;
@end

@implementation NSPlotView

-(id) initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(nil == self)
        return self;
    
    return self;
}

@synthesize datasource;
- (void)setDatasource:(id)aDatasource{
    if (datasource != aDatasource){
        datasource = aDatasource;
    }
    if(nil != datasource){
        delegateRespondsTo.numberOfElements = [datasource respondsToSelector:@selector(numberOfElements)];
        delegateRespondsTo.parameters = [datasource respondsToSelector:@selector(parameters)];
        delegateRespondsTo.plotViewDrawElementInRectWithGraphicsContext = [datasource respondsToSelector:@selector(plotView:drawElement:inBoudns:withParameters:withGraphicsContext:)];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    int element;
    NSRect bounds, p;
    NSInteger numberOfElements = 0;
    NSGraphicsContext * graphicsContext = nil;
    
    [super drawRect:dirtyRect];
    
    bounds = [self bounds];
    
    graphicsContext = [NSGraphicsContext currentContext];
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:bounds];
    
    if(delegateRespondsTo.parameters)
        p = [datasource parameters];
    
    if(delegateRespondsTo.numberOfElements)
        numberOfElements = [datasource numberOfElements];

    [self drawAxysInBounds:bounds withParameters:p withGraphicsContext:graphicsContext];
    
    if(delegateRespondsTo.plotViewDrawElementInRectWithGraphicsContext){
        for(element = 0; element<numberOfElements; element++){
            [datasource plotView:self drawElement:element inBoudns:bounds withParameters:p withGraphicsContext:graphicsContext];
        }
    }
    
}

-(void) reloadData{
    [self setNeedsDisplay:YES];
}

//https://mountandcode.wordpress.com/2010/12/08/export-nsview-to-png/
-(BOOL) exportViewToPath:(NSString *) path{
    NSData * binaryData = nil;
    NSBitmapImageRep * bitmapImage = nil;
    
    [self lockFocus];
    bitmapImage = [self bitmapImageRepForCachingDisplayInRect:[self bounds]];
    [self cacheDisplayInRect:[self bounds] toBitmapImageRep:bitmapImage];
    [self unlockFocus];
    
    binaryData = [bitmapImage representationUsingType:NSPNGFileType properties:nil];
    return [binaryData writeToFile:path atomically:NO];
}

-(void)drawAxysInBounds:(NSRect)bounds withParameters:(NSRect)parameters withGraphicsContext:(NSGraphicsContext*)aGraphicsContext{
    NSPoint aPoint;
    NSBezierPath * bezier = nil;
    NSAffineTransform * tf = nil;
    
    [aGraphicsContext saveGraphicsState];
    
    tf = [NSAffineTransform transform];
    [tf scaleXBy:bounds.size.width/parameters.size.width yBy:bounds.size.height/parameters.size.height];
    [tf translateXBy: -parameters.origin.x yBy:-parameters.origin.y];
    [tf concat];
    
    bezier = [[NSBezierPath alloc] init];
    
    //x axys
    aPoint.y = 0;
    aPoint.x = parameters.origin.x;
    [bezier moveToPoint:aPoint];
    aPoint.x = parameters.origin.x + parameters.size.width;
    [bezier lineToPoint:aPoint];
    
    //y axys
    aPoint.x = 0;
    aPoint.y = parameters.origin.y;
    [bezier moveToPoint:aPoint];
    aPoint.y = parameters.origin.y + parameters.size.height;
    [bezier lineToPoint:aPoint];
    
    [bezier setLineWidth:0.05];
    [[NSColor blackColor] setStroke];
    [bezier stroke];
    
    [aGraphicsContext restoreGraphicsState];
}


@end
