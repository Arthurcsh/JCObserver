//
//  ExampleVC4.m
//  JCObserver
//
//  Created by abc on 17/4/5.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "ExampleVC4.h"
#import "JCObserve.h"
#import <JCFrameLayout/JCFrameLayout.h>

#import <objc/runtime.h>
#import <objc/message.h>

static NSArray* classMethodList(Class c)
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:5];
    unsigned int count = 0;
    Method* methodList = class_copyMethodList(c, &count);
    for(int i = 0; i < count; ++i)
    {
        SEL sel = method_getName(*(methodList+i));
        [array addObject:NSStringFromSelector(sel)];
    }
    free(methodList);
    return array;
}

static void printDescription(NSString* name, id obj)
{
    NSString* string = [NSString stringWithFormat:@"%@:%@\n\tclass %@\n\tobjclass %@\n\timplementmethod %@\n",
                        name,
                        obj,
                        [obj class],
                        object_getClass(obj),
                        [classMethodList(object_getClass(obj)) componentsJoinedByString:@" , "]];
    printf("%s", [string UTF8String]);
}


@interface ExampleVC4 ()
/**
 *  <#注释#>
 **/
@property (nonatomic,strong) UIView *redView;
@end

@implementation ExampleVC4

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
    
    UIButton *frameBtn = [[UIButton alloc]init];
    frameBtn.layer.cornerRadius = 8;
    frameBtn.layer.masksToBounds = YES;
    frameBtn.layer.borderColor = [UIColor blackColor].CGColor;
    frameBtn.layer.borderWidth = 1;
    [frameBtn setTitle:@"修改frame" forState:(UIControlStateNormal)];
    [frameBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [frameBtn addTarget:self action:@selector(changeFrame:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:frameBtn];
    [frameBtn jc_makeLayout:^(JCFrameMake *make) {
        make.centerX.equalTo(self.view);
        make.bottom.jc_equalTo(-100);
        make.height.jc_equalTo(25);
        make.width.jc_equalTo(200);
    }];
}

- (void)setObserve{
    [JCObserve(self.redView, frame) changed:^(id newValue, id oldValue) {
        NSLog(@"\n frame changed: new = %@,old = %@",newValue,oldValue);
    }];
}

- (void)changeFrame:(UIButton*)sender{
    [self.redView jc_makeLayout:^(JCFrameMake *make) {
        make.width.height.jc_equalTo(200);
        make.centerX.equalTo(self.view);
        make.top.jc_equalTo(150);
    }];
}

- (void)dealloc{
    NSLog(@"---ExampleVC4 dealloc");
}

@end
