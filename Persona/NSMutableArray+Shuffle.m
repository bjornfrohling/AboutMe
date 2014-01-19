//
//  NSMutableArray+Shuffle.m
//  Persona
//
//  Created by Björn Fröhling on 1/19/14.
//  Copyright (c) 2014 Björn Fröhling. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

// http://stackoverflow.com/a/56656
- (void)shuffle {
  int aCount = [self count];
  for (int i = 0; i < aCount; ++i) {
    int nElements = aCount - i;
    int randNr = arc4random_uniform(nElements) + i; // nr between i and nElements
    [self exchangeObjectAtIndex:i withObjectAtIndex:randNr];
  }
}

@end
