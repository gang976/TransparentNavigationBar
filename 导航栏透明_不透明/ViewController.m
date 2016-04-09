//
//  ViewController.m
//  导航栏透明_不透明
//
//  Created by mxc235 on 16/3/24.
//  Copyright © 2016年 mxc235. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *tableViewHeadView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, assign) CGFloat headViewHeight;
@property (nonatomic, assign) CGFloat headImageViewHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headViewHeight = 240.0;
    self.headImageViewHeight = 80.0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUI];
}

- (void)setUI
{
    
    [self.view addSubview:self.tableView];
    
    //  概括来说，new和alloc/init在功能上几乎是一致的，分配内存并完成初始化。
    //  差别在于，采用new的方式只能采用默认的init方法完成初始化，采用alloc的方式可以用其他定制的初始化方法。
    UIImage *image = [UIImage new];
    [self setNavigationBarBackImage:image andShadowImage:image];
    [self.tableView insertSubview:self.tableViewHeadView atIndex:0];
}

// 设置导航栏的背景图片
- (void)setNavigationBarBackImage:(UIImage *)backImage andShadowImage:(UIImage *)shadowImage
{
    [self.navigationController.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:shadowImage];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 根据tableViwe的滚动 来改变头视图的大小 相对应的改变头像和个性签名的frame;
    if (scrollView.contentOffset.y < - self.headViewHeight) {
        self.tableViewHeadView.frame = CGRectMake(0, scrollView.contentOffset.y, kScreenWidth, -scrollView.contentOffset.y);
        
        // 头像是居中的 直接改变中心点
        self.headImageView.center = CGPointMake(self.tableViewHeadView.center.x, self.tableViewHeadView.center.y + self.tableViewHeadView.bounds.size.height);
        self.contentLabel.frame = CGRectMake(40, self.headImageView.center.y + 50, kScreenWidth - 80, 50);
    }
    
    // 到达该显示导航栏时，随便命名一张图片，设置背景，透明导航栏就还原了
    if (scrollView.contentOffset.y > -64) {
        UIImage *image = [UIImage imageNamed:@"随便写的"];
        [self setNavigationBarBackImage:image andShadowImage:image];
        self.navigationItem.title = @"测试";
    }else{
        UIImage *image = [UIImage new];
        [self setNavigationBarBackImage:image andShadowImage:image];
        self.navigationItem.title = @"";
    }
}

// 设置头视图
- (UIImageView *)tableViewHeadView
{
    if (!_tableViewHeadView) {
        _tableViewHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -self.headViewHeight, kScreenWidth, self.headViewHeight)];
        _tableViewHeadView.image = [UIImage imageNamed:@"040.jpg"];
        _tableViewHeadView.clipsToBounds = YES;
        _tableViewHeadView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.headImageView.center = CGPointMake(_tableViewHeadView.center.x, _tableViewHeadView.center.y + self.headViewHeight);
        self.contentLabel.frame = CGRectMake(40, self.headImageView.center.y + 50, kScreenWidth - 80, 50);
        
        [_tableViewHeadView addSubview:self.headImageView];
        [_tableViewHeadView addSubview:self.contentLabel];
    }
    return _tableViewHeadView;
}

// 设置头像
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.headImageViewHeight, self.headImageViewHeight)];
        _headImageView.image = [UIImage imageNamed:@"icon.jpg"];
        _headImageView.layer.cornerRadius = self.headImageViewHeight / 2.0;
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.borderWidth = 1;
        _headImageView.layer.borderColor = [UIColor greenColor].CGColor;
    }
    return _headImageView;
}

// 设置个性签名
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"真羡慕自己, 年纪轻轻的就认识了才华横溢的你们!";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor greenColor];
    }
    return _contentLabel;
}


// 设置tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(self.headViewHeight, 0, 0, 0);
        
    }
    return _tableView;
}

#pragma mark -- Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld cell", indexPath.row];
    
    return cell;
}


@end
