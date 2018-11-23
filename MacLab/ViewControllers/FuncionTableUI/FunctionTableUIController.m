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

@interface FunctionTableUIController(){
    Model * model;
    NSArray * comboBoxDataSource;
    AddFunctionUIController * addFunctionUIController;
}

- (BOOL) isSettingsFormCompleted;
@end


@implementation FunctionTableUIController

//----------------Initializers---------------------
-(id) initWithModel: (Model *) aModel
{
    if(nil == [super initWithWindowNibName:@"FunctionTableUI"])
        return nil;
    
    //Save model
    model = aModel;
    //Create the combobox datasource
    comboBoxDataSource = [[NSArray alloc] initWithObjects:@"a*cos(b*x)", @"a*sin(b*x)",@"a*x^b",@"a+ x*b",@"a*x^2 + b*x + c",@"a/(b*x)",@"",nil];
    
    return self;
}

-(instancetype) initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if(nil == self)
        return nil;
    
    //Register handlers for the notifications
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handlFunctionAdded:)
                               name:functionAdded
                             object:nil];
    return self;
}

-(BOOL) windowShouldClose:(NSWindow *)sender
{
    return YES;
}

-(void) awakeFromNib{
    RepresentationParameters parameters = [model representationParameters];
    [xminTextField setDoubleValue:parameters.xmin];
    [xmaxTextField setDoubleValue:parameters.xmax];
    [yminTextField setDoubleValue:parameters.ymin];
    [ymaxTextField setDoubleValue:parameters.ymax];
}

- (void) windowDidLoad {
    [super windowDidLoad];
}

//-----------------Finalizers----------------------
-(void)dealloc{
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

//----------------Notifications--------------------
NSString * sendNewRepresentation = @"sendNewRepresentation";
extern NSString * functionAdded;

/**
 *  @brief handler for functionAdded notification:
 *              saves the function in model, and reloads the view
 */
-(void) handlFunctionAdded:(NSNotification *)aNotification{
    Function * aFunction = nil;
    NSDictionary * notificationInfo = nil;
    
    notificationInfo = [aNotification userInfo];
    aFunction = [notificationInfo objectForKey:@"function"];
    [model addFunction:aFunction];
    
    [functionTableView reloadData];
}

//------------------Delegation---------------------
/**
 *  @brief Enables or disables the add button if the
 *         settings formulary is completed or not
 */
- (void) controlTextDidChange:(NSNotification *)obj{
    BOOL formularyCompleted = [self isSettingsFormCompleted];
    [saveSettingsButton setEnabled: formularyCompleted];
}

/**
 *  @brief Is called by the tableView to load each cell.
 *         It configures each cell with the respective parameters,
 *         sets the target to self and the action to one of the
 *         functions bellow.
 */
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSControl * cell = nil;
    NSString * identifier = [tableColumn identifier];
    Function * f = [model getFunctionWithIndex:(int)row];
    
    cell = [[[tableView makeViewWithIdentifier:identifier owner:nil] subviews] objectAtIndex:0];
    [cell setTag: row];
    [cell setTarget:self];
    
    if([tableColumn isEqual:[tableView tableColumns][0]]){
        NSTextField * textField = (NSTextField *)cell;
        [textField setStringValue: [f name]];
        [textField setAction:@selector(tableViewEditNameColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][1]]){
        NSComboBox * comboBox = (NSComboBox *)cell;
        
        [comboBox removeAllItems];
        [comboBox addItemsWithObjectValues:[comboBoxDataSource subarrayWithRange: NSMakeRange(0, 6)] ];
        [comboBox setStringValue:comboBoxDataSource[[f type]]];

        [comboBox setAction:@selector(tableViewEditTypeColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][2]]){
        NSTextField * textField = (NSTextField *)cell;
        [textField setStringValue: [[NSString alloc]initWithFormat:@"%.2f",[f aValue]]];
        [textField setAction:@selector(tableViewEditAValueColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][3]]){
        NSTextField * textField = (NSTextField *)cell;
        [textField setStringValue: [[NSString alloc]initWithFormat:@"%.2f",[f bValue]]];
        [textField setAction:@selector(tableViewEditBValueColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][4]]){
        NSTextField * textField = (NSTextField *)cell;
        if([f type] == PARABOLA){
            [textField setStringValue: [[NSString alloc]initWithFormat:@"%.2f",[f cValue]]];
            [textField setEnabled: YES];
        }else{
            [textField setStringValue: @"-"];
            [textField setEnabled: NO];
        }
        [textField setAction:@selector(tableViewEditCValueColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][5]]){
        NSColorWell * colorWell = (NSColorWell *)cell;
        [colorWell setColor:[f color]];
        [colorWell setAction:@selector(tableViewEditColorColumn:)];
    }
    
    return cell;
}

