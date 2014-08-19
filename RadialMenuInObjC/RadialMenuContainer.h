//
//  RadialMenuContainer.h
//  RadialMenuInObjC
//
//  Created by RapidValue on 11/08/14.
//  Copyright (c) 2014 RapidValue. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RadialMenuContainerDelegate <NSObject>

-(void)didChangeMenuSelectionToIndex:(int)index;

@end

@interface RadialMenuContainer : UIView

@property (nonatomic, retain) id <RadialMenuContainerDelegate> delegate;

+ (RadialMenuContainer *)sharedInstance;
- (void)setUpInnermostRadialMenu;

- (void)fold;
- (void)expand;

@end
