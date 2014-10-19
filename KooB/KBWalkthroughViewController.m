//
//  KBWalkthroughViewController.m
//  Koob
//
//  Created by Andrea Borghi on 8/14/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import "KBWalkthroughViewController.h"

@interface KBWalkthroughViewController ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *studentPictures;
@property (weak, nonatomic) IBOutlet UIView * pictureContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *centralPicture;

@end

@implementation KBWalkthroughViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self animatePictures];
    //self.centralPicture.frame = CGRectMake(self.centralPicture.frame.origin.x, self.centralPicture.frame.origin.y, self.view.frame.size.height / 10, self.view.frame.size.width / 10);
}

- (void)animatePictures
{
    for (UIImageView * picure in self.studentPictures) {
        CGPoint finalPoint = picure.center;
        
        picure.center = CGPointMake(arc4random_uniform(self.view.frame.size.width * 1.5) + self.view.frame.size.width, arc4random_uniform(self.view.frame.size.height * 1.5) + self.view.frame.size.height);
        
        [UIView animateWithDuration:1.5 delay:0.5 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:NO animations:^{
            picure.center = finalPoint;
        } completion:Nil];
    }
}

@end