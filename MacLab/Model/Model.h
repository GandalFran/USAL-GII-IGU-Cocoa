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

typedef struct{
    double xmin, xmax, ymin, ymax;
}RepresentationParameters;

@interface Model : NSObject{
    RepresentationParameters _representationParameters;
}

@property (nonatomic) RepresentationParameters representationParameters;

- (int) addFunction: (Function *) aFunction;
- (bool) removeFunctionWithID : (int) aFunctionID;
- (bool) updateFunction : (Function *) aFunction;
- (Function *) getFunctionWithID : (int) aFunctionID;
- (Function *) getFunctionWithIndex : (int) anIndex;
- (bool) removeAllFunctions;
- (NSArray *) allFunctions;
- (long) count;

-(bool) exportFile:(NSString *) path;
-(bool) importFile:(NSString *) path;

@end

NS_ASSUME_NONNULL_END
