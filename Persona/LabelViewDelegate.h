//
//  LabelViewDelegate.h
//  Persona
//
//  Created by Björn Fröhling on 1/26/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@class LabelView;

@protocol LabelViewDelegate <NSObject>

- (void)labelViewDidStopAnimation:(CAAnimation *)anim view:(LabelView *)view;

@end
