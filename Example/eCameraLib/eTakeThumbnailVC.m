//
//  eCameraThumbnailVC.m
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/8/12.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import "eTakeThumbnailVC.h"
#import "eTakeAVModel.h"
#import "etHeader.h"
#import "eTakeCell.h"
#import "eTakePhotoManager.h"
#import "eTakeImageNaVC.h"

@interface eTakeThumbnailVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) NSMutableArray<eTakeAVModel *> *arrDataSources;

/**所有滑动经过的indexPath*/
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *arrSlideIndexPath;
/**所有滑动经过的indexPath的初始选择状态*/
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *dicOriSelectStatus;

@end

@implementation eTakeThumbnailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBtn];
    [self setupCollectionView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ui

- (void)initNavBtn
{
    eTakeImageNaVC *nav =(eTakeImageNaVC *)self.navigationController;
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(0, 0, 50, 44);
    [leftbtn setImage:[UIImage imageNamed:@"zl_navBack"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(navLeftBtn_Click) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    leftbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:nav.navColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(navRightBtn_Click) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark - UIButton Action
- (void)navRightBtn_Click
{
    eTakeImageNaVC *nav = (eTakeImageNaVC *)self.navigationController;
    [nav dismissViewControllerAnimated:YES completion:nil];
}
- (void)navLeftBtn_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat width = MIN(ViewWidth, ViewHeight);
    
    NSInteger columnCount;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        columnCount = 6;
    } else {
        columnCount = 4;
    }
    
    layout.itemSize = CGSizeMake((width-1.5*columnCount)/columnCount, (width-1.5*columnCount)/columnCount);
    layout.minimumInteritemSpacing = 1.5;
    layout.minimumLineSpacing = 1.5;
    layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    if (@available(iOS 11.0, *)) {
        [self.collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    }
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:NSClassFromString(@"eTakeCell") forCellWithReuseIdentifier:@"eTakeCell"];
    //注册3d touch
    if (@available(iOS 9.0, *)) {
        [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrDataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    eTakeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"eTakeCell" forIndexPath:indexPath];

    eTakeAVModel *model = self.arrDataSources[indexPath.row];
    cell.cornerRadio = 3.0f;
    cell.model = model;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSInteger index = indexPath.row;
    eTakeAVModel *model = self.arrDataSources[index];
    
//
//    UIViewController *vc = [self getMatchVCWithModel:model];
//    if (vc) {
//        [self showViewController:vc sender:nil];
//    }
}
- (void)scrollToBottom
{
    if (self.arrDataSources.count > 0) {
        NSInteger index = self.arrDataSources.count-1;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
}

- (NSMutableArray<eTakeAVModel *> *)arrDataSources
{
    if (!_arrDataSources) {
        
        if (!_albumListModel) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @et_weakify(self);
                [eTakePhotoManager getCameraRollAlbumList:YES allowSelectImage:YES complete:^(eTakeAVListModel *album) {
                    @et_strongify(self);
                    self.albumListModel = album;
                    self.arrDataSources = [NSMutableArray arrayWithArray:self.albumListModel.models];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.title = album.title;
                        [self.collectionView reloadData];
                    });
                }];
            });
        } else {
            _arrDataSources = [NSMutableArray arrayWithArray:self.albumListModel.models];

        }
    }
    return _arrDataSources;
}



@end
