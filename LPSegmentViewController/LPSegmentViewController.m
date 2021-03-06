//
//  LPSegmentViewController.m
//
//  Created by litt1e-p on 15/11/25.
//  Copyright © 2015年 litt1e-p. All rights reserved.
//

#import "LPSegmentViewController.h"

@interface LPSegmentViewController ()

@property(nonatomic,assign) UIViewController *selectedViewController;
@property(nonatomic, assign) NSInteger selectedViewCtlWithIndex;
@property(nonatomic,strong) UISegmentedControl *segmentControl;

@end

@implementation LPSegmentViewController
@synthesize segmentTinColor = _segmentTinColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self segmentInit];
}

- (void)segmentInit
{
    if (!_segmentControl) {
        _segmentControl                     = [[UISegmentedControl alloc]init];
        _segmentControl.layer.masksToBounds = YES ;
        _segmentControl.layer.cornerRadius  = 3.0;
        _segmentControl.tintColor           = self.segmentTinColor;
        self.navigationItem.titleView       = _segmentControl;
    } else {
        [_segmentControl removeAllSegments];
    }
    [_segmentControl addTarget:self
                        action:@selector(didClickSegmentItem:)
              forControlEvents:UIControlEventValueChanged];
}

- (void)loadViewControllers :(NSArray *)arrVc andSegementTitles :(NSArray *)arrTitle
{
    if (_segmentControl.numberOfSegments > 0) {
        return;
    }
    for (int i = 0; i < arrVc.count; i++) {
        [self addViewController:arrVc[i] title:arrTitle[i]];
    }
    _segmentControl.frame = CGRectMake(0, 0, 200, 25);
    [_segmentControl setSelectedSegmentIndex:self.segmentSelectedIndex];
    self.selectedViewCtlWithIndex = self.segmentSelectedIndex;
}

- (void)addViewController:(UIViewController *)viewController title:(NSString *)title
{
    [_segmentControl insertSegmentWithTitle:title atIndex:_segmentControl.numberOfSegments animated:NO];
    [self addChildViewController:viewController];
    [_segmentControl sizeToFit];
}

- (void)setSelectedViewCtlWithIndex:(NSInteger)index
{
    if (!_selectedViewController) {
        _selectedViewController            = self.childViewControllers[index];
        _selectedViewController.view.frame = self.view.frame;
        [_selectedViewController willMoveToParentViewController:nil];
        [self.view addSubview:[_selectedViewController view]];
        [_selectedViewController didMoveToParentViewController:self];
    } else {
        __weak typeof(self) weakSelf = self;
        UIViewController *selectedVc = self.childViewControllers[index];
        selectedVc.view.frame        = (CGRect){{0, 0}, _selectedViewController.view.bounds.size};
        [self transitionFromViewController:_selectedViewController
                          toViewController:self.childViewControllers[index]
                                  duration:0.0f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:nil
                                completion:^(BOOL finished) {
                                    [_selectedViewController.view removeFromSuperview];
                                    _selectedViewController   = weakSelf.childViewControllers[index];
                                    _selectedViewCtlWithIndex = index;
                                    [_selectedViewController didMoveToParentViewController:weakSelf];
        }];
    }
}

#pragma mark - action
- (void)didClickSegmentItem:(UISegmentedControl *)sender
{
    self.selectedViewCtlWithIndex = _segmentControl.selectedSegmentIndex;
}

#pragma mark - property
- (UIColor *)segmentTinColor
{
    if (!_segmentTinColor) {
        _segmentTinColor = [UIColor whiteColor];
    }
    return _segmentTinColor;
}

- (void)setSegmentTinColor:(UIColor *)segmentTinColor
{
    _segmentTinColor = segmentTinColor;
    _segmentControl.tintColor = segmentTinColor;
}

@end
