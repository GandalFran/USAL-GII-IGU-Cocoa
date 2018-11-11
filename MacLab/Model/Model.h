//
//  Model.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Function.h"

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject

- (int) addFunction : (Function *) function;
- (bool) deleteFunction : (Function *) function;
- (bool) updateFunction : (Function *) function;
- (Function *) getFunctionWithID : (int) ID;
- (bool) removeAllFunctions;
- (NSArray *) allFunctions;

@end

NS_ASSUME_NONNULL_END
