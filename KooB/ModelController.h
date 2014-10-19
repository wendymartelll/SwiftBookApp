//
//  ModelController.h
//  Test
//
//  Created by Andrea Borghi on 8/14/14.
//  Copyright (c) 2014 Andrea Borghi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

@property (nonatomic, strong) PageViewController * parentController;

- (instancetype)initWithInitialViewControllerFromStoryboard:(UIStoryboard *)storyboard;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(UIViewController *)viewController;
- (NSUInteger)numberOfViewControllers;

@end

