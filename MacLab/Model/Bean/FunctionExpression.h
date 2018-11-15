//
//  Expression.h
//  MacLab
//
//  Created by GandalFran on 11/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{COSINE, SINE, EXPONENTIAL, LINE, PARABOLA, HIPERBOLA, NONE_TYPE} FunctionType;

@interface FunctionExpression : NSObject{
    FunctionType _type;;
    double _aValue;
    double _bValue;
    double _cValue;
}

    @property (nonatomic) FunctionType type;;
    @property (nonatomic) double aValue;
    @property (nonatomic) double bValue;
    @property (nonatomic) double cValue;

-(id) initWithFunctionType : (FunctionType) type
                    aValue : (double) a
                    bValue : (double) b
                    cValue : (double) c;

-(double) calculateYValueWithXValue : (double) x;

@end

NS_ASSUME_NONNULL_END
