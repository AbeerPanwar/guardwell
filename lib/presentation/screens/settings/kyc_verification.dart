import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardwell/domain/entities/tourist.dart';
import 'package:guardwell/presentation/bloc/get_data/getdata_cubit.dart';
import 'package:guardwell/presentation/bloc/tourist/tourist_cubit.dart';

class KycVerification extends StatefulWidget {
  const KycVerification({super.key});

  @override
  State<KycVerification> createState() => _KycVerificationState();
}

class _KycVerificationState extends State<KycVerification> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _passportController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final List<String> _itinerary = [];
  final _itineraryController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Missing Document'),
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

  void _addItineraryItem() {
    final destination = _itineraryController.text.trim();
    if (destination.isNotEmpty && !_itinerary.contains(destination)) {
      setState(() {
        _itinerary.add(destination);
        _itineraryController.clear();
      });
    }
  }

  void _removeItineraryItem(String destination) {
    setState(() {
      _itinerary.remove(destination);
    });
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
          'kyc_title'.tr(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<GetDataCubit, GetDataState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.props[0]['ipfs_cid'] != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 64,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'kyc_title'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'kyc_sub_null'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocConsumer<TouristCubit, TouristState>(
                listener: (context, state) {
                  if (state is TouristSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tourist created successfully"),
                      ),
                    );
                  } else if (state is TouristFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is TouristLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is TouristSuccess) {
                    return Column(
                      children: [
                        Center(
                          child: Column(
                            children: [Text('Tourist Registered Successfully')],
                          ),
                        ),
                      ],
                    );
                  }
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildSectionHeader('Personal Information'),
                        SizedBox(
                          width: 300,
                          child: Text(
                            'Name must be same as in your Passport or Aadhar Card',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade900),
                          ),
                        ),
                        const SizedBox(height: 25),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _dobController,
                          label: 'Date of Birth (YYYY-MM-DD)',
                          icon: Icons.calendar_month_rounded,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your date of birth';
                            }
                            if (!RegExp(
                              r'^\d{4}-\d{2}-\d{2}$',
                            ).hasMatch(value)) {
                              return 'Please use YYYY-MM-DD format';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Identity Documents'),
                        Text(
                          'Provide atleast one of the following...',
                          style: TextStyle(color: Colors.grey.shade900),
                        ),
                        const SizedBox(height: 25),
                        _buildTextField(
                          controller: _passportController,
                          label: 'Passport Number',
                          icon: Icons.edit_document,
                          isRequired: false,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _aadhaarController,
                          label: 'Aadhar Number',
                          icon: Icons.credit_card_rounded,
                          isRequired: false,
                        ),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Travel Information'),

                        // Itinerary Section
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Travel Itinerary',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _itineraryController,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Add destination (e.g., Delhi)',
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.outline,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: _addItineraryItem,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      foregroundColor: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                              if (_itinerary.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _itinerary
                                        .map(
                                          (destination) => Chip(
                                            side: BorderSide(
                                              color: Colors.green.shade100,
                                            ),
                                            color: WidgetStatePropertyAll(
                                              Colors.green.shade100,
                                            ),
                                            label: Text(
                                              destination,
                                              style: TextStyle(
                                                color: Colors.green.shade800,
                                              ),
                                            ),
                                            deleteIcon: Icon(
                                              Icons.close,
                                              size: 18,
                                              color: Colors.green.shade800,
                                            ),
                                            onDeleted: () =>
                                                _removeItineraryItem(
                                                  destination,
                                                ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate() &&
                                (_passportController.text.trim().isNotEmpty ||
                                    _aadhaarController.text
                                        .trim()
                                        .isNotEmpty)) {
                              final tourist = Tourist(
                                fullName: _nameController.text,
                                dob: _dobController.text,
                                passport:
                                    _passportController.text.trim().isNotEmpty
                                    ? _passportController.text.trim()
                                    : null,
                                aadhaar:
                                    _aadhaarController.text.trim().isNotEmpty
                                    ? _aadhaarController.text.trim()
                                    : null,
                                itinerary: _itinerary.isNotEmpty
                                    ? _itinerary
                                    : null,
                              );
                              context.read<TouristCubit>().create(tourist);
                            } else {
                              _showErrorDialog(
                                'Passport Number or Aadhar Number is missing, provide atleast one.',
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            width: double.infinity,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Register Tourist",
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildSectionHeader(String title) {
  return Text(
    title,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required bool isRequired,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        floatingLabelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(icon, color: Colors.grey.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    ),
  );
}
