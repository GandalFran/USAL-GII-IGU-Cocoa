//
//  Function.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "Function.h"
#import "Expression.h"

@implementation Function

@synthesize _ID, _name, _color, _expression, _visible;

-(id)initWithID : (int) ID name : (NSString *) name color : (NSColor *) color Expression : (Expression *) expression visible:(bool)visible{
    self = [super init];
    if (!self)
        return nil;
    
    [self set_ID: ID];
    [self set_name : name];
    [self set_color : color];
    [self set_expression : expression];
    [self set_visible : true];
    
    return self;
}

-(id) initWithID : (int) ID name : (NSString *) name color : (NSColor *) color ExpressionType : (FunctionType) type ExpressionAValue : (float) aValue ExpressionBValue : (float) bValue ExpressionCValue : (float) cValue {
    
    Expression * expressionInstance = nil;
    
    if(nil == (expressionInstance =  [Expression initWithFunctionType:type aValue:aValue bValue:bValue cValue:cValue] ) )
        return nil;
        
    return [self initWithID:ID name:name color:color Expression:expressionInstance visible:true]
}


-(NSString *) description{
    NSString * toString = nil;
    toString = [[NSString alloc] initWithFormat: @"{(%d), name=%@, color=%@, expression=%@, visbility=%d}",self._ID,self._name, self._color, self._expression, self._visible];
    return toString;
}

-(BOOL) isEqual:(id)object{
    if(NULL == object || nil == object){
        return false;
    } else if( ![object isKindOfClass:[ Function class] ]){
        return false;
    }else{
        Function f = object;
        if(f._ID == self._ID)
            return true;
        else
            return false;
    }
}

@end
