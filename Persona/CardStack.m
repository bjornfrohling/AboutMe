//
//  CardStack.m
//  Persona
//
//  Created by Björn Fröhling on 1/25/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
//

#import "CardStack.h"

@implementation CardStack

- (NSInteger)totalCards {
  return self.subviews.count;
}

- (CardView *)visibleCard {
  if (self.subviews.count > 0) {
    return [self.subviews objectAtIndex:self.subviews.count-1];
  }
  return nil;
}

- (CardView *)nextCard:(CardView *)card {
  if (self.subviews.count > 1) {
    int index = [self.subviews indexOfObject:card];
    index--;
    if (index > -1) {
      return [self.subviews objectAtIndex:index];
    }
  }
  return nil;
}

@end
