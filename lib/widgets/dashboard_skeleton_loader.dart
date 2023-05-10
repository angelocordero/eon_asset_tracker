import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class DashboardSkeletonLoader extends StatelessWidget {
  const DashboardSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      items: 1,
      period: const Duration(seconds: 1),
      direction: SkeletonDirection.ltr,
      highlightColor: Colors.grey.shade400,
      baseColor: Colors.grey.shade800,

      builder: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      color: Colors.black,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                Flexible(
                  flex: 7,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: Container(
                        color: Colors.black,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          AspectRatio(
            aspectRatio: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      color: Colors.black,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                Flexible(
                  flex: 7,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: Container(
                        color: Colors.black,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // builder: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     AspectRatio(
      //       aspectRatio: 4,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         mainAxisSize: MainAxisSize.max,
      //         children: [
      //           Flexible(
      //             flex: 3,
      //             child: Container(
      //               margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      //               color: Colors.black,
      //               width: double.infinity,
      //               height: double.infinity,
      //             ),
      //           ),
      //           Flexible(
      //             flex: 7,
      //             child: Container(
      //               margin: const EdgeInsets.all(5),
      //               color: Colors.black,
      //               width: double.infinity,
      //               height: double.infinity,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     AspectRatio(
      //       aspectRatio: 4,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         mainAxisSize: MainAxisSize.max,
      //         children: [
      //           Flexible(
      //             flex: 3,
      //             child: Container(
      //               margin: const EdgeInsets.all(5),
      //               color: Colors.black,
      //               width: double.infinity,
      //               height: double.infinity,
      //             ),
      //           ),
      //           Flexible(
      //             flex: 7,
      //             child: Container(
      //               margin: const EdgeInsets.all(5),
      //               color: Colors.black,
      //               width: double.infinity,
      //               height: double.infinity,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
