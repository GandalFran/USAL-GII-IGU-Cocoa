//
//  Model.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "Model.h"

@implementation Model{
    int currentID;
    NSMutableDictionary * model;
}

-(id) init{
    self = [super init];
    if(!self)
        return nil;
    
    currentID = 0;
    model = [[NSMutableDictionary alloc] init];
    
    if(!model)
        return nil;
    
    return self;
}

- (int) addFunction : (Function *) function{
    if(nil == function) return -1;
    
    [function setID: [self getCurrentID]];
    [model setObject:function forKey:[self getKeyFromID:[function ID]]];
    
    return [function ID];
}

- (bool) deleteFunction : (Function *) function{
    if(nil == function) return false;
    
    [model removeObjectForKey:[self getKeyFromID:[function ID]]];
    
    return true;
}

- (bool) updateFunction : (Function *) function{
    if(nil == function) return false;
    if([function ID] < 0) return false;
    if([[model allKeys] containsObject:[self getKeyFromID:[function ID]]]) return false;
    
    [model setObject:function forKey:[self getKeyFromID:[function ID]]];
    
    return true;
}

- (Function *) getFunctionWithID : (int) ID{
    if(ID < 0 || [model count] <= ID ) return nil;
    return [model valueForKey:[self getKeyFromID:ID]];
}

- (bool) removeAllFunctions{
    [model removeAllObjects];
    return true;
}

- (NSArray *) allFunctions{
    return [model allValues];
}

- (int) getCurrentID{
    return currentID++;
}

- (NSString *) getKeyFromID: (int) ID{
    return [[NSString alloc] initWithFormat: @"%d",ID ];
}

@end
