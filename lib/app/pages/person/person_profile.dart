import 'package:al_khalil/app/components/my_fab_group.dart';
import 'package:al_khalil/app/pages/person/new_add_person.dart';
import 'package:al_khalil/app/pages/person/permissioin_step.dart';
import 'package:al_khalil/app/pages/person/student_step.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/adminstrative_note_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/widgets/skeleton.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/adminstrative_note.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/features/quran/pages/home_screen/quran_home_screen.dart';
import 'package:al_khalil/features/quran/pages/page_screen/quran_screen.dart';
import 'package:al_khalil/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/user_profile_appbar.dart';
import '../../providers/managing/person_provider.dart';
import '../../router/router.dart';
import '../../utils/messges/toast.dart';
import 'person_step.dart';

class PersonProfile extends StatefulWidget {
  final int? id;
  final Person? person;
  const PersonProfile({
    super.key,
    this.id,
    this.person,
  });

  @override
  State<PersonProfile> createState() => _PersonProfileState();
}

class _PersonProfileState extends State<PersonProfile> {
  final _scrollController = ScrollController();
  var _currentIndex = 0;
  late Person? _person = widget.person;
  List<AdminstrativeNote>? _notes;
  late bool isLoading = widget.person == null;
  late bool isLoadingNotes = false;

  void _onAddNote({AdminstrativeNote? note}) async {
    final myAccount = context.read<CoreProvider>().myAccount!;

    await CustomDialog.showFieldDialog(
      context: context,
      title: "إضافة ملاحظة",
      label: "الملاحظة",
      initial: note?.note,
      onSave: (p0) async {
        ProviderStates state;
        if (note == null) {
          note ??= AdminstrativeNote(
            people: [_person!],
            admin: myAccount,
            note: p0,
            updatedAt: DateTime.now().getYYYYMMDD(),
          );
          state = await context
              .read<AdminstrativeNoteProvider>()
              .addAdminstrativeNote(note!);
        } else {
          note?.note = p0;
          state = await context
              .read<AdminstrativeNoteProvider>()
              .editAdminstrativeNote(note!);
        }

        if (state is DataState<int> && mounted) {
          note?.id = state.data;
          CustomToast.showToast(CustomToast.succesfulMessage);
          _notes?.add(note!);
          Navigator.pop(context);
        } else if (state is DataState && mounted) {
          CustomToast.showToast(CustomToast.succesfulMessage);
          Navigator.pop(context);
        } else if (state is ErrorState && mounted) {
          CustomToast.handleError(state.failure);
        }
      },
    );

    setState(() {});
  }

  void _onDeleteNote(int id) async {
    final state = await context
        .read<AdminstrativeNoteProvider>()
        .deleteAdminstrativeNote(id);
    if (state is DataState) {
      CustomToast.showToast(CustomToast.succesfulMessage);
      _notes?.removeWhere((note) => note.id == id);
      setState(() {});
    } else if (state is ErrorState) {
      CustomToast.showToast(state.failure.message);
    }
  }

  init() async {
    isLoading = true;
    setState(() {});
    if (widget.person == null) {
      await context.read<PersonProvider>().getPerson(widget.id!).then((state) {
        if (state is DataState<Person> && mounted) {
          setState(() {
            isLoading = false;
            _person = state.data;
          });
        }
        if (state is ErrorState && mounted) {
          setState(() {
            isLoading = false;
          });
          CustomToast.handleError(state.failure);
        }
      });
    }
  }

