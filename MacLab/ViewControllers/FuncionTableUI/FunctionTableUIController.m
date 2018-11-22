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


@implementation FunctionTableUIController{
    
    NSArray * comboBoxDataSource;
}

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
    
    //Create the combobox datasource
    comboBoxDataSource = [[NSArray alloc] initWithObjects:@"a*cos(b*x)", @"a*sin(b*x)",@"a*x^b",@"a+ x*b",@"a*x^2 + b*x + c",@"a/(b*x)",@"",nil];

    //Register handlers for the notifications
    NSNotificationCenter * notificationCenter = nil;

    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleSendModel:)
                               name:sendModelToFunctionTableUI
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(handleReloadData:)
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
    
    [xminTextField setDoubleValue:parameters.xmin];

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
-(void) handleReloadData:(NSNotification *)aNotification{
    [functionTableView reloadData];
}

/*--------------Delegation-------------*/

/**
 *  @brief enables or disables the add button if the
 *         formulary is completed or not
 */
- (void) controlTextDidChange:(NSNotification *)obj{
    BOOL formularyCompleted = [self isSettingsFormCompleted];
    [saveSettingsButton setEnabled: formularyCompleted];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{

    NSString * identifier = [tableColumn identifier];
    NSTableCellView * cell = [tableView makeViewWithIdentifier:identifier owner:nil];
    Function * f = [[model allFunctions] objectAtIndex:row];
    
    if([tableColumn isEqual:[tableView tableColumns][0]]){
        NSTextField * textField = [[cell subviews] objectAtIndex:0];
        [textField setStringValue: [f name]];
        [textField setTag: row];
        [textField setTarget:self];
        [textField setAction:@selector(tableViewEditNameColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][1]]){
        NSComboBox * comboBox = [[cell subviews] objectAtIndex:0];
        
        [comboBox removeAllItems];
        [comboBox addItemsWithObjectValues:[comboBoxDataSource subarrayWithRange: NSMakeRange(0, 6)] ];
        
        [comboBox setStringValue:comboBoxDataSource[[f type]]];
        [comboBox setTag: row];
        [comboBox setTarget:self];
        [comboBox setAction:@selector(tableViewEditTypeColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][2]]){
        NSTextField * textField = [[cell subviews] objectAtIndex:0];
        [textField setStringValue: [[NSString alloc]initWithFormat:@"%.2f",[f aValue]]];
        [textField setTag: row];
        [textField setTarget:self];
        [textField setAction:@selector(tableViewEditAValueColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][3]]){
        NSTextField * textField = [[cell subviews] objectAtIndex:0];
        [textField setStringValue: [[NSString alloc]initWithFormat:@"%.2f",[f bValue]]];
        [textField setTag: row];
        [textField setTarget:self];
        [textField setAction:@selector(tableViewEditBValueColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][4]]){
        NSTextField * textField = [[cell subviews] objectAtIndex:0];
        if([f type] == PARABOLA){
            [textField setStringValue: [[NSString alloc]initWithFormat:@"%.2f",[f cValue]]];
            [textField setEnabled: YES];
        }else{
            [textField setStringValue: @"-"];
            [textField setEnabled: NO];
        }
        [textField setTag: row];
        [textField setTarget:self];
        [textField setAction:@selector(tableViewEditCValueColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][5]]){
        NSColorWell * colorWell = [[cell subviews] objectAtIndex:0];
        [colorWell setColor:[f color]];
        [colorWell setTag: row];
        [colorWell setTarget:self];
        [colorWell setAction:@selector(tableViewEditColorColumn:)];
    }
    
    return cell;
}

-(IBAction)tableViewEditNameColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    NSTextField * tf = sender;
    
    row = [tf tag];
    
    f = [[model allFunctions] objectAtIndex:row];
    [f setName: [tf stringValue] ];
    [model updateFunction:f];
}
-(IBAction)tableViewEditTypeColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    NSComboBox * cb = sender;
    
    row = [cb tag];
    
    f = [[model allFunctions] objectAtIndex:row];
    [f setType:(FunctionType)[cb indexOfSelectedItem]];
    if([f type] != PARABOLA)
        [f setCValue:0];
    
    [model updateFunction:f];
    
    //here the data is reloaded because if is selected or deselected the PARABOLA
    //  the c value should be changed
    [functionTableView reloadData];
}
-(IBAction)tableViewEditAValueColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    NSTextField * tf = sender;
    
    row = [tf tag];
    
    f = [[model allFunctions] objectAtIndex:row];
    [f setAValue: [tf floatValue] ];
    [model updateFunction:f];
}
-(IBAction)tableViewEditBValueColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    NSTextField * tf = sender;
    
    row = [tf tag];
    
    f = [[model allFunctions] objectAtIndex:row];
    [f setBValue: [tf floatValue] ];
    [model updateFunction:f];
}
-(IBAction)tableViewEditCValueColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    NSTextField * tf = sender;
    
    row = [tf tag];
    
    f = [[model allFunctions] objectAtIndex:row];
    
    if([f type] == PARABOLA){
        [f setCValue: [tf floatValue] ];
        [model updateFunction:f];
    }
    
    //here the data is reloaded because if is selected or deselected the PARABOLA
    //  the c value has different treatement
    [functionTableView reloadData];
}
-(IBAction)tableViewEditColorColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    NSColorWell * colorWell = sender;
    
    row = [colorWell tag];
    
    f = [[model allFunctions] objectAtIndex:row];
    [f setColor: [colorWell color] ];
    [model updateFunction:f];
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
-(IBAction)showAddFunctionPanel:(id)sender{
    NSDictionary * notificationInfo = nil;
    NSNotificationCenter * notificationCenter = nil;
    
    if(nil == addFunctionUIController){
        addFunctionUIController = [[AddFunctionUIController alloc] init];
        notificationCenter = [NSNotificationCenter defaultCenter];
        notificationInfo = [NSDictionary dictionaryWithObject:model forKey:@"model"];
        [notificationCenter postNotificationName:sendModelToAddFunctionUI object:self userInfo:notificationInfo];
    }
    
    [addFunctionUIController showWindow:self];
}


