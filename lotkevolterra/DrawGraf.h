//
//  DrawGraf.h
//  lotkevolterra
//
//  Created by Schwietering, Jürgen on 30.11.13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawGraf : NSObject

- (void)setPenColors:(NSArray *)penColors;
- (void)setPenSizes:(NSArray *)penSizes;


- (NSImage*)drawGrafs:(CGSize)size;
@end
