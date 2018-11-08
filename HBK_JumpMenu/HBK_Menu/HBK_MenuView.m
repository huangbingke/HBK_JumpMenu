//
//  HBK_MenuView.m
//  HBK_JumpMenu
//
//  Created by 黄冰珂 on 2018/8/3.
//  Copyright © 2018年 KK. All rights reserved.
//

#import "HBK_MenuView.h"


#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kCellHeight     45
#define kTriangleWith   15  //三角形的高度
static NSString * const cellID = @"HBK_MenuViewCellID";

@interface HBK_MenuView()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *menuTableView;

@property (assign, nonatomic) CGPoint showPoint;
@property (assign, nonatomic) CGRect originalRect;

@property (nonatomic, strong) NSArray<NSString *> *titleArray;
@property (nonatomic, strong) NSArray<NSString *> *ImageArray;

@property (nonatomic, strong) UIView *bgView;
@end
@implementation HBK_MenuView

- (instancetype)initWithFrame:(CGRect)frame
                   TitleArray:(NSArray<NSString *> *)titleArray
                        imageArray:(NSArray<NSString *> *)imageArray
                         showPoint:(CGPoint)showPoint {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        if (titleArray) {
            self.titleArray = [NSArray arrayWithArray:titleArray];
        }
        if (imageArray) {
            self.ImageArray = [NSArray arrayWithArray:imageArray];
        }
        
        CGRect newFrame = frame;
        newFrame.size.height = titleArray.count * kCellHeight + kTriangleWith - 5;
        self.frame = newFrame;
        self.alpha = 0;
        self.originalRect = newFrame;
        self.showPoint = showPoint;
        self.layer.anchorPoint = CGPointMake(0.9, 0);
        self.layer.position = CGPointMake(self.layer.position.x+self.frame.size.width*0.4, self.layer.position.y-self.frame.size.height*0.5);
        
        
    }
    return self;
}

//展开
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.bgView];
    [window bringSubviewToFront:self.bgView];
    [self.bgView addSubview:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.menuTableView reloadData];
    });

    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

//隐藏
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.menuTableView removeFromSuperview];
        [self.bgView removeFromSuperview];
        self.menuTableView = nil;
        self.bgView = nil;
    }];
}

#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect {
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    CGPoint locationPoint = CGPointMake(self.showPoint.x - self.originalRect.origin.x, 0);
    CGPoint leftPoint     = CGPointMake(self.showPoint.x - self.originalRect.origin.x-kTriangleWith/2, kTriangleWith-5);
    CGPoint rightPoint    = CGPointMake(self.showPoint.x - self.originalRect.origin.x+kTriangleWith/2, kTriangleWith-5);
    
    CGContextMoveToPoint(context,locationPoint.x,locationPoint.y);//设置起点
    
    CGContextAddLineToPoint(context,leftPoint.x ,  leftPoint.y);
    
    CGContextAddLineToPoint(context,rightPoint.x, rightPoint.y);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    UIColor * clor = self.menuTableView.backgroundColor;
    [clor setFill];  //设置填充色
    
    [clor setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
}

#pragma mark - UITableViewDelegate, UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    
    if (self.titleArray.count > 0 ) {
        cell.textLabel.text = self.titleArray[indexPath.row];
    }
    if (self.ImageArray.count > 0 && self.titleArray.count == self.ImageArray.count) {
        cell.imageView.image = [UIImage imageNamed:self.ImageArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuViwe:didSelectItemAtIndex:)]) {
        [self.delegate menuViwe:self didSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - UIGestureRecognizerDelegate -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
#pragma mark - Getter -
- (UITableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTriangleWith-5, self.frame.size.width, self.frame.size.height-(kTriangleWith-5)) style:(UITableViewStylePlain)];
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        _menuTableView.scrollEnabled = NO;
        _menuTableView.layer.cornerRadius = 5;
        _menuTableView.layer.masksToBounds = YES;
        [_menuTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        [self addSubview:_menuTableView];
    }
    return _menuTableView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self.bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
@end
