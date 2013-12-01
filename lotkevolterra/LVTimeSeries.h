//
//  LVTimeSeries.h
//  lotkevolterra
//
//  Created by Schwietering, Jürgen on 30.11.13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LotkaVolterraDatatypes.h"

@interface LVTimeSeries:NSObject
{
    LVVECTOR *values;
    int currentItem;
    int maxItems;
    
}

- (void)addItem:(LVVECTOR)value;
- (void)reset;
- (BOOL)getItem:(NSUInteger)index val:(LVVECTOR*)val;

@end
