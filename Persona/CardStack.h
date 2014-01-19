//
//  CardStack.h
//  Persona
//
//  Created by Björn Fröhling on 1/25/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardView;

@interface CardStack : UIView

- (NSInteger)totalCards;
- (CardView *)visibleCard;
- (CardView *)nextCard:(CardView *)card;

@end
