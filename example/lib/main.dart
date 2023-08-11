import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:flutter_unionad/flutter_unionad_stream.dart';
import 'package:flutter_unionad_example/banner_page.dart';
import 'package:flutter_unionad_example/drawfeed_page.dart';
import 'package:flutter_unionad_example/nativeexpressad_page.dart';
import 'package:flutter_unionad_example/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IndexPage(),
    );
  }
}

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool? _init;
  String? _version;
  StreamSubscription? _adViewStream;

  int _themeStatus = FlutterUnionAdTheme.NIGHT;

  @override
  void initState() {
    super.initState();
    _privacy();
    _adViewStream = FlutterUnionadStream.initAdStream(
      flutterUnionadFullVideoCallBack: FlutterUnionadFullVideoCallBack(
        onShow: () {
          print("全屏广告显示");
        },
        onSkip: () {
          print("全屏广告跳过");
        },
        onClick: () {
          print("全屏广告点击");
        },
        onFinish: () {
          print("全屏广告结束");
        },
        onFail: (error) {
          print("全屏广告错误 $error");
        },
        onClose: () {
          print("全屏广告关闭");
        },
      ),
      //插屏广告回调
      flutterUnionadInteractionCallBack: FlutterUnionadInteractionCallBack(
        onShow: () {
          print("插屏广告展示");
        },
        onClose: () {
          print("插屏广告关闭");
        },
        onFail: (error) {
          print("插屏广告失败 $error");
        },
        onClick: () {
          print("插屏广告点击");
        },
        onDislike: (message) {
          print("插屏广告不喜欢  $message");
        },
      ),
      // 新模板渲染插屏广告回调
      flutterUnionadNewInteractionCallBack:
          FlutterUnionadNewInteractionCallBack(
        onShow: () {
          print("新模板渲染插屏广告显示");
        },
        onSkip: () {
          print("新模板渲染插屏广告跳过");
        },
        onClick: () {
          print("新模板渲染插屏广告点击");
        },
        onFinish: () {
          print("新模板渲染插屏广告结束");
        },
        onFail: (error) {
          print("新模板渲染插屏广告错误 $error");
        },
        onClose: () {
          print("新模板渲染插屏广告关闭");
        },
        onReady: () async {
          print("新模板渲染插屏广告预加载准备就绪");
          //显示新模板渲染插屏
          await FlutterUnionad.showFullScreenVideoAdInteraction();
        },
        onUnReady: () {
          print("新模板渲染插屏广告预加载未准备就绪");
        },
      ),
      //激励广告
      flutterUnionadRewardAdCallBack: FlutterUnionadRewardAdCallBack(
          onShow: () {
        print("激励广告显示");
      }, onClick: () {
        print("激励广告点击");
      }, onFail: (error) {
        print("激励广告失败 $error");
      }, onClose: () {
        print("激励广告关闭");
      }, onSkip: () {
        print("激励广告跳过");
      }, onReady: () async {
        print("激励广告预加载准备就绪");
      }, onCache: () async {
        print("激励广告物料缓存成功。建议在这里进行广告展示，可保证播放流畅和展示流畅，用户体验更好。");
        await FlutterUnionad.showRewardVideoAd();
      }, onUnReady: () {
        print("激励广告预加载未准备就绪");
      }, onVerify: (rewardVerify, rewardAmount, rewardName, errorCode, error) {
        print(
            "激励广告奖励  验证结果=$rewardVerify 奖励=$rewardAmount  奖励名称$rewardName 错误码=$errorCode 错误$error");
      }, onRewardArrived: (rewardVerify, rewardType, rewardAmount, rewardName,
              errorCode, error, propose) {
        print(
            "阶段激励广告奖励  验证结果=$rewardVerify 奖励类型<FlutterUnionadRewardType>=$rewardType 奖励=$rewardAmount"
            "奖励名称$rewardName 错误码=$errorCode 错误$error 建议奖励$propose");
      }),
    );
  }

  //注册
  void _initRegister() async {
    _init = await FlutterUnionad.register(
        //穿山甲广告 Android appid 必填
        androidAppId: "5098580",
        //穿山甲广告 ios appid 必填
        iosAppId: "5098580",
        //使用TextureView控件播放视频,默认为SurfaceView,当有SurfaceView冲突的场景，可以使用TextureView 选填
        useTextureView: true,
        //appname 必填
        appName: "unionad_test",
        //是否允许sdk展示通知栏提示 选填
        allowShowNotify: true,
        //是否在锁屏场景支持展示广告落地页 选填
        allowShowPageWhenScreenLock: true,
        //是否显示debug日志
        debug: true,
        //是否支持多进程，true支持 选填
        supportMultiProcess: true,
        //是否开启个人性推荐 选填
        personalise: FlutterUnionadPersonalise.open,
        //主题模式 默认FlutterUnionAdTheme.DAY,修改后需重新调用初始化
        themeStatus: _themeStatus,
        //允许直接下载的网络状态集合 选填
        directDownloadNetworkType: [
          FlutterUnionadNetCode.NETWORK_STATE_2G,
          FlutterUnionadNetCode.NETWORK_STATE_3G,
          FlutterUnionadNetCode.NETWORK_STATE_4G,
          FlutterUnionadNetCode.NETWORK_STATE_WIFI
        ]);
    print("sdk初始化 $_init");
    _version = await FlutterUnionad.getSDKVersion();
    _themeStatus = await FlutterUnionad.getThemeStatus();
    setState(() {});
  }

  //隐私权限
  void _privacy() async {
    if (Platform.isAndroid) {
      await FlutterUnionad.andridPrivacy(
        isCanUseLocation: false,
        //是否允许SDK主动使用地理位置信息 true可以获取，false禁止获取。默认为true
        lat: 1.0,
        //当isCanUseLocation=false时，可传入地理位置信息，穿山甲sdk使用您传入的地理位置信息lat
        lon: 1.0,
        //当isCanUseLocation=false时，可传入地理位置信息，穿山甲sdk使用您传入的地理位置信息lon
        isCanUsePhoneState: false,
        //是否允许SDK主动使用手机硬件参数，如：imei
        imei: "123",
        //当isCanUsePhoneState=false时，可传入imei信息，穿山甲sdk使用您传入的imei信息
        isCanUseWifiState: false,
        //是否允许SDK主动使用ACCESS_WIFI_STATE权限
        isCanUseWriteExternal: false,
        //是否允许SDK主动使用WRITE_EXTERNAL_STORAGE权限
        oaid: "111",
        //开发者可以传入oaid
        //是否允许SDK主动获取设备上应用安装列表的采集权限
        alist: false,
        //是否允许SDK主动获取ANDROID_ID
        isCanUseAndroidId: false,
        //是否允许SDK在申明和授权了的情况下使用录音权限
        isCanUsePermissionRecordAudio: false,
      );
    }
    _initRegister();
  }

  @override
  Widget build(BuildContext context) {
    if (_init == null) {
      return Scaffold(
        body: Center(
          child: Text("正在进行穿山甲sdk初始化..."),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterUnionad example app'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: false,
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              child: Text("穿山甲初始化>>>>>> ${_init! ? "成功" : "失败"}"),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              child: Text("穿山甲SDK版本号>>>>>> v$_version"),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              child:
                  Text("穿山甲主题样式>>>>>> ${_themeStatus == 0 ? "正常模式" : "夜间模式"}"),
            ),
            //修改个性化推荐
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('修改个性化推荐'),
              onPressed: () async {
                _init = await FlutterUnionad.register(
                    //穿山甲广告 Android appid 必填
                    androidAppId: "5098580",
                    //穿山甲广告 ios appid 必填
                    iosAppId: "5098580",
                    //使用TextureView控件播放视频,默认为SurfaceView,当有SurfaceView冲突的场景，可以使用TextureView 选填
                    useTextureView: true,
                    //appname 必填
                    appName: "unionad_test",
                    //是否允许sdk展示通知栏提示 选填
                    allowShowNotify: true,
                    //是否在锁屏场景支持展示广告落地页 选填
                    allowShowPageWhenScreenLock: true,
                    //是否显示debug日志
                    debug: true,
                    //是否支持多进程，true支持 选填
                    supportMultiProcess: true,
                    //是否开启个性化推荐 选填
                    personalise: FlutterUnionadPersonalise.close,
                    //允许直接下载的网络状态集合 选填
                    directDownloadNetworkType: [
                      FlutterUnionadNetCode.NETWORK_STATE_2G,
                      FlutterUnionadNetCode.NETWORK_STATE_3G,
                      FlutterUnionadNetCode.NETWORK_STATE_4G,
                      FlutterUnionadNetCode.NETWORK_STATE_WIFI
                    ]);
                print("sdk初始化 $_init");
                setState(() {});
              },
            ),
            //请求权限
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('请求权限'),
              onPressed: () async {
                FlutterUnionad.requestPermissionIfNecessary(
                  callBack: FlutterUnionadPermissionCallBack(
                    notDetermined: () {
                      print("权限未确定");
                    },
                    restricted: () {
                      print("权限限制");
                    },
                    denied: () {
                      print("权限拒绝");
                    },
                    authorized: () {
                      print("权限同意");
                    },
                  ),
                );
              },
            ),
            //切换主题
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('切换主题'),
              onPressed: () async {
                _themeStatus = _themeStatus == FlutterUnionAdTheme.DAY
                    ? FlutterUnionAdTheme.NIGHT
                    : FlutterUnionAdTheme.DAY;
                _initRegister();
              },
            ),
            //banner广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('banner广告'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new BannerPage(),
                  ),
                );
              },
            ),
            //开屏广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('开屏广告'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new SplashPage(),
                  ),
                );
              },
            ),
            //个性化模板信息流广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('信息流广告'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new NativeExpressAdPage(),
                  ),
                );
              },
            ),
            //激励视频
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('激励视频'),
              onPressed: () {
                FlutterUnionad.loadRewardVideoAd(
                  //是否个性化 选填
                  androidCodeId: "945418088",
                  //Android 激励视频广告id  必填
                  iosCodeId: "945418088",
                  //ios 激励视频广告id  必填
                  supportDeepLink: true,
                  //是否支持 DeepLink 选填
                  rewardName: "200金币",
                  //奖励名称 选填
                  rewardAmount: 200,
                  //奖励数量 选填
                  userID: "123",
                  //  用户id 选填
                  orientation: FlutterUnionadOrientation.VERTICAL,
                  //控制下载APP前是否弹出二次确认弹窗
                  downloadType: FlutterUnionadDownLoadType.DOWNLOAD_TYPE_POPUP,
                  //视屏方向 选填
                  mediaExtra: null,
                  //扩展参数 选填
                  //用于标注此次的广告请求用途为预加载（当做缓存）还是实时加载，
                  adLoadType: FlutterUnionadLoadType.PRELOAD,
                );
              },
            ),
            //个性化模板draw广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('draw视频广告'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new DrawFeedPage(),
                  ),
                );
              },
            ),
            //个性化全屏广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('全屏广告'),
              onPressed: () {
                FlutterUnionad.fullScreenVideoAd(
                  androidCodeId: "945491318",
                  //android 全屏广告id 必填
                  iosCodeId: "945491318",
                  //ios 全屏广告id 必填
                  supportDeepLink: true,
                  //是否支持 DeepLink 选填
                  orientation: FlutterUnionadOrientation.VERTICAL,
                  //视屏方向 选填
                  //控制下载APP前是否弹出二次确认弹窗
                  downloadType: FlutterUnionadDownLoadType.DOWNLOAD_TYPE_POPUP,
                );
              },
            ),
            //新模板渲染插屏广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('新模板渲染插屏广告'),
              onPressed: () {
                FlutterUnionad.loadFullScreenVideoAdInteraction(
                  //android 全屏广告id 必填
                  androidCodeId: "946201351",
                  //ios 全屏广告id 必填
                  iosCodeId: "946201351",
                  //是否支持 DeepLink 选填
                  supportDeepLink: true,
                  //视屏方向 选填
                  orientation: FlutterUnionadOrientation.VERTICAL,
                  //控制下载APP前是否弹出二次确认弹窗
                  downloadType: FlutterUnionadDownLoadType.DOWNLOAD_TYPE_POPUP,
                  //用于标注此次的广告请求用途为预加载（当做缓存）还是实时加载，
                  adLoadType: FlutterUnionadLoadType.PRELOAD,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_adViewStream != null) {
      _adViewStream?.cancel();
    }
  }
}
