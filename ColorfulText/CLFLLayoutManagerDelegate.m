//
//  CLFLLayoutManagerDelegate.m
//  ColorfulText
//
//  Created by TJ Usiyan on 2/19/14.
//  Copyright (c) 2014 TJ Usiyan. All rights reserved.
//

@import CoreText;
#import "CLFLLayoutManagerDelegate.h"
#import "CLFLTextStorage.h"
#import "CLFLLayoutManager.h"


@interface CLFLLayoutManagerDelegate ()
@property (nonatomic, strong) CLFLTextStorage *textStorage;
@end

@implementation CLFLLayoutManagerDelegate
- (NSUInteger)layoutManager:(NSLayoutManager *)layoutManager
       shouldGenerateGlyphs:(const CGGlyph *)glyphs
                 properties:(const NSGlyphProperty *)props
           characterIndexes:(const NSUInteger *)charIndexes
                       font:(UIFont *)aFont
              forGlyphRange:(NSRange)glyphRange
{

    /** Crashes. Reentrant. */
    NSRange charRange = [layoutManager characterRangeForGlyphRange:glyphRange
                                                  actualGlyphRange:&glyphRange];
    NSLog(@"%@", NSStringFromRange(charRange));

    return 0;
}

@end
