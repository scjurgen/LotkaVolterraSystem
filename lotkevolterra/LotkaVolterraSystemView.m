//
//  LotkaVolterraSystemView.m
//  lotkavolterra
//
//  Created by Schwietering, Jürgen on 23.11.13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "LotkaVolterraSystemView.h"
#import "LotkaVolterraModel.h"

#include <sys/stat.h>



@implementation LotkaVolterraSystemView

- (id)init
{
    self = [super init];
    if (self)
    {
        zoomY = 5.0;
        zoomX = 5.0;
    }
    return self;
}

- (void)awakeFromNib
{
    [_solvingProblems1 setStringValue:@"0.0009"];
    [_solvingProblems2 setStringValue:@"0.0005"];
    [_helpOtherTeam1 setStringValue:@"0.0004"];
    [_helpOtherTeam2 setStringValue:@"0.0"];
    [_memoryLoss1 setStringValue:@"0.005"];
    [_memoryLoss2 setStringValue:@"0.005"];
    [_problemsRate1 setStringValue:@"0.005"];
    [_problemsRate2 setStringValue:@"0.005"];
    [_openDocumentMenuItem setEnabled:YES];
    
}

- (NSDictionary *)getCurrentValuesAsDictionary
{
    NSDictionary *dict=@{
                         @"solveTeam1":[NSNumber numberWithDouble: [_solvingProblems1.stringValue doubleValue]],
                         @"solveTeam2":[NSNumber numberWithDouble: [_solvingProblems2.stringValue doubleValue]],
                         @"solveTeam1of2":[NSNumber numberWithDouble: [_helpOtherTeam1.stringValue doubleValue]],
                         @"solveTeam2of1":[NSNumber numberWithDouble: [_helpOtherTeam2.stringValue doubleValue]],
                         @"forgetRate1":[NSNumber numberWithDouble: [_memoryLoss1.stringValue doubleValue]],
                         @"forgetRate2":[NSNumber numberWithDouble: [_memoryLoss2.stringValue doubleValue]],
                         @"moreProblemsRate1":[NSNumber numberWithDouble: [_problemsRate1.stringValue doubleValue]],
                         @"moreProblemsRate2":[NSNumber numberWithDouble: [_problemsRate2.stringValue doubleValue]],
                         };
    return dict;

}

- (void)calculateSystem
{
    LotkaVolterraModel *lvm = [[LotkaVolterraModel alloc] init];
    NSDictionary *dict=[self getCurrentValuesAsDictionary];
    [lvm setValues:dict];

    //[_remain1Solve setStringValue:[NSString stringWithFormat:@"%f", lvm.solveTeam1]];
    //[_remain2Solve setStringValue:[NSString stringWithFormat:@"%f", lvm.solveTeam2]];
    
    NSImage* anImage = [[NSImage alloc] initWithSize:NSMakeSize(_systemImage.frame.size.width, _systemImage.frame.size.height)];
    [anImage lockFocus];
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    CGFloat componentsKnowledge[] = {0.1, 0.0, 0.5, 1.0};
    CGFloat componentsProblems[] = {0.5, 0.0, 0.0, 1.0};
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat lineWidth = ((int)(_systemImage.frame.size.height/100.0))+1.0;
    [lvm run:_systemImage.frame.size.width*zoomX+1]; // for last items one more
    LVVECTOR nextVal,simVal;
    
    for (int x=0; x < _systemImage.frame.size.width*zoomX; x++)
    {
        [lvm.timeseries getItem:x val:&simVal];
        [lvm.timeseries getItem:x+1 val:&nextVal];
        CGColorRef coluse=CGColorCreate(colorspace, componentsKnowledge);
        CGContextSetStrokeColorWithColor(ctx, coluse);
        
        CGContextBeginPath(ctx);

        CGContextMoveToPoint(ctx, x/zoomX, simVal.team[0].knowledge*zoomY);
        CGContextAddLineToPoint(ctx, x/zoomX, nextVal.team[0].knowledge*zoomY);
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextStrokePath(ctx);
        
        coluse=CGColorCreate(colorspace, componentsProblems);
        CGContextSetStrokeColorWithColor(ctx, coluse);
        
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, x/zoomX, simVal.team[0].problems*zoomY);
        CGContextAddLineToPoint(ctx, x/zoomX, nextVal.team[0].problems*zoomY);
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextStrokePath(ctx);
    }
    [anImage unlockFocus];
    _systemImage.image=anImage;
    
    anImage = [[NSImage alloc] initWithSize:NSMakeSize(_systemImage.frame.size.width, _systemImage.frame.size.height)];
    [anImage lockFocus];
    ctx = [[NSGraphicsContext currentContext] graphicsPort];
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    for (int x=0; x < _systemImage.frame.size.width*zoomX; x++)
    {
        [lvm.timeseries getItem:x val:&simVal];
        [lvm.timeseries getItem:x+1 val:&nextVal];
        CGColorRef coluse=CGColorCreate(colorspace, componentsKnowledge);
        CGContextSetStrokeColorWithColor(ctx, coluse);
        
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, x/zoomX, simVal.team[1].knowledge*zoomY);
        CGContextAddLineToPoint(ctx, x/zoomX, nextVal.team[1].knowledge*zoomY);
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextStrokePath(ctx);
        
        coluse=CGColorCreate(colorspace, componentsProblems);
        CGContextSetStrokeColorWithColor(ctx, coluse);
        
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, x/zoomX, simVal.team[1].problems*zoomY);
        CGContextAddLineToPoint(ctx, x/zoomX, nextVal.team[1].problems*zoomY);
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextStrokePath(ctx);
    }
    
    [anImage unlockFocus];
    _system2Image.image=anImage;
}

