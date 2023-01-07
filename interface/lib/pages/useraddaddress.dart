import 'package:flowerbasket/models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../colors/colorsconf.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({
    Key? key,
  }) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  LatLng point = LatLng(39.92077, 32.85411);
  MapController mapController = MapController();

  void _center() {
    mapController.move(point, 19.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add Address'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: Get.height * 0.1,
        backgroundColor: MyColors.tertiary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              tooltip: "Confirm",
              onPressed: () async {
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    point.latitude, point.longitude);
                Placemark place = placemarks[0];
                AddressElement address = AddressElement(
                  street: place.street!,
                  city: place.administrativeArea!,
                  zipCode: place.postalCode!,
                  state: place.subAdministrativeArea!,
                  detail: place.subLocality!,
                  addressId: 0,
                  latitude: point.latitude,
                  longitude: point.longitude,
                );

                Get.toNamed("/useraddressconfirm", arguments: address);
              },
              icon: const Icon(Icons.check),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //get current location
          bool serviceEnabled;
          LocationPermission permission;

          serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            return Future.error('Location services are disabled');
          }

          permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              return Future.error('Location permissions are denied');
            }
          }

          if (permission == LocationPermission.deniedForever) {
            return Future.error(
                'Location permissions are permanently denied, we cannot request permissions.');
          }
          Position? position = await Geolocator.getLastKnownPosition();
          if (position == null) {
            position = await Geolocator.getCurrentPosition();
            setState(() {
              point = LatLng(position!.latitude, position.longitude);
            });
          } else {
            setState(() {
              point = LatLng(position!.latitude, position.longitude);
            });
          }
          _center();
        },
        backgroundColor: MyColors.primary,
        child: const Icon(Icons.location_searching),
      ),
      //
      body: Center(
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            zoom: 12.0,
            //turkey
            center: point,
            onTap: (tapPosition, point) {
              setState(() {
                this.point = point;
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              minZoom: 1,
              subdomains: const ['a', 'b', 'c'],
              maxZoom: 20,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 80,
                  height: 80,
                  builder: (context) => const Icon(
                    Icons.location_on,
                    color: MyColors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
