//
//  SectorImageView.m
//  RadialMenuInObjC
//
//  Created by RapidValue on 08/08/14.
//  Copyright (c) 2014 RapidValue. All rights reserved.
//

#import "SectorImageView.h"

@implementation SectorImageView

- (void)addGesture {
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(highlightLetter:)];
    letterTapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:letterTapRecognizer];

}

- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    UIImageView *view = (UIImageView*) sender.view;
    NSLog(@"%ld", (long)[view tag]);//By tag, you can find out where you had typed.
}
@end
