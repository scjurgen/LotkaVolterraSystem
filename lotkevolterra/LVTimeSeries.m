//
//  LVTimeSeries.m
//  lotkevolterra
//
//  Created by Schwietering, Jürgen on 30.11.13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "LVTimeSeries.h"
#import "LotkaVolterraDatatypes.h"


@implementation  LVTimeSeries

- (id)init
{
    self=[super init];
    if (self)
    {
        values = nil;
        [self reset];
    }
    return self;
}

- (void)dealloc
{
    if (values)
    {
        free(values);
    }
}

- (void)reset
{
    if (values) {
        free(values);
    }
    maxItems = 0x10000;
    values = malloc(maxItems*sizeof(LVVECTOR));
}


- (void)addItem:(LVVECTOR)value
{
    if (!values)
        return;
    values[currentItem] = value;
    currentItem++;
    if (currentItem>=maxItems)
    {
        maxItems += 0x10000L;
        values = realloc(values, maxItems*sizeof(LVVECTOR));
    }
}

- (BOOL)getItem:(NSUInteger)index val:(LVVECTOR*)val
{
    if (index >= maxItems)
        return NO;
    if (values == nil)
        return NO;
    *val = values[index];
    return YES;;
}

@end