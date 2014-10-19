//
//  KBPageViewController.h
//  Koob
//
//  Created by Andrea Borghi on 8/14/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

- (void)updatePageControlToPageNumber:(NSInteger)pageNumber;

@end