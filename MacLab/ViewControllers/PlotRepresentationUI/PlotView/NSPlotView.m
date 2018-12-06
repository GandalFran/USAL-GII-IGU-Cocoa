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
    } datasourceRespondsTo;
    struct{
        unsigned int mouseEntered;
        unsigned int mouseMovedAtXY;
        unsigned int mouseExited;
    }mouseEventsDelegateRespondsTo;
    bool isZoomActive;
    NSRect parameters, zoomParameters;
    NSPoint mouseDownPoint, mouseUpPoint;
    NSTrackingArea * trackingArea;
}
    //----------------Graphic logic--------------------
    -(void) drawAxysInBounds:(NSRect)bounds withParameters:(NSRect)parameters withGraphicsContext:(NSGraphicsContext*)aGraphicsContext;
@end

@implementation NSPlotView

//----------------Initializers---------------------
-(id) initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(nil == self)
        return self;
    
    isZoomActive = NO;
    parameters.origin.x = parameters.origin.y = -10;
    zoomParameters.origin.x = zoomParameters.origin.y = -10;
    parameters.size.width = parameters.size.height = 20;
    zoomParameters.size.width = zoomParameters.size.height = 20;

    return self;
}

//------------------Delegation---------------------
@synthesize datasource=_datasource, mouseEventsDelegate=_mouseEventsDelegate;

- (void)setDatasource:(id)aDatasource{
    if (_datasource != aDatasource){
        _datasource = aDatasource;
    }
    if(nil != _datasource){
        datasourceRespondsTo.numberOfElements = [_datasource respondsToSelector:@selector(numberOfElements)];
        datasourceRespondsTo.plotViewDrawElementInRectWithGraphicsContext = [_datasource respondsToSelector:@selector(plotView:drawElement:inBoudns:withParameters:withGraphicsContext:)];
    }

}

-(void)setMouseEventsDelegate:(id<NSPlotViewMouseEventsDelegate>)aDelegate{
    if (_mouseEventsDelegate != aDelegate){
        _mouseEventsDelegate = aDelegate;
    }
    if(nil != _mouseEventsDelegate){
        mouseEventsDelegateRespondsTo.mouseEntered = [_mouseEventsDelegate respondsToSelector:@selector(mouseEnteredInPlotView:)];
        mouseEventsDelegateRespondsTo.mouseExited = [_mouseEventsDelegate respondsToSelector:@selector(mouseEnteredInPlotView:)];
        mouseEventsDelegateRespondsTo.mouseMovedAtXY = [_mouseEventsDelegate respondsToSelector:@selector(mouseMovedIntPlotView:AtX:Y:)];
    }
}

/**
 *  @brief advise the delgate to draw N functions
 */
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
    
    p = (isZoomActive == YES) ? zoomParameters : parameters;
    
    if(datasourceRespondsTo.numberOfElements)
        numberOfElements = [_datasource numberOfElements];

    [self drawAxysInBounds:bounds withParameters:p withGraphicsContext:graphicsContext];
    
    if(datasourceRespondsTo.plotViewDrawElementInRectWithGraphicsContext){
        for(element = 0; element<numberOfElements; element++){
            [_datasource plotView:self drawElement:element inBoudns:bounds withParameters:p withGraphicsContext:graphicsContext];
        }
    }
    
}

//----------------Bussines logic-------------------

/**
 *  @brief set new representation boudns and save zoom
 */
-(void) setParameters:(NSRect) p{
    isZoomActive = NO;
    parameters = p;
    [self setNeedsDisplay:YES];
}

/**
 *  @brief reload the view
 */
-(void) reloadData{
    [self setNeedsDisplay:YES];
}

/**
 *  @brief reset zoom and reload the view
 */
-(void) resetZoom{
    isZoomActive = NO;
    [self setNeedsDisplay:YES];
}

//----------------Graphic logic--------------------

/**
 *  @brief draw axys in the view
 */
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

//----------------Mouse events gestion--------------------

/**
 *  @brief to accept the mouse events
 */
-(BOOL) acceptsFirstResponder{
    return YES;
}

/**
 *  @brief to refresh the tracking area and know the position of the mouse over the view
 *  @see https://stackoverflow.com/questions/11188034/mouseentered-and-mouseexited-not-called-in-nsimageview-subclass
 *     and https://stackoverflow.com/questions/7543684/mousemoved-not-called
 */
