//
//  RadialMenu.h
//  RadialMenuInObjC
//
//  Created by RapidValue on 08/08/14.
//  Copyright (c) 2014 RapidValue. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RadialMenu : UIView


- (void) showMenu;
- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;
- (void)updateLabelsWithIndexSelected:(int)index withString:(NSString *)level;

@end

@protocol RadialMenuDelegate <NSObject>

- (void) radialMenu:(RadialMenu *)radialMenu didChangeValueToIndex:(int)newIndex;

@end
