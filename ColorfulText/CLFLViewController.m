//
//  CLFLViewController.m
//  ColorfulText
//
//  Created by TJ Usiyan on 2/19/14.
//  Copyright (c) 2014 TJ Usiyan. All rights reserved.
//

#import "CLFLViewController.h"
#import "CLFLTextStorage.h"

@interface CLFLViewController ()
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) NSTextStorage *textStorage;
@end

@implementation CLFLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect textViewRect = CGRectInset(self.view.bounds, 12., 12.);

    CLFLTextStorage *textStorage = [[CLFLTextStorage alloc] init];


    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [textStorage addLayoutManager: layoutManager];

    NSTextContainer *textContainer = [NSTextContainer new];
    [layoutManager addTextContainer: textContainer];

    UITextView *textView = [[UITextView alloc] initWithFrame:textViewRect
                                               textContainer:textContainer];
    [self.view addSubview:textView];
    self.textView = textView;
    self.textStorage = textStorage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
