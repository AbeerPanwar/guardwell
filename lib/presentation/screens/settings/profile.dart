import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardwell/presentation/bloc/get_data/getdata_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
            ),
            elevation: 0.5,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<GetDataCubit, GetDataState>(
        listener: (context, state) {},
        builder: (context, state) {
          String convert(date) {
            DateTime dateTime = DateTime.parse(date).toLocal();
            String result = DateFormat("MMMM d, y hh:mm a").format(dateTime);
            return result;
          }

          final String name = state.props[0]['name'];
          final String role = state.props[0]['role'].toString().toLowerCase();
          final String? statusOrignal = state.props[0]['status'];
          final String status = statusOrignal.toString().toLowerCase();
          final String statusMain = statusOrignal == null
              ? '-'
              : '${status[0].toUpperCase()}${status.substring(1).toLowerCase()}';
          final String? ipfsId = state.props[0]['ipfs_cid'];
          String? isoString = state.props[0]['issued_at'];
          String? isoString2 = state.props[0]['expires_at'];
          final String issuedAt = isoString == null ? '-' : convert(isoString);
          final String expiresAt = isoString2 == null
              ? '-'
              : convert(isoString2);

          if (state is GetdataLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetDataError) {
            return Center(
              child: Column(
                children: [
                  Text("Your Session is expired"),
                  Text("Login again to load data"),
                ],
              ),
            );
          }
          if (state is GetDataLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    color: Colors.green.shade100,
                    shape: CircleBorder(),
                    child: Container(
                      alignment: Alignment(0, 0),
                      height: 80,
                      width: 80,
                      child: Text(
                        name[0],
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Card(
                          color: Colors.green.shade100,
                          shape: CircleBorder(),
                          child: Container(
                            alignment: Alignment(0, 0),
                            height: 35,
                            width: 35,
                            child: Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            'profile_info'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Card(
                      elevation: 0,
                      color: Colors.grey.shade200,
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 1),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Email ID',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      state.props[0]['email'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 1),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Role',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${role[0].toUpperCase()}${role.substring(1).toLowerCase()}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Card(
                          color: Colors.green.shade100,
                          shape: CircleBorder(),
                          child: Container(
                            alignment: Alignment(0, 0),
                            height: 35,
                            width: 35,
                            child: Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            'kyc_info'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Card(
                      elevation: 0,
                      color: Colors.grey.shade200,
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'IPFS-CID',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    ipfsId == null
                                        ? Text(
                                            '-',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        : SizedBox(
                                            width: 200,
                                            child: Text(
                                              ipfsId,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                    SizedBox(width: 1),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Issued At',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      issuedAt,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(width: 1),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Expires At',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      expiresAt,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(width: 1),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Status     ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      statusMain,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(width: 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
