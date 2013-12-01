//
//  LotkaVolterraModel.h
//  lotkevolterra
//
//  Created by Schwietering, Jürgen on 30.11.13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LotkaVolterraDatatypes.h"
#import "LVTimeSeries.h"

@interface LotkaVolterraModel : NSObject

@property (strong, nonatomic) LVTimeSeries *timeseries;

- (void)step;
- (void)run:(NSUInteger)steps;
- (void)setValues:(NSDictionary*)dict;

@end
