//
//  FunctionTableUIController.m
//  MacLab
//
//  Created by GandalFran on 13/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "Model.h"
#import "FunctionTableUIController.h"
#import "PlotRepresentationUIController.h"
#import "AddFunctionUIController.h"
#import "Function.h"


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
 * @brief stop the application if the user closes the window
 */
-(BOOL) windowShouldClose:(NSWindow *)sender
{
    NSNotificationCenter * notificationCenter = nil;
    
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:terminateApplication object:self];
    
    return YES;
}

-(void) awakeFromNib{
    
}

/**
 * @brief  for implement good coding practices
 */
- (void) windowDidLoad {
    [super windowDidLoad];
}

/*----------------Notifications--------------*/

NSString * sendModelToAddFunctionUI = @"sendModelToAddFunctionUI";
NSString * terminateApplication = @"terminateApplication";
extern NSString * sendModelToFunctionTableUI;

/**
 *  @brief handler for sendModelToFunctionTableUI notification:
 *              recives the model
 */
-(void) handleSendModel:(NSNotification *)aNotification{
    NSDictionary * aDictionary = nil;
    
    aDictionary = [aNotification userInfo];
    if(nil != aDictionary){
        model = [aDictionary objectForKey:@"model"];
    }
}

/*--------------Intern actions-------------*/

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
    
    if(!addFunctionUIController){
        addFunctionUIController = [[AddFunctionUIController alloc] init];
        
        [addFunctionUIController showWindow:self];
        
        notificationCenter = [NSNotificationCenter defaultCenter];
        notificationInfo = [NSDictionary dictionaryWithObject:model forKey:@"model"];
        
        [notificationCenter postNotificationName:sendModelToAddFunctionUI object:self userInfo:notificationInfo];
    }
}

-(IBAction)deleteAllElements:(id)sender{
    [model removeAllFunctions];
}

//TEMPORARY -- test model
-(IBAction)resetZoom:(id)sender{
    
    Function * f = nil;
    NSString * name = @"test";
    NSColor * colors = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    
    f = [[Function alloc] initWithName:name color:colors ExpressionType:typeArc ExpressionAValue:1.0 ExpressionBValue:2.0 ExpressionCValue:3.0 ];
    
    int ID = [model addFunction:f];
    NSLog(@"\nID=%d",ID);
    
    f = nil;
    f = [model getFunctionWithID: ID];
    NSLog(@"\n%@",f);
    f = [model getFunctionWithID: 20];
    NSLog(@"\n%@",f);
    f = [model getFunctionWithID: -10];
    NSLog(@"\n%@",f);
    
    [model removeFunctionWithID: [f ID]];
    f = [model getFunctionWithID: ID];
    NSLog(@"\n%@",f);
    
    int i;
    for(i=0; i<20; i++){
        name = [[NSString alloc] initWithFormat:@"FUNCTIONNUMBER%d",i];
        f = [[Function alloc] initWithName:name color:colors ExpressionType:COSINE ExpressionAValue:1.0 ExpressionBValue:2.0 ExpressionCValue:3.0];
    }
    
    NSLog(@"\n%@",model);
}

/*--------------Delegation-------------*/

@end
