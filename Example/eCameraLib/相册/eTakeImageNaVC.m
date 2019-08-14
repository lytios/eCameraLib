//
//  eTakeImageNavigationController.m
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/8/12.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import "eTakeImageNaVC.h"
#import "eTakeAVModel.h"
#import "eTakePhotoManager.h"
#import "eTakePhotoBrowserCell.h"
#import "etHeader.h"
#import "eTakeThumbnailVC.h"

@implementation eTakeImageNaVC


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationBar.translucent = YES;
    }
    return self;
}

- (NSMutableArray<eTakeAVModel *> *)arrSelectedModels
{
    if (!_arrSelectedModels) {
        _arrSelectedModels = [NSMutableArray array];
    }
    return _arrSelectedModels;
}

- (void)setConfiguration
{

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationBar setBackgroundColor:self.navColor];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.navigationBar setBackIndicatorImage:self.navImg];
    [self.navigationBar setBackIndicatorTransitionMaskImage:self.navImg];
}

@end


@interface eTakeAlbumListVC()

@property (nonatomic, strong) NSMutableArray<eTakeAVListModel *> *arrayDataSources;

@property (nonatomic, strong) UIView *placeholderView;


@end

@implementation eTakeAlbumListVC
- (void)dealloc
{

}

- (UIView *)placeholderView
{
    if (!_placeholderView) {
        _placeholderView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        imageView.image = [UIImage imageNamed:@"zl_defaultphoto"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.center = CGPointMake(ViewWidth/2, ViewHeight/2-90);
        [_placeholderView addSubview:imageView];
        
        UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ViewHeight/2-40, ViewWidth, 20)];
        placeholderLabel.text = @"无照片";
        placeholderLabel.textAlignment = NSTextAlignmentCenter;
        placeholderLabel.textColor = [UIColor darkGrayColor];
        placeholderLabel.font = [UIFont systemFontOfSize:15];
        [_placeholderView addSubview:placeholderLabel];
        
        _placeholderView.hidden = YES;
        [self.view addSubview:_placeholderView];
    }
    return _placeholderView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    self.title = @"照片";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self initNavBtn];
    
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @et_weakify(self);
        [eTakePhotoManager getPhotoAblumList:YES allowSelectImage:YES complete:^(NSArray<eTakeAVListModel *> *albums) {
            @et_strongify(self);
            self.arrayDataSources = [NSMutableArray arrayWithArray:albums];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    });
}

- (void)initNavBtn
{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = 50;
    btn.frame = CGRectMake(0, 0, width, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(navRightBtn_Click) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)navRightBtn_Click
{
    eTakeImageNaVC *nav = (eTakeImageNaVC *)self.navigationController;
    [nav dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arrayDataSources.count == 0) {
        self.placeholderView.hidden = NO;
    } else {
        self.placeholderView.hidden = YES;
    }
    return self.arrayDataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    eTakePhotoBrowserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eTakePhotoBrowserCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"eTakePhotoBrowserCell" owner:self options:nil] lastObject];
    }
    
    eTakeAVListModel *albumModel = self.arrayDataSources[indexPath.row];
    
    
    cell.cornerRadio = 3;
    
    cell.model = albumModel;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushThumbnailVCWithIndex:indexPath.row animated:YES];
}

- (void)pushThumbnailVCWithIndex:(NSInteger)index animated:(BOOL)animated
{
    eTakeAVListModel *model = self.arrayDataSources[index];
    eTakeThumbnailVC *tvc = [[eTakeThumbnailVC alloc] init];
    tvc.albumListModel = model;
    [self.navigationController showViewController:tvc sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
