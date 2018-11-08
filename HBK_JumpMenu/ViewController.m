//
//  ViewController.m
//  HBK_JumpMenu
//
//  Created by 黄冰珂 on 2018/8/3.
//  Copyright © 2018年 KK. All rights reserved.
//

#import "ViewController.h"
#import "HBK_Menu/HBK_MenuView.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<HBK_MenuViewDelegate>

@property (nonatomic, strong) HBK_MenuView *menuView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
}

- (IBAction)jump:(UIButton *)sender {

    [self.menuView show];
    
}


- (HBK_MenuView *)menuView {
    if (!_menuView) {
        _menuView = [[HBK_MenuView alloc] initWithFrame:CGRectMake(kScreenWidth-140-10, 64+5, 140, 0)
                                             TitleArray:@[@"扫一扫",@"加好友",@"发起问题单", @"开始会议", @"我的二维码"]
                                             imageArray:@[]
                                              showPoint:CGPointMake(kScreenWidth-25, 10)];
//        [self.view addSubview:_menuView];
        _menuView.delegate = self;
    }
    return _menuView;
}


- (void)menuViwe:(HBK_MenuView *)menuView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"------> %ld", index);
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
