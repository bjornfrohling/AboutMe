//
//  ViewController.m
//  Persona
//
//  Created by Björn Fröhling on 1/10/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
//

#import "CardViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "CardView.h"
#import "PersonaString.h"
#import "CardStack.h"
#import "Constants.h"

@interface CardViewController ()

@property (strong, nonatomic) IBOutlet CardStack *staticCard;
@property (strong, nonatomic) IBOutlet CardStack *stackView1;
@property (strong, nonatomic) IBOutlet CardStack *stackView2;
@property (strong, nonatomic) IBOutlet CardStack *stackView3;
@property (strong, nonatomic) NSArray *cardstacks;
@property (strong, nonatomic) NSMutableArray *animatedCards;

- (void)cardStartPositionSetup;

- (void)moveView:(CardView *)view
         toPoint:(CGPoint)point
      animateDur:(float)dur
     animateBack:(BOOL)goBack
      sendToBack:(BOOL)update
        rotation:(CGAffineTransform)animation;

- (NSArray *)cardsForStrings:(NSArray *)data addedToView:(UIView *)stackView;
- (void)cardSlideInAnimation;
- (void)shuffleVisibleCards;
- (NSArray *)allCards;

@end


@implementation CardViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setCardstacks:[NSArray arrayWithObjects:self.staticCard, self.stackView1,
                       self.stackView2, self.stackView3, nil]];
  
  UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
  [self.view addGestureRecognizer:tgr];
  [tgr release];
  
  [self setAnimatedCards:[[[NSMutableArray alloc]init]autorelease]];
}

- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   
  [self cardsForStrings:@[@"I'm a ..."] addedToView:self.staticCard];
  
  [self cardsForStrings:[PersonaString personaGroup1Words] addedToView:self.stackView1];
  
  [self cardsForStrings:[PersonaString personaGroup2Words] addedToView:self.stackView2];
  
  [self cardsForStrings:[PersonaString personaGroup3Words] addedToView:self.stackView3];
  
  [self cardStartPositionSetup];
}

