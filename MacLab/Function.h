//
//  Function.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "Cocoa/Cocoa.h"

NS_ASSUME_NONNULL_BEGIN

@interface Function : NSObject

@property (nonatomic) int _ID;
@property (nonatomic, copy) NSString * _name;
@property (nonatomic, copy) Expression * _expression;
@property (nonatomic, copy) NSColor * _color;
@property (nonatomic) bool _visible;


+(id)initWithID : (int) ID
           name : (NSString *) name
          color : (NSColor *) color
     Expression : (Expression *) expression
        visible : (bool) visible;

+(id) initWithID : (float) ID
            name : (NSString *) name
           color : (NSColor *) color
  ExpressionType : (FunctionType) type
ExpressionAValue : (float) aValue
ExpressionBValue : (float) bValue
ExpressionCValue : (float) cValue;

@end

NS_ASSUME_NONNULL_END
