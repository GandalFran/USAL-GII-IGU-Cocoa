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
    functionTableUIController = [[FunctionTableUIController alloc] initWithModel: model];
    [functionTableUIController showWindow:self];
    
    //set default values for xmin, xmax, ymin and ymax
    RepresentationParameters parameters;
    parameters.xmin = -10.0;
    parameters.xmax = 10.0;
    parameters.ymin = -10.0;
    parameters.ymax = 10.0;
    [model setRepresentationParameters:parameters];
    
    //register the handle for terminate app notification
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
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

-(void)dealloc{
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

/*----------------Notifications--------------*/

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
    NSLog(@"\n\n%@",aFunctionArray);
}

@end
