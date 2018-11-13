//
//  Model.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "NSFunctionExpression.h"
#import <Cocoa/Cocoa.h>

@class NSFunction;

NS_ASSUME_NONNULL_BEGIN

typedef struct{
    double xmin, xmax, ymin, ymax;
}RepresentationParameters;

@interface Model : NSObject{
    RepresentationParameters _representationParameters;
}

@property (nonatomic) RepresentationParameters representationParameters;

- (int) addFunctionWithName : (NSString *) name
                      color : (NSColor *) color
             ExpressionType : (FunctionType) type
           ExpressionAValue : (double) a
           ExpressionBValue : (double) b
           ExpressionCValue : (double) c;

- (bool) deleteFunction : (NSFunction *) function;
- (bool) updateFunction : (NSFunction *) function;
- (NSFunction *) getFunctionWithID : (int) ID;
- (bool) removeAllFunctions;
- (NSArray *) allFunctions;

@end

NS_ASSUME_NONNULL_END
