//
//  PlotRepresentationUIController.m
//  MacLab
//
//  Created by GandalFran on 10/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Model.h"
#import "Function.h"
#import "NSPlotView.h"

#import "FunctionTableUIController.h"
#import "PlotRepresentationUIController.h"

@interface PlotRepresentationUIController(){
    FunctionTableUIController * functionTableUIController;
}
@end

@implementation PlotRepresentationUIController

//----------------Initializers---------------------
-(id) init {
    self = [super init];
    
    if(nil == self)
        return nil;
    
    //instance and throw secondary panel
    functionTableUIController = [[FunctionTableUIController alloc] initWithXminValue:-10.0
                                                                               xmaxValue:10.0
                                                                               yminValue:-10.0
                                                                               ymaxValue:10.0];
    [functionTableUIController showWindow:self];
    
    //register the handle for terminate app notification
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleReloadRepresentation:)
                               name:representationChanged
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(handleAddNewParameters:)
                               name:sendNewParameters
                             object:nil];
    
    //set hidden the corrdinates label
    [coordinatesLabel setHidden:YES];
    
    
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

extern NSString * representationChanged;
extern NSString * sendNewParameters;

/**
 *  @brief handler for the representationChanged notification:
 *          refreshes the representation content
 */
-(void) handleReloadRepresentation:(NSNotification *)aNotification{
    [plotView reloadData];
}

/**
 *  @brief handler for the sendNewParameters notification:
 *          sets the values for xmin,xmax,ymin and ymax
 */
-(void) handleAddNewParameters:(NSNotification *)aNotification{
    NSRect parameters;
    NSDictionary * aDictionary = nil;
    NSNumber * aXmin = nil, * aXmax = nil, * aYmin = nil, * aYmax = nil;
    
    aDictionary = [aNotification userInfo];
    aXmin = [aDictionary objectForKey:@"xmin"];
    aXmax = [aDictionary objectForKey:@"xmax"];
    aYmin = [aDictionary objectForKey:@"ymin"];
    aYmax = [aDictionary objectForKey:@"ymax"];
    
    parameters.origin.x = [aXmin doubleValue];
    parameters.origin.y = [aYmin doubleValue];
    parameters.size.width = [aXmax doubleValue] - [aXmin doubleValue];
    parameters.size.height = [aYmax doubleValue] - [aYmin doubleValue];
    
    [plotView setParameters: parameters];
}

//------------------Delegation---------------------

- (NSInteger) numberOfElements{
    Model * model = [Model defaultModel];
    return [model count] + 1;
}

-  (void) plotView:(NSPlotView *)aPlotView drawElement:(NSInteger) element inBoudns:(NSRect)bounds withParameters:(NSRect)parameters withGraphicsContext:(NSGraphicsContext *)aGraphicContext{
    Function * f = nil;
    Model * model = [Model defaultModel];
    
    f = [model getFunctionAtIndex:(int)(element-1)];
    [f drawInBounds:bounds withParameters:parameters withGraphicsContext:aGraphicContext];
}

-(void)mouseEnteredInPlotView:(NSPlotView *) plotView{
    [coordinatesLabel setHidden:NO];
}
-(void)mouseMovedIntPlotView:(NSPlotView *) plotView AtX:(double)x Y:(double)y{
    [coordinatesLabel setStringValue:[[NSString alloc] initWithFormat:@"X:%.2f Y:%.2f",x,y] ];
}
-(void)mouseExitedInPlotView:(NSPlotView *) plotView{
    [coordinatesLabel setHidden:YES];
}

//----------------Graphic logic--------------------

/**
 *  @brief Displays a panel to let the user select a path to export the
 *          representation as image, and if an error occurs, let the user
 *          know.
 */
-(IBAction)exportPanel:(id)sender{
    bool IOresult;
    NSInteger result;
    NSString * path = nil;
    NSSavePanel * panel = nil;
    
    panel = [NSSavePanel savePanel];
    [panel setAllowsOtherFileTypes:NO];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:NO];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"png"]];
    [panel setTitle:@"Save image"];
    result = [panel runModal];
    
    if (NSModalResponseOK == result) {
        path = [[panel URL] path];
        IOresult = [plotView exportViewToPath: path];
        if(!IOresult){
            NSAlert * alert = [[NSAlert alloc] init];
            [alert setMessageText:@"Error"];
            [alert setInformativeText:@"Image couldn't be exported."];
            [alert addButtonWithTitle:@"ok"];
            [alert setAlertStyle:NSAlertStyleCritical];
            [alert runModal];
            return;
        }
    }
    
}

/**
 *  @brief Displays a panel to let the user select a path to export the model data,
 *          and if an error occurs, let the user know.
 *  @see https://stackoverflow.com/questions/1640419/open-file-dialog-box
 */
-(IBAction)exportProject:(id)sender{
    bool IOresult;
    NSInteger result;
    NSString * path = nil;
    NSSavePanel * panel = nil;
    Model * model = [Model defaultModel];
    
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
        IOresult = [model exportFile: path];
        if(!IOresult){
            NSAlert * alert = [[NSAlert alloc] init];
            [alert setMessageText:@"Error"];
            [alert setInformativeText:@"Data couldn't be exported."];
            [alert addButtonWithTitle:@"ok"];
            [alert setAlertStyle:NSAlertStyleCritical];
            [alert runModal];
            return;
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
    Model * model = [Model defaultModel];
    
    panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"bin"]];
    [panel setTitle:@"Open project"];
    [panel setAllowsMultipleSelection:NO];
    result = [panel runModal];
    
    if (NSModalResponseOK == result) {
        
        path = [[panel URL] path];
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
            [plotView reloadData];
            [functionTableUIController reloadData];
        }
    
    }
}

-(IBAction)resetZoom:(id)sender{
    [plotView resetZoom];
}


@end
