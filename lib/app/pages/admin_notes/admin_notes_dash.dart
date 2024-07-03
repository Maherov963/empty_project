import 'package:al_khalil/app/components/custom_taple/custom_taple.dart';
import 'package:al_khalil/app/components/try_again_loader.dart';
import 'package:al_khalil/app/pages/additional_point/add_pts_admin_page.dart';
import 'package:al_khalil/app/pages/group/group_profile.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/adminstrative_note_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/domain/models/management/adminstrative_note.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AdminNoteDash extends StatefulWidget {
  const AdminNoteDash({super.key});

  @override
  State<AdminNoteDash> createState() => _AdminNoteDashState();
}

class _AdminNoteDashState extends State<AdminNoteDash> {
  Failure? _failure;
  List<AdminstrativeNote>? _data;
  SortType isadminSort = SortType.none;
  SortType isDateSort = SortType.none;
  SortType isNameSort = SortType.none;
  Future<void> refresh() async {
    AdminstrativeNoteProvider prov = context.read<AdminstrativeNoteProvider>();
    if (prov.getIsViewingAll) {
      return;
    }
    final state = await prov.viewAllAdminstrativeNote();
    if (state is DataState<List<AdminstrativeNote>>) {
      _data = state.data;
    }
    if (state is ErrorState && context.mounted) {
      _failure = state.failure;
      CustomToast.handleError(state.failure);
    }
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myAccount = context.read<CoreProvider>().myAccount;
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل الملاحظات"),
        actions: [
          IconButton(
            onPressed: () {
              refresh();
            },
            icon: const Icon(Icons.replay_outlined),
          )
        ],
      ),
      body: Consumer<AdminstrativeNoteProvider>(
        builder: (_, val, __) => Column(
          children: [
            Visibility(
              visible: val.getIsViewingAll,
              child: const LinearProgressIndicator(),
            ),
            TryAgainLoader(
              failure: _failure,
              isLoading: val.getIsViewingAll,
              isData: _data != null,
              onRetry: refresh,
              child: Expanded(
                child: RefreshIndicator(
                  onRefresh: () => refresh(),
                  child: CustomTaple(
                    culomn: [
                      CustomCulomnCell(
                        sortType: isNameSort,
                        text: "صاحب الملاحظة",
                        onSort: sortReciever,
                      ),
                      CustomCulomnCell(
                        text: "الموجه",
                        sortType: isadminSort,
                        onSort: sortSender,
                      ),
                      CustomCulomnCell(
                        text: "التاريخ",
                        sortType: isDateSort,
                        onSort: sortDate,
                      ),
                      const CustomCulomnCell(
                        text: "التفاصيل",
                      ),
                    ],
                    row: _data?.map(
                      (e) => CustomRow(
                        row: [
                          CustomCell(
                            text: e.person?.getFullName(),
                            onTap: () {
                              context.navigateToPerson(e.person?.id);
                            },
                          ),
                          CustomCell(
                            text: e.admin?.getFullName(),
                          ),
                          CustomCell(
                            text: e.updatedAt,
                          ),
                          CustomIconCell(
                            icon: Icons.info_outline,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => InfoDialog(
                                  title: "التفاصيل",
                                  infoData: [
                                    getInfoCard("الوصف", e.note),
                                  ],
                                  onEdit: myAccount?.id != e.admin?.id
                                      ? null
                                      : () async {
                                          CustomDialog.showDialoug(
                                            context,
                                            AdminNotesSheet(
                                              note: e,
                                              people: const [],
                                            ),
                                            "إضافة ملاحظة إدارية",
                                          );
                                        },
                                  onDelete: (myAccount?.id != e.admin?.id &&
                                          !myAccount!.custom!.admin)
                                      ? null
                                      : () async {
                                          final state = await context
                                              .read<AdminstrativeNoteProvider>()
                                              .deleteAdminstrativeNote(e.id!);
                                          if (state is DataState) {
                                            _data?.removeWhere((element) =>
                                                e.id == element.id);
                                            setState(() {});
                                            CustomToast.showToast(
                                                CustomToast.succesfulMessage);
                                          } else if (state is ErrorState) {
                                            CustomToast.handleError(
                                                state.failure);
                                          }
                                        },
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getInfoCard(String? head, String? body) => Padding(
        padding: const EdgeInsets.all(0.0),
        child: RichText(
          text: TextSpan(
            text: "$head : ",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: body ?? "",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
  sortSender() {
    isDateSort = SortType.none;
    isNameSort = SortType.none;
    if (isadminSort == SortType.inc) {
      isadminSort = SortType.dec;
    } else {
      isadminSort = SortType.inc;
    }
    if (isadminSort == SortType.inc) {
      _data?.sort(
        (a, b) => (a.admin?.getFullName() ?? "")
            .compareTo(b.admin?.getFullName() ?? ""),
      );
    } else {
      _data?.sort(
        (a, b) => (b.admin?.getFullName() ?? "")
            .compareTo(a.admin?.getFullName() ?? ""),
      );
    }
    setState(() {});
  }

  sortReciever() {
    isDateSort = SortType.none;
    isadminSort = SortType.none;
    if (isNameSort == SortType.inc) {
      isNameSort = SortType.dec;
    } else {
      isNameSort = SortType.inc;
    }
    if (isNameSort == SortType.inc) {
      _data?.sort(
        (a, b) => (a.people?.firstOrNull?.getFullName() ?? "")
            .compareTo(b.people?.firstOrNull?.getFullName() ?? ""),
      );
    } else {
      _data?.sort(
        (a, b) => (b.people?.firstOrNull?.getFullName() ?? "")
            .compareTo(a.people?.firstOrNull?.getFullName() ?? ""),
      );
    }
    setState(() {});
  }

  sortDate() {
    isadminSort = SortType.none;
    isNameSort = SortType.none;
    if (isDateSort == SortType.inc) {
      isDateSort = SortType.dec;
    } else {
      isDateSort = SortType.inc;
    }
    if (isDateSort == SortType.inc) {
      _data?.sort((a, b) => (a.updatedAt ?? "").compareTo(b.updatedAt ?? ""));
    } else {
      _data?.sort((a, b) => (b.updatedAt ?? "").compareTo(a.updatedAt ?? ""));
    }
    setState(() {});
  }
}
