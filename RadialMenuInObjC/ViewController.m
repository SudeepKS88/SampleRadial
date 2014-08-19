//
//  ViewController.m
//  RadialMenuInObjC
//
//  Created by RapidValue on 08/08/14.
//  Copyright (c) 2014 RapidValue. All rights reserved.
//

#import "ViewController.h"
#import "RadialMenu.h"
#import <QuartzCore/QuartzCore.h>

#import "SectorImageView.h"
#import "RadialMenuContainer.h"

@interface ViewController ()<RadialMenuContainerDelegate> {
    
    IBOutlet UILabel *SelectedLabel;
}

@property (nonatomic,retain) RadialMenu * menu;
@property (nonatomic,retain) RadialMenu * menu1;

@end

@implementation ViewController

@synthesize menu,menu1;
            
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMenu];
}

- (void)createMenu {
    
    [[RadialMenuContainer sharedInstance] setUpInnermostRadialMenu];
    [RadialMenuContainer sharedInstance].delegate = self;
}


-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}



- (IBAction)onClick:(id)sender {
    

    if([sender isSelected]){
        [[RadialMenuContainer sharedInstance] removeFromSuperview];
        [[RadialMenuContainer sharedInstance] fold];
    }
    else{
        [self.view insertSubview:[RadialMenuContainer sharedInstance] atIndex:0];
        [[RadialMenuContainer sharedInstance] expand];
    }
    [sender setSelected:![sender isSelected]];
}


#pragma mark - menu delegate

-(void)didChangeMenuSelectionToIndex:(int)index {
    
    SelectedLabel.text = [NSString stringWithFormat:@"Index %d of outermost menu selected",index];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
