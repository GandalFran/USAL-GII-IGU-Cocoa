//
//  FunctionTableUIController.h
//  MacLab
//
//  Created by GandalFran on 13/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Model;

NS_ASSUME_NONNULL_BEGIN

@interface FunctionTableUIController : NSObject{
    
    IBOutlet NSTextField * xminTextField;
    IBOutlet NSTextField * xmaxTextField;
    IBOutlet NSTextField * yminTextField;
    IBOutlet NSTextField * ymaxTextField;
    
    Model * model;
}

-(IBAction)setNewRepresentationParameters:(id)sender;

-(IBAction)addFunction:(id)sender;
-(IBAction)deleteAllElements:(id)sender;
-(IBAction)resetZoom:(id)sender;

@end

NS_ASSUME_NONNULL_END
