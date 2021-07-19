class FilterPacket {
  List<String> roomType;
  int minPrice;
  int maxPrice;
  String rentStart;
  String rentDone;

  int isParking;
  int isCCTV;
  int isWifi;

  FilterPacket(List<String> rT, int minP, int maxP, String rStart, String rDone, int iP, int iC, int iW) {
    this.roomType = rT;
    this.minPrice = minP;
    this.maxPrice = maxP;
    this.rentStart = rStart;
    this.rentDone = rDone;
    this.isParking = iP;
    this.isCCTV = iC;
    this.isWifi = iW;
  }
}