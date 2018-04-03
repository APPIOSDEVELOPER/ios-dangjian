//
//  WMPageController.m
//  WMPageController
//
//  Created by Mark on 15/6/11.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMPageController.h"
#import "WMPageConst.h"
//#import "CathAssist-Swift.h"

@interface WMPageController () <WMMenuViewDelegate,UIScrollViewDelegate> {
//    CGFloat self.viewHeight;
//    CGFloat _viewWidth;
    CGFloat _viewX;
//    CGFloat _viewY;
    CGFloat _targetX;
    BOOL    _animate;
}
@property (nonatomic, strong, readwrite) UIViewController *currentViewController;
@property (nonatomic, weak) UIScrollView *scrollView;
// 用于记录子控制器view的frame，用于 scrollView 上的展示的位置
@property (nonatomic, strong) NSMutableArray *childViewFrames;
// 当前展示在屏幕上的控制器，方便在滚动的时候读取 (避免不必要计算)
@property (nonatomic, strong) NSMutableDictionary *displayVC;
// 用于记录销毁的viewController的位置 (如果它是某一种scrollView的Controller的话)
@property (nonatomic, strong) NSMutableDictionary *posRecords;
// 用于缓存加载过的控制器
@property (nonatomic, strong) NSCache *memCache;
// 收到内存警告的次数
@property (nonatomic, assign) int memoryWarningCount;
@end

@implementation WMPageController

#pragma mark - Lazy Loading
- (NSMutableDictionary *)posRecords {
    if (_posRecords == nil) {
        _posRecords = [[NSMutableDictionary alloc] init];
    }
    return _posRecords;
}

- (NSMutableDictionary *)displayVC {
    if (_displayVC == nil) {
        _displayVC = [[NSMutableDictionary alloc] init];
    }
    return _displayVC;
}

#pragma mark - Public Methods
- (instancetype)initWithViewControllerClasses:(NSArray *)classes andTheirTitles:(NSArray *)titles {
    if (self = [super init]) {
        NSAssert(classes.count == titles.count, @"classes.count != titles.count");
        _viewControllerClasses = [NSArray arrayWithArray:classes];
        _titles = [NSArray arrayWithArray:titles];

        [self setup];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
    
}

- (void)setCachePolicy:(WMPageControllerCachePolicy)cachePolicy {
    _cachePolicy = cachePolicy;
    self.memCache.countLimit = _cachePolicy;
}

- (void)setItemsMargins:(NSArray *)itemsMargins {
    NSAssert(itemsMargins.count == self.viewControllerClasses.count + 1, @"item's margin's number must equal to viewControllers's count + 1");
    _itemsMargins = itemsMargins;
}

- (void)setItemsWidths:(NSArray *)itemsWidths {
    NSAssert(itemsWidths.count == self.titles.count, @"itemsWidths.count != self.titles.count");
    _itemsWidths = [itemsWidths copy];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    if (self.menuView) {
        [self.menuView selectItemAtIndex:selectIndex];
    }
}

- (void)setViewFrame:(CGRect)viewFrame {
    _viewFrame = viewFrame;
    if (self.menuView) {
        [self viewDidLayoutSubviews];
    }
}

#pragma mark - Private Methods

// 当子控制器init完成时发送通知
- (void)postAddToSuperViewNotificationWithIndex:(int)index {
    self.currentIndex = index;
    if (!self.postNotification) return;
    NSDictionary *info = @{
                           @"index":@(index),
                           @"title":self.titles[index]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidAddToSuperViewNotification
                                                        object:info];
}

// 当子控制器完全展示在user面前时发送通知
- (void)postFullyDisplayedNotificationWithCurrentIndex:(NSInteger)index {
    if (!self.postNotification || self.titles.count <= index) return;
    NSDictionary *info = @{
                           @"index":@(index),
                           @"title":self.titles[index]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidFullyDisplayedNotification
                                                        object:info];
}

// 初始化一些参数，在init中调用
- (void)setup {
    _titleSizeSelected  = WMTitleSizeSelected;
    _titleColorSelected = WMTitleColorSelected;
    _titleSizeNormal    = WMTitleSizeNormal;
    _titleColorNormal   = WMTitleColorNormal;
    
    _menuBGColor   = WMMenuBGColor;
    _menuHeight    = WMMenuHeight;
    _menuItemWidth = WMMenuItemWidth;
    
    _memCache = [[NSCache alloc] init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeColor:) name:@"" object:nil];
}

- (void)changeColor:(NSNotification*)nofifer{
    
}

