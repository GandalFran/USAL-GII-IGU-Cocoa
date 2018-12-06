//
//  Model.h
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Function;

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject

//------------------Singletone---------------------
+ (Model *) defaultModel;
//----------------Bussines logic-------------------
- (bool) addFunction: (Function *) aFunction;
- (bool) removeFunctionAtIndex : (int) index;
- (bool) updateFunction : (Function *) aFunction atIndex:(int)index;
- (Function *) getFunctionAtIndex : (int) anIndex;
- (bool) removeAllFunctions;
- (long) count;

//----------------------IO-------------------------
-(bool) exportFile:(NSString *) path;
-(bool) importFile:(NSString *) path;

@end

NS_ASSUME_NONNULL_END
