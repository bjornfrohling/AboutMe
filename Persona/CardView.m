//
//  CardView.m
//  Persona
//
//  Created by Björn Fröhling on 1/10/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
//

#import "CardView.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@interface CardView ()

@property (nonatomic, retain) UILabel *label;

- (NSString *)randomDataString;

@end


@implementation CardView


+ (id)cardViewWithFrame:(CGRect)frame labelText:(NSString *)string {
  return [[[self alloc]initWithFrame:frame labelText:string]autorelease];
}

- (id)initWithFrame:(CGRect)frame labelText:(NSString *)string {
  self = [super initWithFrame:frame];
  if (self) {
    [self setLabel:[[[UILabel alloc]initWithFrame:self.bounds]autorelease]];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.label];
    
    [self.label setText:string];
    [self.label setFont:[UIFont fontWithName:@"Menlo-Bold" size:14.0]];
    [self.label setTextColor:[UIColor colorWithRed:30/255.0f green:39/255.0f blue:62/255.0f alpha:1.0f]];

    UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [gr setDelaysTouchesBegan:NO];
    [self addGestureRecognizer:gr];
    [gr release];
    
    [self setBackgroundColor:[UIColor colorWithRed:236/255.0f green:242/255.0f blue:255/255.0f alpha:1.0f]];
    [self dropShadowWithOffset:CGSizeMake(0, 1.0) radius:1.0 color:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f] opacity:1];
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5f;
  }
  return self;
}

- (void)dealloc {
  [_label release];
  [_data release];
  
  [super dealloc];
}

// http://stackoverflow.com/questions/5187502/how-can-i-capture-which-direction-is-being-panned-using-uipangesturerecognizer
- (void)handlePan:(UIPanGestureRecognizer *)sender {
  
  CGPoint velocity = [sender velocityInView:self.superview];
  
  if(velocity.x > 0) {
    [self.delegate handleRightPanGesture:self recognizer:sender];
  }
  else {
    [self.delegate handleLeftPanGesture:self recognizer:sender];
  }
}

- (void)updateDataString {
  NSString *nextString = nil;
  
  do {
    nextString = [self randomDataString];
  } while ([nextString isEqualToString:self.label.text]);
  
  [self.label setText:nextString];
}

- (NSString *)randomDataString {
  if (self.data.count == 0) {
    return nil;
  }
  int randomIndex = (int)(arc4random() % self.data.count);
  
  return [self.data objectAtIndex:randomIndex];
}

- (float)remainingSlideOutAnimationDur {
  float result = 0;
  
  if (self.center.x < self.startCenterPoint.x) { // < moving to left
    result = (self.startCenterPoint.x - self.center.x);
  }
  else { // > moving tor right
    result = (self.center.x - self.startCenterPoint.x);
  }
  
  result = self.startCenterPoint.x - result;
  result = result / self.startCenterPoint.x;
  result *= _animationDur;
  if (result < 0) {
    result *= -1;
  }
  
  if (result < kMinAnimationDur) {
    result = kMinAnimationDur;
  }
  
  return  result;
}

- (float)remainingBackAnimationDur {
  float result = self.animationDur - [self remainingSlideOutAnimationDur];
  
  return result;
}

- (float)rotationDegreesForPoint:(float)point {
  float result = 0;
  
  if (point < self.startCenterPoint.x) { // <<< moving to left
    result = self.startDegrees - (self.startCenterPoint.x - point);
  }
  else { // >>>> moving tor right
    result = self.startDegrees + (point - self.startCenterPoint.x);
  }
  result *= 0.4;
  
  return  result;
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
  
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddRect(path, NULL, self.bounds);
  self.layer.shadowPath = path;
  CGPathCloseSubpath(path);
  CGPathRelease(path);
  
  self.layer.shadowColor = color.CGColor;
  self.layer.shadowOffset = offset;
  self.layer.shadowRadius = radius;
  self.layer.shadowOpacity = opacity;
  
  self.clipsToBounds = NO;
}


@end
