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

/*----------------------Initializers--------------------*/

-(id) initWithID : (int) ID
            name : (NSString *) name
           color : (NSColor *) color
         visible : (bool) visible
    FunctionType : (FunctionType) type
ExpressionAValue : (double) aValue
 ExpressionBValue: (double) bValue
 ExpressionCValue: (double) cValue
{
    
    self = [super init];
    if (!self)
        return nil;
    
    [self setID: ID];
    [self setName : name];
    [self setColor : color];
    [self setVisible : visible];
    [self setType : type];
    [self setAValue : aValue];
    [self setBValue : bValue];
    [self setCValue : cValue];
    
    return self;
}

-(id) initWithName : (NSString *) name
             color : (NSColor *) color
    ExpressionType : (FunctionType) type
  ExpressionAValue : (double) a
  ExpressionBValue : (double) b
   ExpressionCValue: (double) c
{
    return [self initWithID:0 name:name color:color visible:true FunctionType:type ExpressionAValue:a ExpressionBValue:b ExpressionCValue:c];
}

/*----------------------Bean basics--------------------*/

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

/*---------------------Bussines logic-------------------*/

-(double) calculateYValueWithXValue : (double) x
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
            result = a * pow(x,b);
            break;
        case LINE:
            result = (a * x) + b;
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

@end
