
#import "JHCToastHud.h"

#define kToastHideDuration  1.5f

typedef NS_ENUM(NSUInteger, JHCToastHudMode) {
    /// UIActivityIndicatorView.
    JHCToastHudModeIndeterminate,
    /// Ring-shaped progress view.
    JHCToastHudModeAnnularDeterminate,
    // Shows a Success view.
    JHCToastHudModeSuccess,
    // Shows a Success view.
    JHCToastHudModeFail,
    /// Shows only labels.
    JHCToastHudModeText
};

@implementation JHCToastHud

//单例实现
static JHCToastHud *_sharedInstance = nil;
+ (instancetype)sharedInstance
{
    if(_sharedInstance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[JHCToastHud alloc] init];
        });
    }
    return _sharedInstance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if(_sharedInstance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [super allocWithZone:zone];
        });
    }
    return _sharedInstance;
}

+ (void)showLoadingWithMsg:(NSString *)msg inView:(UIView *)view
{
    [self showToastLoadingWithMsg:msg mode:JHCToastHudModeIndeterminate inView:view completeBlock:nil];
}

+ (void)showLoadingProgressWihtMsg:(NSString *)msg inView:(UIView *)view
{
    [self showToastLoadingWithMsg:msg mode:JHCToastHudModeAnnularDeterminate inView:view completeBlock:nil];
}

+ (void)showTipWithMsg:(NSString *)msg inView:(UIView *)view completeBlock:(CompleteBlock)completeBlock
{
    [self showToastLoadingWithMsg:msg mode:JHCToastHudModeText inView:view completeBlock:completeBlock];
}

+ (void)showSuccessWithMsg:(NSString *)msg inView:(UIView *)view completeBlock:(CompleteBlock)completeBlock
{
    [self showToastLoadingWithMsg:msg mode:JHCToastHudModeSuccess inView:view completeBlock:completeBlock];
}

+ (void)showFailWithMsg:(NSString *)msg inView:(UIView *)view completeBlock:(CompleteBlock)completeBlock
{
    [self showToastLoadingWithMsg:msg mode:JHCToastHudModeFail inView:view completeBlock:completeBlock];
}

+ (void)showToastLoadingWithMsg:(NSString *)msg mode:(JHCToastHudMode)mode inView:(UIView *)view completeBlock:(CompleteBlock)completeBlock
{
    __block UIView *blockView = view;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //如果已有弹框，先消失
        if ([JHCToastHud sharedInstance].hud != nil) {
            [JHCToastHud sharedInstance].hud.completionBlock = nil;
            [[JHCToastHud sharedInstance].hud hideAnimated:YES];
            [JHCToastHud sharedInstance].hud = nil;
        }
        
        //4\4s屏幕避免键盘存在时遮挡
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            [view endEditing:YES];
        }
        
        if(blockView == nil){
            blockView = [[[UIApplication sharedApplication] windows] lastObject];
//            blockView = [UIApplication sharedApplication].delegate.window;
//            blockView = [BGCommonUtil getCurrentTopViewController].view;
        }
        
        [JHCToastHud sharedInstance].hud = [JHCProgressHUD showHUDAddedTo:blockView animated:YES];
        [JHCToastHud sharedInstance].hud.label.text = msg ? msg : (mode != JHCToastHudModeIndeterminate && mode != JHCToastHudModeAnnularDeterminate) ?  @"网络异常，请稍候重试！" : @"";
        [JHCToastHud sharedInstance].hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [JHCToastHud sharedInstance].hud.contentColor = [UIColor whiteColor];
        [JHCToastHud sharedInstance].hud.label.font = [UIFont systemFontOfSize:16];
        [JHCToastHud sharedInstance].hud.label.numberOfLines = 0;
        [JHCToastHud sharedInstance].hud.margin = 15;
        [JHCToastHud sharedInstance].hud.offset = CGPointMake(0, -44);
        [JHCToastHud sharedInstance].hud.completionBlock = completeBlock;
        
        switch (mode) {
            case JHCToastHudModeIndeterminate:{ //菊花加载提示样式
                [JHCToastHud sharedInstance].hud.mode = JHCProgressHUDModeIndeterminate;
                [JHCToastHud sharedInstance].hud.square = msg && msg.length > 4 ? NO : YES;
            }
                break;
            case JHCToastHudModeAnnularDeterminate:{ //进度加载提示样式
                [JHCToastHud sharedInstance].hud.mode = JHCProgressHUDModeAnnularDeterminate;
                [JHCToastHud sharedInstance].hud.square = YES;
            }
                break;
            case JHCToastHudModeSuccess:{ //成功加载提示样式
                [JHCToastHud sharedInstance].hud.square = NO;
                [JHCToastHud sharedInstance].hud.mode = JHCProgressHUDModeCustomView;
                [JHCToastHud sharedInstance].hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [self hideAnimated:YES afterDelay:kToastHideDuration];
            }
                break;
            case JHCToastHudModeFail:{ //失败加载提示样式
                [JHCToastHud sharedInstance].hud.square = NO;
                [JHCToastHud sharedInstance].hud.mode = JHCProgressHUDModeCustomView;
                [JHCToastHud sharedInstance].hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [self hideAnimated:YES afterDelay:kToastHideDuration];
            }
                break;
            case JHCToastHudModeText:{ //文字加载提示样式
                [JHCToastHud sharedInstance].hud.square = NO;
                [JHCToastHud sharedInstance].hud.mode = JHCProgressHUDModeText;
                [self hideAnimated:YES afterDelay:kToastHideDuration];
            }
                break;
                
            default:
                break;
        }
        
    });
}


+ (void)hideAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[JHCToastHud sharedInstance].hud hideAnimated:animated];
        [JHCToastHud sharedInstance].hud = nil;
    });
    
}

+ (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[JHCToastHud sharedInstance].hud hideAnimated:animated afterDelay:delay];
        [JHCToastHud sharedInstance].hud = nil;
    });
}


@end
