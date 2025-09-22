import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardwell/presentation/bloc/location/location_bloc.dart';
import 'package:guardwell/presentation/bloc/location/location_state.dart';

class TrackScore extends StatelessWidget {
  const TrackScore({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenheight = screenSize.height;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main card content
          BlocConsumer<LocationBloc, LocationState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is LocationLoaded) {
                return Container(
                  width: screenWidth * 0.4,
                  height: screenheight * 0.23,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenheight * 0.02),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Card(
                                  color: Colors.grey.shade300,
                                  elevation: 4,
                                  shape: CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.health_and_safety_rounded,
                                      size: screenheight * 0.033,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'safety'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenheight * 0.018,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '31',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenheight * 0.05,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Km',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenheight * 0.025,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Text(
                          //   '62',
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: screenheight * 0.05,
                          //     fontWeight: FontWeight.w800,
                          //   ),
                          // ),
                          // Text(
                          //   'Km',
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: screenheight * 0.025,
                          //     fontWeight: FontWeight.w800,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container(
                width: screenWidth * 0.4,
                height: screenheight * 0.23,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenheight * 0.02),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Card(
                                color: Colors.grey.shade300,
                                elevation: 4,
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.health_and_safety_rounded,
                                    size: screenheight * 0.033,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'safety'.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenheight * 0.018,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
