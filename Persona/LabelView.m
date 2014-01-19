//
//  LabelView.m
//  Persona
//
//  Created by Björn Fröhling on 1/26/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
//

#import "LabelView.h"

@implementation LabelView


- (void)awakeFromNib {
  self.animationLayer = [CALayer layer];
  self.animationLayer.frame = CGRectMake(20.0f,
                                         20.0f,
                                         CGRectGetWidth(self.layer.bounds) - 40.0f,
                                         CGRectGetHeight(self.layer.bounds) - 40.0f);
  [self.layer addSublayer:self.animationLayer];
}

- (void)dealloc {
  [_animationLayer release];
  [_pathLayer release];
  [_penLayer release];

  [super dealloc];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  [self.penLayer setHidden:YES];

  [self.delegate labelViewDidStopAnimation:anim view:self];
}

@end
