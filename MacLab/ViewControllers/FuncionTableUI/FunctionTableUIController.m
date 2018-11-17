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
    [notificationCenter addObserver:self
                           selector:@selector(handleFunctionAdded:)
                               name:functionAdded
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

-(void) awakeFromNib{
    RepresentationParameters parameters = [model representationParameters];
    
    [xminTextField setFloatValue:parameters.xmin];
    [xmaxTextField setFloatValue:parameters.xmax];
    [yminTextField setFloatValue:parameters.ymin];
    [ymaxTextField setFloatValue:parameters.ymax];
}

- (void) windowDidLoad {
    [super windowDidLoad];
}

/*----------------Notifications--------------*/

NSString * sendModelToAddFunctionUI = @"sendModelToAddFunctionUI";
NSString * sendNewRepresentation = @"sendNewRepresentation";
extern NSString * sendModelToFunctionTableUI;
extern NSString * functionAdded;

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

/**
 *  @brief handler for functionAdded notification:
 *              reloads the view
 */
-(void) handleFunctionAdded:(NSNotification *)aNotification{
    [tableView reloadData];
}

/*--------------Delegation-------------*/

/**
 *  @brief enables or disables the save button if the
 *         formulary is completed or not
 */
- (void) controlTextDidChange:(NSNotification *)obj{
    BOOL formularyCompleted = [self isFormCompleted];
    [saveSettingsButton setEnabled: formularyCompleted];
}


-(void) tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger row = [tableView selectedRow];
    
    if(-1 == row)
        return;
    
    //TODO de momento nada
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Function * f = nil;
    NSString * columnIdentifier = nil;
    
    columnIdentifier = [tableColumn identifier];
    f = [[model allFunctions] objectAtIndex:row];
    
    if([columnIdentifier isEqualToString:@"NameColumn"]){
        return [f name];
    }else if([columnIdentifier isEqualToString:@"typeColumn"]){
        if([f type] == COSINE){
            return @"a*cos(b*x)";
        }else if([f type] == SINE){
            return @"a*sin(b*x)";
        }else if([f type] == EXPONENTIAL){
            return @"a*x^b)";
        }else if([f type] == LINE){
            return @"a + b*x";
        }else if([f type] == PARABOLA){
            return @"a*x^2 + b*x + c";
        }else if([f type] == HIPERBOLA){
            return @"a/(b*x)";
        }else{
            return nil;
        }
    }else if([columnIdentifier isEqualToString:@"aValueColumn"]){
        return [[NSString alloc]initWithFormat:@"%f",[f aValue]];
    }else if([columnIdentifier isEqualToString:@"bValueColumn"]){
        return [[NSString alloc]initWithFormat:@"%f",[f bValue]];
    }else if([columnIdentifier isEqualToString:@"cValueColumn"]){
        return ([f type] == PARABOLA)? [[NSString alloc]initWithFormat:@"%f",[f cValue]] : @"-";
    }else if([columnIdentifier isEqualToString:@"ColorColumn"]){
        return nil;
    }else if([columnIdentifier isEqualToString:@"vissibleColumn"]){
        return nil;
    }else{
        return nil;
    }
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    
    Function * f = nil;
    NSString * columnIdentifier = nil;
    
    columnIdentifier = [aTableColumn identifier];
    f = [[model allFunctions] objectAtIndex:rowIndex];
    
    if([columnIdentifier isEqualToString:@"NameColumn"]){
        [f setName:anObject];
    }else if([columnIdentifier isEqualToString:@"typeColumn"]){
        if([anObject isEqualToString:@"a*cos(b*x)"]){
            [f setType:COSINE];
        }else if([anObject isEqualToString:@"a*sin(b*x)"]){
            [f setType:SINE];
        }else if([anObject isEqualToString:@"a*x^b)"]){
            [f setType:EXPONENTIAL];
        }else if([anObject isEqualToString:@"a + b*x"]){
            [f setType:LINE];
        }else if([anObject isEqualToString:@"a*x^2 + b*x + c"]){
            [f setType:PARABOLA];
        }else if([anObject isEqualToString:@"a/(b*x)"]){
            [f setType:HIPERBOLA];
        }
    }else if([columnIdentifier isEqualToString:@"aValueColumn"]){
        [f setAValue:[anObject doubleValue]];
    }else if([columnIdentifier isEqualToString:@"bValueColumn"]){
        [f setBValue:[anObject doubleValue]];
    }else if([columnIdentifier isEqualToString:@"cValueColumn"] && ([f type] == PARABOLA)){
        [f setCValue:[anObject doubleValue]];
    }else if([columnIdentifier isEqualToString:@"ColorColumn"]){
        //TODO
    }else if([columnIdentifier isEqualToString:@"vissibleColumn"]){
        //TODO
    }
    
    [model updateFunction:f];
    [tableView reloadData];
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return [model count];
}

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
    
    if(nil == addFunctionUIController){
        addFunctionUIController = [[AddFunctionUIController alloc] init];
    }
    
    [addFunctionUIController showWindow:self];
    
    notificationCenter = [NSNotificationCenter defaultCenter];
    notificationInfo = [NSDictionary dictionaryWithObject:model forKey:@"model"];
    
    [notificationCenter postNotificationName:sendModelToAddFunctionUI object:self userInfo:notificationInfo];
}

/**
 *  @brief removes all elements from model
 */
-(IBAction)removeAllModelElements:(id)sender{
    [model removeAllFunctions];
    [tableView reloadData];
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

- (BOOL) isFormCompleted{
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    
    BOOL areAllFilled = ([[xminTextField stringValue] length] != 0
                         && [[xmaxTextField stringValue] length] != 0
                         && [[yminTextField stringValue] length] != 0
                         && [[ymaxTextField stringValue] length] != 0);
    
    //TODO improve the validation of numbers
    BOOL areNumberTextFieldsCorrectlyFilled = (
                            [numberFormatter numberFromString:[xminTextField stringValue]] != nil
                            && [numberFormatter numberFromString:[xmaxTextField stringValue]] != nil
                            && [numberFormatter numberFromString:[yminTextField stringValue]] != nil
                            && [numberFormatter numberFromString:[ymaxTextField stringValue]] != nil);
    
    return (areAllFilled && areNumberTextFieldsCorrectlyFilled);
}


-(IBAction)TEST:(id)sender{
    Function * f = nil;
    NSString * name = nil;
    NSColor * color = nil;
    FunctionType type;
    
    int i;
    for(i=0; i<20; i++){
        name = [[NSString alloc] initWithFormat: @"%d",i];
        type = arc4random_uniform(6);
        color = [NSColor colorWithRed:arc4random_uniform(255) green:arc4random_uniform(255) blue:arc4random_uniform(255) alpha:1.0];
        f = [[Function alloc] initWithName:name color:color ExpressionType:type ExpressionAValue:1.0 ExpressionBValue:2.0 ExpressionCValue:3.0];
        [model addFunction: f];
    }
    
    [tableView reloadData];
    
}

@end
