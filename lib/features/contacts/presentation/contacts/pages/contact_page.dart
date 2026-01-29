import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/core/utils/colors/app_colors.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/bloc/contacts_bloc.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/add_contact_sheet.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/contact_title.dart';
import 'package:contacts_phone/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/contacts_model.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: MainApp.themeNotifier,
            builder: (context, mode, _) {
              return Switch(
                activeTrackColor: const Color(0xFF6A6A6A),
                activeColor: const Color(0xFF414141),
                value: mode == ThemeMode.dark,
                onChanged: (isDark) async {
                  await MainApp.setTheme(
                    isDark ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              );
            },
          ),
        ),

        title: Text(
          'contacts'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.dark,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<Locale>(
            icon: Icon(
              Icons.language,
              color: isDark ? AppColors.white : AppColors.dark,
            ),
            onSelected: (locale) => context.setLocale(locale),
            itemBuilder: (_) => const [
              PopupMenuItem(value: Locale('uz'), child: Text('UZ')),
              PopupMenuItem(value: Locale('ru'), child: Text('RU')),
              PopupMenuItem(value: Locale('en'), child: Text('EN')),
            ],
          ),

          IconButton(
            icon: Icon(
              Icons.add,
              color: isDark ? AppColors.white : AppColors.dark,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) {
                  return BlocProvider.value(
                    value: context.read<ContactBloc>(),
                    child: const AddContactSheet(),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('contacts')
            .orderBy('firstName')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('no_contacts'.tr()));
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, _) => Divider(
              height: 0,
              color: isDark ? AppColors.grey : AppColors.greylight,
            ),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final contact = ContactsModel.fromJson(data, docs[index].id);
              return ContactTile(contact: contact);
            },
          );
        },
      ),
    );
  }
}
