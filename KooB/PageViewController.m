//
//  KBPageViewController.m
//  Koob
//
//  Created by Andrea Borghi on 8/14/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import "PageViewController.h"
#import "ModelController.h"

@interface PageViewController ()
@property (strong, nonatomic) ModelController *modelController;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end

@implementation PageViewController

@synthesize modelController = _modelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = nil;
    
    self.modelController = [[ModelController alloc] initWithInitialViewControllerFromStoryboard:self.storyboard];
    
    self.modelController.parentController = self;
    
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    UIViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    self.pageControl.numberOfPages = [self.modelController numberOfViewControllers];
}

- (void)updatePageControlToPageNumber:(NSInteger)pageNumber
{
    self.pageControl.currentPage = pageNumber;
    
    [self.pageControl updateCurrentPageDisplay];
}

@end