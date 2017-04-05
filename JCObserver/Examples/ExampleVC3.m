//
//  ExampleVC3.m
//  JCObserver
//
//  Created by abc on 17/4/5.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "ExampleVC3.h"
#import "JCObserver.h"
#import <JCFrameLayout/JCFrameLayout.h>

#define radomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0  blue:arc4random_uniform(256)/255.0  alpha:1]

@interface ExampleVC3 ()
/**
 *  <#注释#>
 **/
@property (nonatomic,strong) UIView *redView;
@end

@implementation ExampleVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configView];
    
    [self setObserve];
}

- (void)configView{
    
    self.redView = [[UIView alloc]init];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    [self.redView jc_makeLayout:^(JCFrameMake *make) {
        make.width.height.jc_equalTo(100);
        make.centerX.equalTo(self.view);
        make.top.jc_equalTo(100);
    }];
    
    UIButton *backcolorBtn = [[UIButton alloc]init];
    backcolorBtn.layer.cornerRadius = 8;
    backcolorBtn.layer.masksToBounds = YES;
    backcolorBtn.layer.borderColor = [UIColor blackColor].CGColor;
    backcolorBtn.layer.borderWidth = 1;
    [backcolorBtn setTitle:@"修改backgroundColor" forState:(UIControlStateNormal)];
    [backcolorBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [backcolorBtn addTarget:self action:@selector(changeBackgroundColor:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backcolorBtn];
    [backcolorBtn jc_makeLayout:^(JCFrameMake *make) {
        make.centerX.equalTo(self.view);
        make.bottom.jc_equalTo(-100);
        make.height.jc_equalTo(25);
        make.width.jc_equalTo(200);
    }];
}

- (void)setObserve{
    [JCObserver(self.redView, backgroundColor) changed:^(id newValue, id oldValue) {
        NSLog(@"\ncolor changed: new = %@,old = %@",newValue,oldValue);
    }];
}

- (void)changeBackgroundColor:(UIButton*)sender{
    self.redView.backgroundColor = radomColor;
}

- (void)dealloc{
    NSLog(@"---ExampleVC3 dealloc");
}
@end
