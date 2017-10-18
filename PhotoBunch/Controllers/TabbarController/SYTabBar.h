//
//  SYTabBar.h
//  自定义IUTabBar
//
//  Created by 刘一峰 on 2016/12/18.
//  Copyright © 2016年 刘一峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYTabBar;
/**
 这个代理方法中我们可以实现点击切换btn的选中图片和字体颜色(感觉修改样式有点鸡肋，一般都是push 或者 模态一个界面，tabbar 自然会隐藏)
 */
@protocol SYTabBarDelegate <UITabBarDelegate>

- (void)tabBarDidClickPlusButton:(UIButton *)tabBar titleInfo:(UILabel *)titleLabel;

@end

@interface SYTabBar : UITabBar
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,assign) id<SYTabBarDelegate>SYDelegate;
- (void)resetPlusBtnStyle;
@end
