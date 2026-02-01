import 'package:azlistview/azlistview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/core/utils/colors/app_colors.dart';
import 'package:contacts_phone/core/widgets/icon_widget.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/bloc/contacts_bloc.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/add_contact_sheet.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/contact_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/contacts_model.dart';

class ContactsPage extends StatefulWidget {
  final String title;
  const ContactsPage({super.key, required this.title});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<ContactsModel> _contacts = [];

  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {                
    _searchController.dispose();
    super.dispose();
  }

  bool _matchContact(ContactsModel contacts, String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return true;

    final name = '${contacts.firstName} ${contacts.lastName}'
        .trim()
        .toLowerCase();
    final phone = (contacts.phoneNumber).toString().toLowerCase();

    return name.contains(query) || phone.contains(query);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'contacts'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.dark,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        leadingWidth: 110,
        leading: Row(
          children: [
            const SizedBox(width: 15),
            IconWidget(
              imege: Image.asset(
                isDark
                    ? "assets/pictures/white_back_icon.png"
                    : "assets/pictures/black_back_icon.png",
                width: 22,
                height: 22,
              ),
              selected: true,
              isDark: isDark,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BlocProvider.value(
                    value: context.read<ContactBloc>(),
                    child: AddContactSheet(),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          IconWidget(
            imege: Image.asset(
              isDark
                  ? "assets/pictures/white_plus_icon.png"
                  : "assets/pictures/black_plus_icon.png",
              width: 20,
              height: 20,
            ),
            selected: true,
            isDark: isDark,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<ContactBloc>(),
                  child: AddContactSheet(),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
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

          _contacts = docs
              .map(
                (doc) => ContactsModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList();

          final filtered = _contacts
              .where((c) => _matchContact(c, _query))
              .toList();

          for (var contact in filtered) {
            final fullName = '${contact.firstName}${contact.lastName}'.trim();
            contact.tag = fullName.isNotEmpty ? fullName[0].toUpperCase() : '#';
          }

          SuspensionUtil.sortListBySuspensionTag(filtered);
          SuspensionUtil.setShowSuspensionStatus(filtered);

          return SafeArea(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1C1C1E)
                            : const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Icon(
                            Icons.search,
                            color: isDark ? Colors.white54 : Colors.black45,
                            size: 22,
                          ),
                          const SizedBox(width: 8),

                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) => setState(() => _query = v),
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.black38,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),

                          if (_query.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              icon: Icon(
                                Icons.close,
                                size: 20,
                                color: isDark ? Colors.white54 : Colors.black45,
                              ),
                            ),

                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.mic,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: AzListView(
                      data: filtered,
                      itemCount: filtered.length,
                      physics: const StopPhysics(),
                      itemBuilder: (context, index) {
                        return ContactTile(contact: filtered[index]);
                      },

                      indexBarOptions: IndexBarOptions(
                        textStyle: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        selectTextStyle: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        selectItemDecoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        needRebuild: true,
                        indexHintWidth: 0,
                        indexHintHeight: 0,
                        indexHintDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        indexHintTextStyle: const TextStyle(
                          color: Colors.transparent,
                          fontSize: 0,
                        ),
                      ),

                      indexHintBuilder: (_, __) => const SizedBox.shrink(),

                      susItemBuilder: (context, index) {
                        final tag = filtered[index].getSuspensionTag();
                        return Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          color: isDark ? AppColors.dark : AppColors.whitegrey,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.greylight,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class StopPhysics extends ScrollPhysics {
  const StopPhysics({super.parent});

  @override
  StopPhysics applyTo(ScrollPhysics? ancestor) {
    return StopPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    return null;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }

    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      return value - position.pixels;
    }

    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }

    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      return value - position.maxScrollExtent;
    }

    return 0.0;
  }
}
