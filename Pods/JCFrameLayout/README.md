# JCFrameLayout

JCFrameLayout是一个类似Masonry的布局工具，与Masonry不同的是JCFrameLayout采用的是Frame布局而非约束布局，实现了Masonry大部分功能。

### 使用方式
例如一下代码实现效果：
```
UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = radomColor;
    [self.view addSubview:leftView];
    leftView.jc_debug_key = @"leftView";
    [leftView jc_makeLayout:^(JCFrameMake *make) {
        make.width.jc_equalTo(50);
        make.top.jc_equalTo(50 + 64);
        make.bottom.jc_equalTo(-50);
        make.left.jc_equalTo(0);
    }];
    
    
    UIView *rightView = [[UIView alloc]init];
    rightView.backgroundColor = radomColor;
    [self.view addSubview:rightView];
    rightView.jc_debug_key = @"rightView";
    [rightView jc_makeLayout:^(JCFrameMake *make) {
        make.width.jc_equalTo(50);
        make.top.jc_equalTo(50 + 64);
        make.bottom.jc_equalTo(-50);
        make.right.jc_equalTo(0);
    }];
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = radomColor;
    [self.view addSubview:topView];
    topView.jc_debug_key = @"topView";
    [topView jc_makeLayout:^(JCFrameMake *make) {
        make.top.jc_equalTo(64);
        make.height.jc_equalTo(50);
        make.left.jc_equalTo(50);
        make.right.jc_equalTo(-50);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = radomColor;
    [self.view addSubview:bottomView];
    bottomView.jc_debug_key = @"bottomView";
    [bottomView jc_makeLayout:^(JCFrameMake *make) {
        make.height.jc_equalTo(50);
        make.left.jc_equalTo(50);
        make.right.jc_equalTo(-50);
        make.bottom.jc_equalTo(0);
    }];
    
    
    UIView *centerView = [[UIView alloc]init];
    centerView.backgroundColor = radomColor;
    [self.view addSubview:centerView];
    centerView.jc_debug_key = @"centerView";
    [centerView jc_makeLayout:^(JCFrameMake *make) {
        make.left.equalTo(leftView.jc_right);
        make.top.equalTo(topView.jc_bottom);
        make.right.equalTo(rightView.jc_left);
        make.bottom.equalTo(bottomView.jc_top);
    }];
    [self.view sendSubviewToBack:centerView];
```


### 历史版本

#### V2.0.0
实现多视图的相对布局
```
[centerView jc_makeLayout:^(JCFrameMake *make) {
        make.left.equalTo(leftView.jc_right);
        make.top.equalTo(topView.jc_bottom);
        make.right.equalTo(rightView.jc_left);
        make.bottom.equalTo(bottomView.jc_top);
    }];
```

#### V1.1.2
完善了单视图的链式语法，可以实现这样的的效果

```
[self.redView jc_makeLayout:^(JCFrameMake *make) {
        make.left.top.width.height.jc_equalTo(100);
    }];
```

#### V1.1.1
jc_equalTo()时自动将基本类型进行装箱

可以将V1.1.0的代码简化为：

```
[self.redView jc_makeLayout:^(JCFrameMake *make) {
        make.center.jc_equalTo(CGPointMake(100, 100));
        make.size.jc_equalTo(CGSizeMake(100, 100));
    }];
```

#### V1.1.0
增加了center,size两个复合属性的支持

```
[self.redView jc_makeLayout:^(JCFrameMake *make) {
        make.center.jc_equalTo([NSValue valueWithCGPoint:CGPointMake(100, 100)]);
        make.size.jc_equalTo([NSValue valueWithCGSize:CGSizeMake(100, 100)]);
}];
```

#### V1.0.0
实现了单视图的基本布局，支持6个布局属性left,top,width,height,centerX,centerY，可以链式语法还支持不完善，下面是布局的一个例子：

```
[self.redView jc_makeLayout:^(JCFrameMake *make) {
        make.left.jc_equalTo(@50);
        make.top.jc_equalTo(@50);
        make.width.jc_equalTo(@100);
        make.height.jc_equalTo(@100);
    }];
```


### 期望

* 发现Bug请在Issues提出，或者邮件告知我，我将尽快修复
* 如果觉得有用，请给我个Star