// 包括宽高，子控制器视图 frame
- (void)calculateSize {
//    if (CGRectEqualToRect(self.viewFrame, CGRectZero)) {
//        _viewWidth = self.view.frame.size.width;
//        _viewHeight = self.view.frame.size.height - self.menuHeight;
//    } else {
//        _viewWidth = self.viewFrame.size.width;
//        _viewHeight = self.viewFrame.size.height - self.menuHeight;
//    }
    
    
    
    _viewX = self.viewFrame.origin.x;
//    _viewY = self.viewFrame.origin.y;
    // 重新计算各个控制器视图的宽高
    _childViewFrames = [NSMutableArray array];
    
    NSInteger py = 0;
    
    if (IS_IPHONE_X) {
        if (@available(iOS 11.0, *)) {
            py = 26;
        } else {
            // Fallback on earlier versions
        }
    }
    self._viewY = py;
    
    for (int i = 0; i < self.viewControllerClasses.count; i++) {
        CGRect frame = CGRectMake(i*self.viewWidth, self._viewY, self.viewWidth, self.viewHeight - self._viewY);
        [_childViewFrames addObject:[NSValue valueWithCGRect:frame]];
    }
}

//- (void)reloadData{
//    self.selectIndex = 0;
//    [self calculateSize];
//    
//    [self addViewControllerAtIndex:self.selectIndex];
//    self.currentViewController = self.displayVC[@(self.selectIndex)];
//    self.currentViewController = self.displayVC[@(self.selectIndex)];
//    [self viewDidLayoutSubviews];
//}


//- (void)viewWillLayoutSubviews{
//    [_childViewFrames removeAllObjects];
//    [self calculateSize];
//    [self layoutChildViewControllers];
//    [self viewDidLayoutSubviews];
//}

- (void)addScrollView {
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    [self.view addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = self.bounces;
//    scrollView.scrollEnabled = false;
    scrollView.directionalLockEnabled = true;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollView = scrollView;
    
    
}

- (void)addMenuView {
    
//    if (self.menuView) {
//        [self.menuView removeFromSuperview];
//    }
    
    CGFloat width = self.view.frame.size.width;
    
    NSInteger py = 0;
    if (IS_IPHONE_X){
        py = 88;
//     if ([self isKindOfClass:[DailyViewController class]]){
//            py = 0;
//        }

    }
//    else if ([self isKindOfClass:[DailyViewController class]]){
//        py = 0;
//    }
    
    CGRect frame = CGRectMake(_viewX, py, width, self.menuHeight);
    WMMenuView *menuView = [[WMMenuView alloc] initWithFrame:frame buttonItems:self.titles backgroundColor:self.menuBGColor norSize:self.titleSizeNormal selSize:self.titleSizeSelected norColor:self.titleColorNormal selColor:self.titleColorSelected];
    menuView.backgroundColor = [UIColor redColor];
    menuView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    menuView.delegate = self;
    menuView.style = self.menuViewStyle;
    menuView.progressHeight = self.progressHeight;
    if (self.titleFontName) {
        menuView.fontName = self.titleFontName;
    }
    if (self.progressColor) {
        menuView.lineColor = self.progressColor;
    }
    [self.view addSubview:menuView];
    self.menuView = menuView;
    // 如果设置了初始选择的序号，那么选中该item
    if (self.selectIndex != 0) {
        [self.menuView selectItemAtIndex:self.selectIndex];
    }
}

- (void)layoutChildViewControllers {
    int currentPage = (int)self.scrollView.contentOffset.x / self.viewWidth;
    currentPage = MAX(currentPage, 0);
    int start = currentPage == 0 ? currentPage : (currentPage - 1);
    
    int end = (currentPage == self.viewControllerClasses.count - 1) ? currentPage : (currentPage + 1);
    for (int i = start; i <= end; i++) {
        if (self.childViewFrames.count <= i) {
            return;
        }
        CGRect frame = [self.childViewFrames[i] CGRectValue];
        UIViewController *vc = [self.displayVC objectForKey:@(i)];
        if ([self isInScreen:frame]) {
            if (vc == nil) {
                // 先从 cache 中取
                vc = [self.memCache objectForKey:@(i)];
                if (vc) {
                    // cache 中存在，添加到 scrollView 上，并放入display
                    [self addCachedViewController:vc atIndex:i];
                } else {
                    // cache 中也不存在，创建并添加到display
                    [self addViewControllerAtIndex:i];
                }
                [self postAddToSuperViewNotificationWithIndex:i];
            }
        } else {
            if (vc) {
                // vc不在视野中且存在，移除他
                [self removeViewController:vc atIndex:i];
            }
        }
    }
}

- (void)addCachedViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrames[index] CGRectValue];
    [viewController didMoveToParentViewController:self];
    
    [self.scrollView insertSubview:viewController.view atIndex:0];
