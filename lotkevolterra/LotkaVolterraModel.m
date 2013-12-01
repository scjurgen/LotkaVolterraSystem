//
//  LotkaVolterraModel.m
//  lotkevolterra
//
//  Created by Schwietering, Jürgen on 30.11.13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "LotkaVolterraModel.h"

@interface LotkaVolterraModel()
{
    LVVECTOR current;
    LVVECTOR next;
    
    double solveTeam1;
    double solveTeam1of2;
    double solveTeam2of1;
    double solveTeam2;
    
    double forgetRate1;
    double forgetRate2;
    double moreProblemsRate1;
    double moreProblemsRate2;
}
@end

@implementation LotkaVolterraModel

- (id)init
{
    self = [super init];
    if (self)
    {
        self.timeseries = [[LVTimeSeries alloc] init];
    }
    return self;
}


- (void)setValues:(NSDictionary*)dict
{
    for (int i=0; i < 2; i++)
    {
        next.team[i].knowledge = 4.0;
        next.team[i].problems = 24.0;
    }
    solveTeam1 = [dict[@"solveTeam1"] doubleValue];
    solveTeam2 = [dict[@"solveTeam2"] doubleValue];
    solveTeam1of2 = [dict[@"solveTeam1of2"] doubleValue];
    solveTeam2of1 = [dict[@"solveTeam2of1"] doubleValue];
    solveTeam1 -= solveTeam1of2;
    solveTeam2 -= solveTeam2of1;
    forgetRate1 = [dict[@"forgetRate1"] doubleValue];
    forgetRate2 = [dict[@"forgetRate2"] doubleValue];
    moreProblemsRate1 = [dict[@"moreProblemsRate1"] doubleValue];
    moreProblemsRate2 = [dict[@"moreProblemsRate2"] doubleValue];
    [self.timeseries reset];
}

- (double)clamp:(double)val
{
    if (val > 400.0)
        return 400.0;
    if (val < 0.0)
        return 0.0;
    return val;
}

- (void)run:(NSUInteger)steps
{
    while (steps--)
    {
        [self step];
        [self.timeseries addItem:current];
    }
}

- (void)step
{
    for (int i=0; i < 2; i++)
    {
        current.team[i].knowledge = next.team[i].knowledge;
        current.team[i].problems = next.team[i].problems;
    }
    next.team[0].knowledge = current.team[0].knowledge
        + solveTeam1 * current.team[0].knowledge * current.team[0].problems
        + solveTeam1of2 * current.team[0].knowledge * current.team[1].problems
        - forgetRate1 * current.team[0].knowledge;
    
    next.team[0].problems  = current.team[0].problems
        - solveTeam1 * next.team[0].knowledge * current.team[0].problems
        + moreProblemsRate1 * current.team[0].problems;
    
    next.team[1].knowledge = current.team[1].knowledge
        + solveTeam2 * current.team[1].knowledge * current.team[1].problems
        + solveTeam2of1 * current.team[1].knowledge * next.team[1].problems
        - forgetRate2 * current.team[1].knowledge;
    
    next.team[1].problems  = current.team[1].problems
        - solveTeam2 * next.team[1].knowledge * current.team[1].problems
        + moreProblemsRate2 * current.team[1].problems;
    
    for (int i=0; i < 2; i++)
    {
        next.team[i].knowledge = [self clamp:next.team[i].knowledge];
        next.team[i].problems = [self clamp:next.team[i].problems];
    }
}

@end
