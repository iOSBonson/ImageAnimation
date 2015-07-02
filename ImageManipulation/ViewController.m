//
//  ViewController.m
//  ImageManipulation
//
//  Created by Bonson on 5/27/13.
//  Copyright (c) 2013 Frozen Digit. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

#import <stdio.h>

#define deg2rad(degrees) (degrees * 0.01745327)
@interface ViewController ()

@end

@implementation ViewController{
    IBOutlet UIImageView *rotatingImageView;
    UITouch *currentTouch;
}


-(UIImage *) mergeTwoImages: (UIImage *)bottomImage : (UIImage *)upperImage : (CGRect)rect

{
    
    UIImage *image = upperImage;
    
    CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
    
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    
    [bottomImage drawInRect:CGRectMake(rotatingImageView.frame.origin.x,rotatingImageView.frame.origin.y,newSize.width,newSize.height)];
    
    // Apply supplied opacity
    
    [image drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0f / -500.0f;
    
//    NSMutableArray *data = [[NSMutableArray alloc] init];
//  //  [data addObject:[NSValue valueWithCGPoint:CGPointMake(20.0f, 10.0f)]];
// //   [data addObject:[NSValue valueWithCGPoint:CGPointMake(5.0f, -15.0f)]];
////    [data addObject:[NSValue valueWithCGPoint:CGPointMake(-5.0f, 20.0f)]];
////    [data addObject:[NSValue valueWithCGPoint:CGPointMake(15.0f, 30.0f)]];
//
//    NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:13],@"marks" ,[NSNumber numberWithInt:20],@"marks", nil];
//    
//     NSDictionary *d2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:20],@"marks", nil];
//    
// //   NSLog(@"%@",d1);
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    
//    [array addObject:d1];
//    [array addObject:d2];
//     
//
//   NSLog(@"min x: %f",[[array valueForKeyPath:@"@max.marks"] floatValue]);

 //   [data addObject: [NSValue valueWithCGRect:CGRectMake(5.0f,6.0f,20.0f,20.8f)]];
//    [data addObject: [NSValue valueWithCGRect:CGRectMake(3.0f,6.0f,20.0f,20.8f)]];
 //   [data addObject: [NSValue valueWithCGRect:CGRectMake(1.0f,6.0f,20.0f,20.8f)]];
    
     
    

    
//    [data addObject:[NSNumber numberWithInt:20]];
  //  [data addObject:[NSNumber numberWithInt:22]];
    
    
    
     
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    [rotatingImageView setImage:[self mergeTwoImages:[UIImage imageNamed:@"iphone.jpg"] :[UIImage imageNamed:@"url.gif"] :rotatingImageView.frame]];
    
    UIRotationGestureRecognizer *rotationGesture =
    [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(handleRotate:)];
    rotationGesture.delegate = (id)self;
    [rotatingImageView addGestureRecognizer:rotationGesture];
}
//Multi-Channel Funnels data collection lags by up to two days and therefore data from today and yesterday is not available in your reports.

//As soon as you create a Goal, it starts recording data. You can pause a Goal by changing the Recording status to OFF. No data is recorded for a Goal when turned off, but you can resume recording anytime by turning it back ON. You can't retrive data during the time a Goal is OFF.

- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    NSLog(@"in the method");
    if(recognizer.state == UIGestureRecognizerStateBegan ||
       recognizer.state == UIGestureRecognizerStateChanged)
    {
        recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform,
                                                            recognizer.rotation);
        [recognizer setRotation:0];
    }
}

// another approach

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        currentTouch=touch;
        if (CGRectContainsPoint([self.view frame], [touch locationInView:rotatingImageView]))
        {
            [self transformSpinnerwithTouches:touch];
        }
        else if (!CGRectContainsPoint([rotatingImageView frame], [touch locationInView:rotatingImageView])) {
            
         //   [self dispatchTouchEvent:[touch view]WithTouch:touch];
        
        }
    }
}

-(void)transformSpinnerwithTouches:(UITouch *)touchLocation
{
    CGPoint touchLocationpoint = [touchLocation locationInView:self.view];
    CGPoint PrevioustouchLocationpoint = [touchLocation previousLocationInView:self.view];
    
    //Origin is the respective point. From that I am going to measure the
    //angle of the current position with respect to the previous position ....
    CGPoint origin;
    origin.x=rotatingImageView.center.x;
    origin.y=rotatingImageView.center.y;
    //NSLog(@"currentTouch Touch In Location In View:%F %F\n",touchLocationpoint.x,touchLocationpoint.y);
    //NSLog(@"currentTouch Touch previous Location In View:%F %F\n",PrevioustouchLocationpoint.x,PrevioustouchLocationpoint.y);
    CGPoint previousDifference = [self vectorFromPoint:origin toPoint:PrevioustouchLocationpoint];
    CGAffineTransform newTransform =CGAffineTransformScale(rotatingImageView.transform, 1, 1);
    CGFloat previousRotation = atan2(previousDifference.y, previousDifference.x);
    CGPoint currentDifference = [self vectorFromPoint:origin toPoint:touchLocationpoint];
    CGFloat currentRotation = atan2(currentDifference.y, currentDifference.x);
    CGFloat newAngle = currentRotation- previousRotation;
    NSLog(@"currentRotation of x %F  previousRotation %F\n",currentRotation,previousRotation);
 //   NSLog(@"Angle:%F\n",(temp1*180)/M_PI);
 //   temp1=temp1+newAngle;
    //NSLog(@"Angle:%F\n",(temp1*180)/M_PI);
    newTransform = CGAffineTransformRotate(newTransform, newAngle);
    [self animateView:rotatingImageView toPosition:newTransform];
}

-(CGPoint)vectorFromPoint:(CGPoint)firstPoint toPoint:(CGPoint)secondPoint
{
    CGPoint result;
    CGFloat x = secondPoint.x-firstPoint.x;
    CGFloat y = secondPoint.y-firstPoint.y;
    result = CGPointMake(x, y);
    return result;
}



-(void)animateView:(UIView *)theView toPosition:(CGAffineTransform) newTransform
{
    //animating the rotator arrow...
    [UIView setAnimationsEnabled:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.0750];
    rotatingImageView.transform = newTransform;
    [UIView commitAnimations];
}




-(IBAction)rotate:(id)sender{
    
    
        
    [UIView beginAnimations:nil context:nil];
    CATransform3D _3Dt = CATransform3DRotate(rotatingImageView.layer.transform,3.14, 0.0, 1.0,0.0);
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationDuration:5];
    rotatingImageView.layer.transform=_3Dt;
    [UIView commitAnimations];
    
    return;
    
    
    
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:deg2rad(360)];
    rotate.duration = 1;
    rotate.repeatCount = 1;
    [rotatingImageView.layer addAnimation:rotate forKey:@"10"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