//    [self.scrollView addSubview:viewController.view];
    [self.displayVC setObject:viewController forKey:@(index)];
}



// 添加子控制器
- (void)addViewControllerAtIndex:(NSInteger)index {
    
    if (self.viewControllerClasses.count > index) {
        
        Class vcClass = self.viewControllerClasses[index];
        UIViewController *viewController = [[vcClass alloc] init];
        viewController.title=self.titles[index];
        if (self.values && self.keys) {
            NSArray *keys = self.keys[index];
            NSArray* values = self.values[index];
            if ([keys isKindOfClass:[NSArray class]]) {
                NSInteger idx = 0;
                NSInteger count = keys.count;
                while (idx < count) {
                    id key = keys[idx];
                    id value = values[idx];
                    [viewController setValue:value forKey:key];
                    idx++;

                }
            }else{
                [viewController setValue:self.values[index] forKey:self.keys[index]];

            }

        }
        [self addChildViewController:viewController];
        viewController.view.frame = [self.childViewFrames[index] CGRectValue];
        [viewController didMoveToParentViewController:self];
        [self.scrollView addSubview:viewController.view];
        [self.displayVC setObject:viewController forKey:@(index)];
        
        [self backToPositionIfNeeded:viewController atIndex:index];
    }
    
}



// 移除控制器，且从display中移除
- (void)removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self rememberPositionIfNeeded:viewController atIndex:index];
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.displayVC removeObjectForKey:@(index)];
    
    // 放入缓存
    if (![self.memCache objectForKey:@(index)]) {
        [self.memCache setObject:viewController forKey:@(index)];
    }
}

- (void)backToPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) return;
#pragma clang diagnostic pop
    if ([self.memCache objectForKey:@(index)]) return;
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        NSValue *pointValue = self.posRecords[@(index)];
        if (pointValue) {
            CGPoint pos = [pointValue CGPointValue];
            // 奇怪的现象，我发现 collectionView 的 contentSize 是 {0, 0};
            [scrollView setContentOffset:pos];
        }
    }
}

- (void)rememberPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) return;
#pragma clang diagnostic pop
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        CGPoint pos = scrollView.contentOffset;
        self.posRecords[@(index)] = [NSValue valueWithCGPoint:pos];
    }
}

- (UIScrollView *)isKindOfScrollViewController:(UIViewController *)controller {
    UIScrollView *scrollView = nil;
    if ([controller.view isKindOfClass:[UIScrollView class]]) {
        // Controller的view是scrollView的子类(UITableViewController/UIViewController替换view为scrollView)
        scrollView = (UIScrollView *)controller.view;
    } else if (controller.view.subviews.count >= 1) {
        // Controller的view的subViews[0]存在且是scrollView的子类，并且frame等与view得frame(UICollectionViewController/UIViewController添加UIScrollView)
        UIView *view = controller.view.subviews[0];
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
        }
    }
    return scrollView;
}

- (BOOL)isInScreen:(CGRect)frame {
    CGFloat x = frame.origin.x;
    CGFloat ScreenWidth = self.scrollView.frame.size.width;
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    if (CGRectGetMaxX(frame) > contentOffsetX && x-contentOffsetX < ScreenWidth) {
        return YES;
    } else {
        return NO;
    }
}

- (void)resetMenuView {
    WMMenuView *oldMenuView = self.menuView;
    if (!oldMenuView) {
        [self addMenuView];
    }
    oldMenuView.items = self.titles;
    [oldMenuView reloadData];
    
//    [oldMenuView removeFromSuperview];
}

- (void)growCachePolicyAfterMemoryWarning {
    self.cachePolicy = WMPageControllerCachePolicyBalanced;
    [self performSelector:@selector(growCachePolicyToHigh) withObject:nil afterDelay:2.0 inModes:@[NSRunLoopCommonModes]];
}

- (void)growCachePolicyToHigh {
    self.cachePolicy = WMPageControllerCachePolicyHigh;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addScrollView];
    self.selectIndex = 0;
    [self addViewControllerAtIndex:self.selectIndex];
//    self.currentViewController = self.displayVC[@(self.selectIndex)];
}

