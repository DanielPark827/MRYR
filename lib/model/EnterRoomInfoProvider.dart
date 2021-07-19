import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mryr/userData/Room.dart';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'dart:math' as Math;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image/image.dart' as Img;

class EnterRoomInfoProvider with ChangeNotifier {
  int curStep = 0;

  int transferType = 0; //1 : 월세, 2 : 전세
  int CompleteCheck = 0;
  int ItemCategory = null;

  int ExistingMonthlyRent = null;
  int ExistingDeposit = null;
  int AdministrativeExpenses = null;
  int AverageUtilityBill = null;
  int AreaSize = null;

  bool depositCheckBox = false;
  bool monthlyCheckBox= false;
  int ProposedDeposit = null;
  int ProposedMonthlyRent = null;

  String Address = null;
  String DetailAddress = null;

  String rentStart = null;
  String rentDone = null;

  int condition = null;
  int floor = null;

  String ItemDescription = null;

  bool CheckCompleteFlag = false;
  bool jeonse = false;


  List<bool> OptionList = [false,false,false,false,false,false,false,false,false,false,false,false,false,false];
  List<File> ItemImgList= [];

  List<bool> FlagEnterRoomInfo = [false,false,false,false,false,false,false,false,false,false];
  //변수 추가되거나 수정 되면 Reset 함수도 수정해주기

  EnterRoomInfoProvider(){
  }

  Future<void> SetEnterRoomInfo(RoomSalesInfo data) async {
    ItemImgList.clear();

    depositCheckBox = data.depositFeesOffer == 0? true : false;
    ItemCategory = data.type;
    ExistingMonthlyRent = data.monthlyRentFees;
    ExistingDeposit = data.depositFees;
    Address = data.location;
    DetailAddress = data.locationDetail;
    ProposedMonthlyRent = data.monthlyRentFees;
    ProposedDeposit = data.depositFees;
    AdministrativeExpenses = data.managementFees;
    AverageUtilityBill = data.utilityFees;
    AreaSize = data.square;
    ProposedDeposit = data.depositFeesOffer;
    ProposedMonthlyRent = data.monthlyRentFeesOffer;
    condition = data.Condition;
    floor = data.Floor;
    OptionList = [data.bed,data.desk,data.chair,data.closet,data.aircon,data.induction,data.refrigerator,data.tv,data.doorLock,data.microwave,data.washingMachine,data.hallwayCCTV,data.wifi,data.parking];
    ItemDescription = data.information;
    jeonse = data.jeonse;


    rentStart = data.termOfLeaseMin;
    rentDone = data.termOfLeaseMax;

    transferType = data.jeonse ? 2 : 1;

    if(data.imageUrl1 != null) {
      var response = await get(get_resize_image_name(data.imageUrl1,360));
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + "/images";
      var filePathAndName = documentDirectory.path + '/images/pict1'+'.jpg';
      await Directory(firstPath).create(recursive: true);
      File file2 = new File(filePathAndName);
      file2.writeAsBytesSync(response.bodyBytes);

      if(byteToMb(file2.lengthSync()) < ImgSizeStandard) {
        ItemImgList.add(File(filePathAndName));
      } else {
        int rand = new Math.Random().nextInt(10000000);
        Img.Image image = Img.decodeImage(file2.readAsBytesSync());
        var compressImg = new File(documentDirectory.path + '/images/resizePict_$rand'+'.jpg')
          ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
        ItemImgList.add(compressImg);
      }

    }
    if(data.imageUrl2 != null) {
      var response = await get(get_resize_image_name(data.imageUrl2,360));
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + "/images";
      var filePathAndName = documentDirectory.path + '/images/pict2'+'.jpg';
      await Directory(firstPath).create(recursive: true);
      File file2 = new File(filePathAndName);
      file2.writeAsBytesSync(response.bodyBytes);
      print("###############################${byteToMb(file2.lengthSync())}");
      int rand = new Math.Random().nextInt(10000000);
      if(byteToMb(file2.lengthSync()) < ImgSizeStandard) {
        ItemImgList.add(File(filePathAndName));
        print("yeah");
      } else {
        Img.Image image = Img.decodeImage(file2.readAsBytesSync());
        Img.Image smallerImg = Img.copyResize(image, width: (image.width*0.7).toInt(), height: (image.height*0.7.toInt()));
        var compressImg = new File(documentDirectory.path + '/images/resizePict_$rand'+'.jpg')
          ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${byteToMb(compressImg.lengthSync())}");
        ItemImgList.add(compressImg);
      }
    }
    if(data.imageUrl3 != null) {
      var response = await get(get_resize_image_name(data.imageUrl3,360));
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + "/images";
      var filePathAndName = documentDirectory.path + '/images/pict3'+'.jpg';
      await Directory(firstPath).create(recursive: true);
      File file2 = new File(filePathAndName);
      file2.writeAsBytesSync(response.bodyBytes);
      print("###############################${byteToMb(file2.lengthSync())}");
      int rand = new Math.Random().nextInt(10000000);
      if(byteToMb(file2.lengthSync()) < ImgSizeStandard) {
        ItemImgList.add(File(filePathAndName));
        print("yeah");
      } else {
        Img.Image image = Img.decodeImage(file2.readAsBytesSync());
        var compressImg = new File(documentDirectory.path + '/images/resizePict_$rand'+'.jpg')
          ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${byteToMb(compressImg.lengthSync())}");
        ItemImgList.add(compressImg);
      }
    }
    if(data.imageUrl4!= null) {
      var response = await get(get_resize_image_name(data.imageUrl4,360));
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + "/images";
      var filePathAndName = documentDirectory.path + '/images/pict4'+'.jpg';
      await Directory(firstPath).create(recursive: true);
      File file2 = new File(filePathAndName);
      file2.writeAsBytesSync(response.bodyBytes);
      print("###############################${byteToMb(file2.lengthSync())}");
      int rand = new Math.Random().nextInt(10000000);
      if(byteToMb(file2.lengthSync()) < ImgSizeStandard) {
        ItemImgList.add(File(filePathAndName));
        print("yeah");
      } else {
        Img.Image image = Img.decodeImage(file2.readAsBytesSync());
        var compressImg = new File(documentDirectory.path + '/images/resizePict_$rand'+'.jpg')
          ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${byteToMb(compressImg.lengthSync())}");
        ItemImgList.add(compressImg);
      }
    }
    if(data.imageUrl5 != null) {
      var response = await get(get_resize_image_name(data.imageUrl5,360));
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + "/images";
      var filePathAndName = documentDirectory.path + '/images/pict5'+'.jpg';
      await Directory(firstPath).create(recursive: true);
      File file2 = new File(filePathAndName);
      file2.writeAsBytesSync(response.bodyBytes);
      print("###############################${byteToMb(file2.lengthSync())}");
      int rand = new Math.Random().nextInt(10000000);
      if(byteToMb(file2.lengthSync()) < ImgSizeStandard) {
        ItemImgList.add(File(filePathAndName));
        print("yeah");
      } else {
        Img.Image image = Img.decodeImage(file2.readAsBytesSync());
        var compressImg = new File(documentDirectory.path + '/images/resizePict_$rand'+'.jpg')
          ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${byteToMb(compressImg.lengthSync())}");
        ItemImgList.add(compressImg);
      }
    }
    return;
  }

