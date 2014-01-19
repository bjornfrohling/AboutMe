//
//  ViewController.h
//  Persona
//
//  Created by Björn Fröhling on 1/10/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewDelegate.h"

@class CardView;
@class CardStack;

@interface CardViewController : UIViewController <CardViewDelegate> {
  @private
  float _delataX;
}

@end