-(IBAction)removeFunction:(id)sender{
    NSInteger row;
    Function * f = nil;
    
    row = [functionTableView selectedRow];
    if(-1 == row) return;
    
    f = [[model allFunctions] objectAtIndex:row];
    [model removeFunctionWithID:[f ID]];
    [functionTableView reloadData];
}

/**
 *  @brief removes all elements from model
 */
-(IBAction)removeAllModelElements:(id)sender{
    [model removeAllFunctions];
    [functionTableView reloadData];
}

/**
 *  @brief take the selected items and send them to the main window
 *          to be represented
 */
-(IBAction)representSelectedFunctions:(id)sender{
    NSMutableArray * aFunctionArray = [[NSMutableArray alloc] init];
    NSIndexSet * indexesOfselectedFunctions = nil;
    NSDictionary * aDictionary = nil;
    NSNotificationCenter * aNotificationCenter = nil;
    
    indexesOfselectedFunctions = [functionTableView selectedRowIndexes];
    
    [[functionTableView selectedRowIndexes] enumerateIndexesUsingBlock:^(NSUInteger range, BOOL *stop) {
        [aFunctionArray addObject:[[model allFunctions] objectAtIndex:range] ];
    }];
    
    aNotificationCenter = [NSNotificationCenter defaultCenter];
    
    aDictionary = [NSDictionary dictionaryWithObject: aFunctionArray
                                              forKey:@"representationArray"];
    [aNotificationCenter postNotificationName:sendNewRepresentation
                                       object:self
                                     userInfo:aDictionary];
}

- (BOOL) isSettingsFormCompleted{
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
    float a,b,c;
    
    int i;
    for(i=0; i<20; i++){
        name = [[NSString alloc] initWithFormat: @"FunctionNumber%d",i];
        type = arc4random_uniform(6);
        color = [NSColor colorWithRed: ((float)arc4random_uniform(100))/100 green:((float)arc4random_uniform(100))/100 blue:((float)arc4random_uniform(100))/100 alpha:1.0];
        a = ((float)arc4random_uniform(10000))/100;
        b = ((float)arc4random_uniform(10000))/100;
        c = ((float)arc4random_uniform(10000))/100;
        
        f = [[Function alloc] initWithName:name color:color ExpressionType:type ExpressionAValue:a ExpressionBValue:b ExpressionCValue:c];
        [model addFunction: f];
    }
    
    [functionTableView reloadData];
}

@end
