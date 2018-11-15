//
//  Function.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "Function.h"
#import "FunctionExpression.h"

@implementation Function

@synthesize ID=_ID, name=_name, color=_color, expression=_expression, visible=_visible;

-(id)initWithID : (int) ID name : (NSString *) name color : (NSColor *) color Expression : (FunctionExpression *) expression visible:(bool)visible{
    self = [super init];
    if (!self)
        return nil;
    
    [self setID: ID];
    [self setName : name];
    [self setColor : color];
    [self setExpression : expression];
    [self setVisible : visible];
    
    return self;
}

-(id) initWithID : (int) ID name : (NSString *) name color : (NSColor *) color ExpressionType : (FunctionType) type ExpressionAValue : (double) a ExpressionBValue : (double) b ExpressionCValue : (double) c {
    
    FunctionExpression * expressionInstance = nil;
    
    if(nil == (expressionInstance =  [[FunctionExpression alloc] initWithFunctionType:type aValue:a bValue:b cValue:c] ) )
        return nil;
        
    return [self initWithID:ID name:name color:color Expression:expressionInstance visible:true];
}

-(id) initWithID : (int) ID name : (NSString *) name color : (NSColor *) color ExpressionType : (FunctionType) type ExpressionAValue : (double) a ExpressionBValue : (double) b{
    return [self initWithID:ID name:name color:color ExpressionType:type ExpressionAValue:a ExpressionBValue:b];
}

-(NSString *) description{
    NSString * toString = nil;
    toString = [[NSString alloc] initWithFormat: @"Function{ID=%d, name=%@, color=%@, expression=%@, visbility=%d}",self.ID,self.name, self.color, self.expression, self.visible];
    return toString;
}

-(BOOL) isEqual:(id)object{
    if(NULL == object || nil == object){
        return false;
    } else if( ![object isKindOfClass:[ Function class] ]){
        return false;
    }else{
        Function * f = object;
        return ( [f ID] == self.ID );
    }
}

@end
