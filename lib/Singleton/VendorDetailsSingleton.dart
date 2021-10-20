class VendorDetailsSingleton{
  static final VendorDetailsSingleton vendorDetails = VendorDetailsSingleton._init();

  String _number;

  int _id;
  String _serviceType;
  int _position;
  String _nationalType;
  int tabIndex ;

  List _vendorList;
  List get vendorList => _vendorList;
  void setVendorList(newList){
    _vendorList = newList;
  }

  int get id => _id;
  void setId(newValue){
    _id = newValue;
  }

  void setPosition(newValue){
    _position = newValue;
  }
  int get position => _position;


  get tabPosition => tabIndex;

  void setTabPosition(index){
    tabIndex = index;
  }


  String get serviceType => _serviceType;
  void setServiceType(newValue){
    _serviceType = newValue;
  }

  String get nationalType => _nationalType;
  void setNationalType(newValue){
    _nationalType = newValue;
  }
  

  factory VendorDetailsSingleton(){
    return vendorDetails;
  }

  VendorDetailsSingleton._init();

}
class VendorNationalSingleton{
  static final VendorNationalSingleton vendorNational = VendorNationalSingleton._init();

  String _nationalType;

  String get nationalType => _nationalType;
  void setNationalType(newValue){
    _nationalType = newValue;
  }


  factory VendorNationalSingleton(){
    return vendorNational;
  }

  VendorNationalSingleton._init();

}