/**
 *  @brief The following methods, are the action executed when
 *          a tableView cell is edited.
 */-(IBAction)tableViewEditNameColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    NSTextField * tf = sender;
    
    row = [tf tag];
    
    f = [model getFunctionWithIndex:(int)row];
    [f setName: [tf stringValue] ];
    [model updateFunction:f];
}
-(IBAction)tableViewEditTypeColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    NSComboBox * cb = sender;
    
    row = [cb tag];
    
    f = [model getFunctionWithIndex:(int)row];
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
    
    f = [model getFunctionWithIndex:(int)row];
    [f setAValue: [tf floatValue] ];
    [model updateFunction:f];
}
-(IBAction)tableViewEditBValueColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    NSTextField * tf = sender;
    
    row = [tf tag];
    
    f = [model getFunctionWithIndex:(int)row];
    [f setBValue: [tf floatValue] ];
    [model updateFunction:f];
}
-(IBAction)tableViewEditCValueColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    NSTextField * tf = sender;
    
    row = [tf tag];
    
    f = [model getFunctionWithIndex:(int)row];
    
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
    
    f = [model getFunctionWithIndex:(int)row];
    [f setColor: [colorWell color] ];
    [model updateFunction:f];
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return [model count];
}

//----------------Graphic logic--------------------
/**
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
    if(nil == addFunctionUIController)
        addFunctionUIController = [[AddFunctionUIController alloc] initWithComboBoxDataSource:comboBoxDataSource];
    [addFunctionUIController showWindow:self];
}

/**
 *  @brief removes the selected function from model in tableView.
 */
-(IBAction)removeFunction:(id)sender{
    NSInteger row;
    Function * f = nil;
    
    row = [functionTableView selectedRow];
    if(-1 == row) return;
    
    f = [model getFunctionWithIndex:(int)row];
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
 *  @brief take the selected items on tableView and send them to
 *          the representation panel to be represented.
 */
-(IBAction)representSelectedFunctions:(id)sender{
    NSMutableArray * aFunctionArray = nil;
    NSIndexSet * indexesOfselectedFunctions = nil;
    NSDictionary * aDictionary = nil;
    NSNotificationCenter * aNotificationCenter = nil;
    
    indexesOfselectedFunctions = [functionTableView selectedRowIndexes];
    
    aFunctionArray = [[NSMutableArray alloc] init];
    [[functionTableView selectedRowIndexes] enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
       [ aFunctionArray addObject:[self->model getFunctionWithIndex:(int)index] ];
    }];
    
    aNotificationCenter = [NSNotificationCenter defaultCenter];
    aDictionary = [NSDictionary dictionaryWithObject: aFunctionArray
                                              forKey:@"representationArray"];
    [aNotificationCenter postNotificationName:sendNewRepresentation
                                       object:self
                                     userInfo:aDictionary];
}

/**
 * @brief checks the settings formulary is completed and the values are correct.
 */
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
    
    BOOL areValuesSemanticallyCorrect = (
                        areNumberTextFieldsCorrectlyFilled //To avoid crash if numbers aren't correctly filled
                        && [xminTextField doubleValue] < [xmaxTextField doubleValue]
                        && [yminTextField doubleValue] < [ymaxTextField doubleValue]);
    
    
    return (areAllFilled && areNumberTextFieldsCorrectlyFilled && areValuesSemanticallyCorrect);
}

//----------------Bussines logic-------------------
/**
 * @brief reload tableView to show external changes in model.
 */
-(void) reloadData{
    [functionTableView reloadData];
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
