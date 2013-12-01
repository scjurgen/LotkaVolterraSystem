//
//  AppDelegate.m
//  lotkavolterra
//
//  Created by jay on 20/11/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

/**
 lotka model Wissen, Probleme, Problembewusstsein, casino-kapital, innovation
 
 
 X(t+1) = X(t)+p*X(t)*Y(t)-l*X(t)
 Y(t+1) = Y(t)-p*X(t+1)*Y(t)+c*Y(t)
 if (t-k>0)
    A(t+1) = A(t)+g*X(t+1)*Y(t+1)-f*Y*(t-k);
 if (C(t)>=0)
    C(t+1) = C(t_ - u*C(t)*X(t+1)+d*A(t+1)*sin(omega*t);
 I(t+1) = i*X(t+1)*C(t+1)*A(t+1)
 
 
 to do:
 
 
 webview for formular
 menu for saving systems
 evaluate written formulars
 units in 
 
 
 
 */


#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


@end

