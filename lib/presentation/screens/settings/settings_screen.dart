import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardwell/presentation/bloc/Auth/auth_cubit.dart';
import 'package:guardwell/presentation/screens/settings/contact_management_screen.dart';
import 'package:guardwell/presentation/screens/settings/kyc_verification.dart';
import 'package:guardwell/presentation/screens/settings/language_management_screen.dart';
import 'package:guardwell/presentation/screens/settings/profile.dart';
import 'package:guardwell/presentation/widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'settings'.tr(),
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
            ),
            SizedBox(height: 30),
            SettingsTile(
              icon: Icons.person,
              title: 'update_profile'.tr(),
              subtitle: 'update_profile_sub'.tr(),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            SizedBox(height: 30),
            SettingsTile(
              icon: Icons.verified_rounded,
              title: 'kyc_title'.tr(),
              subtitle: 'kyc_sub_title'.tr(),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const KycVerification(),
                  ),
                );
              },
            ),
            SizedBox(height: 30),
            SettingsTile(
              icon: Icons.contacts_rounded,
              title: 'contact'.tr(),
              subtitle: 'contact_sub'.tr(),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ContactManagementScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 30),
            SettingsTile(
              icon: Icons.language_rounded,
              title: 'language'.tr(),
              subtitle: 'language_sub'.tr(),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LanguageManagementScreen(),
                  ),
                );
                setState(() {});
              },
            ),
            SizedBox(height: 30),
            // SettingsTile(
            //   icon: Icons.location_on_rounded,
            //   title: 'show_my_location'.tr(),
            //   subtitle: 'show_my_location_sub'.tr(),
            //   onTap: () {},
            // ),
            // SizedBox(height: 30),
            SettingsTile(
              icon: Icons.logout_outlined,
              title: 'logout'.tr(),
              subtitle: 'logout_sub'.tr(),
              onTap: () {
                context.read<AuthCubit>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
