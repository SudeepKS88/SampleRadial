//
//  RadialMenuContainer.m
//  RadialMenuInObjC
//
//  Created by RapidValue on 11/08/14.
//  Copyright (c) 2014 RapidValue. All rights reserved.
//

#import "RadialMenuContainer.h"
#import "RadialMenu.h"

@interface RadialMenuContainer ()<RadialMenuDelegate> {
    
}

@property (nonatomic,retain) RadialMenu * innermostMenu;
@property (nonatomic,retain) RadialMenu * firstLevelMenu;
@property (nonatomic,retain) RadialMenu * secondLevelMenu;


- (void)foldMenuLevelFrom:(RadialMenu *)menu;
- (void)expandMenuLevelTo:(RadialMenu *)menu;

@end

@implementation RadialMenuContainer
@synthesize innermostMenu,firstLevelMenu,secondLevelMenu;
@synthesize delegate;

+ (RadialMenuContainer *)sharedInstance {
    static RadialMenuContainer *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RadialMenuContainer alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _sharedClient.backgroundColor = [UIColor blackColor];
        _sharedClient.alpha = .8;
        
    });
    
    return _sharedClient;
}


- (void)setUpInnermostRadialMenu {
    
    if(!innermostMenu){
        innermostMenu = [[RadialMenu alloc] initWithFrame:CGRectMake(0, 0, 180, 180)
                                     andDelegate:self
                                    withSections:8];
        [innermostMenu showMenu];
        innermostMenu.clipsToBounds = YES;
        
        innermostMenu.frame = CGRectMake(self.frame.size.width, self.frame.size.height, 0, 0);
        [self insertSubview:innermostMenu atIndex:0];
    }
}


- (void)setUpFirstLevelRadialMenu {
    
    if(!firstLevelMenu){
        firstLevelMenu = [[RadialMenu alloc] initWithFrame:CGRectMake(0, 0, 360, 360)
                                      andDelegate:self
                                     withSections:8];
        [firstLevelMenu showMenu];
        firstLevelMenu.clipsToBounds = YES;
        firstLevelMenu.frame = CGRectMake(self.frame.size.width, self.frame.size.height, 0, 0);
        [self addSubview:firstLevelMenu];
        [self insertSubview:firstLevelMenu atIndex:0];
    }
}

- (void)setUpSecondLevelRadialMenu {
    
    if(!secondLevelMenu){
        secondLevelMenu = [[RadialMenu alloc] initWithFrame:CGRectMake(0, 0, 540, 540)
                                      andDelegate:self
                                     withSections:8];
        [secondLevelMenu showMenu];
        secondLevelMenu.clipsToBounds = YES;
        secondLevelMenu.frame = CGRectMake(self.frame.size.width, self.frame.size.height, 0, 0);
        [self addSubview:secondLevelMenu];
        [self insertSubview:secondLevelMenu atIndex:0];
    }
    
}



- (void)fold {
    
    [self foldMenuLevelFrom:innermostMenu];
    [self foldMenuLevelFrom:firstLevelMenu];
    [self foldMenuLevelFrom:secondLevelMenu];
}

- (void)expand {
    
    [self expandMenuLevelTo:innermostMenu];

}


- (void)foldMenuLevelFrom:(RadialMenu *)menu {
    
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         menu.frame = CGRectMake(self.frame.size.width, self.frame.size.height, 0, 0);
                     }
                     completion:^(BOOL finished) {
                     }];
}


- (void)expandMenuLevelTo:(RadialMenu *)menu {
    
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         menu.frame = [self frameForRadialMenu:menu];
                         menu.center = CGPointMake(self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}



#pragma mark - Menu Delegates

- (void) radialMenu:(RadialMenu *)radialMenu didChangeValueToIndex:(int)newIndex {

    if(radialMenu == innermostMenu){
        
        [self setUpFirstLevelRadialMenu];
        [self expandMenuLevelTo:firstLevelMenu];
        [self foldMenuLevelFrom:secondLevelMenu];
        [firstLevelMenu updateLabelsWithIndexSelected:newIndex withString:@"1"];
    }
    else if(radialMenu == firstLevelMenu){
        
        [self setUpSecondLevelRadialMenu];
        [self expandMenuLevelTo:secondLevelMenu];
        [secondLevelMenu updateLabelsWithIndexSelected:newIndex withString:@"2"];

    }
    else {
        if(delegate && [delegate respondsToSelector:@selector(didChangeMenuSelectionToIndex:)]){
            [self.delegate didChangeMenuSelectionToIndex:newIndex];
        }
    }
}


- (CGRect)frameForRadialMenu:(RadialMenu *)radialMenu {
    
    CGRect frame = CGRectZero;
    if(radialMenu == innermostMenu){
        frame = CGRectMake(0, 0, 180, 180);
    }
    else if(radialMenu == firstLevelMenu){
        frame = CGRectMake(0, 0, 360, 360);
    }
    else {
        frame = CGRectMake(0, 0, 540, 540);
    }
    return frame;
}


@end
