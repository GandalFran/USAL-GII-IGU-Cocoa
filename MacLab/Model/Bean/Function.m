//
//  Function.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "Function.h"

@implementation Function

@synthesize ID=_ID, name=_name, color=_color, visible=_visible, type=_type, aValue=_aValue, bValue=_bValue, cValue=_cValue;

//----------------Initializers---------------------

-(id) initWithID : (int) ID
            name : (NSString *) aName
           color : (NSColor *) aColor
         visible : (bool) aVisible
    FunctionType : (FunctionType) aType
ExpressionAValue : (double) aValue
 ExpressionBValue: (double) bValue
 ExpressionCValue: (double) cValue
{
    
    self = [super init];
    if (!self)
        return nil;
    
    [self setID: ID];
    [self setName : aName];
    [self setColor : aColor];
    [self setVisible : aVisible];
    [self setType : aType];
    [self setAValue : aValue];
    [self setBValue : bValue];
    [self setCValue : cValue];
    
    return self;
}

-(id) initWithName : (NSString *) aName
             color : (NSColor *) aColor
    ExpressionType : (FunctionType) aType
  ExpressionAValue : (double) aValue
  ExpressionBValue : (double) bValue
   ExpressionCValue: (double) cValue
{
    return [self initWithID:0
                       name:aName
                      color:aColor
                    visible:true
               FunctionType:aType
           ExpressionAValue:aValue
           ExpressionBValue:bValue
           ExpressionCValue:cValue];
}

//-------------NSObject hierarchy------------------

-(NSString *) description
{
    return [[NSString alloc] initWithFormat: @"Function{ID=%d, name=%@, color=%@, visbility=%d, type=%d, aValue=%f, bValue=%f, cValue=%f,  }",self.ID,self.name, self.color, self.visible, self.type,self.aValue,self.bValue,self.cValue];
}

-(BOOL) isEqual:(id)object
{
    if(NULL == object || nil == object){
        return false;
    } else if( ![object isKindOfClass:[ Function class] ]){
        return false;
    }else{
        Function * f = object;
        return ( [f ID] == self.ID );
    }
}

- (id) copy
{
    Function * f = nil;
    
    f = [[Function alloc] init];
    
    [f setID: self.ID];
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
    
    [f setID: self.ID];
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
 *  @param aXValue x value to calculate the respective y value
 *  @return the y value for the xvalue in the function
 */
-(double) calculateYValueWithXValue : (double) aXValue
{
    double result, a, b, c;
    
    a =  self.aValue;
    b =  self.bValue;
    c =  self.cValue;
    
    switch(self.type){
        case COSINE:
            result =  a * cos( b * aXValue );
            break;
        case SINE:
            result = a * sin( b * aXValue );
            break;
        case EXPONENTIAL:
            result = a * pow(aXValue,b);
            break;
        case LINE:
            result = a + (b * aXValue);
            break;
        case PARABOLA:
            result =  (a*aXValue*aXValue) + (b*aXValue) + c;
            break;
        case HIPERBOLA:
            result = a / (b * aXValue);
            break;
        default:
            result = 0;
    }
    
    return result;
}

/**
 *  @brief returns a string with the expression which defines the function
 */
-(NSString *) expressionStringValue{
    NSString * expressionString = nil;
    
    switch([self type]){
        case COSINE:
            expressionString =  [[NSString alloc] initWithFormat:@"%.2f*cos(%.2f*x)",[self aValue],[self bValue]];
            break;
        case SINE:
            expressionString =  [[NSString alloc] initWithFormat:@"%.2f*sin(%.2f*x)",[self aValue],[self bValue]];
            break;
        case EXPONENTIAL:
            expressionString =  [[NSString alloc] initWithFormat:@"%.2f*x^%.2f",[self aValue],[self bValue]];
            break;
        case LINE:
            expressionString =  [[NSString alloc] initWithFormat:@"%.2f*x + %.2f",[self aValue],[self bValue]];
            break;
        case PARABOLA:
            expressionString =  [[NSString alloc] initWithFormat:@"%.2f*x^2 + %.2f*x + %.2f)",[self aValue],[self bValue],[self cValue]];
            break;
        case HIPERBOLA:
            expressionString =  [[NSString alloc] initWithFormat:@"%.2f*/(%.2f*x)",[self aValue],[self bValue]];
            break;
        default:
            expressionString = nil;
    }
    
    return expressionString;
}

+ (NSArray *) functionTypeAsStringValues{
    return [[NSArray alloc] initWithObjects:@"a*cos(b*x)", @"a*sin(b*x)",@"a*x^b",@"a+ x*b",@"a*x^2 + b*x + c",@"a/(b*x)",@"",nil];
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
             ExpressionCValue:[decoder decodeDoubleForKey:@"cValue"]];
}

@end
