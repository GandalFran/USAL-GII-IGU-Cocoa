//
//  Model.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"

@class Function;


NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject

- (int) addFunctionWithName : (NSString *) name
                      color : (NSColor *) color
             ExpressionType : (FunctionType) type
           ExpressionAValue : (double) a
           ExpressionBValue : (double) b
           ExpressionCValue : (double) c;

- (bool) deleteFunction : (Function *) function;
- (bool) updateFunction : (Function *) function;
- (Function *) getFunctionWithID : (int) ID;
- (bool) removeAllFunctions;
- (NSArray *) allFunctions;

@end

NS_ASSUME_NONNULL_END
