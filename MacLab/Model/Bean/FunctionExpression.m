//
//  Expression.m
//  MacLab
//
//  Created by GandalFran on 11/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "FunctionExpression.h"
#import <math.h>

@implementation FunctionExpression
@synthesize type=_type, aValue=_aValue, bValue=_bValue, cValue=_cValue;

-(id) initWithFunctionType : (FunctionType) type aValue : (double) a bValue : (double) b cValue : (double) c{
    self = [super init];
    if (!self)
        return nil;
    
    [self setType: type];
    [self setAValue: a];
    [self setBValue: b];
    [self setCValue: c];
    
    return self;
}

-(NSString *) description{
    NSString * toString = nil;
    toString = [[NSString alloc] initWithFormat: @"Expression{type=%u, aValue=%f, bValue=%f, cValue=%f}",self.type,self.aValue,self.bValue,self.cValue];
    return toString;
}

-(BOOL) isEqual:(id)object{
    if(NULL == object || nil == object){
        return false;
    } else if(![object isKindOfClass:[FunctionExpression class]]){
        return false;
    }else{
        FunctionExpression * e = object;
        return ( self.type == e.type
                && self.aValue == e.aValue
                && self.bValue == e.bValue
                && self.cValue == e.cValue);
    }
}

-(double) calculateYValueWithXValue : (double) x{
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
