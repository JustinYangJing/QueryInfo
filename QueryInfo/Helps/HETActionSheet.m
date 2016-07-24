//
//  HETActionSheet.m
//  HETPublicSDK_Core
//
//  Created by tl on 16/2/27.
//  Copyright © 2016年 HET. All rights reserved.
//

#import "HETActionSheet.h"
/**
 *  每一个按钮的高度
 */
static CGFloat kActionSheetHeight = 54.f;

/**
 *  动画时间
 */
static CGFloat kActionSheetTime = 0.25f;

@interface HETActionSheet(){
    UIView *_backView;
}

@property (nonatomic,copy)NSString *cancelTitle;
@property (nonatomic,copy)NSArray<NSString *> *titles;
@property (nonatomic,copy)void (^click)(NSInteger);
@end
@implementation HETActionSheet
UIColor *kColor1(){
    return [UIColor blackColor];
}

UIColor *kColor7(){
    return [UIColor blueColor];
}
UIFont *kFont1(){
    return  [UIFont systemFontOfSize:18.f];
}

UIColor *kColor5(){
    return [[HETUIConfig colorFromHexRGB:@"c6c6c6"] colorWithAlphaComponent:0.8];
}
+(instancetype)sheetCancelTitile:(NSString *)cancelTitle otherTitles:(NSArray<NSString *> *)titles{
    HETActionSheet *sheet = [HETActionSheet new];
    sheet.cancelTitle = cancelTitle;
    sheet.titles = titles;
    [sheet initializeUIs];
    return sheet;
    
    
}
-(void)initializeUIs{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.backgroundColor = [kColor1() colorWithAlphaComponent:0.4f];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [self addGestureRecognizer:tapGesture];
    
    _backView = [UIView new];
    [self addSubview:_backView];
    
    //取消btn
    UIButton *backBtn = [UIButton new];
    [backBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [backBtn setTitleColor:kColor7() forState:UIControlStateNormal];
    backBtn.titleLabel.font = kFont1();
    backBtn.backgroundColor= [UIColor whiteColor];
    [backBtn addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.cancelTitle.length ==0) {
            make.top.equalTo(_backView.mas_bottom).offset(5.f);
        }else{
            make.bottom.equalTo(_backView.mas_bottom);
        }
        make.left.equalTo(_backView.mas_left);
        make.right.equalTo(_backView.mas_right);
        make.height.equalTo(@(kActionSheetHeight));
    }];
    
    for (NSInteger index =0; index <self.titles.count; index ++) {
        UIView *line = [UIView new];
        line.backgroundColor = kColor5();
        [_backView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1.f/[UIScreen mainScreen].scale));
            make.left.equalTo(_backView.mas_left);
            make.right.equalTo(_backView.mas_right);
            make.bottom.equalTo(backBtn.mas_top).offset(-5.f-kActionSheetHeight*index);
        }];
        UIButton *btn = [UIButton new];
        [btn setTitle:self.titles[index] forState:UIControlStateNormal];
        [btn setTitleColor:kColor1() forState:UIControlStateNormal];
        btn.titleLabel.font = kFont1();
        btn.backgroundColor= [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left);
            make.right.equalTo(_backView.mas_right);
            make.height.equalTo(@(kActionSheetHeight));
            make.bottom.equalTo(line.mas_top);
        }];
        
        if (index == self.titles.count -1) {
            [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right);
                make.left.equalTo(self.mas_left);
                make.bottom.equalTo(self.mas_bottom).offset(300.f);
                make.height.equalTo(@(300.f));
            }];
        }
    }
}

-(void)tappedCancel{
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(300.f);
    }];
    [UIView animateWithDuration:kActionSheetTime animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)showInView:(UIView *)view click:(void (^)(NSInteger))click{
    [view.window addSubview:self];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
    }];
    [UIView animateWithDuration:kActionSheetTime animations:^{
        [self layoutIfNeeded];
    }];
    self.click = click;
}

-(void)btnClick:(UIButton *)btn{
    if (btn.currentTitle.length > 0 && [self.titles containsObject:btn.currentTitle] && self.click) {
        self.click([self.titles indexOfObject:btn.currentTitle]);
    }
    [self tappedCancel];
}

-(void)dealloc{
    NSLog(@"__%s",__func__);
}

@end
