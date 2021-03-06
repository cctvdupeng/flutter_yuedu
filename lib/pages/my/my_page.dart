import 'package:flutter/material.dart';
import 'package:flutter_yuedu/pages/login/login_page.dart';
import 'package:flutter_yuedu/pages/main/main_provider.dart';
import 'package:flutter_yuedu/pages/member/join_member.dart';
import 'package:flutter_yuedu/pages/member/my_account.dart';
import 'package:flutter_yuedu/pages/setting/setting_page.dart';
import 'package:flutter_yuedu/util/my_navigator.dart';
import 'package:flutter_yuedu/widget/my_app_bar.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  double elevation = 0.0; // 滚动阴影

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
//      Toast.show("个人中心", context, gravity: Toast.CENTER);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      final mainState = Provider.of<MainProvider>(context, listen: false);
      if (mainState.getTabBarSelectedIndex == 3) {
        mainState.cleanMessage();
      }
    });
    super.build(context);
    return Scaffold(
      backgroundColor: Color(0xfffefefe),
      appBar: MyAppBar(
        leadingType: AppBarBackType.None,
        actions: <Widget>[
          SizedBox(
            width: 60,
            child: FlatButton(
              padding: const EdgeInsets.all(0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "设置",
                  style: TextStyle(fontSize: 15, color: Color(0xff555555)),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingPage()));
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollNotification) {
              if (scrollNotification is ScrollUpdateNotification)
                _onScroll(scrollNotification.metrics.pixels);
              return true;
            },
            child: ListView(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      MyNavigator.present(context, LoginPage());
//                  Navigator.of(context).pushNamed('/login');
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      height: 90,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 18,
                            child: Text(
                              "立即登录",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff444444)),
                            ),
                          ),
                          Positioned(top: 55, child: Text("每天都要看书哟~")),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Image.asset(
                              "images/usercenter/usercenter_unlogin_header.png",
                              height: 90,
                            ),
                          )
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 12, right: 12),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: _getCardItems(),
                  ),
                ),
                _getListItem(
                    "我的成就", "images/usercenter/icon_setting_medal.png"),
                Divider(
                  indent: 20,
                  height: 0.5,
                ),
                _getListItem(
                    "兴趣选择", "images/usercenter/usercenter_interest.png"),
                Divider(
                  indent: 20,
                  height: 0.5,
                ),
                _getListItem("阅读报告", "images/usercenter/usercenter_report.png"),
                Divider(
                  indent: 20,
                  height: 0.5,
                ),
              ],
            ),
          ),
          Positioned(
              child: Container(
            height: 5,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromARGB((120 * elevation).toInt(), 245, 245, 245),
                  Color.fromARGB(0, 240, 240, 240)
                ])),
          ))
        ],
      ),
    );
  }

  _onScroll(offset) {
    var result = offset / 50.0;
    if (result > 1.0) {
      result = 1.0;
    } else if (result < 0) {
      result = 0.0;
    }
    setState(() {
      elevation = result;
    });
  }

  List<Widget> _getCardItems() {
    final data = [
      {
        "title": "我的帐户",
        "subTitle": "0乐豆 0优惠卷",
        "icon": "images/usercenter/usercenter_wallet.png"
      },
      {
        "title": "我的会员",
        "subTitle": "加入乐读会员",
        "icon": "images/usercenter/usercenter_membership.png"
      },
    ];
    return [
      _getCardItem(data[0], () {
        MyNavigator.push(context, MyAccount());
      }),
      _getCardItem(data[1], () {
        MyNavigator.push(context, JoinMember());
      })
    ];
  }

  Widget _getCardItem(Map<String, String> item, [GestureTapCallback onTap]) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          margin: const EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0xffdedede),
                    offset: Offset(0, 3.0),
                    spreadRadius: 1.0,
                    blurRadius: 10.0)
              ],
              borderRadius: BorderRadius.circular(6)),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 14,
                top: 14,
                child: Text(
                  item["title"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                left: 14,
                top: 35,
                child: Text(
                  item["subTitle"],
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  item["icon"],
                  height: 30,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getListItem(String title, String icon) {
    return SizedBox(
      height: 80,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20),
        onTap: () {
          MyNavigator.present(context, LoginPage());
        },
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Image.asset(
                icon,
                height: 42,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(title),
              )
            ],
          ),
        ),
        trailing: SizedBox(
          width: 50,
          child: Align(
            alignment: Alignment.centerRight,
            child: Image.asset("images/usercenter/usercenter_arrow.png"),
          ),
        ),
      ),
    );
  }
}
