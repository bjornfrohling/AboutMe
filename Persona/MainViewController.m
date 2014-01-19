//
//  MainViewController.m
//  Persona
//
//  Created by Björn Fröhling on 6/11/13.
//  Copyright (c) 2013 Björn Fröhling. All rights reserved.
//

#import "MainViewController.h"
#import "CardViewController.h"
#import "Constants.h"

@interface MainViewController ()

@property (nonatomic, strong) NSTimer *downloadTimer;

@end


@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  self.downloadTimer = [NSTimer scheduledTimerWithTimeInterval:15.0
                                                        target:self
                                                      selector:@selector(useBundleData)
                                                      userInfo:nil
                                                       repeats:NO];
  
  [self downloadStringSource:kGroup3Words url:kGroup3Url sourceType:BFTypeGroup3 block:^ {
    [self downloadStringSource:kGroup1Words url:kGroup1Url sourceType:BFTypeGroup1 block:^ {
      [self downloadStringSource:kGroup2Words url:kGroup2Url sourceType:BFTypeGroup2 block:^ {
        
        CardViewController *cvc = [[[CardViewController alloc] initWithNibName:@"CardViewController" bundle:nil] autorelease];
        _downloadFinished = TRUE;
        [self.downloadTimer invalidate];
        [self presentModalViewController:cvc animated:NO];
      }];
    }];
  }];
}

- (void)downloadStringSource:(NSString *)fileName url:(NSString *)url sourceType:(int)type block:(void (^)())myblock {
  NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  
  [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *downloaderror) {
    NSString *result = nil;
    
    if (downloaderror != nil) {
      NSString *file = [[NSBundle mainBundle] pathForResource:fileName ofType:@"csv"];
      result = [NSString stringWithContentsOfFile:file
                                         encoding:NSUTF8StringEncoding error:NULL];
    }
    else {
      result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fpath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fpath];
    if (fileExists) {
      [self deleteSourceFileFromDocuments:fileName];
    }
    
    NSError *writeError;
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    // Write to the file
    [result writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&writeError];
    if (myblock) {
      myblock();
    }
  }];
}

- (void)deleteSourceFileFromDocuments:(NSString *)fileName {
  NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
  NSFileManager* fm = [[[NSFileManager alloc] init] autorelease];
  NSError* err = nil;
  NSString* file = fileName;
  [fm removeItemAtPath:[path stringByAppendingPathComponent:file] error:&err];
}

- (void)showErrorAlert {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unfortunately it was not possbile to fetch data from the web" delegate:nil cancelButtonTitle:@"Okey" otherButtonTitles: nil];
  [alert show];
  [alert release];
}

- (void)useBundleData {
  if (_downloadFinished) {
    return;
  }
  
  NSArray *data = @[kGroup1Words, kGroup2Words, kGroup3Words];
  
  for (NSString *type in data) {
    NSString *result = [[NSString alloc] initWithContentsOfFile:type encoding:NSUTF8StringEncoding error:nil];
    [result writeToFile:type atomically:NO encoding:NSUTF8StringEncoding error:nil];
    [result release];
  }
  CardViewController *cvc = [[[CardViewController alloc] initWithNibName:@"CardViewController" bundle:nil] autorelease];
  [self presentModalViewController:cvc animated:NO];
}


@end
