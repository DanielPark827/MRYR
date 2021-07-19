class LocationList {

  String address;

  LocationList({this.address});

  factory LocationList.fromJson(Map<String, dynamic> json){
    return LocationList(
      address: json['Location'] as String,
    );
  }
}