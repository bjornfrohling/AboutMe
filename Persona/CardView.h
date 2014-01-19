//
//  CardView.h
//  Persona
//
//  Created by Björn Fröhling on 1/10/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewDelegate.h"

@interface CardView : UIView {
  
}

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, assign) id <CardViewDelegate> delegate;
@property (nonatomic, assign) CGPoint startCenterPoint;
@property (nonatomic, assign) CGPoint rightEndPoint;
@property (nonatomic, assign) CGPoint leftEndPoint;
@property (nonatomic, assign) float startDegrees;
@property (nonatomic, assign) float animationDur;

+ (id)cardViewWithFrame:(CGRect)frame labelText:(NSString *)string;

- (void)updateDataString;
- (float)remainingSlideOutAnimationDur;
- (float)remainingBackAnimationDur;
- (float)rotationDegreesForPoint:(float)point;
- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity;

@end
