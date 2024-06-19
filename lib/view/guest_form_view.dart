import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guestbook/controller/guest_controller.dart';
import 'package:guestbook/theme/colors.dart';
import 'package:guestbook/theme/input_text_field.dart';
import 'package:guestbook/theme/rounded_material_button.dart';
import 'dart:io';

class GuestFormView extends StatefulWidget {
  const GuestFormView({super.key});

  @override
  State<GuestFormView> createState() => _GuestFormViewState();
}

class _GuestFormViewState extends State<GuestFormView> {
  final GuestController controller = Get.find();

  final nameController = TextEditingController();
  final addressController = TextEditingController();

  final listActivity = const [
    "Lihat Produk",
    "Bermain VR",
    "Bermain Game AFL",
    "Bermain Game GTP 2D",
    "Bermain Game Xavena",
    "Bermain Game Commando"
  ];

  var nama = ''.obs;
  var address = ''.obs;
  File? _photo;

  final List<String> imageUrls = [
    'see_product.png',
    'play_vr.png',
    'airforce.png',
    'garuda.png',
    'xavena.png',
    'commando.png',
  ];

  List<int> selectedIndices = [];

  void _onImageTap(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputFormTextField(
                        controller: nameController,
                        onChanged: (p0) => nama.value = p0,
                        title: 'Nama',
                        marginBottom: 8,
                        capitalizeFirstLetter: true,
                      ),
                      InputFormTextField(
                        controller: addressController,
                        onChanged: (p0) => address.value = p0,
                        title: 'Alamat',
                        marginBottom: 8,
                        capitalizeFirstLetter: true,
                      ),
                      Text("Foto Kegiatan",
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.black500)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          File? pickedPhoto = await controller.pickImage();
                          if (pickedPhoto != null) {
                            setState(() {
                              _photo = pickedPhoto;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          decoration: BoxDecoration(
                              color: AppColors.black200,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: (_photo != null)
                                ? Image.file(
                                    _photo!,
                                    width: 100,
                                    height: 100,
                                  )
                                : Column(
                                    children: [
                                      const Icon(
                                        Icons.add_a_photo,
                                        size: 40,
                                        color: AppColors.black300,
                                      ),
                                      const SizedBox(height: 8),
                                      Text("Tambahkan foto",
                                          style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: AppColors.black300))
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Pilih Kegiatan",
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.black500)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: List.generate(
                          listActivity.length,
                          (index) {
                            return GestureDetector(
                              onTap: () => _onImageTap(index),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selectedIndices.contains(index)
                                            ? AppColors.danger
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4.0),
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Image.asset(
                                            "assets/images/${imageUrls[index]}",
                                            fit: BoxFit.cover,
                                            width: (width / 2) - 30,
                                            height: 150,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black
                                                    .withOpacity(0.2)),
                                            child: Text(listActivity[index],
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 11,
                                                        color:
                                                            AppColors.white)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (selectedIndices.contains(index))
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: AppColors.danger,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      //     ModalSearchbox(
                      //         padding: const EdgeInsets.all(0),
                      //         label: "Pilih Kegiatan",
                      // labelTextstyle: GoogleFonts.plusJakartaSans(
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: 14,
                      //     color: AppColors.black500),
                      //         isMultipleSelect: true,
                      //         selectedMutipleValue: selectedMultipleActivity,
                      //         list: listActivity,
                      //         contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      //         onChanged: (newValue) {
                      //           selectedMultipleActivity = newValue;
                      //         }),
                      // if (_photo != null)
                      //   Image.file(
                      //     _photo!,
                      //     width: 100,
                      //     height: 100,
                      //   ),
                      //     if (_photo == null)
                      //       ElevatedButton(
                      //         onPressed: () async {
                      // File? pickedPhoto = await controller.pickImage();
                      // if (pickedPhoto != null) {
                      //   setState(() {
                      //     _photo = pickedPhoto;
                      //   });
                      // }
                      //         },
                      //         child: const Text('Pick Photo'),
                      //       ),
                      //     const SizedBox(height: 20),
                      //     if (nama.value.isNotEmpty &&
                      //         address.value.isNotEmpty &&
                      //         _photo != null)
                      //       ElevatedButton(
                      //         onPressed: () {
                      // if (nameController.text.isNotEmpty &&
                      //     addressController.text.isNotEmpty &&
                      //     _photo != null) {
                      //   controller.addGuest(
                      //       nameController.text,
                      //       addressController.text,
                      //       _photo!,
                      //       selectedMultipleActivity);
                      //   nama.value = '';
                      //   address.value = '';
                      //   _photo = null;
                      //   nameController.clear();
                      //   addressController.clear();
                      //   selectedMultipleActivity.clear();
                      //           } else {
                      //             Get.snackbar('Error', 'All fields are required');
                      //           }
                      //         },
                      //         child: const Text('Submit'),
                      //       ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: RoundedMaterialButton(
                  label: "Simpan",
                  disabled: (nama.value.isEmpty ||
                      address.value.isEmpty ||
                      _photo == null ||
                      selectedIndices.isEmpty),
                  onPressed: (loadingController) async {
                    List<String> selectedMultipleActivity =
                        selectedIndices.map((e) => listActivity[e]).toList();
                    loadingController.start();
                    await controller.addGuest(
                        nameController.text,
                        addressController.text,
                        _photo!,
                        selectedMultipleActivity);
                    nama.value = '';
                    address.value = '';
                    _photo = null;
                    nameController.clear();
                    addressController.clear();
                    selectedMultipleActivity.clear();

                    loadingController.stop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
