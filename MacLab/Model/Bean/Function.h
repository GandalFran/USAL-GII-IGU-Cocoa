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

@interface Function : NSObject <NSCopying, NSCoding>{
    NSString * _name;
    NSColor * _color;
    FunctionType _type;
    double _aValue;
    double _bValue;
    double _cValue;
    bool _visible;
}

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSColor * color;
@property (nonatomic) FunctionType type;
@property (nonatomic) double aValue;
@property (nonatomic) double bValue;
@property (nonatomic) double cValue;
@property (nonatomic) bool visible;

+(NSArray *) functionTypeAsStringValues;

//----------------Initializers---------------------

-(id) initWithName : (NSString *) aName
             color : (NSColor *) aColor
    ExpressionType : (FunctionType) aType
  ExpressionAValue : (double) aValue
  ExpressionBValue : (double) bValue
  ExpressionCValue : (double) cValue
           visible : (bool) aVisible;

-(id) initWithName : (NSString *) aName
             color : (NSColor *) aColor
    ExpressionType : (FunctionType) aType
  ExpressionAValue : (double) aValue
  ExpressionBValue : (double) bValue
  ExpressionCValue : (double) cValue;

//----------------Bussines logic-------------------

-(double) valueAt : (double) x;
-(void) drawInBounds:(NSRect) bounds withParameters:(NSRect) parameters withGraphicsContext:(NSGraphicsContext *) aGraphicContext;

@end

NS_ASSUME_NONNULL_END
