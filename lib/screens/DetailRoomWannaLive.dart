import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/EditRoomWannaLive.dart';
import 'package:mryr/screens/ReverseSuggestionComplete.dart';
import 'package:mryr/screens/NeedRoomProposalListScreen.dart';
import 'package:mryr/screens/Setting/report.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/Dialog/OKDialog.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/widget/RoomWannaLive/StringForRommWannaLive.dart';

class DetailRoomWannaLive extends StatefulWidget {
  final NeedRoomInfo needRoomInfo;
  bool Likes;

  DetailRoomWannaLive({Key key, @required this.needRoomInfo, @required this.Likes}) : super(key: key);
  @override
  _DetailRoomWannaLiveState createState() => _DetailRoomWannaLiveState();
}

class _DetailRoomWannaLiveState extends State<DetailRoomWannaLive> {

  bool isMe = false;
  bool FlagForLikes = false;

  final GreyEmptyHeartIcon= 'assets/images/public/GreyEmptyHeartIcon.svg';
  final PurpleFilledHeartIcon= 'assets/images/public/PurpleFilledHeartIcon.svg';

  void initState() {
    super.initState();
    if(GlobalProfile.NeedRoomInfoOfloggedInUser != null)
      isMe = widget.needRoomInfo.id == GlobalProfile.NeedRoomInfoOfloggedInUser.id;
  }
  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,widget.Likes);
        setState(() {

        });
        return;
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context,widget.Likes);
                  setState(() {

                  });
                }),
            actions: [

              isMe ?
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context, // 기본 파라미터, SecondRoute로 전달
                      MaterialPageRoute(
                          builder: (context) =>
                              EditRoomWannaLive()) // SecondRoute를 생성하여 적재
                  );
                },
                child: SvgPicture.asset(
                  editForRoomWannaLive,
                  width: screenWidth *(24/360),
                ),
              ) : Container(),
              SizedBox(width: screenWidth*(12/360),),

              widget.Likes == null ? SizedBox() : GestureDetector(
                  onTap: () async {
                    var res = await ApiProvider().post('/NeedRoomSalesInfo/InsertLike', jsonEncode(
                        {
                          "userID" : GlobalProfile.loggedInUser.userID,
                          "needRoomSaleID": widget.needRoomInfo.id,
                        }
                    ));
                    setState(() {
                      widget.Likes = !widget.Likes;
                      print(widget.Likes);
                    });
                  },
                  child:  widget.Likes ?
                  SvgPicture.asset(
                    PurpleFilledHeartIcon,
                    width: screenHeight * 0.0375,
                    height: screenHeight * 0.0375,
                    color: kPrimaryColor,
                  )
                      : SvgPicture.asset(
                    GreyEmptyHeartIcon,
                    width: screenHeight * 0.0375,
                    height: screenHeight * 0.0375,
                  )),
              SizedBox(width: screenWidth*(12/360),),
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext bc) {
                        return Container(
                          color: Colors.transparent,
                          width: screenWidth,
                          height: screenHeight * (125 / 640 ),
                          child: Column(
                            children: [
                              Container(
                                width: screenWidth * (336 / 360),
                                height: screenHeight * (97 / 640 / 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 4,
                                      offset: Offset(1.5, 1.5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    FlatButton(
                                      onPressed: () {

                                        Navigator.pop(context,widget.Likes);
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: screenHeight * (8.6667 / 640),
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Container(
                                                height: screenHeight * (30 / 640),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: screenHeight * (2 / 640)),
                                                  child: Center(
                                                    child: Text(
                                                      "공유하기",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: screenWidth*( 16/360),
                                                          color: Color(0xff222222)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenHeight * (8.6667 / 640),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * (8 / 640),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context,widget.Likes);
                                },
                                child: Container(
                                  width: screenWidth * (336 / 360),
                                  height: screenHeight * (48 / 640),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(1.5, 1.5),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "취소",
                                      style: TextStyle(
                                          fontSize: screenWidth*( 16/360),
                                          color: Color(0xff222222)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * (20 / 640),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: SvgPicture.asset(
                  moreForRoomWannaLive,
                  width: screenWidth *(24/360),
                ),
              ),
              SizedBox(width: screenWidth*(14/360),)
            ],
          ),
          body: WillPopScope(
            onWillPop: (){
              Navigator.pop(context,widget.Likes);
              return;
            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight*(8/640),),
                    Row(
                      children: [
                        Spacer(),
                        SvgPicture.asset(
                          ProfileIconInMoreScreen,
                          width: screenHeight * (120 / 640),
                          height: screenHeight * (120 / 640),
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: screenHeight*(12/640),),
                    Row(children: [
                      Spacer(),
                      Text('${widget.needRoomInfo.MonthlyFeesMin}',style: TextStyle(fontSize: screenWidth*(20/360),fontWeight: FontWeight.bold,color: Color(0xff222222)),),
                      Text("만원",style: TextStyle(fontSize: screenWidth*(20/360),fontWeight: FontWeight.bold,color: Color(0xff222222)),),
                      Text(" ~ ",style: TextStyle(fontSize: screenWidth*(20/360),fontWeight: FontWeight.bold,color: Color(0xff222222)),),
                      Text('${widget.needRoomInfo.MonthlyFeesMax}',style: TextStyle(fontSize: screenWidth*(20/360),fontWeight: FontWeight.bold,color: Color(0xff222222)),),
                      Text("만원",style: TextStyle(fontSize: screenWidth*(20/360),fontWeight: FontWeight.bold,color: Color(0xff222222)),),
                      Text(" / ",style: TextStyle(fontSize: screenWidth*(20/360),fontWeight: FontWeight.bold,color: Color(0xff222222)),),
                      Text("월",style: TextStyle(fontSize: screenWidth*(20/360),fontWeight: FontWeight.bold,color: Color(0xff222222)),),
                      Spacer(),
                    ],),
                    SizedBox(height: screenHeight*(8/640),),
                    Row(children: [

                      Container(width: screenWidth*(95/360),),
                      Container(
                        // width: screenWidth*(185/360),
                        child: Row(children: [
                          Container(
                              width: screenWidth*(84/360),
                              child: Text("임대희망기간",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,fontWeight: FontWeight.bold,color: Color(0xff222222)),)),

                          widget.needRoomInfo.TermOfLeaseMin==null? Text(" - ",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff666666)),):
                          Row(children: [
                            Text(getMonthAndDay(widget.needRoomInfo.TermOfLeaseMin)+" ~ "+getMonthAndDay(widget.needRoomInfo.TermOfLeaseMax),
                              style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                          ],),

                        ],),
                      ),

                    ],),
                    SizedBox(height: screenHeight*(4/640),),
                    Row(children: [
                      Container(width: screenWidth*(95/360),),
                      Container(
                        // width: screenWidth*(185/360),
                        child: Row(children: [
                          Container(
                              width: screenWidth*(84/360),
                              child: Text("희망보증금",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,fontWeight: FontWeight.bold,color: Color(0xff222222)),)),
                          Row(children: [
                            Text('${widget.needRoomInfo.DepositeFeesMin}'+"만원 ~ "+'${widget.needRoomInfo.DepositeFeesMax}'+"만원"
                              ,style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                          ],),
                        ],),
                      ),

                    ],),
                    SizedBox(height: screenHeight*(24/640),),
                    Row(children: [
                      Spacer(),
                      Container(
                        width: screenWidth*(53/360),
                        height: screenHeight*(22/640),
                        decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                        child: Center(child: Text( widget.needRoomInfo.Type == 0?"원룸": widget.needRoomInfo.Type == 1?"투룸이상": widget.needRoomInfo.Type == 2?"오피스텔":"아파트"
                          ,style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                      ),
                      SizedBox(width: screenWidth*(4/360),),
                      Container(
                        width: screenWidth*(53/360),
                        height: screenHeight*(22/640),
                        decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                        child: Center(child: Text(widget.needRoomInfo.SmokingPossible == 0?"흡연 O": widget.needRoomInfo.SmokingPossible == 1?"흡연 X": "흡연 무관"
                          ,style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                      ),
                      SizedBox(width: screenWidth*(4/360),),
                      Container(
                        width: screenWidth*(53/360),
                        height: screenHeight*(22/640),
                        decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                        child: Center(child: Text(widget.needRoomInfo.PreferSex== 0?"남자 선호": widget.needRoomInfo.PreferSex == 1?"여자 선호": "성별 무관",
                          style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                      ),
                      Spacer(),
                    ],),
                    SizedBox(height: screenHeight*(12/640),),
                    Container(width: screenWidth,height: screenHeight*(16/640),color: Color(0xfff8f8f8),),

                    SizedBox(height: screenHeight*(8/640),),
                    Row(children: [
                      SizedBox(width: screenWidth*OptionFontSize,),
                      Text("매물 정보",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),)
                    ],),
                    SizedBox(height: screenHeight*(8/640),),

                    Container(width: screenWidth,height: 0.3,color: OptionDivideLineColor,),

                    SizedBox(height: screenHeight*(8/640),),
                    Row(children: [
                      SizedBox(width: screenWidth*OptionFontSize,),
                      Container(
                          width: screenWidth*(90/360),
                          child: Text("임대 위치",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),)),
                      Text("인하대학교",style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Colors.black),)
                    ],),
                    SizedBox(height: screenHeight*(8/640),),


                    Container(width: screenWidth,height: 0.3,color: OptionDivideLineColor,),
                    SizedBox(height: screenHeight*(8/640),),
                    Row(children: [
                      SizedBox(width: screenWidth*OptionFontSize,),
                      Container(
                          width: screenWidth*(90/360),
                          child: Text("매물 종류",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),)),
                      Text( widget.needRoomInfo.Type == 0?"원룸": widget.needRoomInfo.Type == 1?"투룸이상": widget.needRoomInfo.Type == 2?"오피스텔":"아파트"
                        ,style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Colors.black),)
                    ],),
                    SizedBox(height: screenHeight*(8/640),),

                    Container(width: screenWidth,height: 0.3,color: OptionDivideLineColor,),
                    SizedBox(height: screenHeight*(8/640),),
                    Row(children: [
                      SizedBox(width: screenWidth*OptionFontSize,),
                      Container(
                          width: screenWidth*(90/360),
                          child: Text("임대 기간",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),)),

                      widget.needRoomInfo.TermOfLeaseMin==null?  Text(" - ",style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Colors.black),):

                      Row(children: [
                        Text(getYearMonthDay(widget.needRoomInfo.TermOfLeaseMin),style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Colors.black),),
                        Text(" ~ ",style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Colors.black),),
                        Text(getYearMonthDay(widget.needRoomInfo.TermOfLeaseMax),style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Colors.black),),

                      ],),


                    ],),
                    SizedBox(height: screenHeight*(8/640),),


                    Container(width: screenWidth,height: screenHeight*(8/640),color: Color(0xfff8f8f8),),


                    SizedBox(height: screenHeight*(8/640),),
                    Row(children: [
                      SizedBox(width: screenWidth*OptionFontSize,),
                      Text("기타 사항",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),)
                    ],),
                    SizedBox(height: screenHeight*(8/640),),

                    Container(width: screenWidth,height: 0.3,color: OptionDivideLineColor,),

                    SizedBox(height: screenHeight*(8/640),),
                    Row(children: [
                      SizedBox(width: screenWidth*OptionFontSize,),
                      Container(
                          width: screenWidth*(90/360),
                          child: Text("선호 성별",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),)),
                      Text(widget.needRoomInfo.PreferSex== 0?"남자선호": widget.needRoomInfo.PreferSex == 1?"여자선호": "성별 무관"
                        ,style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Colors.black),)
                    ],),
                    SizedBox(height: screenHeight*(8/640),),


                    Container(width: screenWidth,height: 0.3,color: OptionDivideLineColor,),
                    SizedBox(height: screenHeight*(8/640),),
                    Row(children: [
                      SizedBox(width: screenWidth*OptionFontSize,),
                      Container(
                          width: screenWidth*(90/360),
                          child: Text("흡연 여부",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),)),
                      Text(widget.needRoomInfo.SmokingPossible == 0?"O": widget.needRoomInfo.SmokingPossible == 1?"X": "흡연 무관"
                        ,style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Colors.black),)
                    ],),
                    SizedBox(height: screenHeight*(8/640),),
                    Container(width: screenWidth,height: screenHeight*(8/640),color: Color(0xfff8f8f8),),



                    SizedBox(height: screenHeight*(8/640),),
                    Row(children: [
                      SizedBox(width: screenWidth*OptionFontSize,),
                      Text("가격 정보",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),)
                    ],),
                    SizedBox(height: screenHeight*(8/640),),

                    Container(width: screenWidth,height: 0.3,color: OptionDivideLineColor,),

                    SizedBox(height: screenHeight*(8/640),),
                    Row(children: [
                      SizedBox(width: screenWidth*OptionFontSize,),
                      Container(
                          width: screenWidth*(90/360),
                          child: Text("월세",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),)),

                      Row(children: [
                        Text( '${widget.needRoomInfo.MonthlyFeesMin}',style: TextStyle(fontSize: screenWidth*OptionFontSize),),
                        Text("만원",style: TextStyle(fontSize: screenWidth*OptionFontSize),),
                        Text(" ~ ",style: TextStyle(fontSize: screenWidth*OptionFontSize),),
                        Text('${widget.needRoomInfo.MonthlyFeesMax}',style: TextStyle(fontSize: screenWidth*OptionFontSize),),
                        Text("만원",style: TextStyle(fontSize: screenWidth*OptionFontSize),),
                      ],),

                    ],),
                    SizedBox(height: screenHeight*(8/640),),


                    Container(width: screenWidth,height: 0.3,color: OptionDivideLineColor,),
                    SizedBox(height: screenHeight*(8/640),),
                    Row(children: [
                      SizedBox(width: screenWidth*OptionFontSize,),
                      Container(
                          width: screenWidth*(90/360),
                          child: Text("보증금",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),)),

                      Row(children: [
                        Text('${widget.needRoomInfo.DepositeFeesMin}',style: TextStyle(fontSize: screenWidth*OptionFontSize),),
                        Text("만원",style: TextStyle(fontSize: screenWidth*OptionFontSize),),
                        Text(" ~ ",style: TextStyle(fontSize: screenWidth*OptionFontSize),),
                        Text('${widget.needRoomInfo.DepositeFeesMax}',style: TextStyle(fontSize: screenWidth*OptionFontSize),),
                        Text("만원",style: TextStyle(fontSize: screenWidth*OptionFontSize),),

                      ],),
                    ],),
                    SizedBox(height: screenHeight*(8/640),),

                    Container(width: screenWidth,height: screenHeight*(24/640),color: Color(0xfff8f8f8),),
                    ExpansionTile(
                        title: new Text('매물 상세 설명',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth*(16/360),
                              color: Colors.black
                          ),
                        ),
                        initiallyExpanded: true,
                        backgroundColor: Colors.white,
                        children: <Widget>[
                          Divider(height: 3,color: OptionDivideLineColor,),
                          Container(
                            width: screenWidth,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0333333, vertical: screenHeight*0.0125),
                              child: Text(
                                widget.needRoomInfo.Information==null?"":widget.needRoomInfo.Information,
                                style: TextStyle(
                                    fontSize: screenWidth*OptionFontSize,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          )
                        ]
                    ),
                    Container(
                      color: hexToColor("#F8F8F8"),
                      height: screenHeight*0.0125,
                    ),
                  ],),
              ),
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: () {
              if(isMe){
                if(GlobalProfile.roomSalesInfo == null){
                  //방 내놓기 등록 페이지로 이동
                  Function okFunc = () {
                    Navigator.pop(context,widget.Likes);
                  };
                  OKDialog(context,"내 방 제안하기 실패!","상대방에게 제안할 나의 방이 등록되어 있지 않습니다.\n매물을 등록한 이후 다시 시도해주세요.","확인", okFunc);
                }else{
                  Navigator.push(
                      context, // 기본 파라미터, SecondRoute로 전달
                      MaterialPageRoute(
                          builder: (context) =>
                              NeedRoomProposalListScreen()) // SecondRoute를 생성하여 적재
                  );
                }
              }else{
                if(GlobalProfile.roomSalesInfo == null) {

                  Function okFunc = () {
                    Navigator.pop(context,widget.Likes);
                  };
                  OKDialog(context,"내 방 제안하기 실패!","상대방에게 제안할 나의 방이 등록되어 있지 않습니다.\n매물을 등록한 이후 다시 시도해주세요.","확인", okFunc);
                }
                else {
                  Function okFunc = () async {
                   var tmp = await ApiProvider().post('/NeedRoomSalesInfo/Request', jsonEncode(
                        {
                          "userID" : GlobalProfile.loggedInUser.userID,
                          "roomUserID" : widget.needRoomInfo.UserID,
                          "roomSaleInfoID" : GlobalProfile.roomSalesInfo.id
                        }
                    ));

                   Navigator.push(
                       context, // 기본 파라미터, SecondRoute로 전달
                       MaterialPageRoute(
                           builder: (context) =>
                               ReverseSuggestionComplete()) // SecondRoute를 생성하여 적재
                   );
                  };

                  Function cancelFunc = () {
                    Navigator.pop(context,widget.Likes);
                  };

                  OKCancelDialog(context, "내 방을 제안하시겠습니까?","내 방의 조건과 맞는 방을 찾는\n이용자에게 역제안을 해보세요.", "확인", "취소", okFunc, cancelFunc);
                }
              }
            },
            child: Container(
              width: screenWidth,
              height: screenHeight*(60/640),
              color: kPrimaryColor,
              child: Center(
                  child: Text(isMe ? "나에게 온 제안 보러가기" : "내 방 제안하기",
                    style: TextStyle(fontSize: screenWidth*BottomButtonMentSize,fontWeight: FontWeight.bold,color: Colors.white),
                  )
              )
              ,),
          ),
        ),
      ),
    );
  }
}
