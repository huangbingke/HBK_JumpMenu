//
//  HBK_MenuView.h
//  HBK_JumpMenu
//
//  Created by 黄冰珂 on 2018/8/3.
//  Copyright © 2018年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBK_MenuView;
@protocol HBK_MenuViewDelegate <NSObject>

- (void)menuViwe:(HBK_MenuView *)menuView didSelectItemAtIndex:(NSInteger)index;

@end


@interface HBK_MenuView : UIView



- (instancetype)initWithFrame:(CGRect)frame
                   TitleArray:(NSArray<NSString *> *)titleArray
                   imageArray:(NSArray<NSString *> *)imageArray
                    showPoint:(CGPoint)showPoint;

@property (nonatomic, weak) id<HBK_MenuViewDelegate>delegate;

/** 弹出 */
- (void)show;

/** 隐藏 */
- (void)dismiss;

@end


















