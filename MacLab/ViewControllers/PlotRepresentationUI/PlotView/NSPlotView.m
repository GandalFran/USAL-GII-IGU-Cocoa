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
    if (datasource != aDatasource) {NSLog(@"2asdf");
        datasource = aDatasource;
    }
    NSLog(@"asdf");
    if(nil != datasource){NSLog(@"3asdf");
        delegateRespondsTo.numberOfElements = [datasource respondsToSelector:@selector(numberOfElements)];
        delegateRespondsTo.parameters = [datasource respondsToSelector:@selector(parameters)];
        delegateRespondsTo.plotViewDrawElementInRectWithGraphicsContext = [datasource respondsToSelector:@selector(plotView:drawElement:inRect:withParameters:withGraphicsContext:)];
    }
    NSLog(@"%d %d %d",delegateRespondsTo.numberOfElements,delegateRespondsTo.parameters,delegateRespondsTo.plotViewDrawElementInRectWithGraphicsContext);
}

- (void)drawRect:(NSRect)dirtyRect {
    int element;
    NSRect bounds, parameters;
    NSInteger numberOfElements = 0;
    NSGraphicsContext * graphicsContext = nil;
    
    [super drawRect:dirtyRect];
    
    bounds = [self bounds];
    
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:bounds];
    
    
    if(delegateRespondsTo.parameters)
        parameters = [datasource parameters];
    
    if(delegateRespondsTo.numberOfElements)
        numberOfElements = [datasource numberOfElements];
    
    if(delegateRespondsTo.plotViewDrawElementInRectWithGraphicsContext){
        [graphicsContext saveGraphicsState]; //stored for security reasons
        for(element = 0; element<numberOfElements; element++){
            [datasource plotView:self drawElement:element inRect:bounds withParameters:parameters withGraphicsContext:[NSGraphicsContext currentContext]];
        }
        [graphicsContext restoreGraphicsState];
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


@end
