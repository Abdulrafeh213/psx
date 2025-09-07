import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPhoneInput extends StatelessWidget {
  final RxString selectedCountryDialCode;
  final RxString selectedCountryCode;

  final Function(String) onCountryCodeChanged;
  final Function(String) onNumberChanged;

  const CustomPhoneInput({
    super.key,
    required this.selectedCountryDialCode,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
    required this.onNumberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 24,
        ), // padding right added
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CountryCodePicker(
              onChanged: (country) {
                onCountryCodeChanged(country.dialCode ?? '+92');
                // Also update the country code (alpha-2)
                selectedCountryCode.value = country.code ?? 'PK';
              },
              // Use country code (alpha-2) for initialSelection
              initialSelection: selectedCountryCode.value.isNotEmpty
                  ? selectedCountryCode.value
                  : 'PK', // default Pakistan
              favorite: const ['+92', '+1', '+44'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(fontSize: 16),
              flagWidth: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Phone Number',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 20,
                  ),
                ),
                onChanged: onNumberChanged,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                    return 'Enter valid number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
