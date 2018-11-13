//
//  Function.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSFunctionExpression.h"
#import "Cocoa/Cocoa.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSFunction : NSObject{
    int _ID;
    NSString * _name;
    NSFunctionExpression * _expression;
    NSColor * _color;
    bool _visible;
}

@property (nonatomic) int ID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSFunctionExpression * expression;
@property (nonatomic, copy) NSColor * color;
@property (nonatomic) bool visible;


-(id)initWithID : (int) ID
           name : (NSString *) name
          color : (NSColor *) color
     Expression : (NSFunctionExpression *) expression
        visible : (bool) visible;

-(id) initWithID : (int) ID
            name : (NSString *) name
           color : (NSColor *) color
  ExpressionType : (FunctionType) type
ExpressionAValue : (double) a
ExpressionBValue : (double) b
ExpressionCValue : (double) c;

-(id) initWithID : (int) ID
            name : (NSString *) name
           color : (NSColor *) color
  ExpressionType : (FunctionType) type
ExpressionAValue : (double) a
ExpressionBValue : (double) b;

@end

NS_ASSUME_NONNULL_END
