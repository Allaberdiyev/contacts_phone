import 'package:azlistview/azlistview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/core/utils/colors/app_colors.dart';
import 'package:contacts_phone/core/widgets/icon_widget.dart';
import 'package:contacts_phone/core/widgets/search_bar_widget.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/bloc/contacts_bloc.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/pages/conatact_details_page.dart';
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
    final phone = contacts.phoneNumber.toLowerCase();

    return name.contains(query) || phone.contains(query);
  }

  double _dividerIndent(BuildContext context) => 76;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.dark : Colors.white,
        elevation: 0,
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
              type: IconContentType.image,
              image: Image.asset(
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
            type: IconContentType.image,
            image: Image.asset(
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
                    child: SearchBarWidget(
                      controller: _searchController,
                      query: _query,
                      isDark: isDark,
                      onChanged: (v) => setState(() => _query = v),
                      onClear: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      onMic: () {},
                    ),
                  ),

                  Expanded(
                    child: AzListView(
                      data: filtered,
                      itemCount: filtered.length,
                      physics: const StopPhysics(),
                      itemBuilder: (context, index) {
                        final contact = filtered[index];

                        final isLast = index == filtered.length - 1;
                        final currentTag = contact.getSuspensionTag();
                        final nextTag = !isLast
                            ? filtered[index + 1].getSuspensionTag()
                            : null;
                        final needLongDivider =
                            !isLast && nextTag != currentTag;

                        final dividerColor = isDark
                            ? Colors.white12
                            : Colors.black12;

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ContactDetailsPage(contact: contact),
                                  ),
                                );
                              },
                              child: ContactTile(contact: contact),
                            ),
                            if (!isLast)
                              Divider(
                                height: 1,
                                thickness: 0.6,
                                color: dividerColor,
                                indent: needLongDivider
                                    ? 0
                                    : _dividerIndent(context),
                                endIndent: 0,
                              ),
                          ],
                        );
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
                      indexHintBuilder: (_, _) => const SizedBox.shrink(),
                      susItemBuilder: (context, index) {
                        final tag = filtered[index].getSuspensionTag();
                        final dividerColor = isDark
                            ? Colors.white12
                            : Colors.black12;

                        return Column(
                          children: [
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              color: isDark ? AppColors.dark : Colors.white,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.greylight,
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: dividerColor,
                              indent: 0,
                              endIndent: 0,
                            ),
                          ],
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
  ) => null;

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
