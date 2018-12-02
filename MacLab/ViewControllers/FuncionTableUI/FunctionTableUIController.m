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
    double xmin,xmax,ymin,ymax;
    AddFunctionUIController * addFunctionUIController;
}

- (BOOL) isSettingsFormCompleted;

@end


@implementation FunctionTableUIController

//----------------Initializers---------------------
-(id) initWithXminValue:(double) aXmin
          xmaxValue:(double) aXmax
          yminValue:(double) aYmin
          ymaxValue:(double) aYmax
{
    if(nil == [super initWithWindowNibName:@"FunctionTableUI"])
        return nil;
    
    //Save settings values
    xmin = aXmin;
    xmax = aXmax;
    ymin = aYmin;
    ymax = aYmax;
    
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
    [NSApp terminate:self];
    return YES;
}

-(void) awakeFromNib{
    [xminTextField setDoubleValue:xmin];
    [xmaxTextField setDoubleValue:xmax];
    [yminTextField setDoubleValue:ymin];
    [ymaxTextField setDoubleValue:ymax];
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
NSString * representationChanged = @"representationChanged";
NSString * sendNewParameters = @"sendNewParameters";
extern NSString * functionAdded;

/**
 *  @brief handler for functionAdded notification:
 *              saves the function in model, and reloads the view
 */
-(void) handlFunctionAdded:(NSNotification *)aNotification{
    NSNotificationCenter * aNotificationCenter = nil;
    
    [functionTableView reloadData];
    
    //send to reload representation data
    aNotificationCenter = [NSNotificationCenter defaultCenter];
    [aNotificationCenter postNotificationName:representationChanged object:self];
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
    Function * f = nil;
    Model * model = nil;
    
    
    model = [Model defaultModel];
    f = [model getFunctionWithIndex:(int)row];
    
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
        [comboBox addItemsWithObjectValues:[[Function functionTypeAsStringValues] subarrayWithRange: NSMakeRange(0, 6)]];
        [comboBox setStringValue:[Function functionTypeAsStringValues][[f type]]];

        [comboBox setAction:@selector(tableViewEditTypeColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][2]]){
        NSTextField * textField = (NSTextField *)cell;
        [textField setFormatter:formatter];
        [textField setDoubleValue:[f aValue]];
        [textField setAction:@selector(tableViewEditAValueColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][3]]){
        NSTextField * textField = (NSTextField *)cell;
        [textField setFormatter:formatter];
        [textField setDoubleValue:[f bValue]];
        [textField setAction:@selector(tableViewEditBValueColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][4]]){
        NSTextField * textField = (NSTextField *)cell;
        if([f type] == PARABOLA){
            [textField setFormatter:formatter];
            [textField setDoubleValue:[f cValue]];
            [textField setEnabled: YES];
        }else{
            [textField setFormatter:nil];
            [textField setStringValue: @"-"];
            [textField setEnabled: NO];
        }
        [textField setAction:@selector(tableViewEditCValueColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][5]]){
        NSColorWell * colorWell = (NSColorWell *)cell;
        [colorWell setColor:[f color]];
        [colorWell setAction:@selector(tableViewEditColorColumn:)];
    }else if([tableColumn isEqual:[tableView tableColumns][6]]){
        NSButton * checkBox = (NSButton *)cell;
        [checkBox setState: ([f visible] ? NSControlStateValueOn:NSControlStateValueOff)];
        [checkBox setAction:@selector(tableViewEditVisibilityColumn:)];
    }
    
    return cell;
}

