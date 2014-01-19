//
//  CardViewDelegate.h
//  Persona
//
//  Created by Björn Fröhling on 1/12/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
////

#import <Foundation/Foundation.h>

@class CardView;

@protocol CardViewDelegate <NSObject>

- (void)handleRightPanGesture:(CardView *)view recognizer:(UIGestureRecognizer *)recognizer;
- (void)handleLeftPanGesture:(CardView *)view recognizer:(UIGestureRecognizer *)recognizer;

@end
