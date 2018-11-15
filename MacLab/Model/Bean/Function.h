//
//  Function.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{COSINE, SINE, EXPONENTIAL, LINE, PARABOLA, HIPERBOLA, NONE_TYPE} FunctionType;

@interface Function : NSObject <NSCopying>{
    int _ID;
    NSString * _name;
    NSColor * _color;
    bool _visible;
    FunctionType _type;
    double _aValue;
    double _bValue;
    double _cValue;
}

@property (nonatomic) int ID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSColor * color;
@property (nonatomic) bool visible;
@property (nonatomic) FunctionType type;
@property (nonatomic) double aValue;
@property (nonatomic) double bValue;
@property (nonatomic) double cValue;

-(id) initWithID : (int) ID
            name : (NSString *) name
           color : (NSColor *) color
         visible : (bool) visible
    FunctionType : (FunctionType) type
ExpressionAValue : (double) aValue
 ExpressionBValue: (double) bValue
 ExpressionCValue: (double) cValue;

-(id) initWithName : (NSString *) name
            color : (NSColor *) color
   ExpressionType : (FunctionType) type
 ExpressionAValue : (double) a
 ExpressionBValue : (double) b
 ExpressionCValue : (double) c;

-(double) calculateYValueWithXValue : (double) x;

@end

NS_ASSUME_NONNULL_END
