class FilterType {
  String title;
  bool flag;
  bool selected;

  FilterType(String title, {bool flag = false, bool selected = false}) {
    this.title = title;
    this.flag = flag;
    this.selected = selected;
  }
}