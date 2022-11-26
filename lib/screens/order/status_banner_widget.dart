import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {
  bool? status;
  String? orderStatus;

  StatusBanner({
    this.status,
    this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successful" : message = "UnSuccessful";

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.blueAccent,
          Colors.purpleAccent,
        ],
        begin: FractionalOffset(0.0, 0.0),
        end: FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      )),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            orderStatus == "ended" || orderStatus == "rated"
                ? "Parcel Delivered $message"
                : orderStatus == "shifted"
                    ? "Parcel Shifted $message"
                    : orderStatus == "normal"
                        ? "Order Placed $message"
                        : "",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(
            width: 6,
          ),
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.white,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
