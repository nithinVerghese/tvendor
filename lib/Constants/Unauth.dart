import 'package:get/get.dart';
import 'package:takhlees_v/view/Auth/sign_up.dart';

class UnAuth{

  isUnAuth(String status){
    if(status.contains('Unauthorised')||status.contains('Unauthenticated')){
      Get.off(()=>SignUp());
    }
  }

}