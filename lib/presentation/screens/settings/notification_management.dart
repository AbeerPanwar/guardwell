import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardwell/presentation/bloc/get_data/getdata_cubit.dart';

class NotificationManagement extends StatefulWidget {
  const NotificationManagement({super.key});

  @override
  State<NotificationManagement> createState() => _NotificationManagementState();
}

class _NotificationManagementState extends State<NotificationManagement> {
  @override
  void initState() {
    super.initState();
    context.read<GetDataCubit>().fetchUser();
  }

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
        title: Text(
          'notification'.tr(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<GetDataCubit, GetDataState>(
        builder: (context, state) {
          if (state is GetdataLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetDataError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Text(
                      "Your Session is expired",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Failed to load notifications"),
                  ],
                ),
              ),
            );
          }
          if (state is GetDataLoaded) {
            final notifications = state.notification.reversed.toList();
            if (notifications.isEmpty) {
              return const Center(child: Text("No notifications yet."));
            }
            return Padding(
              padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  return Card(
                    color: Colors.grey.shade100,
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_active),
                      title: Text(
                        'Government of India',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(n["message"] ?? "No message"),
                      trailing: n["read"] == true
                          ? const Icon(Icons.check, color: Colors.green)
                          : const Icon(
                              Icons.mark_email_unread,
                              color: Colors.red,
                            ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