- (void)reloadData{
    //先重新布局  否则出现view闪现问题
//    self removeFromParentViewController
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self viewDidLayoutSubviews];
    //然后重新设置view
    //重新加载清除缓存
    self.memCache=nil;
    self.selectIndex = 0;
    [self calculateSize];
    
    

    [self addViewControllerAtIndex:self.selectIndex];
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    self.currentViewController = self.displayVC[@(self.selectIndex)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 计算宽高及子控制器的视图frame
    
    [self calculateSize];
    if (self.childViewFrames.count<=self.selectIndex) {
        return;
    }
    NSInteger maxY = self.menuHeight;
    if (IS_IPHONE_X) {
        maxY -= 24;
    }
    
    CGRect scrollFrame = CGRectMake(_viewX,  maxY, self.viewWidth, self.viewHeight);
    self.scrollView.frame = scrollFrame;
    self.scrollView.contentSize = CGSizeMake(self.titles.count*self.viewWidth, 0);
    [self.scrollView setContentOffset:CGPointMake(self.selectIndex*self.viewWidth, 0)];

    self.currentViewController.view.frame = [self.childViewFrames[self.selectIndex] CGRectValue];
    
    [self resetMenuView];

    [self.view layoutIfNeeded];
}
- (CGFloat)viewHeight{
    //    if (CGRectEqualToRect(self.viewFrame, CGRectZero)) {
    //        _viewWidth = self.view.frame.size.width;
    //        self.viewHeight = self.view.frame.size.height - self.menuHeight;
    //    } else {
    //        _viewWidth = self.viewFrame.size.width;
    //        self.viewHeight = self.viewFrame.size.height - self.menuHeight;
    //    }
    return self.view.frame.size.height - self.menuHeight;
}
- (CGFloat)viewWidth{
    return self.view.frame.size.width;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)reloadContentFontSize:(NSNotification*)notifer{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.memoryWarningCount++;
    self.cachePolicy = WMPageControllerCachePolicyLowMemory;
    // 取消正在增长的 cache 操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyAfterMemoryWarning) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyToHigh) object:nil];
    
    [self.memCache removeAllObjects];
    [self.posRecords removeAllObjects];
    self.posRecords = nil;
    
    // 如果收到内存警告次数小于 3，一段时间后切换到模式 Balanced
    if (self.memoryWarningCount < 3) {
        [self performSelector:@selector(growCachePolicyAfterMemoryWarning) withObject:nil afterDelay:3.0 inModes:@[NSRunLoopCommonModes]];
    }
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"UIContentSizeCategoryDidChangeNotification_System" object:nil];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutChildViewControllers];
    if (_animate) {
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        if (contentOffsetX < 0 ) {
            contentOffsetX = 0;
        }
        if (contentOffsetX > scrollView.contentSize.width - self.viewWidth) {
            contentOffsetX = scrollView.contentSize.width - self.viewWidth;
        }
        CGFloat rate = contentOffsetX / self.viewWidth;
        [self.menuView slideMenuAtProgress:rate];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _animate = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _selectIndex = (int)scrollView.contentOffset.x / self.viewWidth;
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
//    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    
    [self printScrollContentOffset];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
//    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat rate = _targetX / self.viewWidth;
        [self.menuView slideMenuAtProgress:rate];
//        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);

    }
    [self printScrollContentOffset];

}

- (void)printScrollContentOffset{
    
//    for (UIView *item in _scrollView.subviews){
//        NSLog(@"content rect = %@",NSStringFromCGRect(item.frame));
//
//    }
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    _targetX = targetContentOffset->x;
}

#pragma mark - WMMenuView Delegate
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    NSInteger gap = (NSInteger)labs(index - currentIndex);
    _selectIndex = (int)index;
    _animate = NO;
    CGPoint targetP = CGPointMake(self.viewWidth*index, 0);
    
    [self.scrollView setContentOffset:targetP animated:gap > 1 ? NO : self.pageAnimatable];
    if (gap > 1 || !self.pageAnimatable) {
        // 由于不触发 -scrollViewDidScroll: 手动处理控制器
        [self layoutChildViewControllers];
        self.currentViewController = self.displayVC[@(self.selectIndex)];
        
        [self postFullyDisplayedNotificationWithCurrentIndex:(int)index];
    }
    [self printScrollContentOffset];

}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    if (self.itemsWidths) {
        return [self.itemsWidths[index] floatValue];
    }
    return self.menuItemWidth;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index {
    if (self.itemsMargins) {
        return [self.itemsMargins[index] floatValue];
    }
    return self.itemMargin;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
