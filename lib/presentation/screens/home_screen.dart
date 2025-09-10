import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guardwell/core/constants.dart';
import 'package:guardwell/presentation/bloc/location/location_bloc.dart';
// import 'package:guardwell/presentation/bloc/location/location_event.dart';
import 'package:guardwell/presentation/bloc/location/location_state.dart';
import 'package:guardwell/presentation/bloc/sos/sos_cubit.dart';
import 'package:guardwell/presentation/bloc/sos/sos_state.dart';
import 'package:guardwell/presentation/screens/settings_screen.dart';
import 'package:guardwell/presentation/widgets/sos_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) =>
      _mapController = controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 10),
        backgroundColor: Colors.transparent,
        title: Text(
          'Hello, Abeer',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(
            CupertinoIcons.person_crop_circle,
            color: Colors.grey.shade900,
            size: 55,
          ),
        ),
        actions: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
            ),
            elevation: 0.4,
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.black),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ),
          // BlocBuilder<LocationBloc, LocationState>(
          //   builder: (context, state) => IconButton(
          //     icon: const Icon(Icons.refresh),
          //     onPressed: state is LocationLoading
          //         ? null
          //         : () => context.read<LocationBloc>().add(
          //             const RefreshLocation(),
          //           ),
          //   ),
          // ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LocationBloc, LocationState>(
            listenWhen: (prev, curr) => curr is LocationLoaded,
            listener: (context, state) {
              if (state is LocationLoaded) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(state.position.latitude, state.position.longitude),
                    AppConstants.defaultZoom,
                  ),
                );
              }
            },
          ),
          BlocListener<SosCubit, SosState>(
            listener: (context, sosState) {
              if (sosState is SosFailure) _showErrorDialog(sosState.message);
              if (sosState is SosSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'SOS alert sent to ${sosState.recipients} contacts',
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(25),
                ),
                height: 400,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BlocBuilder<LocationBloc, LocationState>(
                    builder: (context, state) {
                      if (state is LocationLoading ||
                          state is LocationInitial) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(
                                height: AppConstants.defaultPadding,
                              ),
                              Text(
                                'Getting your location...',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        );
                      }
                      if (state is LocationFailure) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_off, size: 48),
                              const SizedBox(height: AppConstants.smallPadding),
                              Text(state.message, textAlign: TextAlign.center),
                            ],
                          ),
                        );
                      }
                      if (state is LocationLoaded) {
                        final marker = Marker(
                          markerId: const MarkerId('current_location'),
                          position: LatLng(
                            state.position.latitude,
                            state.position.longitude,
                          ),
                          infoWindow: const InfoWindow(title: 'Your are here!'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed,
                          ),
                        );
                        return GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              state.position.latitude,
                              state.position.longitude,
                            ),
                            zoom: AppConstants.defaultZoom,
                          ),
                          markers: {marker},
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          mapToolbarEnabled: false,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              BlocBuilder<SosCubit, SosState>(
                builder: (context, sosState) => SosButton(
                  onPressed: () {
                    final locState = context.read<LocationBloc>().state;
                    if (locState is LocationLoaded) {
                      context.read<SosCubit>().send(locState.position);
                    } else {
                      _showErrorDialog(
                        'Location not available. Please wait for location to be determined.',
                      );
                    }
                  },
                  isLoading: sosState is SosSending,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