/**
 *  @brief The following methods, are the action executed when
 *          a tableView cell is edited.
 */-(IBAction)tableViewEditNameColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    Model * model = nil;
    NSTextField * tf = sender;
     
    row = [tf tag];
    
    model = [Model defaultModel];
    f = [model getFunctionWithIndex:(int)row];
    [f setName: [tf stringValue] ];
    [model updateFunction:f atIndex:(int)row];

}
-(IBAction)tableViewEditTypeColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    Model * model = nil;
    NSComboBox * cb = sender;
    NSNotificationCenter * aNotificationCenter = nil;
    
    row = [cb tag];
    
    model = [Model defaultModel];
    f = [model getFunctionWithIndex:(int)row];
    [f setType:(FunctionType)[cb indexOfSelectedItem]];
    if([f type] != PARABOLA)
        [f setCValue:0];
    
    [model updateFunction:f atIndex:(int)row];
    
    //here the data is reloaded because if is selected or deselected the PARABOLA
    //  the c value should be changed
    [functionTableView reloadData];
    
    if([f visible] == true){
        //send to reload representation data
        aNotificationCenter = [NSNotificationCenter defaultCenter];
        [aNotificationCenter postNotificationName:representationChanged object:self];
    }
}
-(IBAction)tableViewEditAValueColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    Model * model = nil;
    NSTextField * tf = sender;
    NSNotificationCenter * aNotificationCenter = nil;
    
    
    row = [tf tag];
    
    model = [Model defaultModel];
    f = [model getFunctionWithIndex:(int)row];
    [f setAValue: [tf doubleValue] ];
    [model updateFunction:f atIndex:(int)row];
    
    if([f visible] == true){
        //send to reload representation data
        aNotificationCenter = [NSNotificationCenter defaultCenter];
        [aNotificationCenter postNotificationName:representationChanged object:self];
    }
}
-(IBAction)tableViewEditBValueColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    Model * model = nil;
    NSTextField * tf = sender;
    NSNotificationCenter * aNotificationCenter = nil;
    
    row = [tf tag];
    model = [Model defaultModel];
    f = [model getFunctionWithIndex:(int)row];
    [f setBValue: [tf doubleValue] ];
    [model updateFunction:f atIndex:(int)row];
    
    if([f visible] == true){
        //send to reload representation data
        aNotificationCenter = [NSNotificationCenter defaultCenter];
        [aNotificationCenter postNotificationName:representationChanged object:self];
    }
}
-(IBAction)tableViewEditCValueColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    Model * model = nil;
    NSTextField * tf = sender;
    NSNotificationCenter * aNotificationCenter = nil;
    
    row = [tf tag];
    
    model = [Model defaultModel];
    f = [model getFunctionWithIndex:(int)row];
    
    if([f type] == PARABOLA){
        [f setCValue: [tf doubleValue] ];
        [model updateFunction:f atIndex:(int)row];
        
        if([f visible] == true){
            //send to reload representation data
            aNotificationCenter = [NSNotificationCenter defaultCenter];
            [aNotificationCenter postNotificationName:representationChanged object:self];
        }
    }
    
    //here the data is reloaded because if is selected or deselected the PARABOLA
    //  the c value has different treatement
    [functionTableView reloadData];
}
-(IBAction)tableViewEditColorColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    Model * model = nil;
    NSColorWell * colorWell = sender;
    NSNotificationCenter * aNotificationCenter = nil;
    
    row = [colorWell tag];
    
    model = [Model defaultModel];
    f = [model getFunctionWithIndex:(int)row];
    [f setColor: [colorWell color] ];
    [model updateFunction:f atIndex:(int)row];
    
    if([f visible] == true){
        //send to reload representation data
        aNotificationCenter = [NSNotificationCenter defaultCenter];
        [aNotificationCenter postNotificationName:representationChanged object:self];
    }
}
-(IBAction)tableViewEditVisibilityColumn:(id)sender{
    NSInteger row;
    Function * f = nil;
    Model * model = nil;
    NSButton * checkBox = sender;
    NSNotificationCenter * aNotificationCenter = nil;
    
    row = [checkBox tag];
    
    model = [Model defaultModel];
    f = [model getFunctionWithIndex:(int)row];
    [f setVisible: ( [checkBox state] == NSControlStateValueOn) ];
    [model updateFunction:f atIndex:(int)row];
    
    aNotificationCenter = [NSNotificationCenter defaultCenter];
    [aNotificationCenter postNotificationName:representationChanged object:self];
}


-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    Model * model = [Model defaultModel];
    return [model count];
}

