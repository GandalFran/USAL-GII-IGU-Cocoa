//
//  Model.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "Function.h"
#import "Model.h"

@implementation Model{
    int currentID;
    NSMutableArray * modelData;
}

@synthesize representationParameters=_representationParameters;

/*----------------------Initializers--------------------*/

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

/*-------------------Bean basics-----------------------*/

-(NSString *) description
{
    return [[NSString alloc] initWithFormat: @"Model{currentID=%d, data=%@}",currentID,modelData.description];
}

/*---------------------Bussines logic-------------------*/

- (int) addFunction: (Function *) aFunction{
    if(nil == aFunction || NULL == aFunction) return -1;
    
    [aFunction setID:[self getCurrentID]];
    [modelData addObject:aFunction];
    
    return [aFunction ID];
}

- (bool) removeFunctionWithID : (int) aFunctionID{
    if(0 > aFunctionID || currentID <= aFunctionID) return false;
    
    int i;
    bool found = false;
    
    for(i=0; i<[modelData count]; i++){
        if([[modelData objectAtIndex:i] ID] == aFunctionID){
            found = true;
            break;
        }
    }
    
    if(found)
        [modelData removeObjectAtIndex:i];
    
    return found;
}

- (bool) updateFunction : (Function *) aFunction{
    if(nil == aFunction || NULL == aFunction) return false;
    if(0 > [aFunction ID] || currentID <= [aFunction ID]) return false;
    
    int i;
    bool found = false;
    
    for(i=0; i<[modelData count]; i++){
        if([[modelData objectAtIndex:i] ID] == [aFunction ID]){
            found = true;
            break;
        }
    }
    
    if(found){
        [modelData removeObjectAtIndex:i];
        [modelData addObject:aFunction];
    }
    
    return found;
}

- (Function *) getFunctionWithID : (int) aFunctionID{
    if(0 > aFunctionID || currentID <= aFunctionID) return false;
    
    int i;
    bool found = false;
    
    for(i=0; i<[modelData count]; i++){
        if([[modelData objectAtIndex:i] ID] == aFunctionID){
            found = true;
            break;
        }
    }
    
    if(found){
        return [modelData objectAtIndex:i];
    }else{
        return false;
    }
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

@end
