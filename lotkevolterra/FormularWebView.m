//
//  FormularWebView.m
//  lotkevolterra
//
//  Created by Schwietering, Jürgen on 01.12.13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "FormularWebView.h"

typedef enum
{
    MLELEMENTTYPE_NUMBER,
    MLELEMENTTYPE_OPERATOR,
    MLELEMENTTYPE_I
}MLELEMENTTYPE;


@implementation FormularWebView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}


+ (MLELEMENTTYPE)elementType:(NSString *)item
{
    NSError *regError;
    NSRegularExpression *regex;
    regex = [NSRegularExpression regularExpressionWithPattern:@"^[-+][0-9.E]+$"
                                                      options:NSRegularExpressionAnchorsMatchLines
                                                        error:&regError];
    if ([regex numberOfMatchesInString:item
                               options:NSMatchingAnchored
                                 range:NSMakeRange(0, [item length])])
    {
        return MLELEMENTTYPE_NUMBER;
    }
    regex = [NSRegularExpression regularExpressionWithPattern:@"^[-+/*]$"
                                                      options:NSRegularExpressionAnchorsMatchLines
                                                        error:&regError];
    if ([regex numberOfMatchesInString:item
                               options:NSMatchingAnchored
                                 range:NSMakeRange(0, [item length])])
    {
        return MLELEMENTTYPE_NUMBER;
    }    return MLELEMENTTYPE_I;
}


- (NSString *)factorizedString:(NSArray *)values
{
    __block NSString *str = @"";
    
    [values enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL *stop)
     {
         MLELEMENTTYPE elementType;
         elementType = [FormularWebView elementType:item];

         switch (elementType)
         {
             case MLELEMENTTYPE_NUMBER:
                 str = [str stringByAppendingFormat:@"<mn> %@ </mn>",item];
                 break;
             case MLELEMENTTYPE_OPERATOR:
                 str = [str stringByAppendingFormat:@"<mo> %@ </mo>",item];
                 break;
             case MLELEMENTTYPE_I:
                 str = [str stringByAppendingFormat:@"<mi> %@ </mi>",item];
                 break;
         }
     }];
    str= [str stringByAppendingString:@"\n"];
    return str;
}

- (NSString *)subIndizesFromSomething:(NSString *)main sub:(NSArray*)sub
{
    return [NSString stringWithFormat:@"<msub><mi>%@</mi><mrow>%@</mrow></msub>&nbsp; ", main, [self factorizedString:sub]];
}
#define PLUSTERM1 @"<mop> + </mop> <mn>%@</mn><mop> · </mop>%@&nbsp; "
#define PLUSTERM2 @"<mop> + </mop> <mn>%@</mn><mop> · </mop>%@<mop> · </mop>%@&nbsp; "
#define MINUSTERM1 @"<mop> - </mop> <mn>%@</mn><mop> · </mop>%@&nbsp;"
#define MINUSTERM2 @"<mop> - </mop> <mn>%@</mn><mop> · </mop>%@<mop> · </mop>%@&nbsp; "