- (IBAction)buttonClick:(id)sender {
    [self calculateSystem];
}

- (IBAction)horizontalChanged:(NSSlider*)slider {
    zoomX=[slider.stringValue doubleValue];
    [self calculateSystem];
}

- (IBAction)verticalChanged:(NSSlider*)slider {
    zoomY=[slider.stringValue doubleValue];
    [self calculateSystem];
}




- (NSString *)diskCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    // need to create the path
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"cache"];
    NSLog(@"%@",dbPath);
    mkdir([dbPath UTF8String],0755);
    return dbPath;
}


- (NSString *)diskCachePathWithComponent:(NSString *)filename
{
    NSString *cachePath=[self diskCachePath];
    return [cachePath stringByAppendingPathComponent:filename];
}


- (IBAction)loadDocument:(id)sender;
{

    NSArray *types = @[@".lkvt"];
    [[NSOpenPanel openPanel] setAllowsMultipleSelection:NO];
    [[NSOpenPanel openPanel] setAllowedFileTypes:types];
    if ([[NSOpenPanel openPanel] runModal] == NSFileHandlingPanelOKButton)
    {
        
        NSURL *fname = [[NSOpenPanel openPanel] URL];
        NSLog(@"%@",fname);
        
//        NSArchiver *stream = [[NSUnarchiver alloc] initForReadingWithData:[NSData dataWithContentsOfFile:aFilename]];
    }

}

- (IBAction)saveDocumentAs:(id)sender;
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"/"];
    if (path != nil)
        [savePanel setDirectoryURL:[NSURL fileURLWithPath:path]];
    [savePanel setAllowedFileTypes:@[@"mxml"]];
    //[savePanel setNameFieldStringValue:[self.filename lastPathComponent]];
    if ([savePanel runModal] == NSFileHandlingPanelOKButton) {
        
        // [[NSUserDefaults standardUserDefaults] setObject:[[savePanel directoryURL] path] forKey:MDK_MonetFileDirectory];
//        
//        NSString *newFilename = [[savePanel URL] path];
//        
//        BOOL result = [model writeXMLToFile:newFilename comment:nil];
//        
//        if (result == NO)
//            NSRunAlertPanel(@"Save Failed", @"Couldn't save document to %@", @"OK", nil, nil, self.filename);
//        else {
//            [self setFilename:newFilename];
//            NSLog(@"Saved file: %@", newFilename);
//        }
    }
}


- (IBAction)saveDocument:(id)sender {
	[self saveDataToDisk:@"default.knots"];
}

- (IBAction)revertDocument:(id)sender {
    [self loadDataFromDisk:@"default.knots"];
    [self calculateSystem];
}

- (void)initWithDict:(NSDictionary*)dict
{
    [_solvingProblems1 setStringValue:dict[@"solvingProblems1"]];
    [_solvingProblems2 setStringValue:dict[@"solvingProblems1"]];
    [_helpOtherTeam1 setStringValue:dict[@"helpOtherTeam1"]];
    [_helpOtherTeam2 setStringValue:dict[@"helpOtherTeam2"]];
    [_memoryLoss1 setStringValue:dict[@"memoryLoss1"]];
    [_memoryLoss2 setStringValue:dict[@"memoryLoss2"]];
    [_problemsRate1 setStringValue:dict[@"problemsRate1"]];
    [_problemsRate2 setStringValue:dict[@"problemsRate2"]];
}

- (void)saveDataToDisk:(NSString*)fname
{
    NSString *path=[self diskCachePathWithComponent:fname];
    NSDictionary *dict = [self getCurrentValuesAsDictionary];
    [NSKeyedArchiver archiveRootObject:dict toFile:path];
}

- (void)loadDataFromDisk:(NSString*)fname
{
    NSString *path=[self diskCachePathWithComponent:fname];
    [self initWithDict:[NSKeyedUnarchiver unarchiveObjectWithFile:path]];

}

- (void)windowDidResize:(NSNotification *)note
{
    if (_systemImage.frame.size.width)
    {
        [self calculateSystem];
        
    }
}

@end
