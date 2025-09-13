import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardwell/presentation/bloc/location/location_bloc.dart';
import 'package:guardwell/presentation/bloc/location/location_state.dart';
import 'package:guardwell/presentation/bloc/sos/sos_cubit.dart';

class SosTrackingScreen extends StatelessWidget {
  final Position initialPosition;

  const SosTrackingScreen({super.key, required this.initialPosition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SOS Active")),
      body: BlocListener<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is SosStoppedState) {
            Navigator.pop(context);
          }
        },
        child: Column(
          children: [
            Center(
              child: Text(
                "SOS started at:\nLat: ${initialPosition.latitude}, Lng: ${initialPosition.longitude}",
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<SosCubit>().stopSos();
              },
              child: const Text("✅ I am safe"),
            ),
          ],
        ),
      ),
    );
  }
}