- (void)createFormular:(NSDictionary*)dict
{
    NSLog(@"%@", dict);
    NSString *problems1=@"",*knowledge1=@"";
    NSString *problems2=@"",*knowledge2=@"";
    // "<msub><mi>p</mi><mrow><mi> t </mi><mo> + </mo><mn> 1 </mn></mrow></msub> <mop> = </mop> "
    // "<msub><mi>p</mi><mrow><mi> t </mi></mrow></msub> <mop> + </mop> "
    //<mi>0.0005</mi><msub><mi>p</mi><mrow><mi> t </mi></mrow></msub> <msub><mi>k</mi><mrow><mi> t </mi></mrow></msub> <mop> + </mop>
    
    problems1 = [NSString stringWithFormat:@"%@ <mop> = </mop>",[self subIndizesFromSomething:@"p[1]" sub:@[@"t",@"+",@"1"]]];
    problems1 = [problems1 stringByAppendingFormat:@"%@", [self subIndizesFromSomething:@"p[2]" sub:@[@"t"]]];
    
    if ([dict[@"solveTeam1"] doubleValue] != 0.0f)
    {
        problems1 = [problems1 stringByAppendingFormat:MINUSTERM2,
                     dict[@"solveTeam1"],
                     [self subIndizesFromSomething:@"p[1]" sub:@[@"t"]],
                     [self subIndizesFromSomething:@"k[1]" sub:@[@"t"]]];
    }
    if ([dict[@"solveTeam1of2"] doubleValue] != 0.0f)
    {
        problems1 = [problems1 stringByAppendingFormat:MINUSTERM2,
                     dict[@"solveTeam1of2"],
                     [self subIndizesFromSomething:@"p[2]" sub:@[@"t"]],
                     [self subIndizesFromSomething:@"k[1]" sub:@[@"t"]]];
    }
    if ([dict[@"moreProblemsRate1"] doubleValue] != 0.0f)
    {
        problems1 = [problems1 stringByAppendingFormat:PLUSTERM1,
                     dict[@"moreProblemsRate1"],
                     [self subIndizesFromSomething:@"p[1]" sub:@[@"t"]]];
    }
 
    knowledge1 = [NSString stringWithFormat:@"%@ <mop> = </mop>",[self subIndizesFromSomething:@"k[1]" sub:@[@"t",@"+",@"1"]]];
    knowledge1 = [knowledge1 stringByAppendingFormat:@"%@", [self subIndizesFromSomething:@"k[1]" sub:@[@"t"]]];
    if ([dict[@"solveTeam2"] doubleValue] != 0.0f)
    {
        problems1 = [problems1 stringByAppendingFormat:PLUSTERM2,
                     dict[@"solveTeam2"],
                     [self subIndizesFromSomething:@"p[2]" sub:@[@"t"]],
                     [self subIndizesFromSomething:@"k[2]" sub:@[@"t"]]];
    }
    
    if ([dict[@"solveTeam1of2"] doubleValue] != 0.0f)
    {
        knowledge1 = [knowledge1 stringByAppendingFormat:PLUSTERM2,
                     dict[@"solveTeam1of2"],
                     [self subIndizesFromSomething:@"k[1]" sub:@[@"t"]],
                     [self subIndizesFromSomething:@"p[2]" sub:@[@"t"]]];
    }
    if ([dict[@"forgetRate1"] doubleValue] != 0.0f)
    {
        knowledge1 = [knowledge1 stringByAppendingFormat:MINUSTERM1,
                     dict[@"forgetRate1"],
                     [self subIndizesFromSomething:@"k" sub:@[@"t"]]];
    }
    problems2 = [NSString stringWithFormat:@"%@ <mop> = </mop>",[self subIndizesFromSomething:@"p[2]" sub:@[@"t",@"+",@"1"]]];
    problems2 = [problems2 stringByAppendingFormat:@"%@", [self subIndizesFromSomething:@"p[2]" sub:@[@"t"]]];
    
    if ([dict[@"solveTeam2of1"] doubleValue] != 0.0f)
    {
        problems2 = [problems2 stringByAppendingFormat:MINUSTERM2,
                     dict[@"solveTeam2of1"],
                     [self subIndizesFromSomething:@"p[2]" sub:@[@"t"]],
                     [self subIndizesFromSomething:@"k[2]" sub:@[@"t"]]];
    }
    if ([dict[@"moreProblemsRate2"] doubleValue] != 0.0f)
    {
        problems2 = [problems2 stringByAppendingFormat:PLUSTERM1,
                     dict[@"moreProblemsRate2"],
                     [self subIndizesFromSomething:@"p[2]" sub:@[@"t"]]];
    }
    
    knowledge2 = [NSString stringWithFormat:@"%@ <mop> = </mop>",[self subIndizesFromSomething:@"k[2]" sub:@[@"t",@"+",@"1"]]];
    knowledge2 = [knowledge2 stringByAppendingFormat:@"%@", [self subIndizesFromSomething:@"k[2]" sub:@[@"t"]]];
    
    if ([dict[@"solveTeam2of1"] doubleValue] != 0.0f)
    {
        knowledge2 = [knowledge2 stringByAppendingFormat:PLUSTERM2,
                      dict[@"solveTeam2of1"],
                      [self subIndizesFromSomething:@"p[1]" sub:@[@"t"]],
                      [self subIndizesFromSomething:@"k[2]" sub:@[@"t"]]];
    }
    if ([dict[@"forgetRate2"] doubleValue] != 0.0f)
    {
        knowledge2 = [knowledge2 stringByAppendingFormat:MINUSTERM1,
                      dict[@"forgetRate2"],
                      [self subIndizesFromSomething:@"k[2]" sub:@[@"t"]]];
    }
    
    
   
    
    NSString *formularML = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" \
                            "<!DOCTYPE html  PUBLIC \"-//W3C//DTD XHTML 1.1 plus MathML 2.0//EN\" \"http://www.w3.org/Math/DTD/mathml2/xhtml-math11-f.dtd\">" \
                            "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\">" \
                            "<body>" \
                            "<font color=red>red=problems</font><br/><font color=blue>blue=new knowledge</font><br/>" \
                            "<math xmlns=\"http://www.w3.org/1998/Math/MathML\">%@</math><br/>" \
                            "<math xmlns=\"http://www.w3.org/1998/Math/MathML\">%@</math><br/>" \
                            "<math xmlns=\"http://www.w3.org/1998/Math/MathML\">%@</math><br/>" \
                            "<math xmlns=\"http://www.w3.org/1998/Math/MathML\">%@</math><br/>" \
                            "</body>" \
                            "</html>",problems1, knowledge1,problems2,knowledge2];
    [[self mainFrame] loadHTMLString:formularML baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self createFormular:nil];
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
