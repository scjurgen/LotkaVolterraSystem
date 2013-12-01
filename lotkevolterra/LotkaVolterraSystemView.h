//
//  LotkaVolterraSystemView.h
//  lotkavolterra
//
//  Created by Schwietering, Jürgen on 23.11.13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "FormularWebView.h"

@interface LotkaVolterraSystemView : NSView
{
    double zoomX, zoomY;
}
@property (weak) IBOutlet NSMenuItem *openDocumentMenuItem;
@property (weak) IBOutlet NSImageView *systemImage;
@property (weak) IBOutlet NSImageView *system2Image;

@property (weak) IBOutlet NSTextField *solvingProblems1;
@property (weak) IBOutlet NSTextField *helpOtherTeam1;
@property (weak) IBOutlet NSTextField *memoryLoss1;
@property (weak) IBOutlet NSTextField *problemsRate1;
@property (weak) IBOutlet NSTextField *remain1Solve;

@property (weak) IBOutlet NSTextField *solvingProblems2;
@property (weak) IBOutlet NSTextField *helpOtherTeam2;
@property (weak) IBOutlet NSTextField *memoryLoss2;
@property (weak) IBOutlet NSTextField *problemsRate2;
@property (weak) IBOutlet NSTextField *remain2Solve;
@property (weak) IBOutlet FormularWebView *formularWebView;

- (IBAction)buttonClick:(id)sender;

- (IBAction)horizontalChanged:(id)sender;
- (IBAction)verticalChanged:(id)sender;
- (IBAction)saveDocument:(id)sender;
- (IBAction)revertDocument:(id)sender;

@end
