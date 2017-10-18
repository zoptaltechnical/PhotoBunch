//
//  SYTabBar.m
//  自定义IUTabBar
//
//  Created by 刘一峰 on 2016/12/18.
//  Copyright © 2016年 刘一峰. All rights reserved.
//

#import "SYTabBar.h"

@implementation SYTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (UIButton *)btn{
    
    if (_btn==nil) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setImage:[UIImage imageNamed:@"camera_iconTB"] forState:UIControlStateNormal];
        //button的大小与图片一致
       // [_btn sizeToFit];
        [_btn addTarget:self action:@selector(PlusBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
    }
    return _btn;
    
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"";
        _nameLabel.font = [UIFont systemFontOfSize:10];
        _nameLabel.textColor = [UIColor darkTextColor];
        [_nameLabel sizeToFit];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (void)layoutSubviews{
    //千万别忘写这一句
    [super layoutSubviews];
    
    CGFloat btnx = 0;
    CGFloat btny = 0;
    //5.0是tabbar中的控件的数量
    CGFloat width = self.bounds.size.width/5.0;
    CGFloat height = self.bounds.size.height;
    
    int i=0;
    for (UIView *btn in self.subviews) {
        //判断是否是系统自带的UITabBarButton类型的控件
        if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i==2) {
                i=3;
            }
            
            btnx = i*width;
            btn.frame = CGRectMake(btnx, btny, width, height);
            NSLog(@"%@",btn.subviews);
            i++;
        }
    }
    //设置自定义button的位置
    self.btn.frame = CGRectMake(width * 2 + (width - height) / 2, -height /1.5, 60, 60);
    CGPoint point = self.btn.center;
    //note: 这里减去 1 是 参照系统中的tabbaritem中label的bottomMargin
    point.y = self.bounds.size.height - self.nameLabel.frame.size.height / 2   - 1;
    self.nameLabel.center = point;

    
}

/**
 setp:
    1.获取点击处的坐标
    2.将点击处的坐标转换为指定目标(即凸起的btn)中坐标
    3.判断转换后的坐标是否在指定目标的坐标系中
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden) {
        return [super hitTest:point withEvent:event];
    }else {
        CGPoint newP = [self convertPoint:point toView:self.btn];
        if ( [self.btn pointInside:newP withEvent:event]) {
            return self.btn;
        }else{//如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
}

#pragma mark Plus button Delegate method
- (void)PlusBtnAction {
    if (self.SYDelegate && [self.SYDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:titleInfo:)]) {
        [self.SYDelegate tabBarDidClickPlusButton:self.btn titleInfo:self.nameLabel];
    }
}

- (void)resetPlusBtnStyle {
    [self.btn setImage:[UIImage imageNamed:@"camera_iconTB"] forState:UIControlStateNormal];
    [self.nameLabel setTextColor:[UIColor darkGrayColor]];
}
@end