//----------------Graphic logic--------------------
/**
 * @brief takes the representation parameters and then, posts a notification with it
 */
-(IBAction)setNewRepresentationParameters:(id)sender{
    NSNumber * xmin = nil, * xmax = nil, * ymin = nil, * ymax = nil;
    NSDictionary * notificationInfo = nil;
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    
    xmin = [NSNumber numberWithDouble:[xminTextField doubleValue]];
    xmax = [NSNumber numberWithDouble:[xmaxTextField doubleValue]];
    ymin = [NSNumber numberWithDouble:[yminTextField doubleValue]];
    ymax = [NSNumber numberWithDouble:[ymaxTextField doubleValue]];
    
    notificationInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:xmin,xmax,ymin,ymax,nil]
                                                   forKeys:[NSArray arrayWithObjects:@"xmin",@"xmax",@"ymin",@"ymax",nil]];
    [notificationCenter postNotificationName:sendNewParameters
                                      object:nil
                                    userInfo:notificationInfo];
}

/**
 *  @brief displays the addFunction formulary when the addFunction button is pushed
 */
-(IBAction)showAddFunctionPanel:(id)sender{
    if(nil == addFunctionUIController)
        addFunctionUIController = [[AddFunctionUIController alloc] init];
    [addFunctionUIController showWindow:self];
}

/**
 *  @brief removes the selected function from model in tableView.
 */
-(IBAction)removeFunction:(id)sender{
    int i;
    Model * model = nil;
    NSMutableArray * indexArray = nil;
    NSIndexSet * indexesOfselectedFunctions = nil;
    NSNotificationCenter * aNotificationCenter = nil;
    
    indexesOfselectedFunctions = [functionTableView selectedRowIndexes];
    if(nil == indexesOfselectedFunctions || [indexesOfselectedFunctions count] == 0)
        return;
    
    indexArray = [[NSMutableArray alloc] init];
    [indexesOfselectedFunctions enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        [indexArray addObject: [NSNumber numberWithInt:(int)index]];
    }];
    
    model = [Model defaultModel];
    for(i=(int)([indexArray count]-1); i>=0; i--){
        [model removeFunctionWithIndex:(int)[indexArray[i] integerValue]];
    }
    
    [functionTableView reloadData];
    
    //send to reload representation data
    aNotificationCenter = [NSNotificationCenter defaultCenter];
    [aNotificationCenter postNotificationName:representationChanged object:self];
}

/**
 *  @brief removes all elements from model
 */
-(IBAction)removeAllModelElements:(id)sender{
    Model * model = [Model defaultModel];
    NSNotificationCenter * aNotificationCenter = nil;
    
    [model removeAllFunctions];
    [functionTableView reloadData];
    
    //send to reload representation data
    aNotificationCenter = [NSNotificationCenter defaultCenter];
    [aNotificationCenter postNotificationName:representationChanged object:self];
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
    Model * model = nil;
    NSString * name = nil;
    NSColor * color = nil;
    FunctionType type;
    float a,b,c;
    
    model = [Model defaultModel];
    
    int i;
    for(i=0; i<5; i++){
        name = [[NSString alloc] initWithFormat: @"FunctionNumber%d",i];
        type = arc4random_uniform(6);
        color = [NSColor colorWithRed: ((float)arc4random_uniform(100))/100 green:((float)arc4random_uniform(100))/100 blue:((float)arc4random_uniform(100))/100 alpha:1.0];
        a = ((double)arc4random_uniform(100))/10;
        b = ((double)arc4random_uniform(100))/10;
        c = ((double)arc4random_uniform(100))/10;
        
        f = [[Function alloc] initWithName:name color:color ExpressionType:type ExpressionAValue:a ExpressionBValue:b ExpressionCValue:c];
        [model addFunction: f];
    }
    
    [functionTableView reloadData];
    
    NSNotificationCenter * aNotificationCenter = [NSNotificationCenter defaultCenter];
    [aNotificationCenter postNotificationName:representationChanged object:self];
}

@end
