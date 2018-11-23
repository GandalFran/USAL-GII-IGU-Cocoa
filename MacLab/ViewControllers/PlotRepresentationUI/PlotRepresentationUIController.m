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

@interface PlotRepresentationUIController(){
    Model * model;
    FunctionTableUIController * functionTableUIController;
}
@end

@implementation PlotRepresentationUIController

//----------------Initializers---------------------
-(id) init {
    self = [super init];
    
    if(nil == self)
        return nil;
    
    //Instance model
    model =[[Model alloc] init];
    
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

//-----------------Finalizers----------------------
-(void)dealloc {
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

//----------------Notifications--------------------

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

//------------------Delegation---------------------


//----------------Graphic logic--------------------

/**
 *  @brief Displays a panel to let the user select a path to export the
 *          representation as image, and if an error occurs, let the user
 *          know.
 */
-(IBAction)exportPanel:(id)sender{
    bool IOResult = NO;
    
    //TODO implement
    
    if(NO == IOResult){
        NSAlert * alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Error"];
        [alert setInformativeText:@"Image couldn't be exported."];
        [alert addButtonWithTitle:@"ok"];
        [alert setAlertStyle:NSAlertStyleCritical];
        [alert runModal];
        return;
    }
}

//https://stackoverflow.com/questions/1640419/open-file-dialog-box
/**
 *  @brief Displays a panel to let the user select a path to export the model data,
 *          and if an error occurs, let the user know.
 */
-(IBAction)exportProject:(id)sender{
    bool IOresult;
    NSInteger result;
    NSString * path = nil;
    NSSavePanel * panel = nil;
    
    if([model count] == 0){
        NSAlert * alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Error"];
        [alert setInformativeText:@"To export the project must be declared fucntions."];
        [alert addButtonWithTitle:@"ok"];
        [alert setAlertStyle:NSAlertStyleCritical];
        [alert runModal];
        return;
    }
    
    panel = [NSSavePanel savePanel];
    [panel setAllowsOtherFileTypes:NO];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:NO];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"bin"]];
    [panel setTitle:@"Save project"];
    result = [panel runModal];
    
    if (NSModalResponseOK == result) {
        path = [[panel URL] path];
        NSLog(@"\n\n%@",path);
        IOresult = [model exportFile: path];
        if(!IOresult){
            NSAlert * alert = [[NSAlert alloc] init];
            [alert setMessageText:@"Error"];
            [alert setInformativeText:@"Data couldn't be exported."];
            [alert addButtonWithTitle:@"ok"];
            [alert setAlertStyle:NSAlertStyleCritical];
            [alert runModal];
            return;
        }else{
            [functionTableUIController reloadData];
        }
    }
    
}

/**
 *  @brief Displays a panel to let the user select a path to import a project,
 *          and if an error occurs, let the user know.
 */
-(IBAction)importProject:(id)sender{
    bool IOresult;
    NSInteger result;
    NSString * path = nil;
    NSOpenPanel * panel = nil;
    
    panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"bin"]];
    [panel setTitle:@"Open project"];
    [panel setAllowsMultipleSelection:NO];
    result = [panel runModal];
    
    if (NSModalResponseOK == result) {
        
        path = [[panel URL] path];
        NSLog(@"\n\n%@",path);
        IOresult = [model importFile: path];
        if(!IOresult){
            NSAlert * alert = [[NSAlert alloc] init];
            [alert setMessageText:@"Error"];
            [alert setInformativeText:@"Data couldn't be imported."];
            [alert addButtonWithTitle:@"ok"];
            [alert setAlertStyle:NSAlertStyleCritical];
            [alert runModal];
            return;
        }else{
            [functionTableUIController reloadData];
        }
    
    }
}

/**
 *  @brief Shows the functionTable panel (preferences panel)
 */
-(IBAction)showFunctionTablePanel:(id)sender{
    if(nil == functionTableUIController)
        functionTableUIController = [[FunctionTableUIController alloc] initWithModel: model];
    [functionTableUIController showWindow:self];
}

//----------------Bussines logic-------------------

/**
 *  @brief Represent a set of functions
 */
-(void) addRepresentationWithFunctionArray: (NSArray *) aFunctionArray{
    NSLog(@"\n\n%@",aFunctionArray);
}

@end