  void ResetEnterRoomInfoProvider() {
     CompleteCheck = 0;
     ItemCategory = null;


     ExistingMonthlyRent = null;
     ExistingDeposit = null;
     AdministrativeExpenses = null;
     AverageUtilityBill = null;
     AreaSize = null;
     rentStart = null;
     rentDone = null;

     depositCheckBox = false;
    ProposedDeposit = null;
    ProposedMonthlyRent = null;

     Address = null;
     DetailAddress = null;

     condition = null;
     floor = null;

    ItemDescription = null;

    CheckCompleteFlag = false;

     OptionList = [false,false,false,false,false,false,false,false,false,false,false,false,false];
     ItemImgList= [];
     // openchat = null;

     FlagEnterRoomInfo = [false,false,false,false,false,false,false,false,false,false];

     notifyListeners();
  }

  void changeJeonse(bool value) {
    jeonse = value;
    notifyListeners();
  }

  void changeTransferType(int value) {
    transferType = value;
    notifyListeners();
  }

  void changeCurStep(int value) {
    curStep = value;
    notifyListeners();
  }

  void changeRentStart(String value) {
    rentStart = value;
    notifyListeners();
  }
  void changeRentDone(String value) {
    rentDone = value;
    notifyListeners();
  }

  void ChangeFlagEnterRoomInfo(int index, bool value) {
    FlagEnterRoomInfo[index] = value;
    notifyListeners();
  }

  void ChangedepositCheckBox(bool value) {
    depositCheckBox = value;
    notifyListeners();
  }
  void ChangemonthlyCheckBox(bool value) {
    monthlyCheckBox = value;
    notifyListeners();
  }
  void ChangeAddress(String value) {
    Address = value;
  }
  void ChangeDetailAddress(String value) {
    DetailAddress = value;
  }

  void ChangeItemImgList(int index,File targetFile){
    print(index);
    ItemImgList[index] = targetFile;
    notifyListeners();
  }
  void AddItemImgList(File f) {
    ItemImgList.add(f);
    notifyListeners();
  }
  void RemoveItemImgList(int index) {
    ItemImgList.removeAt(index);
    notifyListeners();
  }


  void ChangeItemDescription(String value) {
    ItemDescription = value;
    notifyListeners();
  }
  void ChangeCompleteCheck(int value) {
    CompleteCheck = value;
    notifyListeners();
  }
  void ChangeItemCategory(int value) {
    ItemCategory = value;
    notifyListeners();
  }

  void ChangeExistingMonthlyRent(int value) {
    ExistingMonthlyRent = value;
    notifyListeners();
  }
  void ChangeExistingDeposit(int value) {
    ExistingDeposit = value;
    notifyListeners();
  }
  void ChangeAdministrativeExpenses(int value) {
    AdministrativeExpenses = value;
    notifyListeners();
  }
  void ChangeAverageUtilityBill(int value) {
    AverageUtilityBill = value;
    notifyListeners();
  }
  void ChangeAreaSize(int value) {
    AreaSize = value;
    notifyListeners();
  }

  void ChangeProposedDeposit(int value) {
    ProposedDeposit = value;
    notifyListeners();
  }
  void ChangeProposedMonthlyRent(int value) {
    ProposedMonthlyRent = value;
    notifyListeners();
  }


  void ChangeCondition(int value) {
    condition = value;
    notifyListeners();
  }
  void ChangePrefferedSex(int value) {
    floor = value;
    notifyListeners();
  }
  void ChangeOptionListComponent(int index, bool value) {
    OptionList[index] = value;
    notifyListeners();
  }
  void ChangeCheckComplete(bool value) {
    CheckCompleteFlag = value;
    notifyListeners();
  }


}
