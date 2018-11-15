//
//  FunctionTableUIController.m
//  MacLab
//
//  Created by GandalFran on 13/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "Model.h"
#import "FunctionTableUIController.h"
#import "AddFunctionUIController.h"
#import "NotificationDeclarations.h"
#import "Function.h"


@implementation FunctionTableUIController

extern NSString * setModelNotificationSelector;

/*------------------MODEL INITIALIZERS-------------------*/

-(id) init
{
    self = [super initWithWindowNibName:@"FunctionTableUI"];
    
    if (nil == self)
        return nil;
    
    return self;
}


-(instancetype) initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if(nil == self)
        return nil;
    
    //Register handlers for the notification
    NSNotificationCenter * notificationCenter = nil;
    
    [notificationCenter addObserver:self
                           selector:@selector(handleSendModel:)
                               name:setModelNotificationSelector
                             object:nil];
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

/**
 * @brief  for implement good coding practices
 */
- (void) windowDidLoad {
    [super windowDidLoad];
}


/*------------------NOTIFICATION HANDLERS-------------------*/

/**
 *  @brief handler to recieve the model
 */
-(void) handleSendModel:(NSNotification *)aNotification{
    NSDictionary * aDictionary = nil;
    
    aDictionary = [aNotification userInfo];
    if(nil != aDictionary){
        model = [aDictionary objectForKey:@"model"];
    }
}

/*----------------------TABLE DELEGATE----------------------*/



/*-------------------------BUTTONS--------------------------*/

/*
 * @brief method to take the representation parameters and set it on the model
 */
-(IBAction)setNewRepresentationParameters:(id)sender{
    RepresentationParameters new;
    
    new.xmin = [xminTextField doubleValue];
    new.xmax = [xmaxTextField doubleValue];
    new.ymin = [yminTextField doubleValue];
    new.ymax = [ymaxTextField doubleValue];
    
    [model setRepresentationParameters:new];
}

-(IBAction)addFunction:(id)sender{
    NSDictionary * notificationInfo = nil;
    NSNotificationCenter * notificationCenter = nil;
    AddFunctionUIController * addFunctionUIController;
    
    addFunctionUIController = [[AddFunctionUIController alloc] init];
    if(nil == addFunctionUIController){
        //Show error
    }else{
        [addFunctionUIController showWindow:self];
        
        notificationCenter = [NSNotificationCenter defaultCenter];
        notificationInfo = [NSDictionary dictionaryWithObject:model forKey:@"model"];
        
        [notificationCenter postNotificationName:setModelNotificationSelector object:self userInfo:notificationInfo];
    }
}

-(IBAction)deleteAllElements:(id)sender{
    [model removeAllFunctions];
}

//TEMPORARY -- test model
-(IBAction)resetZoom:(id)sender{
    NSString * name = @"test";
    NSColor * colors = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0];;
    
    int ID = [model addFunctionWithName:name color:colors ExpressionType:COSINE ExpressionAValue:1.0 ExpressionBValue:2.0 ExpressionCValue:5.0];
    NSLog(@"\nID=%d",ID);
    
    Function * f = [model getFunctionWithID: ID];
    NSLog(@"\n%@",f);
    f = [model getFunctionWithID: 20];
    NSLog(@"\n%@",f);
    f = [model getFunctionWithID: -10];
    NSLog(@"\n%@",f);
    
    [model deleteFunction: f];
    f = [model getFunctionWithID: ID];
    NSLog(@"\n%@",f);
    
    int i;
    for(i=0; i<20; i++){
        name = [[NSString alloc] initWithFormat:@"FUNCTIONNUMBER%d",i];
        [model addFunctionWithName:name color:colors ExpressionType:COSINE ExpressionAValue:1.0 ExpressionBValue:2.0 ExpressionCValue:3.0];
    }
    
    NSLog(@"\n%@",model);
}

@end
