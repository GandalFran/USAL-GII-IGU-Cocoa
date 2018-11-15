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

/*----------------------Initializers--------------------*/

-(id) init {
    self = [super init];
    
    if(nil == self)
        return nil;
    
    //Instance model
    model =[[Model alloc] init];
    
    //Instance and throw secondary window
    functionTableUIController = [[FunctionTableUIController alloc] init];
    [functionTableUIController showWindow:self];
    
    //Send the model
    NSDictionary * notificationInfo = nil;
    NSNotificationCenter * notificationCenter = nil;
    
    notificationCenter = [NSNotificationCenter defaultCenter];
    notificationInfo = [NSDictionary dictionaryWithObject:model forKey:@"model"];
    [notificationCenter postNotificationName:sendModelToFunctionTableUI
                                          object:self
                                        userInfo:notificationInfo];
    
    //register the handle for terminate app notification
    [notificationCenter addObserver:self
                           selector:@selector(handleTerminateApplication:)
                               name:terminateApplication
                             object:nil];
    
    return self;
}

/**
 * @brief stop the application if the user closes the window
 */
-(BOOL) windowShouldClose:(NSWindow *)sender
{
    [NSApp terminate:self];
    return YES;
}

/*----------------Notifications--------------*/

NSString * sendModelToFunctionTableUI = @"sendModelToFunctionTableUI";
extern NSString * terminateApplication;

/**
 *  @brief handler for the terminateApplication notification:
 *          finishes the application
 */
-(void) handleTerminateApplication:(NSNotification *)aNotification{
    [NSApp terminate:self];
}

/*--------------Intern actions-------------*/


@end
