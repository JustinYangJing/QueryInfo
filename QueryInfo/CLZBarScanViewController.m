//
//  CLZBarScanViewController.m
//  NewBindDeviceProject
//
//  Created by mr.cao on 15/6/30.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#define TINTCOLOR_ALPHA 0.2 //浅色透明度
#define DARKCOLOR_ALPHA 1.0 //深色透明度
#define VIEW_WIDTH [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCANVIEW_EdgeTop ((VIEW_HEIGHT-(VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft))/2)
#define SCANVIEW_EdgeLeft 50.0
#import "ZBarSDK.h"
#import "CLZBarScanViewController.h"
#import "UIViewController+HETAdditions.h"
#import "BNRInputNumVC.h"
@interface CLZBarScanViewController()<ZBarReaderDelegate,ZBarReaderViewDelegate>
{
    UIImageView* scanZomeBack;
    ZBarReaderView *readview;
    UIImageView *readLineView;
    BOOL is_Anmotion;
    UIView *_QrCodeline;
    NSTimer *_timer;
    //设置扫描画面
    UIView *_scanView;
    
    UIButton *_manualInputBtn;
}
@end

@implementation CLZBarScanViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
 
    self.title = @"二维码/条形码";
    
    
    self.view.backgroundColor =[HETUIConfig colorFromHexRGB:@"EFEFF4"];
    
    //初始化扫描界面
    [ self setScanView];
    readview = [ZBarReaderView new];
    readview.backgroundColor = [UIColor clearColor];
    readview.frame = CGRectMake ( 0 , 0, VIEW_WIDTH , VIEW_HEIGHT  );
   
    readview.allowsPinchZoom = YES;//使用手势变焦
    readview.trackingColor = [UIColor redColor];
    //readview.showsFPS = NO;// 显示帧率  YES 显示  NO 不显示   ....这里有bug
    readview.torchMode=NO;
    //readview.scanCrop = CGRectMake(0, 0, 1, 1);//将被扫描的图像的区域
    //readview.alpha=0.9;
    
    UIImage *hbImage=[UIImage imageNamed:@"pick_bg.png"];
    scanZomeBack=[[UIImageView alloc] initWithImage:hbImage];
    //添加一个背景图片
    CGRect mImagerect=CGRectMake((readview.frame.size.width-200)/2.0, (readview.frame.size.height-200)/2.0, 200, 200);
    [scanZomeBack setFrame:mImagerect];
    //readview.scanCrop = [self getScanCrop:mImagerect readerViewBounds:readview.bounds];//将被扫描的图像的区域
    
    [readview addSubview:scanZomeBack];
    [readview addSubview:readLineView];
    
    [ readview addSubview : _scanView ];
  
    _manualInputBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, VIEW_HEIGHT-35-20-64, VIEW_WIDTH-40, 35)];
    [_manualInputBtn setTitle:@"手动输入" forState:UIControlStateNormal];
    [_manualInputBtn setTitleColor:[HETUIConfig colorFromHexRGB:@"303030"] forState:UIControlStateNormal];
    _manualInputBtn.backgroundColor = [HETUIConfig colorFromHexRGB:@"295bb1"];
    _manualInputBtn.layer.cornerRadius = 35/2.;
    _manualInputBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _manualInputBtn.layer.borderWidth = 0.5;
    [readview addSubview:_manualInputBtn];
    [_manualInputBtn addTarget:self action:@selector(manualInputHandle:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
     readview.readerDelegate = self;
    [self.view addSubview:readview];
    _QrCodeline .frame= CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , 2);
    [readview start];
    //[ self moveUpAndDownLine];
    [self createTimer];
    
    [self opaqueNavigationBar];
    self.navigationController.navigationBar.barTintColor = [HETUIConfig colorFromHexRGB:@"3f4542"];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self stopTimer];
  


}

- ( void )createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector (moveUpAndDownLine) userInfo: nil repeats: YES ];
}
- ( void )stopTimer
{
    if ([_timer isValid] == YES ) {
        [_timer invalidate];
        _timer = nil ;
    }
}
//二维码的横线移动
- ( void )moveUpAndDownLine
{
    CGFloat Y= _QrCodeline . frame . origin . y ;
    //CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft, 1)]
    if (VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: 1 ];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 2 );
        [UIView commitAnimations];
    } else if (SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: 1 ];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 2 );
        [UIView commitAnimations];
    }
    /* _QrCodeline.frame =CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 2);
     [UIView animateWithDuration:1.0
     delay: 0.0
     options: UIViewAnimationOptionCurveEaseIn
     animations:^{
     //修改fream的代码写在这里
     _QrCodeline.frame =CGRectMake(SCANVIEW_EdgeLeft, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 2 );
     
     
     }
     completion:^(BOOL finished){
     if (!is_Anmotion) {
     
     [self moveUpAndDownLine];
     }
     
     }];*/
    
}

