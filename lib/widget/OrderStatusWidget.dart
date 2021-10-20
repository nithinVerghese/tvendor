import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';

Widget orderStatus(String status, BuildContext context,
    // var height
    ){

  return ClayContainer(
    surfaceColor:status == 'Processing'
        ? Color(0xffD8EEF0)
        : status == 'Order Accepted'
        ? Color(0xffD8EEF0)
        : status == 'Order Issues'
        ? Color(0xFFFDD8DA)
        : status == 'Rejected - Book Delivery'
        ? Color(0xFFFDD8DA)
        : status == 'Document Delivery'
        ? Color(0xFFD8EEF0)
        : status == 'Waiting Documents'
        ? Color(0x50F15B29)
        : status == 'Completed'
        ? Color(0xffD8EEF0)
        : status == 'Document Collection'
        ? Color(0xffD8EEF0)
        : status == 'With Driver'
        ? Color(0x12F15B29)
        : status == 'With Service Provider'
        ? Color(0x12F15B29)
        : status == 'Something is Wrong'
        ? Color(0xffFDD8DA)
        : status == 'Completed - Book Delivery'
        ? Color(0xffD8EEF0)
        : status == 'Delivery'
        ? Color(0xffD8EEF0)
        : status == 'Closed'
        ? Color(0xffD8EEF0)
        : status == 'Cancelled'
        ? Color(0xffFDD8DA)
        : Colors.transparent,
    depth:0,
    emboss:true,
    spread: 0,
    borderRadius: 10,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:12.0,vertical: 10),
        child: Text('$status',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontFamily: FontStrings.Roboto_Regular,
              color: status == 'Processing'
                  ? Color(0xff0A95A0)
                  : status == 'Completed'
                  ? Color(0xff0A95A0)
                  : status == 'Order Issues'
                  ? Color(0xFFC1282D)
                  : status == 'Document Delivery'
                  ? Color(0xff0A95A0)
                  : status == 'Waiting Documents'
                  ? Color(0xFFF15B29)
                  : status == 'Order Accepted'
                  ? Color(0xff0A95A0)
                  : status == 'Document Collection'
                  ? Color(0xff0A95A0)
                  : status == 'With Driver'
                  ? Color(0xFFF15B29)
                  : status == 'With Service Provider'
                  ? Color(0xFFF15B29)
                  : status == 'Something is Wrong'
                  ? Color(0xffC1282D)
                  : status == 'Rejected - Book Delivery'
                  ? Color(0xffC1282D)
                  : status == 'Completed - Book Delivery'
                  ? Color(0xff0A95A0)
                  : status == 'Delivery'
                  ? Color(0xff0A95A0)
                  : status == 'Closed'
                  ? Color(0xff0A95A0)
                  : status == 'Cancelled'
                  ? Color(0xffC1282D)
                  : Colors.transparent),
        ),
      ),
    ),
  );

  // return Container(
  //   padding:
  //   const EdgeInsets.all(
  //       10.0),
  //   decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(10)),
  //       color: status == 'Processing'
  //           ? Color(0xffD8EEF0)
  //           : status == 'Order Accepted'
  //           ? Color(0xffD8EEF0)
  //           : status == 'Completed'
  //           ? Color(0xffD8EEF0)
  //           : status == 'Document Collection'
  //           ? Color(0xffD8EEF0)
  //           : status == 'With Driver'
  //           ? Color(0x12F15B29)
  //           : status == 'With Service Provider'
  //           ? Color(0x12F15B29)
  //           : status == 'Something is Wrong'
  //           ? Color(0xffFDD8DA)
  //           : status == 'Completed - Book Delivery'
  //           ? Color(0xffD8EEF0)
  //           : status == 'Delivery'
  //           ? Color(0xffD8EEF0)
  //           : status == 'Closed'
  //           ? Color(0xffD8EEF0)
  //           : status == 'Cancelled'
  //           ? Color(0xffFDD8DA)
  //           : Colors.transparent,
  //     boxShadow: [
  //       BoxShadow(
  //         color: Colors.black26,
  //         offset: Offset(0.0, 1),
  //         blurRadius: 1,
  //       ),
  //     ],
  //
  //     // 'Processing',
  //     // 'Order Accepted',
  //     // 'Document Collection',
  //     // 'With Driver',
  //     // 'With Service Provider',
  //     // 'Something is Wrong',
  //     // 'Completed - Book Delivery',
  //     // 'Delivery',
  //     // 'Closed',
  //     // 'Cancelled'
  //
  //   ),
  //   child: Center(
  //     child: Text(
  //       '$status',
  //       style: Theme.of(context).textTheme.bodyText1.copyWith(
  //           fontFamily: FontStrings.Roboto_Regular,
  //           color: status == 'Processing'
  //               ? Color(0xff0A95A0)
  //               : status == 'Completed'
  //               ? Color(0xff0A95A0)
  //               : status == 'Order Accepted'
  //               ? Color(0xff0A95A0)
  //               : status == 'Document Collection'
  //               ? Color(0xff0A95A0)
  //               : status == 'With Driver'
  //               ? Color(0xFFF15B29)
  //               : status == 'With Service Provider'
  //               ? Color(0xFFF15B29)
  //               : status == 'Something is Wrong'
  //               ? Color(0xffC1282D)
  //               : status == 'Completed - Book Delivery'
  //               ? Color(0xff0A95A0)
  //               : status == 'Delivery'
  //               ? Color(0xff0A95A0)
  //               : status == 'Closed'
  //               ? Color(0xff0A95A0)
  //               : status == 'Cancelled'
  //               ? Color(0xffC1282D)
  //               : Colors.transparent),
  //     ),
  //   ),
  // );
}
