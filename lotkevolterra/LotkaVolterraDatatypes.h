//
//  LotkaVolterraDatatypes.h
//  lotkevolterra
//
//  Created by Schwietering, Jürgen on 30.11.13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#ifndef lotkevolterra_LotkaVolterraDatatypes_h
#define lotkevolterra_LotkaVolterraDatatypes_h


typedef struct
{
    double knowledge;
    double problems;
}LVITEM;

typedef struct
{
    LVITEM team[2];
} LVVECTOR;


#endif
