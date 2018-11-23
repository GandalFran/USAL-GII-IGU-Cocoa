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
    int currentID;
    NSMutableArray * modelData;
}

- (int) getCurrentID;
- (int) getIndexWithID: (int) aFunctionID;

@end

@implementation Model

@synthesize representationParameters=_representationParameters;

//----------------Initializers---------------------

-(id) init
{
    self = [super init];
    if(!self)
        return nil;
    
    currentID = 0;
    modelData = [[NSMutableArray alloc] init];
    
    if(!modelData)
        return nil;
    
    return self;
}

//-------------NSObject hierarchy------------------

-(NSString *) description
{
    return [[NSString alloc] initWithFormat: @"Model{currentID=%d, data=%@}",currentID,modelData.description];
}

//----------------Bussines logic-------------------

- (int) addFunction: (Function *) aFunction{
    if(nil == aFunction || NULL == aFunction) return -1;
    
    [aFunction setID:[self getCurrentID]];
    [modelData addObject:aFunction];
    
    return [aFunction ID];
}

- (bool) removeFunctionWithID : (int) aFunctionID{
    if(0 > aFunctionID || currentID <= aFunctionID) return false;
    
    int index = [self getIndexWithID: aFunctionID];
    if(-1 != index)
        [modelData removeObjectAtIndex:index];
    
    return (-1 != index);
}

- (bool) updateFunction : (Function *) aFunction{
    if(nil == aFunction || NULL == aFunction) return false;
    if(0 > [aFunction ID] || currentID <= [aFunction ID]) return false;
    
    int index = [self getIndexWithID: [aFunction ID]];
    if(-1 != index){
        [modelData removeObjectAtIndex:index];
        [modelData insertObject:aFunction atIndex:index];
    }
    
    NSLog(@"\n\nUpdated f:%@",aFunction);
    
    return (-1 != index);
}

- (Function *) getFunctionWithID : (int) aFunctionID{
    if(0 > aFunctionID || currentID <= aFunctionID) return false;
    
    int index = [self getIndexWithID: aFunctionID];
    return (-1 == index)? nil : [[modelData objectAtIndex:index] copy];
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

- (int) getCurrentID{
    return currentID++;
}

- (int) getIndexWithID: (int) aFunctionID
{
    int i;
    bool found;
    
    found = false;
    for(i=0; i<[modelData count]; i++){
        if([[modelData objectAtIndex:i] ID] == aFunctionID){
            found = true;
            break;
        }
    }
    
    return found? i : -1;
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
