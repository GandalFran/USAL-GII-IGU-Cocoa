//
//  Model.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "Function.h"
#import "Model.h"

@interface Model(){
    NSMutableArray * modelData;
}

@end

@implementation Model

+(Model *) defaultModel{
    static Model * singleToneModel = nil;
    
    if (nil == singleToneModel)
        singleToneModel = [[Model alloc] init];
    
    return singleToneModel;
}

//----------------Initializers---------------------

-(id) init
{
    self = [super init];
    if(!self)
        return nil;
    
    modelData = [[NSMutableArray alloc] init];
    
    if(!modelData)
        return nil;
    
    return self;
}

//-------------NSObject hierarchy------------------

-(NSString *) description
{
    return [[NSString alloc] initWithFormat: @"Model{data=%@}",modelData.description];
}

//----------------Bussines logic-------------------

- (bool) addFunction: (Function *) aFunction{
    if(nil == aFunction || NULL == aFunction) return -1;
    [modelData addObject:aFunction];
    return true;
}

- (bool) removeFunctionWithIndex : (int) index{
    if(0 > index || index >= [modelData count]) return false;
    [modelData removeObjectAtIndex:index];
    return true;
}

- (bool) updateFunction : (Function *) aFunction atIndex:(int) index{
    if(nil == aFunction || NULL == aFunction) return false;
    if(0 > index || index >= [modelData count]) return false;
    
    [modelData removeObjectAtIndex:index];
    [modelData insertObject:aFunction atIndex:index];
    
    NSLog(@"\n\nUpdated f:%@",aFunction);
    
    return true;
}

- (Function *) getFunctionWithIndex : (int) anIndex{
    if(0 > anIndex || [modelData count]<=anIndex) return nil;
    return modelData[anIndex];
}

- (bool) removeAllFunctions{
    [modelData removeAllObjects];
    return true;
}

- (NSArray *) allFunctions{
    return [modelData copy];
}

- (long) count{
    return [modelData count];
}

//----------------------IO-------------------------

-(bool) exportFile:(NSString *) path{
    return [NSKeyedArchiver archiveRootObject:modelData toFile:path];
}

-(bool) importFile:(NSString *) path{
    NSMutableArray *anArray = nil;
    NSFileManager * fileManager = nil;
    
    fileManager = [NSFileManager defaultManager];
    if (NO == [fileManager fileExistsAtPath:path])
        return NO;
    
    anArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if(nil == anArray)
        return NO;
    else{
        modelData = anArray;
        return YES;
    }
}

@end
