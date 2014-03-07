//
//  CLFLViewController.m
//  ColorfulText
//
//  Created by TJ Usiyan on 2/19/14.
//  Copyright (c) 2014 TJ Usiyan. All rights reserved.
//

#import "CLFLViewController.h"
#import "CLFLTextStorage.h"
#import "CLFLLayoutManager.h"
#import "CLFLLayoutManagerDelegate.h"

@interface CLFLViewController ()
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, strong) CLFLLayoutManagerDelegate *layoutManagerDelegate;
@property (nonatomic, weak) NSTextStorage *textStorage;
@end

@implementation CLFLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    CGRect textViewRect = UIEdgeInsetsInsetRect(self.view.bounds, edgeInsets);

    CLFLTextStorage *textStorage = [[CLFLTextStorage alloc] init];


    self.layoutManagerDelegate = [[CLFLLayoutManagerDelegate alloc] init];
    CLFLLayoutManager *layoutManager = [[CLFLLayoutManager alloc] init];
    layoutManager.delegate = self.layoutManagerDelegate;
    layoutManager.edgeInsets = edgeInsets;
    [textStorage addLayoutManager: layoutManager];

    NSTextContainer *textContainer = [[NSTextContainer alloc] init];
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
