//
//  FunctionTableUIController.m
//  MacLab
//
//  Created by GandalFran on 13/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Model.h"
#import "Function.h"

#import "AddFunctionUIController.h"
#import "FunctionTableUIController.h"
#import "PlotRepresentationUIController.h"


@implementation FunctionTableUIController

/*----------------------Initializers--------------------*/

-(id) init
{
    if(nil == [super initWithWindowNibName:@"FunctionTableUI"])
        return nil;
    return self;
}

-(instancetype) initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if(nil == self)
        return nil;

    //Register handlers for the notifications
    NSNotificationCenter * notificationCenter = nil;

    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleSendModel:)
                               name:sendModelToFunctionTableUI
                             object:nil];
    return self;
}

/**
 * @brief send a notification to the main controller to stop the application if the user closes the window
 */
-(BOOL) windowShouldClose:(NSWindow *)sender
{
    [NSApp terminate:self];
    return YES;
}

- (void) windowDidLoad {
    [super windowDidLoad];
}

/*----------------Notifications--------------*/

NSString * sendModelToAddFunctionUI = @"sendModelToAddFunctionUI";
NSString * sendNewRepresentation = @"sendNewRepresentation";
extern NSString * sendModelToFunctionTableUI;

/**
 *  @brief handler for sendModelToFunctionTableUI notification:
 *              recives the model
 */
-(void) handleSendModel:(NSNotification *)aNotification{
    NSDictionary * aDictionary = nil;
    
    aDictionary = [aNotification userInfo];
    if(nil != aDictionary)
        model = [aDictionary objectForKey:@"model"];
    
}

/*--------------Delegation-------------*/


/*--------------Bussines logic-------------*/

/*
 * @brief take the representation parameters and set it on the model
 */
-(IBAction)setNewRepresentationParameters:(id)sender{
    RepresentationParameters new;
    
    new.xmin = [xminTextField doubleValue];
    new.xmax = [xmaxTextField doubleValue];
    new.ymin = [yminTextField doubleValue];
    new.ymax = [ymaxTextField doubleValue];
    
    [model setRepresentationParameters:new];
}

/**
 *  @brief displays the addFunction formulary when the addFunction button is pushed
 */
-(IBAction)addFunction:(id)sender{
    NSDictionary * notificationInfo = nil;
    NSNotificationCenter * notificationCenter = nil;
    
    if(!addFunctionUIController){
        addFunctionUIController = [[AddFunctionUIController alloc] init];
        
        [addFunctionUIController showWindow:self];
        
        notificationCenter = [NSNotificationCenter defaultCenter];
        notificationInfo = [NSDictionary dictionaryWithObject:model forKey:@"model"];
        
        [notificationCenter postNotificationName:sendModelToAddFunctionUI object:self userInfo:notificationInfo];
    }
}

/**
 *  @brief removes all elements from model
 */
-(IBAction)removeAllModelElements:(id)sender{
    [model removeAllFunctions];
}

/**
 *  @brief take the selected items and send them to the main window
 *          to be represented
 */
-(IBAction)representSelectedFunctions:(id)sender{
    NSArray * aFunctionArray = nil;
    NSDictionary * aDictionary = nil;
    NSNotificationCenter * aNotificationCenter = nil;
    
    //TODO retrieve selected functions in table
    
    aNotificationCenter = [NSNotificationCenter defaultCenter];
    
    aDictionary = [NSDictionary dictionaryWithObject: aFunctionArray
                                              forKey:@"representationArray"];
    [aNotificationCenter postNotificationName:sendNewRepresentation
                                       object:self
                                     userInfo:aDictionary];
}

@end
