//
//  PlotRepresentationUIController.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "PlotRepresentationUIController.h"
#import "FunctionTableUIController.h"
#import "NSPlotView.h"
#import "Model.h"


@implementation PlotRepresentationUIController

extern NSString * setModelNotificationSelector;

-(id) init {
    self = [super init];
    
    if(nil == self)
        return nil;
    
    model =[[Model alloc] init];
    
    //Create the secondary window and send the model
    NSDictionary * notificationInfo = nil;
    NSNotificationCenter * notificationCenter = nil;
    FunctionTableUIController * functionTableUIController;
    
    functionTableUIController = [[FunctionTableUIController alloc] init];
    
    if(nil == functionTableUIController){
        //Show error
    }else{
        [functionTableUIController showWindow:self];
        
        notificationCenter = [NSNotificationCenter defaultCenter];
        notificationInfo = [NSDictionary dictionaryWithObject:model forKey:@"model"];
        
        [notificationCenter postNotificationName:setModelNotificationSelector object:self userInfo:notificationInfo];
    }
    
    return self;
}

/**
 * @brief stop the application if the user closes the window
 */
-(BOOL) windowShouldClose:(NSWindow *)sender
{
    [NSApp stop:self];
    return YES;
}


@end