  Future getNotes() async {
    isLoadingNotes = true;
    setState(() {});
    final state = await context
        .read<AdminstrativeNoteProvider>()
        .viewAdminstrativeNote(AdminstrativeNote(people: [_person!]));
    if (state is DataState<List<AdminstrativeNote>> && mounted) {
      _notes = state.data;
    } else if (state is ErrorState && mounted) {
      CustomToast.handleError(state.failure);
    }
    setState(() {
      isLoadingNotes = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Person myAccount = context.read<CoreProvider>().myAccount!;
    late List<Widget> taps = [
      PersonStep(
        person: _person!,
        enabled: false,
      ),
      StudentStep(
        student: _person!.student!,
        // ignore: prefer_const_literals_to_create_immutables
        groups: [],
        classs: 0,
        enabled: false,
      ),
      if (myAccount.custom!.appoint)
        PermissionStep(
          custom: _person!.custom!,
          enabled: false,
        ),
      _notes == null && isLoadingNotes
          ? getLoader()
          : _notes == null
              ? getError(getNotes)
              : Column(
                  children: _notes!
                      .map((e) => NoteWidget(
                            note: e,
                            onDelete: _onDeleteNote,
                            onEdit: (p0) => _onAddNote(note: p0),
                          ))
                      .toList()
                      .reversed
                      .toList(),
                ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: MyFabGroup(
        fabModel: [
          if (myAccount.custom!.isAdminstration)
            FabModel(
              icon: Icons.note_add,
              tooltip: "إضافة ملاحظة إدارية",
              onTap: _onAddNote,
              tag: 3,
            ),
          FabModel(
            icon: Icons.edit,
            tooltip: "تعديل",
            onTap: () async {
              if (_person != null) {
                if (myAccount.custom!.editPerson) {
                  context.myPushReplacment(
                      AddNewPerson(fromEdit: true, person: _person));
                } else {
                  CustomToast.showToast(CustomToast.noPermissionError);
                }
              }
            },
            tag: 2,
          ),
          FabModel(
            icon: Icons.menu_book_sharp,
            tooltip: "المحفوظات",
            onTap: () async {
              if (_person != null) {
                if (myAccount.custom!.viewRecite) {
                  context.myPush(QuranHomeScreen(
                    student: _person,
                    reason: PageState.reciting,
                  ));
                } else {
                  CustomToast.showToast(CustomToast.noPermissionError);
                }
              }
            },
            tag: 1,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.account_circle), label: "شخص"),
          const NavigationDestination(
              icon: Icon(Icons.accessibility_sharp), label: "طالب"),
          if (myAccount.custom!.appoint)
            const NavigationDestination(
                icon: Icon(Icons.assignment_ind_sharp), label: "أستاذ"),
          if (myAccount.custom!.isAdminstration)
            const NavigationDestination(
                icon: Icon(Icons.notes), label: "ملاحظات"),
        ],
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          if (i == taps.length - 1 && myAccount.custom!.isAdminstration) {
            getNotes();
          }
          setState(() => _currentIndex = i);
        },
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          UserProfileAppBar(
            scrollController: _scrollController,
            firstLastName: _person?.getFullName() ?? "",
            file: _person?.imageLink ?? "",
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: isWin ? 600 : null,
              child: Center(
                child: _person == null && isLoading
                    ? getLoader()
                    : _person == null
                        ? getError(init)
                        : taps[_currentIndex],
              ),
            ),
          )),
        ],
      ),
    );
  }

  getError(Function() onTap) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: TextButton(
          onPressed: onTap,
          child: Text(
            "إعادة المحاولة",
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
      ),
    );
  }

  getLoader() {
    return const Column(
      children: [
        Skeleton(height: 75),
        Skeleton(height: 75),
        Skeleton(height: 75),
        Skeleton(height: 75),
        Skeleton(height: 75),
      ],
    );
  }
}

callWhatsApp(String? number, bool isCall) async {
  if (number == null) {
    CustomToast.showToast("not valid");
    return;
  }
  var contact = number;
  const String content = "";
  var androidUrl =
      isCall ? 'tel:$contact' : "whatsapp://send?phone=$contact&text=$content";

  await launchUrl(Uri.parse(androidUrl));
}

class NoteWidget extends StatelessWidget {
  final AdminstrativeNote note;
  final Function(AdminstrativeNote)? onEdit;
  final Function(int)? onDelete;
  const NoteWidget({
    super.key,
    required this.note,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final myAccount = context.read<CoreProvider>().myAccount;
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.1, color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoListTile(
            onTap: () {
              context.navigateToPerson(note.admin!.id);
            },
            title: Text(
              note.admin?.getFullName() ?? "",
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              note.updatedAt ?? "",
              style: theme.textTheme.bodySmall,
            ),
            leading: ClipOval(
              child: SizedBox.square(
                  dimension: 40,
                  child: Image.asset("assets/images/profile.png")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(note.note ?? ""),
          ),
          Visibility(
            visible: !context
                .watch<AdminstrativeNoteProvider>()
                .isLoadingIn
                .contains(note.id),
            replacement: const LinearProgressIndicator(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (myAccount!.custom!.admin || myAccount.id == note.admin?.id)
                  IconButton(
                    onPressed: () {
                      onDelete?.call(note.id!);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: theme.colorScheme.error,
                    ),
                  ),
                if (myAccount.id == note.admin?.id)
                  IconButton(
                    onPressed: () {
                      onEdit?.call(note);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
