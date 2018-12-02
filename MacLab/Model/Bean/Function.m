//
//  Function.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <math.h>
#import "Function.h"
#define HOPS 500

@implementation Function

@synthesize name=_name, color=_color, type=_type, aValue=_aValue, bValue=_bValue, cValue=_cValue, visible=_visible;

+ (NSArray *) functionTypeAsStringValues{
    return [[NSArray alloc] initWithObjects:@"a*cos(b*x)", @"a*sin(b*x)",@"a*x^b",@"a+ x*b",@"a*x^2 + b*x + c",@"a/(b*x)",@"",nil];
}

//----------------Initializers---------------------

-(id) initWithName : (NSString *) aName
             color : (NSColor *) aColor
    ExpressionType : (FunctionType) aType
  ExpressionAValue : (double) aValue
  ExpressionBValue : (double) bValue
  ExpressionCValue : (double) cValue
           visible : (bool) aVisible{
    self = [super init];
    if (!self)
        return nil;
    
    [self setName : aName];
    [self setColor : aColor];
    [self setType : aType];
    [self setAValue : aValue];
    [self setBValue : bValue];
    [self setCValue : cValue];
    [self setVisible: aVisible];
    
    return self;
}

-(id) initWithName : (NSString *) aName
             color : (NSColor *) aColor
    ExpressionType : (FunctionType) aType
  ExpressionAValue : (double) aValue
  ExpressionBValue : (double) bValue
   ExpressionCValue: (double) cValue
{
    return [self initWithName:aName
                        color:aColor
               ExpressionType:aType
             ExpressionAValue:aValue
             ExpressionBValue:bValue
             ExpressionCValue:cValue
                      visible:true
            ];
}

//-------------NSObject hierarchy------------------

-(NSString *) description
{
    return [[NSString alloc] initWithFormat: @"Function{name=%@, color=%@, visbility=%d, type=%d, aValue=%f, bValue=%f, cValue=%f,  }",self.name, self.color, self.visible, self.type,self.aValue,self.bValue,self.cValue];
}

-(BOOL) isEqual:(id)object
{
    if(NULL == object || nil == object){
        return false;
    } else if( ![object isKindOfClass:[ Function class] ]){
        return false;
    }else{
        Function * f = object;
        return ( [[f name] isEqual: [self name]]
                && [[f color] isEqual:[self color]]
                && [f type] == [self type]
                && [f aValue] == [self aValue]
                && [f bValue] == [self bValue]
                && [f cValue] == [self cValue]
                && [f visible] == [self visible]
                );
    }
}

- (id) copy
{
    Function * f = nil;
    
    f = [[Function alloc] init];
    
    [f setName : [self.name copy] ];
    [f setColor : [self.color copy] ];
    [f setVisible : self.visible];
    [f setType : self.type];
    [f setAValue : self.aValue];
    [f setBValue : self.bValue];
    [f setCValue : self.cValue];
    
    return f;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    Function * f = nil;
    
    f = [[Function alloc] init];
    
    [f setName : [self.name copy] ];
    [f setColor : [self.color copy] ];
    [f setVisible : self.visible];
    [f setType : self.type];
    [f setAValue : self.aValue];
    [f setBValue : self.bValue];
    [f setCValue : self.cValue];
    
    return f;
}

//----------------Bussines logic-------------------

/**
 *  @brief calculates the y value for a x value
 *  @param x value to calculate the respective y value
 *  @return the y value for the xvalue in the function
 */
-(double) valueAt : (double) x
{
    double result, a, b, c;
    
    a =  self.aValue;
    b =  self.bValue;
    c =  self.cValue;
    
    switch(self.type){
        case COSINE:
            result =  a * cos( b * x );
            break;
        case SINE:
            result = a * sin( b * x );
            break;
        case EXPONENTIAL:
            result = a* pow(x,b);
            break;
        case LINE:
            result = a + (b * x);
            break;
        case PARABOLA:
            result =  (a*x*x) + (b*x) + c;
            break;
        case HIPERBOLA:
            result = a / (b * x);
            break;
        default:
            result = 0;
    }
    
    return result;
}

-(void) drawInBounds:(NSRect) bounds withParameters:(NSRect) parameters withGraphicsContext:(NSGraphicsContext *) aGraphicContext{
    double distance;
    double lastY;
    NSPoint aPoint;
    NSAffineTransform *tf = nil;
    NSBezierPath * bezier = nil;
    
    if([self visible]){
        [aGraphicContext saveGraphicsState];
        
        tf = [NSAffineTransform transform];
        [tf scaleXBy:bounds.size.width/parameters.size.width yBy:bounds.size.height/parameters.size.height];
        [tf translateXBy: -parameters.origin.x yBy:-parameters.origin.y];
        [tf concat];
        
        bezier = [[NSBezierPath alloc] init];
        distance = parameters.size.width/HOPS;
        
        if([self type] == EXPONENTIAL && parameters.origin.x<0 && ([self bValue] - (int)[self bValue])!=0){
            aPoint.x = 0;
            aPoint.y = [self valueAt:0];
        }else{
            aPoint.x = parameters.origin.x;
            aPoint.y = [self valueAt:aPoint.x];
        }
        
        [bezier moveToPoint:aPoint];
        
        lastY = aPoint.y;
        while (aPoint.x <= parameters.origin.x + parameters.size.width)
        {
            aPoint.y = [self valueAt:aPoint.x];
            
            if([self type] == HIPERBOLA && ( lastY<parameters.origin.y || lastY>(parameters.size.height-parameters.origin.y) ) )
                [bezier moveToPoint:aPoint];
            else
                [bezier lineToPoint:aPoint];

            aPoint.x += distance;
            lastY = aPoint.y;
        }
        
        [bezier setLineWidth:0.05];
        [self.color setStroke];
        [bezier stroke];
        [aGraphicContext restoreGraphicsState];
    }
}

//----------------------IO-------------------------

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self name] forKey:@"name"];
    [encoder encodeObject:[self color] forKey:@"color"];
    [encoder encodeBool:[self visible] forKey:@"visible"];
    [encoder encodeInt:[self type] forKey:@"type"];
    [encoder encodeDouble:[self aValue] forKey:@"aValue"];
    [encoder encodeDouble:[self bValue] forKey:@"bValue"];
    [encoder encodeDouble:[self cValue] forKey:@"cValue"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    return [self initWithName:[decoder decodeObjectForKey:@"name"]
                        color:[decoder decodeObjectForKey:@"color"]
               ExpressionType:(FunctionType)[decoder decodeIntForKey:@"type"]
             ExpressionAValue:[decoder decodeDoubleForKey:@"aValue"]
             ExpressionBValue:[decoder decodeDoubleForKey:@"bValue"]
             ExpressionCValue:[decoder decodeDoubleForKey:@"cValue"]
                      visible:[decoder decodeBoolForKey:@"visible"]
            ];
}

@end
