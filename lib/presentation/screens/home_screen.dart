import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guardwell/core/constants.dart';
import 'package:guardwell/data/datasources/aut_local_datasource.dart';
import 'package:guardwell/data/repositories/location_repository_impl.dart';
import 'package:guardwell/data/services/location_service.dart';
import 'package:guardwell/domain/usecases/location/get_current_location.dart';
import 'package:guardwell/presentation/bloc/get_data/getdata_cubit.dart';
// import 'package:guardwell/data/services/background_service.dart';
import 'package:guardwell/presentation/bloc/location/location_bloc.dart';
import 'package:guardwell/presentation/bloc/location/location_event.dart';
// import 'package:guardwell/presentation/bloc/location/location_event.dart';
import 'package:guardwell/presentation/bloc/location/location_state.dart';
import 'package:guardwell/presentation/bloc/sos/sos_cubit.dart';
import 'package:guardwell/presentation/bloc/sos/sos_state.dart';
import 'package:guardwell/presentation/screens/settings/settings_screen.dart';
import 'package:guardwell/presentation/widgets/sos_button.dart';
import 'package:guardwell/presentation/widgets/track_score.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  @override
  void initState() {
    super.initState();
    context.read<GetDataCubit>().fetchUser();
  }

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
        title: BlocConsumer<GetDataCubit, GetDataState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GetDataLoaded) {
              final fullName = state.props[0]['name'].split(' ');
              return Text(
                'Hello, ${fullName.first}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            }
            return Text(
              'Session is expired sign in again...',
              style: TextStyle(fontSize: 16, color: Colors.red),
            );
          },
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
            listener: (context, state) async {
              if (state is LocationLoaded) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(state.position.latitude, state.position.longitude),
                    AppConstants.defaultZoom,
                  ),
                );
                final localDataSource = AuthLocalDataSourceImpl(
                  secureStorage: FlutterSecureStorage(),
                );
                final String token = await localDataSource.getToken() ?? '';
                final LocationBloc locationBloc = LocationBloc(
                  LocationRepositoryImpl(
                    LocationService(
                      baseUrl: dotenv.env['NODE_JS_BACKEND_URI']!,
                      token: token,
                    ),
                  ),
                  getCurrentLocation: GetCurrentLocation(
                    LocationRepositoryImpl(
                      LocationService(
                        baseUrl: dotenv.env['NODE_JS_BACKEND_URI']!,
                        token: token,
                      ),
                    ),
                  ),
                );
                locationBloc.add(StartLiveLocationEvent());
                // final token = await const FlutterSecureStorage().read(
                //   key: "token",
                // );
                // BackgroundService.initialize(
                //   backendUrl: dotenv.env['NODE_JS_BACKEND_URI']!,
                //   token: token ?? '',
                // );
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
              Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TrackScore(),
                    Column(
                      children: [
                        Container(
                          width: 170,
                          height: 145,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 12,
                              bottom: 6,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  elevation: 4,
                                  color: Colors.grey.shade900,
                                  shape: CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.terrain_rounded,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Area',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Safe',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        BlocConsumer<LocationBloc, LocationState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            if (state is LocationLoaded) {
                              return Container(
                                width: 170,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        SizedBox(width: 5),
                                        Text(state.place),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              width: 170,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on),
                                      SizedBox(width: 20),
                                      SizedBox(
                                        height: 20,
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
                  ],
                ),
              ),
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
                  onPressed: () async {
                    final localDataSource = AuthLocalDataSourceImpl(
                      secureStorage: FlutterSecureStorage(),
                    );
                    final String token = await localDataSource.getToken() ?? '';
                    final locationservice = LocationService(
                      baseUrl: dotenv.env['NODE_JS_BACKEND_URI']!,
                      token: token,
                    );
                    if (!mounted) {
                      return;
                    }
                    final pos = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );
                    final locState = context.read<LocationBloc>().state;
                    try {
                      await locationservice.sendSos(pos);
                      if (locState is LocationLoaded) {
                        context.read<SosCubit>().send(locState.position);
                      } else {
                        _showErrorDialog(
                          'Location not available. Please wait for location to be determined.',
                        );
                      }
                    } catch (e) {
                      throw e.toString();
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
