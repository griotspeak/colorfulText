//
//  CLFLViewController.m
//  ColorfulText
//
//  Created by TJ Usiyan on 2/19/14.
//  Copyright (c) 2014 TJ Usiyan. All rights reserved.
//

@import CoreText;
#import "CLFLViewController.h"
#import "CLFLTextStorage.h"
#import "CLFLLayoutManager.h"

@interface CLFLViewController () <NSLayoutManagerDelegate>
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) NSTextStorage *textStorage;
@end

@implementation CLFLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    CGRect textViewRect = UIEdgeInsetsInsetRect(self.view.bounds, edgeInsets);

    CLFLTextStorage *textStorage = [[CLFLTextStorage alloc] init];

    CLFLLayoutManager *layoutManager = [[CLFLLayoutManager alloc] init];
    layoutManager.delegate = self;
    layoutManager.edgeInsets = edgeInsets;
    [textStorage addLayoutManager: layoutManager];

    NSTextContainer *textContainer = [[NSTextContainer alloc] init];
    [layoutManager addTextContainer: textContainer];

    UITextView *textView = [[UITextView alloc] initWithFrame:textViewRect
                                               textContainer:textContainer];
    [self.view addSubview:textView];
    self.textView = textView;
    self.textView.font = [UIFont systemFontOfSize:45];
    self.textStorage = textStorage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSRange)makeRangeWithCharIndexes:(NSUInteger const *)charIndexes
                         glyphRange:(NSRange)glyphRange {
    return NSMakeRange(*charIndexes, charIndexes[glyphRange.length - 1] - charIndexes[0] + 1);
}

- (NSUInteger)layoutManager:(NSLayoutManager *)layoutManager
       shouldGenerateGlyphs:(const CGGlyph *)glyphs
                 properties:(const NSGlyphProperty *)props
           characterIndexes:(const NSUInteger *)charIndexes
                       font:(UIFont *)aFont
              forGlyphRange:(NSRange)glyphRange
{
    NSRange effectiveRange;
    for (int i = 0; i < glyphRange.length; i++) {
        NSDictionary *attributes = [self.textStorage attributesAtIndex:charIndexes[i]
                                                        effectiveRange:&effectiveRange];
        NSLog(@"charIndex[%d]:%lu", i, (unsigned long)charIndexes[i]);
        NSLog(@"glyphRange:%@", NSStringFromRange(glyphRange));
        NSLog(@"effectiveRange:%@", NSStringFromRange(effectiveRange));
        if ([attributes[CLFLPhoneNumberAttributeName] isEqual:@YES]) {
            NSLog(@"number found");
            const size_t bufferLength = 2;

            CGGlyph *glyphBuffer = malloc(sizeof(CGGlyph) * bufferLength);
            NSGlyphProperty *propsBuffer = malloc(sizeof(NSGlyphProperty) * bufferLength);
            UTF16Char bullet = 0x2022; // obviously.
            if (CTFontGetGlyphsForCharacters((CTFontRef)aFont, &bullet, (CGGlyph *)(glyphs + i), 1)) {
                [layoutManager setGlyphs:glyphBuffer
                              properties:propsBuffer
                        characterIndexes:charIndexes + i
                                    font:aFont
                           forGlyphRange:NSMakeRange(glyphRange.location + i, glyphRange.length - i)];
            }

            free(glyphBuffer);
            free(propsBuffer);
        }
    }
    NSLog(@"--------------------------");
    return 0;
}

@end
