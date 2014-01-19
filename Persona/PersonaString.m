//
//  PersonaString.m
//  Persona
//
//  Created by Björn Fröhling on 1/25/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
//

#import "PersonaString.h"
#import "Constants.h"
#import "NSString+ParsingExtensions.h"
#import "NSMutableArray+Shuffle.h"

@implementation PersonaString


+ (NSArray *)personaGroup1Words {

  return [PersonaString arrayWithData:kGroup1Words];
}

+ (NSArray *)personaGroup2Words {
  
  return [PersonaString arrayWithData:kGroup2Words];
}

+ (NSArray *)personaGroup3Words {
  
  return [PersonaString arrayWithData:kGroup3Words];
}

+ (NSArray *)arrayWithData:(NSString *)type {
  NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
  
  NSString *filePath = [documentsDirectory stringByAppendingPathComponent:type];
  
  NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
  
  NSArray *cvsArray = [fileContent csvRows];
  NSMutableArray *mA = [[[NSMutableArray alloc] initWithCapacity:cvsArray.count] autorelease];
  for (NSArray *a in cvsArray) {
    NSString *s = [a objectAtIndex:0];
    [mA addObject:s];
  }
  [mA shuffle];
  
  return mA;
}

@end
