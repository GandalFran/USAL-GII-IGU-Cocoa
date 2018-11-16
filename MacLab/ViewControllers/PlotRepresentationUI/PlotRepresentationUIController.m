//
//  PlotRepresentationUIController.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Model.h"
#import "NSPlotView.h"

#import "FunctionTableUIController.h"
#import "PlotRepresentationUIController.h"

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
                           selector:@selector(handleAddRepresentation:)
                               name:sendNewRepresentation
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
extern NSString * sendNewRepresentation;

/**
 *  @brief handler for the sendNewRepresentation notification:
 *          refreshes the representation content
 */
-(void) handleAddRepresentation:(NSNotification *)aNotification{
    NSArray * aFunctionArray = nil;
    NSDictionary * aDictionary = nil;
    
    aDictionary = [aNotification userInfo];
    aFunctionArray = [aDictionary objectForKey:@"representationArray"];
    
    [self addRepresentationWithFunctionArray: aFunctionArray];
}

/*--------------Delegation-------------*/


/*--------------Bussines logic-------------*/

-(void) addRepresentationWithFunctionArray: (NSArray *) aFunctionArray{
    //TODO implement
}

@end
