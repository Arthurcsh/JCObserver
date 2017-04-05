//
//  JCDemoHomeVC.m
//  JCObserver
//
//  Created by abc on 17/4/5.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "JCDemoHomeVC.h"

#import <JCFrameLayout/JCFrameLayout.h>

@interface JCDemoHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation JCDemoHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView jc_makeLayout:^(JCFrameMake *make) {
        make.left.jc_equalTo(0);
        make.top.jc_equalTo(0);
        make.right.jc_equalTo(0);
        make.bottom.jc_equalTo(0);
    }];

}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.datasource[indexPath.item];
    cell.textLabel.text = dict[@"title"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.datasource[indexPath.item];
    NSString *cls = dict[@"cls"];
    Class class = NSClassFromString(cls);
    UIViewController *vc = [[class alloc]init];
    vc.title = dict[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray<NSDictionary<NSString *,UIViewController *> *> *)datasource{
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
    return nil;
}


@end
