import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/authentication_controller.dart';

class LocationView extends GetView<AuthenticationController> {
  LocationView({super.key});

  final LatLng defaultLocation = const LatLng(24.8607, 67.0011);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/images/location icon.png', height: 150),
                const SizedBox(height: 20),

                // Google Map Preview
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: controller.locationData.value != null
                            ? LatLng(
                                controller.locationData.value!.latitude!,
                                controller.locationData.value!.longitude!,
                              )
                            : defaultLocation,
                        zoom: 16,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("current_location"),
                          position: controller.locationData.value != null
                              ? LatLng(
                                  controller.locationData.value!.latitude!,
                                  controller.locationData.value!.longitude!,
                                )
                              : defaultLocation,
                        ),
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (mapController) {
                        controller.googleMapController = mapController;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Where is your location?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enjoy a personalized selling and buying experience by telling us your location.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.isFetchingLocation.value
                        ? null
                        : controller.fetchCurrentLocation,
                    icon: const Icon(Icons.location_on_outlined),
                    label: Text(
                      controller.isFetchingLocation.value
                          ? 'Locating...'
                          : 'Find My Location',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00CFC1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
