import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guestbook/controller/guest_controller.dart';
import 'dart:io';

import 'package:guestbook/theme/colors.dart';
import 'package:guestbook/theme/rounded_material_button.dart';
import 'package:intl/intl.dart';

class GuestListView extends StatelessWidget {
  final GuestController controller = Get.find();

  GuestListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoadingFetch.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.guests.isEmpty) {
          return const Center(child: Text('No guests found.'));
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.guests.length,
                  itemBuilder: (context, index) {
                    final guest = controller.guests[index];

                    final formattedDate = DateFormat('HH:mm - dd MMM yyyy')
                        .format(DateTime.fromMicrosecondsSinceEpoch(
                            int.parse(guest.date)));

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: const Color.fromARGB(255, 255, 251, 251),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(guest.imagePath),
                                width: 100,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Expanded(
                                          child: Text(
                                            guest.name.capitalizeFirst!,
                                            style: GoogleFonts.plusJakartaSans(
                                                color: AppColors.secondary500,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(formattedDate,
                                            style: GoogleFonts.plusJakartaSans(
                                                color: AppColors.black300,
                                                fontSize: 10)),
                                      ]),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                                guest.address.capitalizeFirst!,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                        color:
                                                            AppColors.black400,
                                                        fontSize: 14)),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Konfirmasi'),
                                                    content: const Text(
                                                        'Apakah Anda yakin ingin menghapus tamu ini?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Batal'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          controller
                                                              .deleteGuest(
                                                                  guest.id!);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Hapus'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Icon(
                                                Icons.delete_outline,
                                                color: AppColors.black300,
                                                size: 20),
                                          )
                                        ],
                                      ),
                                      Text(guest.activity,
                                          style: GoogleFonts.plusJakartaSans(
                                              color: AppColors.black500,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 8, bottom: 16, left: 16, right: 16),
                child: RoundedMaterialButton(
                    label: "Share CSV",
                    onPressed: (loading) async {
                      loading.start();
                      await controller.exportToCsvAndShare();
                      loading.stop();
                    }),
              ),
            ],
          );
        }
      }),
    );
  }
}
