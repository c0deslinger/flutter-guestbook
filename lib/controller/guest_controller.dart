import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guestbook/model/guest.dart';
import 'package:guestbook/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:csv/csv.dart';

class GuestController extends GetxController {
  var isLoadingSend = false.obs;
  var isLoadingFetch = false.obs;
  var guests = <Guest>[].obs;

  GuestController() {
    fetchGuests();
  }

  Future<void> addGuest(
      String name, String origin, File photo, List<String> activities) async {
    isLoadingSend.value = true;
    try {
      var uuid = const Uuid();
      String id = uuid.v4();

      String fileName = basename(photo.path);
      String localPath =
          '${(await getApplicationDocumentsDirectory()).path}/$fileName';
      await photo.copy(localPath);

      String activity = activities.join(', ');

      Guest guest = Guest(
          id: id,
          name: name,
          address: origin,
          imagePath: localPath,
          activity: activity,
          date: DateTime.now().microsecondsSinceEpoch.toString());
      await DatabaseHelper().insertGuest(guest);
      guests.add(guest);

      Get.snackbar('Success', 'Guest added successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingSend.value = false;
    }
  }

  Future<File?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  void fetchGuests() async {
    isLoadingFetch.value = true;
    List<Guest> localGuests = await DatabaseHelper().getGuests();
    guests.addAll(localGuests);

    isLoadingFetch.value = false;
  }

  // Add this method to the GuestController class in guest_controller.dart
  Future<void> deleteGuest(String id) async {
    try {
      await DatabaseHelper().deleteGuest(id);
      guests.removeWhere((guest) => guest.id == id);
      Get.snackbar('Success', 'Guest deleted successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> exportToPdf() async {
    final pdf = pw.Document();

    for (var guest in guests) {
      final image = guest.imagePath.startsWith('http')
          ? pw.MemoryImage((await NetworkAssetBundle(Uri.parse(guest.imagePath))
                  .load(guest.imagePath))
              .buffer
              .asUint8List())
          : pw.MemoryImage(File(guest.imagePath).readAsBytesSync());

      final formattedDate = DateFormat('HH:mm dd/MM/yyyy')
          .format(DateTime.fromMicrosecondsSinceEpoch(int.parse(guest.date)));

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(guest.name, style: const pw.TextStyle(fontSize: 24)),
                pw.Text(guest.address),
                pw.Text(guest.activity),
                pw.Text(formattedDate),
                pw.SizedBox(height: 20),
                pw.Image(image),
              ],
            );
          },
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/guests.pdf");
    await file.writeAsBytes(await pdf.save());
    Get.snackbar('Success', 'PDF exported successfully');
  }

  Future<void> exportToCsvAndShare() async {
    try {
      final output = await getTemporaryDirectory();
      final csvFile = File("${output.path}/guests.csv");
      final imageDirectory = Directory("${output.path}/images");

      if (!await imageDirectory.exists()) {
        await imageDirectory.create(recursive: true);
      }

      List<List<dynamic>> rows = [
        ["ID", "Name", "Address", "Activity", "Date", "Photo Path"]
      ];

      for (var guest in guests) {
        final formattedDate = DateFormat('HH:mm dd/MM/yyyy')
            .format(DateTime.fromMicrosecondsSinceEpoch(int.parse(guest.date)));

        final localImagePath =
            "${imageDirectory.path}/${basename(guest.imagePath)}";
        await File(guest.imagePath).copy(localImagePath);

        List<dynamic> row = [
          guest.id,
          guest.name,
          guest.address,
          guest.activity,
          formattedDate,
          'images/${basename(guest.imagePath)}'
        ];
        rows.add(row);
      }

      String csv = const ListToCsvConverter().convert(rows);
      await csvFile.writeAsString(csv);

      final zipFile = File("${output.path}/guests.zip");
      final encoder = ZipFileEncoder();
      encoder.create(zipFile.path);
      encoder.addFile(csvFile);
      encoder.addDirectory(imageDirectory);
      encoder.close();

      Get.snackbar('Success', 'CSV and images exported successfully');
      await shareFile(zipFile.path);
    } catch (e) {
      Get.snackbar('Error', 'Failed to export and share: $e');
    }
  }

  Future<void> shareFile(String filePath) async {
    Share.shareXFiles([XFile(filePath)], text: 'Daftar buku tamu');
  }
}
