class ItemCount{
  static final ItemCount iCount = ItemCount._init();
   String _item ;
   String get getItem => _item;
   setItem(String value) {
     _item = value;
   }

  // void setItem(String total) {
  //   setItem(String value) {
  //     _item = total;
  //   }
  // }

  factory ItemCount(){
    return iCount;
  }

  ItemCount._init();
}