//
//  FunctionTableUIController.m
//  MacLab
//
//  Created by GandalFran on 13/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import "Model.h"
#import "FunctionTableUIController.h"

@implementation FunctionTableUIController

-(IBAction)setNewRepresentationParameters:(id)sender{
    RepresentationParameters new;
    
    new.xmin = [xminTextField doubleValue];
    new.xmax = [xmaxTextField doubleValue];
    new.ymin = [yminTextField doubleValue];
    new.ymax = [ymaxTextField doubleValue];
    
    [model setRepresentationParameters:new];
}

-(IBAction)addFunction:(id)sender{
    //Throw add window and give it the model
}

-(IBAction)deleteAllElements:(id)sender{
    [model removeAllFunctions];
}

-(IBAction)resetZoom:(id)sender{
    
}

@end