- (void)viewDidAppear:(BOOL)animated {
   [super viewDidAppear:animated];
   
  [self performSelector:@selector(cardSlideInAnimation) withObject:nil  afterDelay:0.5];
  NSArray *tempA = self.staticCard.subviews;
  for (CardView *card in tempA) {
    [card setDelegate:nil]; // don't react to user interaction
    [card setTag:kStaticCard];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [_staticCard release];
  [_stackView1 release];
  [_stackView2 release];
  [_stackView3 release];
  [_cardstacks release];
  [_animatedCards release];
  
  [super dealloc];
}

- (void)cardStartPositionSetup {
  int i = 0;
  
  NSArray *allCards = [self allCards];
  for (CardView *card in allCards) {
    if (++i%2) {
      [card setCenter:card.leftEndPoint];
    }
    else {
      [card setCenter:card.rightEndPoint];
    }
    card.transform = [self rotationToDegrees:[card rotationDegreesForPoint:card.center.x]];
  }
}

- (void)cardSlideInAnimation {
  NSArray *allCards = [self allCards];
  
  for (CardView *card in allCards) {
    [self moveView:card toPoint:card.startCenterPoint animateDur:card.animationDur animateBack:NO sendToBack:NO rotation:[self rotationToDegrees:[card rotationDegreesForPoint:card.startCenterPoint.x]]];
  }
}

- (NSArray *)cardsForStrings:(NSArray *)data addedToView:(UIView *)stackView {
  NSMutableArray *array = [[NSMutableArray alloc]init];
  int prevRand = 0;
  for (NSString *string in data) {
    CardView *tempCard = [CardView cardViewWithFrame:CGRectMake(stackView.bounds.size.width/2 - kCardWidth/2, stackView.bounds.size.height/2 - kCardHeight/2, kCardWidth, kCardHeight) labelText:string];
    [tempCard setDelegate:self];
    [tempCard setData:[NSArray arrayWithObject:string]];
    [tempCard setAnimationDur:kAnimationDur];
    
    [tempCard setStartDegrees:(int)(arc4random() % 16)]; // random nr between 0 and 8
    if (tempCard.startDegrees == prevRand) {
      tempCard.startDegrees *= -1;
    }
    prevRand = tempCard.startDegrees;
    
    [array addObject:tempCard];
    
    [stackView addSubview:tempCard];
    
    [tempCard setRightEndPoint:CGPointMake(tempCard.superview.bounds.size.width + tempCard.bounds.size.width / 2, tempCard.center.y)];
    [tempCard setLeftEndPoint:CGPointMake(tempCard.bounds.size.width / 2 * -1, tempCard.center.y)];
    [tempCard setStartCenterPoint:tempCard.center];
    
    tempCard.transform = [self rotationToDegrees:[tempCard rotationDegreesForPoint:tempCard.center.x]];
  } // end for
  
  return [array autorelease];
}

- (void)moveView:(CardView *)view toPoint:(CGPoint)point animateDur:(float)dur animateBack:(BOOL)goBackToStart sendToBack:(BOOL)toBack rotation:(CGAffineTransform)animation {
  [self.animatedCards addObject:view];
  
  [UIView animateWithDuration:dur
                        delay:0
                      options:UIViewAnimationCurveEaseOut
                   animations:^{
                     [view setCenter:point];
                     [view setTransform:animation];
                     
                   }
                   completion:^(BOOL finished){
                     
                     if (toBack) {
                       [view.superview sendSubviewToBack:view];
                     }
                     [self.animatedCards removeObject:view];
                     
                     if (goBackToStart) { // animate back to start pos
                       CGAffineTransform anima = [self rotationToDegrees:[view rotationDegreesForPoint:view.startCenterPoint.x]];
                       [self moveView:view toPoint:view.startCenterPoint animateDur:view.animationDur animateBack:NO sendToBack:NO rotation:anima];
                     }
                   }];
  
}


- (void)handleRightPanGesture:(CardView *)view recognizer:(UIGestureRecognizer *)recognizer {
  CGPoint currentPoint = [recognizer locationInView:self.view];
  
  switch (recognizer.state) {
    case UIGestureRecognizerStateBegan:
      _delataX = view.center.x - currentPoint.x;
      
      break;
    case UIGestureRecognizerStateChanged:
      [view setCenter:CGPointMake(currentPoint.x + _delataX, view.startCenterPoint.y)];
      
      view.transform = [self rotationToDegrees:[view rotationDegreesForPoint:view.center.x]];
      break;
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled: {
      
      if (view.center.x > self.view.bounds.size.width - kTrashold) {
        // animate to right >>>
        float degrees = [view rotationDegreesForPoint:view.rightEndPoint.x];
        CGAffineTransform anima = [self rotationToDegrees:degrees];
        
        [self moveView:view toPoint:view.rightEndPoint animateDur:[view remainingSlideOutAnimationDur] animateBack:YES sendToBack:YES rotation:anima];
      }
      else  {
        // animate back to center
        CGAffineTransform anima = [self rotationToDegrees:[view rotationDegreesForPoint:view.startCenterPoint.x]];
        
        [self moveView:view toPoint:view.startCenterPoint animateDur:[view remainingBackAnimationDur] animateBack:NO sendToBack:NO rotation:anima];
      }
    }
      break;
      
    default:
      break;
  }
}

- (void)handleLeftPanGesture:(CardView *)view recognizer:(UIGestureRecognizer *)recognizer {
  CGPoint currentPoint = [recognizer locationInView:self.view];
  
  switch (recognizer.state) {
    case UIGestureRecognizerStateBegan:
      _delataX = view.center.x - currentPoint.x;
      break;
    case UIGestureRecognizerStateChanged:
      [view setCenter:CGPointMake(currentPoint.x + _delataX, view.startCenterPoint.y)];
      
      view.transform = [self rotationToDegrees:[view rotationDegreesForPoint:view.center.x]];
      
      break;
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled: {
      
      if (view.center.x < kTrashold) {
        // animate to left <<<<
        float degrees = [view rotationDegreesForPoint:view.leftEndPoint.x];
        CGAffineTransform anima = [self rotationToDegrees:degrees];
        
        [self moveView:view toPoint:view.leftEndPoint animateDur:[view remainingSlideOutAnimationDur] animateBack:YES sendToBack:YES rotation:anima];
      }
      else  {
        // animate back to center
        CGAffineTransform anima = [self rotationToDegrees:[view rotationDegreesForPoint:view.startCenterPoint.x]];
        
        [self moveView:view toPoint:view.startCenterPoint animateDur:[view remainingBackAnimationDur] animateBack:NO sendToBack:NO rotation:anima];
      }
    }
      break;
      
    default:
      break;
  }
}

// http://www.informit.com/blogs/blog.aspx?uk=Ask-Big-Nerd-Ranch-Rotating-an-iPhone-View-Around-a-Point
CGFloat degreesToRadians(CGFloat degrees) {
  return degrees * M_PI / 180;
};


- (CGAffineTransform)rotationToDegrees:(float)toValue {
  CGAffineTransform  animation = CGAffineTransformMakeRotation(degreesToRadians(toValue));
  
  return animation;
}

- (void)handleTap:(UIGestureRecognizer *)gestureRec {
  
  [self shuffleVisibleCards];
}

- (void)shuffleVisibleCards {
  NSMutableArray *array = [[NSMutableArray alloc]init];
  
  for (CardStack *stack in self.cardstacks) {
    CardView *vCard = stack.visibleCard;
    if (vCard == nil || vCard.tag == kStaticCard) {
      continue;
    }
    
    while ([self.animatedCards containsObject:vCard]) {
      vCard = [stack nextCard:vCard];
      if (vCard == nil) {
        break;
      }
    }
    
    if (vCard != nil) {
      [array addObject:vCard];
    }
  }
  
  for (CardView *card in array) {
    CGPoint point = CGPointZero;
    int rand = (int)(arc4random() % 21);  // 0 to x-1
    if (rand % 2) {
      point = card.leftEndPoint;
    }
    else {
      point = card.rightEndPoint;
    }
    float degrees = [card rotationDegreesForPoint:point.x];
    CGAffineTransform anima = [self rotationToDegrees:degrees];
    
    [self moveView:card toPoint:point animateDur:[card remainingSlideOutAnimationDur] animateBack:YES sendToBack:YES rotation:anima];
  }
  [array release];
}

- (NSArray *)allCards {
  NSMutableArray *array = [[NSMutableArray alloc]init];
  for (CardStack *stack in self.cardstacks) {
    [array addObjectsFromArray:stack.subviews];
  }
  return [array autorelease];
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
  for (int i = 1; i <= 3; i++) {
    [self performSelector:@selector(shuffleVisibleCards) withObject:nil afterDelay:i*0.1];
  }
}

@end