-(void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if(trackingArea != nil) {
        [self removeTrackingArea:trackingArea];
        trackingArea = nil;
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveAlways);
    trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:trackingArea];
}

/**
 *  @brief save the point where the user pushed the mouse
 */
-(void) mouseDown:(NSEvent *)event{
    mouseDownPoint = [self convertPoint:[event locationInWindow] fromView:nil];
}

/**
 *  @brief save the point where the user lifted the mouse, and set
 *      the zoom to the area delimited by the mouseDownPoint and
 *      the mouseUpPoint.
 */
-(void) mouseUp:(NSEvent *)event{
    
    NSRect p;
    NSAffineTransform * tf = nil;
    double nXmin, nXmax, nYmin, nYmax;
    
    mouseUpPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    
    //if the start and end of some dimension are the same exit because isn't any zoom
    if(mouseUpPoint.x == mouseDownPoint.x || mouseUpPoint.y == mouseDownPoint.y)
        return;
    //if some point isn't in the view exit because the user has made a bad use of the zoom
    if(mouseUpPoint.x < self.bounds.origin.x || mouseUpPoint.x > self.bounds.size.width
       || mouseDownPoint.x < self.bounds.origin.x || mouseDownPoint.x > self.bounds.size.width
       || mouseUpPoint.y < self.bounds.origin.y || mouseUpPoint.y > self.bounds.size.height
       || mouseDownPoint.y < self.bounds.origin.y || mouseDownPoint.y > self.bounds.size.height)
        return;
    
    
    p = (isZoomActive) ? zoomParameters : parameters;
    
    tf = [NSAffineTransform transform];
    [tf scaleXBy:self.bounds.size.width/p.size.width yBy:self.bounds.size.height/p.size.height];
    [tf translateXBy: -p.origin.x yBy:-p.origin.y];
    [tf invert];
    mouseDownPoint = [tf transformPoint:mouseDownPoint];
    mouseUpPoint = [tf transformPoint:mouseUpPoint];
    
    nXmin = (mouseDownPoint.x < mouseUpPoint.x) ? mouseDownPoint.x : mouseUpPoint.x;
    nXmax = (mouseDownPoint.x > mouseUpPoint.x) ? mouseDownPoint.x : mouseUpPoint.x;
    nYmin = (mouseDownPoint.y < mouseUpPoint.y) ? mouseDownPoint.y : mouseUpPoint.y;
    nYmax = (mouseDownPoint.y > mouseUpPoint.y) ? mouseDownPoint.y : mouseUpPoint.y;
    
    zoomParameters.origin.x = nXmin;
    zoomParameters.origin.y = nYmin;
    zoomParameters.size.width = nXmax - nXmin;
    zoomParameters.size.height = nYmax - nYmin;
    
    isZoomActive = YES;
    
    [self setNeedsDisplay:YES];
}

/**
 *  @brief advise the delegate that mouse has entered in vew
 */
-(void) mouseEntered:(NSEvent *)event{
    if(mouseEventsDelegateRespondsTo.mouseEntered)
        [_mouseEventsDelegate mouseEnteredInPlotView:self];
}

/**
 *  @brief advise the delegate the position where the mouse is on
 */
-(void)mouseMoved:(NSEvent *)event{
    NSPoint aPoint;
    NSRect p;
    NSAffineTransform * tf = nil;
    if(mouseEventsDelegateRespondsTo.mouseMovedAtXY){
        aPoint = [self convertPoint:[event locationInWindow] fromView:nil];
        
        p = (isZoomActive) ? zoomParameters : parameters;
        
        tf = [NSAffineTransform transform];
        [tf scaleXBy:self.bounds.size.width/p.size.width yBy:self.bounds.size.height/p.size.height];
        [tf translateXBy: -p.origin.x yBy:-p.origin.y];
        [tf invert];
        aPoint = [tf transformPoint:aPoint];
        
        [_mouseEventsDelegate mouseMovedIntPlotView:self AtX:aPoint.x Y:aPoint.y];
    }
}

/**
 *  @brief advise the delegate the mouse has leaved the view
 */
-(void)mouseExited:(NSEvent *)event{
    if(mouseEventsDelegateRespondsTo.mouseExited)
        [_mouseEventsDelegate mouseExitedInPlotView:self];
}

//----------------------IO-------------------------

/**
 *  @brief export view to png
 *  @see https://mountandcode.wordpress.com/2010/12/08/export-nsview-to-png/
 */
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
