//
//  CLFLLayoutManager.m
//  ColorfulText
//
//  Created by TJ Usiyan on 2/19/14.
//  Copyright (c) 2014 TJ Usiyan. All rights reserved.
//

#import "CLFLLayoutManager.h"

@implementation CLFLLayoutManager

- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow
                            atPoint:(CGPoint)origin {
    CGRect rect = CGRectIntegral([self boundingRectForGlyphRange:glyphsToShow
                                  inTextContainer:self.textContainers[0]]);
    rect.origin = origin;
    rect.origin.x += self.edgeInsets.left;
    rect = CGRectIntegral(CGRectInset(rect, -2, 0));
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                    cornerRadius:3.0];
    [[UIColor greenColor] set];
    [path fill];
}

@end
