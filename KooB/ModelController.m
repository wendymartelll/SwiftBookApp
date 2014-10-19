//
//  ModelController.m
//  Test
//
//  Created by Andrea Borghi on 8/14/14.
//  Copyright (c) 2014 Andrea Borghi. All rights reserved.
//

#import "ModelController.h"

@interface ModelController ()

@property (strong, nonatomic) NSMutableArray *pages;

@end

@implementation ModelController

- (instancetype)init
{
    self.pages = [[NSMutableArray alloc] init];
    
    return self;
}

- (instancetype)initWithInitialViewControllerFromStoryboard:(UIStoryboard *)storyboard
{
    self = [self init];
    
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Page Content View Controller"];
    [self.pages addObject:viewController];
    
    UIViewController *viewController2 = [storyboard instantiateViewControllerWithIdentifier:@"Page Content View Controller 2"];
    [self.pages addObject:viewController2];
    
    return self;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Return the data view controller for the given index.
    if (([self.pages count] == 0) || (index >= [self.pages count])) {
        return nil;
    }
    
    return [self.pages objectAtIndex:index];
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
    // Return the index of the given data view controller.
    return [self.pages indexOfObject:viewController];
}

- (NSUInteger)numberOfViewControllers
{
    return self.pages.count;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        [self updateParentControllerPageControlToIndexOfViewController:[self indexOfViewController:viewController]];
        
        return nil;
    }
    
    index--;
    
    [self updateParentControllerPageControlToIndexOfViewController:[self indexOfViewController:viewController]];
    
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    
    if (index == NSNotFound) {
        [self updateParentControllerPageControlToIndexOfViewController:[self indexOfViewController:viewController]];
        
        return nil;
    }
    
    index++;
    
    if (index == [self.pages count]) {
        [self updateParentControllerPageControlToIndexOfViewController:[self indexOfViewController:viewController]];
        
        return nil;
    }
    
    [self updateParentControllerPageControlToIndexOfViewController:[self indexOfViewController:viewController]];
    
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (void)updateParentControllerPageControlToIndexOfViewController:(NSInteger)index
{
    if (self.parentController) {
        [self.parentController updatePageControlToPageNumber:index];
    }
}

@end