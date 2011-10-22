//
//  main.m
//  MakeSpinnerSprite
//
//  Created by Fred Potter on 10/18/11.
//  Copyright (c) 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

void DrawDash(int dashNumber, int numDashes, float radiusStart, float radiusEnd, float padding, NSColor *dashColor, float dashWidth);
void DrawDash(int dashNumber, int numDashes, float radiusStart, float radiusEnd, float padding, NSColor *dashColor, float dashWidth) {
    
  NSAffineTransform *transform = [NSAffineTransform transform];
  
  [transform translateXBy:(radiusEnd + padding) yBy:(radiusEnd + padding)];
  [transform rotateByDegrees:((dashNumber * 1.0) / numDashes) * 360.0];
  [transform concat];
  
  [dashColor setFill];
  [[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(radiusStart, 0, (radiusEnd - radiusStart), dashWidth)
                                   xRadius:(MIN(dashWidth, radiusEnd - radiusStart) / 2.0)
                                   yRadius:(MIN(dashWidth, radiusEnd - radiusStart) / 2.0)] fill];
}

void DrawFrame(int iteration, int numDashes, float radiusStart, float radiusEnd, float padding, NSColor *dashColor, float dashWidth);
void DrawFrame(int iteration, int numDashes, float radiusStart, float radiusEnd, float padding, NSColor *dashColor, float dashWidth) {

  int count = 0;
  while (count < numDashes) {
    int dashNumber = (iteration + count) % numDashes;
    float opacity =  ((numDashes - count) / (numDashes * 1.0));
    
    NSColor *color = [dashColor colorWithAlphaComponent:opacity];
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    DrawDash(dashNumber, numDashes, radiusStart, radiusEnd, padding, color, dashWidth);
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
    
    count++;
  }
}


int main(int argc, const char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  float radiusStart = 5;
  float radiusEnd = 10;  
  NSColor *color = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0];
  float dashWidth = 1.8f;
  int dashes = 12;
  float padding = 3;
  NSColor *backgroundColor = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.0];
  NSString *outputFile = nil;
  
  BOOL showUsage = NO;
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  if ([defaults objectForKey:@"radiusStart"] != nil) {
    radiusStart = [[defaults objectForKey:@"radiusStart"] floatValue];
  }
  
  if ([defaults objectForKey:@"radiusEnd"] != nil) {
    radiusEnd = [[defaults objectForKey:@"radiusEnd"] floatValue];
  }
  
  if ([defaults objectForKey:@"color"] != nil) {
    NSString *hexString = [defaults objectForKey:@"color"];
    
    if (hexString.length == 6 || hexString.length == 8) {
      unsigned int r = 0;
      unsigned int g = 0;
      unsigned int b = 0;
      unsigned int a = 255;
      
      [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
      [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
      [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];

      if (hexString.length == 8) {
        [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(6, 2)]] scanHexInt:&a];
      }
      
      color = [NSColor colorWithCalibratedRed:(r / 255.0)
                                        green:(g / 255.0)
                                         blue:(b / 255.0)
                                        alpha:(a / 255.0)];
    }
  }
  
  if ([defaults objectForKey:@"dashWidth"] != nil) {
    dashWidth = [[defaults objectForKey:@"dashWidth"] floatValue];
  }
  
  if ([defaults objectForKey:@"dashes"] != nil) {
    dashes = [[defaults objectForKey:@"dashes"] intValue];
  }

  if ([defaults objectForKey:@"padding"] != nil) {
    padding = [[defaults objectForKey:@"padding"] floatValue];
  }

  if ([defaults objectForKey:@"backgroundColor"] != nil) {
    NSString *hexString = [defaults objectForKey:@"backgroundColor"];
    
    if (hexString.length == 6 || hexString.length == 8) {
      unsigned int r = 0;
      unsigned int g = 0;
      unsigned int b = 0;
      unsigned int a = 255;
      
      [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
      [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
      [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];
      
      if (hexString.length == 8) {
        [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(6, 2)]] scanHexInt:&a];
      }
      
      backgroundColor = [NSColor colorWithCalibratedRed:(r / 255.0)
                                                  green:(g / 255.0)
                                                   blue:(b / 255.0)
                                                  alpha:(a / 255.0)];
    }
  }
  
  if ([defaults objectForKey:@"output"] != nil) {
    outputFile = [defaults objectForKey:@"output"];
  } else {
    fprintf(stderr, "ERROR: Missing required 'output' parameter.\n");
    showUsage = YES;
  }

  if (showUsage) {
    fprintf(stderr, "usage: %s -output MySpinner.png [-dashes 12] [-dashWidth 1.8] [-radiusStart 5] [-radiusEnd 10] [-padding 3] [-color RRGGBB] [-backgroundColor RRGGBB]\n", argv[0]);
    return 1;
  }

  printf("\nOptions:\n\n");
  printf("Dashes:         %d\n", dashes);
  printf("Dash Width:     %.2f\n", dashWidth);  
  printf("Radius Start:   %.2f\n", radiusStart);
  printf("Radius End:     %.2f\n", radiusEnd);
  printf("Padding:        %.2f\n", padding);
  printf("Color:          rgba(%.2f, %.2f, %.2f, %.2f)\n", [color redComponent], [color greenComponent], [color blueComponent], [color alphaComponent]);
  
  if ([backgroundColor alphaComponent] == 0.0) {
    printf("BG Color:       transparent\n");    
  } else {
    printf("BG Color:       rgba(%.2f, %.2f, %.2f, %.2f)\n", [backgroundColor redComponent], [backgroundColor greenComponent], [backgroundColor blueComponent], [backgroundColor alphaComponent]);
  }
  
  printf("Output File:    %s\n", [outputFile UTF8String]);
  printf("\n");
  
  NSSize spriteSize = NSMakeSize((radiusEnd + padding) * 2 * dashes, (radiusEnd + padding) * 2);
  NSImage *spriteImage = [[[NSImage alloc] initWithSize:spriteSize] autorelease];
  
  [spriteImage lockFocusFlipped:YES];
  
  [backgroundColor setFill];
  [NSBezierPath fillRect:NSMakeRect(0.0, 0.0, spriteSize.width, spriteSize.height)];
  
  printf("Generating");
  fflush(stdout);
  
  for (int i = 0; i < dashes; i++) {
    printf(".");
    fflush(stdout);
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:(spriteSize.width / dashes) * i yBy:0];
    [transform concat];
    
    DrawFrame(i, dashes, radiusStart, radiusEnd, padding, color, dashWidth);

    [[NSGraphicsContext currentContext] restoreGraphicsState];
  }
  
  printf("\nDone.\n");

  NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, spriteSize.width, spriteSize.height)];
  NSData *pngData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
  [pngData writeToFile:outputFile atomically:NO];
  [spriteImage unlockFocus];
  
  [pool release];
  return 0;
}

