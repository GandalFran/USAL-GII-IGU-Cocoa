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

extern NSString * terminateApplication;
extern NSString * sendModelToFunctionTableUI;

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
        NSAlert * alert = nil;
        NSModalResponse response;
        
        alert = [[NSAlert alloc] init];
        
        [alert setMessageText:@"Error"];
        [alert setInformativeText:@"A problem ocurred during execution. The program will be restrated."];
        [alert addButtonWithTitle:@"ok"];
        [alert setAlertStyle:NSAlertStyleCritical];
        
        response = [alert runModal];
        
        [NSApp terminate:self];
    }else{
        [functionTableUIController showWindow:self];
        
        notificationCenter = [NSNotificationCenter defaultCenter];
        notificationInfo = [NSDictionary dictionaryWithObject:model forKey:@"model"];
        
        [notificationCenter postNotificationName:sendModelToFunctionTableUI object:self userInfo:notificationInfo];
    }
    
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

/*------------------NOTIFICATION HANDLERS-------------------*/

/**
 *  @brief handler to recieve the model
 */
-(void) handleTerminateApplication:(NSNotification *)aNotification{

    [NSApp terminate:self];
}


@end
