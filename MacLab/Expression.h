//
//  Expression.h
//  MacLab
//
//  Created by GandalFran on 11/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{COSINE, SINE, EXPONENTIAL, LINE, PARABOLA, HIPERBOLA} FunctionType;

@interface Expression : NSObject

    @property (nonatomic) FunctionType _type;;
    @property (nonatomic) float _aValue;
    @property (nonatomic) float _bValue;
    @property (nonatomic) float _cValue;

+(id) initWithFunctionType : (FunctionType) type
                    aValue : (float) aValue
                    bValue : (float) bValue
                    cValue : (float) cValue;

-(float) calculateYValueWithXValue : (float) xValue;


@end

NS_ASSUME_NONNULL_END