#pragma mark 获取扫描区域
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}
#pragma mark 扫描动画
-(void)loopDrawLine
{
    CGRect  rect = CGRectMake(scanZomeBack.frame.origin.x, scanZomeBack.frame.origin.y, scanZomeBack.frame.size.width, 2);
    if (readLineView) {
        [readLineView removeFromSuperview];
    }
    readLineView = [[UIImageView alloc] initWithFrame:rect];
    [readLineView setImage:[UIImage imageNamed:@"line.png"]];
    [UIView animateWithDuration:3.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //修改fream的代码写在这里
                         readLineView.frame =CGRectMake(scanZomeBack.frame.origin.x, scanZomeBack.frame.origin.y+scanZomeBack.frame.size.height, scanZomeBack.frame.size.width, 2);
                         [readLineView setAnimationRepeatCount:0];
                         
                     }
                     completion:^(BOOL finished){
                         if (!is_Anmotion) {
                             
                             [self loopDrawLine];
                         }
                         
                     }];
    
    [readview addSubview:readLineView];
    
}
#pragma mark 二维码的扫描区域
- ( void )setScanView
{
    _scanView =[[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , VIEW_WIDTH , VIEW_HEIGHT - 64 )];
    _scanView . backgroundColor =[ UIColor clearColor ];
    //最上部view
    UIView * upView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , VIEW_WIDTH , SCANVIEW_EdgeTop )];
    upView. alpha = TINTCOLOR_ALPHA ;
    upView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :upView];
    UIImageView *upimageView=[[UIImageView alloc]initWithFrame:CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , 32 , 32 )];
    upimageView.image=[UIImage imageNamed:@"ScanQR1"];
    [_scanView addSubview:upimageView];
    //左侧的view
    UIView *leftView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    leftView. alpha = TINTCOLOR_ALPHA ;
    leftView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :leftView];
    UIImageView *leftimageView=[[UIImageView alloc]initWithFrame:CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop+VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft-32 , 32,32 )];
    leftimageView.image=[UIImage imageNamed:@"ScanQR3"];
    [_scanView addSubview:leftimageView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[ UIImageView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    scanCropView. backgroundColor =[ UIColor clearColor ];
    [ _scanView addSubview :scanCropView];
    //右侧的view
    UIView *rightView = [[ UIView alloc ] initWithFrame : CGRectMake ( VIEW_WIDTH - SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    rightView. alpha = TINTCOLOR_ALPHA ;
    rightView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :rightView];
    UIImageView *rightimageView=[[UIImageView alloc]initWithFrame:CGRectMake ( VIEW_WIDTH - SCANVIEW_EdgeLeft-32 , SCANVIEW_EdgeTop , 32,32 )];
    rightimageView.image=[UIImage imageNamed:@"ScanQR2"];
    [_scanView addSubview:rightimageView];
    //底部view
    UIView *downView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop , VIEW_WIDTH , VIEW_HEIGHT )];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView. backgroundColor = [[ UIColor blackColor ] colorWithAlphaComponent : TINTCOLOR_ALPHA ];
    [ _scanView addSubview :downView];
    UIImageView *downimageView=[[UIImageView alloc]initWithFrame:CGRectMake( VIEW_WIDTH - SCANVIEW_EdgeLeft-32 ,SCANVIEW_EdgeTop+VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft-32, 32,32 )];
    downimageView.image=[UIImage imageNamed:@"ScanQR4"];
    [_scanView addSubview:downimageView];
    //用于说明的label
    UILabel *labIntroudction= [[ UILabel alloc ] init ];
    labIntroudction. backgroundColor = [ UIColor clearColor ];
    labIntroudction. frame = CGRectMake ( 0 , 5 , VIEW_WIDTH , 20 );
    labIntroudction. numberOfLines = 1 ;
    labIntroudction. font =[ UIFont systemFontOfSize : 15.0 ];
    labIntroudction. textAlignment = NSTextAlignmentCenter ;
    labIntroudction. textColor =[ UIColor whiteColor ];
    labIntroudction. text = @"将二维码/条形码放入方框，即可自动扫描" ;
    [downView addSubview :labIntroudction];
    UIView *darkView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , downView. frame . size . height - 100.0 , VIEW_WIDTH , 100.0 )];
    darkView. backgroundColor = [[ UIColor blackColor ]  colorWithAlphaComponent : DARKCOLOR_ALPHA ];
    [downView addSubview :darkView];

    //画中间的基准线
    _QrCodeline = [[ UIView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , 2)];
    _QrCodeline . backgroundColor =[UIColor colorWithRed:26/255.0 green:178/255.0 blue:10/255.0 alpha:1.0];// [ UIColor blueColor];
    [ _scanView addSubview : _QrCodeline ];
}
#pragma mark 获取扫描结果
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    is_Anmotion=YES;
    // 得到扫描的条码内容
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
   // NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) {
        // 是否QR二维码
    }
    
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"扫描的结果:%@",symbol.data);
        
        NSString * resultStr = symbol.data;
        NSLog(@"scan resultStr %@",resultStr);
        
        
    }
    
  

    
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    NSLog(@"扫描的结果0:%@",symbol.data);
    /*resultText.text = symbol.data;
     
     // EXAMPLE: do something useful with the barcode image
     resultImage.image =
     [info objectForKey: UIImagePickerControllerOriginalImage];*/
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)manualInputHandle:(UIButton *)btn{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BNRInputNumVC *vc = [sb instantiateViewControllerWithIdentifier:@"inputNumVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
