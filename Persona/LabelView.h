//
//  LabelView.h
//  Persona
//
//  Created by Björn Fröhling on 1/26/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LabelViewDelegate.h"

@interface LabelView : UIView

@property (nonatomic, strong) CALayer *animationLayer;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, strong) CALayer *penLayer;
@property (nonatomic, assign) id <LabelViewDelegate> delegate;
@property (nonatomic, copy) NSString *text;

@end
