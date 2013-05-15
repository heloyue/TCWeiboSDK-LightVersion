//
//  ViewController.m
//  TCWeiboSDK-LightVersion
//
//  Created by heloyue on 13-4-25.
//  Copyright (c) 2013年 heloyue. All rights reserved.
//

#import "ViewController.h"
#import "constant.h"
#import "ResultViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize wbapi;

-(NSString*)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent: @"weibosdkcache.plist"];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    if(self->wbapi == nil)
    {
        self->wbapi = [[WeiboApi alloc]initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUri:REDIRECTURI] ;
    }
    
    
    btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogin setFrame:CGRectMake(40, 100, 240, 40)];
    [btnLogin setTitle:@"授权" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    
    btnExtend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnExtend setFrame:CGRectMake(40, 150, 240, 40)];
    [btnExtend setTitle:@"续期" forState:UIControlStateNormal];
    [btnExtend addTarget:self action:@selector(onExtend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnExtend];
    
    
    btnHometimeline = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnHometimeline setFrame:CGRectMake(40, 200, 240, 40)];
    [btnHometimeline setTitle:@"获取主时间线" forState:UIControlStateNormal];
    [btnHometimeline addTarget:self action:@selector(onGetHometimeline) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnHometimeline];
    
    
    btnAddPic = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAddPic setFrame:CGRectMake(40, 250, 240, 40)];
    [btnAddPic setTitle:@"发表带图微博" forState:UIControlStateNormal];
    [btnAddPic addTarget:self action:@selector(onAddPic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAddPic];
    
    btnLogout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogout setFrame:CGRectMake(40, 300, 240, 40)];
    [btnLogout setTitle:@"取消授权" forState:UIControlStateNormal];
    [btnLogout addTarget:self action:@selector(onLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogout];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    NSLog(@"hi");
    
    NSString *path = [self dataFilePath];
    
    NSData * dictData = [NSKeyedArchiver archivedDataWithRootObject:wbapi];
    [dictData writeToFile:path atomically:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击登录按钮
- (void)onLogin {
    [wbapi loginWithDelegate:self andRootController:self];
}

//点击登录按钮
- (void)onExtend {
    [wbapi refreshAuthWithDelegate:self];
}

//点击登录按钮
- (void)onGetHometimeline {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                                                        @"0", @"pageflag",
                                                                        @"30", @"reqnum",
                                                                        @"0", @"type",
                                                                        @"0", @"contenttype",
                                                                        nil];   
    [wbapi requestWithParams:params apiName:@"statuses/home_timeline" httpMethod:@"GET" delegate:self];
    [params release];
}

//点击登录按钮
- (void)onAddPic {
    
    UIImage *pic = [UIImage imageNamed:@"icon.png"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   @"hi,weibo sdk", @"content",
                                   pic, @"pic",
                                   nil];
    [wbapi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
    [pic release];
    [params release];
  
}


- (void)showMsg:(NSString *)msg
{
    ResultViewController *rvc = [[ResultViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rvc];
    rvc.result = msg;
    
    [self presentModalViewController:nav animated:YES];
    [rvc release];
    [nav release];
}

- (void)onLogout {
    // 注销授权
    [wbapi  cancelAuth];
    
    NSString *resStr = [[NSString alloc]initWithFormat:@"取消授权成功！"];
    
    [self showMsg:resStr];
    [resStr release];
    
}



#pragma mark WeiboRequestDelegate

/**
 * @brief   接口调用成功后的回调
 * @param   INPUT   data    接口返回的数据
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    NSString *strResult = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    //[NSString stringWithCharacters:[data bytes] length:[data length]];
    NSLog(@"result = %@",strResult);
    
    [self showMsg:strResult];
    [strResult release];

}
/**
 * @brief   接口调用失败后的回调
 * @param   INPUT   error   接口返回的错误信息
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
    [self showMsg:str];
    [str release];
}



#pragma mark WeiboAuthDelegate

/**
 * @brief   重刷授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthRefreshed:(WeiboApi *)wbapi_
{
    
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r", wbapi_.accessToken, wbapi_.openid, wbapi_.appKey, wbapi_.appSecret];
    
    NSLog(@"result = %@",str);
    
    [self showMsg:str];
    [str release];

}

/**
 * @brief   重刷授权失败后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthRefreshFail:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
     [self showMsg:str];
    [str release];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthFinished:(WeiboApi *)wbapi_
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r", wbapi_.accessToken, wbapi_.openid, wbapi_.appKey, wbapi_.appSecret];
    
    NSLog(@"result = %@",str);
    
    [self showMsg:str];
    
    [str release];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi   weiboapi 对象，取消授权后，授权信息会被清空
 * @return  无返回
 */
- (void)DidAuthCanceled:(WeiboApi *)wbapi_
{
    
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthFailWithError:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
    [self showMsg:str];
    [str release];
}
@end
