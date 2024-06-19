import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guestbook/theme/colors.dart';
import 'package:guestbook/view/guest_form_view.dart';
import 'package:guestbook/view/guest_list_view.dart';

class MainTabView extends StatelessWidget {
  const MainTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primary100,
        appBar: AppBar(
          backgroundColor: AppColors.primary100,
          title: Text('Guestbook',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 20, color: AppColors.white)),
          bottom: const TabBar(
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.secondary100,
            indicatorColor: AppColors.primary500,
            // indicatorColor: Theme.of(context).accentColor,
            tabs: [
              Tab(text: 'Tambah Tamu'),
              Tab(text: 'Daftar Tamu'),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appbar_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            const GuestFormView(),
            GuestListView(),
          ],
        ),
      ),
    );
  }
}
