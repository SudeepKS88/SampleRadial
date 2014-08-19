//
//  RadialMenu.m
//  RadialMenuInObjC
//
//  Created by RapidValue on 08/08/14.
//  Copyright (c) 2014 RapidValue. All rights reserved.
//

#import "RadialMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "SegmentDetail.h"
#import "SectorImageView.h"


static float deltaAngle;
//static float minAlphavalue = 1.0;
//static float maxAlphavalue = 1.0;

@interface RadialMenu () {
    
    
}

@property CGAffineTransform startTransform;
@property (nonatomic, strong) UIView *menuContainer;
@property int numberOfSections;
@property int currentValue;
@property (weak) id <RadialMenuDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *cloves;

@end

@implementation RadialMenu

@synthesize menuContainer;
@synthesize numberOfSections,currentValue;
@synthesize delegate,cloves;
@synthesize startTransform;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber {
    
    if ((self = [super initWithFrame:frame])) {
        
        self.currentValue = -1;
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
        
    }
    return self;
}


- (void)showMenu {
    
    [self drawWheel];

}

- (void) drawWheel {
    
    self.menuContainer = [[UIView alloc] initWithFrame:self.frame];

    CGFloat angleSize = 2*M_PI/numberOfSections;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        NSString *imageName = nil;
        if(self.frame.size.width == 180)
            imageName = @"segment01-active.png";
        else if(self.frame.size.width == 540)
            imageName = @"segment03-active.png";
        else
            imageName = @"segment02-active.png";

        SectorImageView *im = [[SectorImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        
        im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        im.layer.position = CGPointMake(menuContainer.bounds.size.width/2.0-menuContainer.frame.origin.x,
                                        menuContainer.bounds.size.height/2.0-menuContainer.frame.origin.y);
        im.transform = CGAffineTransformMakeRotation(angleSize*i);
//        im.alpha = minAlphavalue;
        im.tag = i;
        [im addGesture];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50 ,50)];
        label.tag = i;
        [label setBackgroundColor:[UIColor clearColor]];
//        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:[NSString stringWithFormat:@"%d",i]];
        label.transform = CGAffineTransformMakeRotation(25);
        [im addSubview:label];
        [menuContainer addSubview:im];
        
    }
    
    
    menuContainer.userInteractionEnabled = NO;
    [self addSubview:menuContainer];
    
    cloves = [NSMutableArray arrayWithCapacity:numberOfSections];
    
    if (numberOfSections % 2 == 0) {
        [self buildClovesEven];
    } else {
        [self buildClovesOdd];
    }
}



- (void) changeSelectionImage:(int)value {
    
    UIImageView *res;
    
    NSArray *views = [menuContainer subviews];
    
    NSString *imageName = nil;
    if(self.frame.size.width == 180)
        imageName = @"segment01";
    else if(self.frame.size.width == 540)
        imageName = @"segment03";
    else
        imageName = @"segment02";
    
    for (UIImageView *im in views) {
        
        if (im.tag == value){
            res = im;
            im.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
        }
        else{
            im.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-active.png",imageName]];
        }
    }
}

- (void) buildClovesEven {
    
    CGFloat fanWidth = M_PI*2/numberOfSections;
    CGFloat mid = 1;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        SegmentDetail *clove = [[SegmentDetail alloc] init];
        clove.midValue = mid;
        clove.minValue = mid - (fanWidth/2);
        clove.maxValue = mid + (fanWidth/2);
        clove.value = i;
        
        
        if (clove.maxValue-fanWidth < - M_PI) {
            
            mid = M_PI;
            clove.midValue = mid;
            clove.minValue = fabsf(clove.maxValue);
            
        }
        
        mid -= fanWidth;
        
        NSLog(@"cl is %@", clove);
        [cloves addObject:clove];
    }
}


- (void) buildClovesOdd {
    
    CGFloat fanWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        SegmentDetail *clove = [[SegmentDetail alloc] init];
        clove.midValue = mid;
        clove.minValue = mid - (fanWidth/2);
        clove.maxValue = mid + (fanWidth/2);
        clove.value = i;
        
        mid -= fanWidth;
        
        if (clove.minValue < - M_PI) {
            
            mid = -mid;
            mid -= fanWidth;
            
        }
        [cloves addObject:clove];
        NSLog(@"cl is %@", clove);
    }
}

- (float) calculateDistanceFromCenter:(CGPoint)point {
    
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [[event allTouches] anyObject];

    CGPoint touchPoint = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:touchPoint];
    
    if (dist < 40 || dist > self.frame.size.width/2)
    {
        // forcing a tap to be on the ferrule
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return ;
    }
    
    float dx = touchPoint.x - menuContainer.center.x;
    float dy = touchPoint.y - menuContainer.center.y;
    deltaAngle = atan2(dy,dx);
    
    startTransform = menuContainer.transform;
    
    [self changeSelectionImage:currentValue];
//    im.alpha = minAlphavalue;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint pt = [touch locationInView:self];
    
    float dist = [self calculateDistanceFromCenter:pt];
    
    if (dist < 40 || dist > self.frame.size.width/2)
    {
        // a drag path too close to the center
        NSLog(@"drag path too close to the center (%f,%f)", pt.x, pt.y);
        
        // here you might want to implement your solution when the drag
        // is too close to the center
        // You might go back to the clove previously selected
        // or you might calculate the clove corresponding to
        // the "exit point" of the drag.
        
    }
    
    float dx = pt.x  - menuContainer.center.x;
    float dy = pt.y  - menuContainer.center.y;
    float ang = atan2(dy,dx);
    
    float angleDifference = deltaAngle - ang;
    
    menuContainer.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGFloat radians = atan2f(menuContainer.transform.b, menuContainer.transform.a);
    
    CGFloat newVal = 0.0;
    
    for (SegmentDetail *c in cloves) {
        
        if (c.minValue > 0 && c.maxValue < 0) { // anomalous case
            
            if (c.maxValue > radians || c.minValue < radians) {
                
                if (radians > 0) { // we are in the positive quadrant
                    
                    newVal = radians - M_PI;
                    
                } else { // we are in the negative one
                    
                    newVal = M_PI + radians;
                    
                }
                currentValue = c.value;
                
            }
            
        }
        
        else if (radians > c.minValue && radians < c.maxValue) {
            
            newVal = radians - c.midValue;
            currentValue = c.value;
            
        }
        
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
    CGAffineTransform t = CGAffineTransformRotate(menuContainer.transform, -newVal);
    menuContainer.transform = t;
    
    [UIView commitAnimations];
    
    if(delegate!=nil && [delegate respondsToSelector:@selector(radialMenu:didChangeValueToIndex:)]){
        [self.delegate radialMenu:self didChangeValueToIndex:currentValue];
    }
    
    [self changeSelectionImage:currentValue];
//    im.alpha = maxAlphavalue;
    
}


- (void)updateLabelsWithIndexSelected:(int)index withString:(NSString *)level{
    
    NSArray *views = [menuContainer subviews];
    
    for (UIImageView *im in views) {
        
        UILabel *label = (UILabel*)[[im subviews] objectAtIndex:0];
        label.text = [NSString stringWithFormat:@"%ld(of %d)",(long)label.tag,index];
    }
}


@end
