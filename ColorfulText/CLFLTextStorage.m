//
//  CLFLTextStorage.m
//  Musical Text
//
//  Created by TJ Usiyan on 1/12/14.
//  Copyright (c) 2014 TJ Usiyan. All rights reserved.
//


#import "CLFLTextStorage.h"

@interface CLFLTextStorage ()
@property (nonatomic, strong) NSMutableAttributedString *privateAttributedString;
@property (nonatomic, strong) NSDataDetector *linkDetector;
@property (nonatomic, strong) NSRegularExpression *numberDetector;
@end

NSString * const CLFLPhoneNumberAttributeName = @"CLFLPhoneNumberAttributeName";

@implementation CLFLTextStorage

- (id)init {
    return [self initWithString:@""];
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr {
    self = [super init];
    if (self) {
        // use Text storage as backing to get the expected font behavior
        _privateAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attrStr];
        NSError *error = nil;
        _linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                           error:&error];

        if (_linkDetector == nil) {
            @throw [NSException exceptionWithName:@"CLFLUnexpectedStateException"
                                           reason:[NSString stringWithFormat:@"Text Storage error parsing the string. Error:%@", error]
                                         userInfo:nil];
        }

        _numberDetector = [NSRegularExpression regularExpressionWithPattern:@"[0-9]"
                                                                    options:0
                                                                      error:&error];

        if (_numberDetector == nil) {
            @throw [NSException exceptionWithName:@"CLFLUnexpectedStateException"
                                           reason:[NSString stringWithFormat:@"Text Storage error parsing the string. Error:%@", error]
                                         userInfo:nil];
        }
    }
    return self;
}

- (instancetype)initWithString:(NSString *)str
                    attributes:(NSDictionary *)attrs {
    return [self initWithAttributedString:[[NSMutableAttributedString alloc] initWithString:str
                                                                                 attributes:attrs]];
}

- (instancetype)initWithString:(NSString *)str {
    return [self initWithAttributedString:[[NSMutableAttributedString alloc] initWithString:str
                                                                                 attributes:@{}]];
}

#pragma mark NSAttributedString primitives

- (NSString *)string {
    return self.privateAttributedString.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range {
    return [self.privateAttributedString attributesAtIndex:location
                                            effectiveRange:range];
}

#pragma mark NSMutableAttributedString primitives

- (void)replaceCharactersInRange:(NSRange)aRange
                      withString:(NSString *)aString {
    [self.privateAttributedString replaceCharactersInRange:aRange
                                                withString:aString];
    [self edited:NSTextStorageEditedCharacters
           range:aRange
  changeInLength:aString.length - aRange.length];
}

- (void)setAttributes:(NSDictionary *)attributes
                range:(NSRange)aRange {
    [self.privateAttributedString setAttributes:attributes
                                          range:aRange];
    [self edited:NSTextStorageEditedAttributes
           range:aRange
  changeInLength:0];
}

#pragma mark -

- (void)processEditing {
    NSString *string = self.string;

    NSRange paragaphRange = [string paragraphRangeForRange:self.editedRange];
    [self removeAttribute:NSBackgroundColorAttributeName
                    range:paragaphRange];
    @try {
        [self.linkDetector enumerateMatchesInString:string
                                            options:0
                                              range:NSMakeRange(0, string.length)
                                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                             [self addAttribute:NSBackgroundColorAttributeName
                                                          value:[UIColor colorWithRed:0.9
                                                                                green:0.9
                                                                                 blue:0.9
                                                                                alpha:1.0]
                                                          range:result.range];
                                         }];

        [self.numberDetector enumerateMatchesInString:string
                                                   options:0
                                                     range:NSMakeRange(0, string.length)
                                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                                    [self addAttribute:CLFLPhoneNumberAttributeName
                                                                 value:@YES
                                                                 range:result.range];
                                                }];


    }
    @catch (NSException *exception) {
        NSLog(@"Caught exception: %@", exception);
    }
    @finally {
        // nothing to do
    }
    [super processEditing]; // call to super last.
}

@end
