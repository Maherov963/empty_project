import '../static/id_name_model.dart';

class Custom {
  int? id;
  bool admin;
  bool manager;
  bool supervisor;
  bool moderator;
  bool assistant;
  bool custom;
  bool reciter;
  bool tester;
  bool seller;
  bool adder;
  bool appoint;
  bool viewPerson;
  bool viewRecite;
  bool viewGroups;
  bool viewPeople;
  bool addPerson;
  bool editPerson;
  bool deletePerson;
  bool viewGroup;
  bool addGroup;
  bool editGroup;
  bool deleteGroup;
  bool observe;
  bool recite;
  bool test;
  bool sell;
  bool viewAttendance;
  bool attendance;
  bool evaluation;
  bool level;
  bool viewLog;
  bool appointStudent;
  String? note;
  int? state;
  int? defaultGroup;

  List<IdNameModel>? moderatorGroups;
  List<IdNameModel>? superVisorGroups;
  List<IdNameModel>? assitantsGroups;
  Custom({
    this.viewGroups = false,
    this.viewAttendance = false,
    this.viewPeople = false,
    this.viewRecite = false,
    this.id,
    this.defaultGroup,
    this.adder = false,
    this.admin = false,
    this.appointStudent = false,
    this.manager = false,
    this.supervisor = false,
    this.moderator = false,
    this.assistant = false,
    this.custom = false,
    this.reciter = false,
    this.tester = false,
    this.seller = false,
    this.appoint = false,
    this.viewPerson = false,
    this.addPerson = false,
    this.editPerson = false,
    this.deletePerson = false,
    this.addGroup = false,
    this.deleteGroup = false,
    this.editGroup = false,
    this.viewGroup = false,
    this.observe = false,
    this.recite = false,
    this.test = false,
    this.sell = false,
    this.attendance = false,
    this.evaluation = false,
    this.level = false,
    this.note,
    this.state,
    this.viewLog = false,
    this.moderatorGroups = const [],
    this.superVisorGroups = const [],
    this.assitantsGroups = const [],
  });

  Custom copy() {
    return Custom(
      addGroup: addGroup,
      addPerson: addPerson,
      admin: admin,
      appoint: appoint,
      appointStudent: appointStudent,
      assistant: assistant,
      assitantsGroups: assitantsGroups?.map((e) => e.copy()).toList(),
      attendance: attendance,
      custom: custom,
      deleteGroup: deleteGroup,
      deletePerson: deletePerson,
      editGroup: editGroup,
      editPerson: editPerson,
      evaluation: evaluation,
      id: id,
      defaultGroup: defaultGroup,
      level: level,
      manager: manager,
      moderator: moderator,
      moderatorGroups: moderatorGroups?.map((e) => e.copy()).toList(),
      note: note,
      observe: observe,
      recite: recite,
      reciter: reciter,
      sell: sell,
      seller: seller,
      state: state,
      superVisorGroups: superVisorGroups?.map((e) => e.copy()).toList(),
      supervisor: supervisor,
      test: test,
      tester: tester,
      viewGroup: viewGroup,
      viewLog: viewLog,
      viewPerson: viewPerson,
      viewGroups: viewGroups,
      viewRecite: viewRecite,
      viewPeople: viewPeople,
      viewAttendance: viewAttendance,
      adder: adder,
    );
  }

  factory Custom.fromJson(Map<String, dynamic> json) {
    final moderatorGroupsList = json["moderator_groups"] == null
        ? []
        : json["moderator_groups"] as List;
    final superVisorGroupsList = json["supervisor_groups"] == null
        ? []
        : json["supervisor_groups"] as List;
    final assitantsGroupsList = json["assistant_groups"] == null
        ? []
        : json["assistant_groups"] as List;
    return Custom(
      id: json["ID_Permission_Pep"],
      defaultGroup: json["Default_Group"],
      admin: json["Admin"] == "1" ? true : false,
      addGroup: json["Add_Group"] == "1" ? true : false,
      addPerson: json["Add_Person"] == "1" ? true : false,
      appoint: json["Appoint"] == "1" ? true : false,
      assistant: json["Assisstent"] == "1" ? true : false,
      assitantsGroups: assitantsGroupsList
          .map((e) =>
              IdNameModel.fromJson(e, idKey: "ID_Group", nameKey: "Group_Name"))
          .toList(), //
      appointStudent: json["Appoint_Student"] == "1" ? true : false,
      attendance: json["Attendance"] == "1" ? true : false,
      custom: json["Custom"] == "1" ? true : false,
      deleteGroup: json["Delete_Group"] == "1" ? true : false,
      deletePerson: json["Delete_Person"] == "1" ? true : false,
      editGroup: json["Edit_Group"] == "1" ? true : false,
      editPerson: json["Edit_Person"] == "1" ? true : false,
      evaluation: json["Evaluation"] == "1" ? true : false,
      level: json["Level"] == "1" ? true : false,
      manager: json["Manager"] == "1" ? true : false,
      moderator: json["Moderator"] == "1" ? true : false,
      moderatorGroups: moderatorGroupsList
          .map((e) =>
              IdNameModel.fromJson(e, idKey: "ID_Group", nameKey: "Group_Name"))
          .toList(),
      note: json["Note"],
      observe: json["Observe"] == "1" ? true : false,
      recite: json["Recite"] == "1" ? true : false,
      reciter: json["Reciter"] == "1" ? true : false,
      sell: json["Sell"] == "1" ? true : false,
      seller: json["Seller"] == "1" ? true : false,
      state: json["state"]?["ID_State"],
      superVisorGroups: superVisorGroupsList
          .map((e) =>
              IdNameModel.fromJson(e, idKey: "ID_Group", nameKey: "Group_Name"))
          .toList(),
      supervisor: json["Supervisor"] == "1" ? true : false,
      test: json["Test"] == "1" ? true : false,
      tester: json["Tester"] == "1" ? true : false,
      viewGroup: json["View_Group"] == "1" ? true : false,
      viewLog: json["View_Log"] == "1" ? true : false,
      viewPerson: json["View_Person"] == "1" ? true : false,
      viewGroups: json["View_Groups"] == "1" ? true : false,
      viewPeople: json["View_People"] == "1" ? true : false,
      viewRecite: json["View_Recite"] == "1" ? true : false,
      viewAttendance: json["View_Attendance"] == "1" ? true : false,
      adder: json["Adder"] == "1" ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Default_Group": defaultGroup,
      "ID_Permission_Pep": id,
      "Admin": admin ? "1" : "0",
      "Appoint_Student": appointStudent ? "1" : "0",
      "Add_Group": addGroup ? "1" : "0",
      "Add_Person": addPerson ? "1" : "0",
      "Appoint": appoint ? "1" : "0",
      "Assisstent": assistant ? "1" : "0",
      "assistant_groups": assitantsGroups
          ?.map((e) => e.toJson(idKey: "ID_Group", nameKey: "Group_Name"))
          .toList(),
      "Attendance": attendance ? "1" : "0",
      "Custom": custom ? "1" : "0",
      "Delete_Group": deleteGroup ? "1" : "0",
      "Delete_Person": deletePerson ? "1" : "0",
      "Edit_Group": editGroup ? "1" : "0",
      "Edit_Person": editPerson ? "1" : "0",
      "Evaluation": evaluation ? "1" : "0",
      "Level": level ? "1" : "0",
      "Manager": manager ? "1" : "0",
      "Moderator": moderator ? "1" : "0",
      "moderator_groups": moderatorGroups
          ?.map((e) => e.toJson(idKey: "ID_Group", nameKey: "Group_Name"))
          .toList(),
      "Note": note,
      "Observe": observe ? "1" : "0",
      "Recite": recite ? "1" : "0",
      "Reciter": reciter ? "1" : "0",
      "Sell": sell ? "1" : "0",
      "Seller": seller ? "1" : "0",
      "state": {"ID_State": state},
      "supervisor_groups": superVisorGroups
          ?.map((e) => e.toJson(idKey: "ID_Group", nameKey: "Group_Name"))
          .toList(),
      "Supervisor": supervisor ? "1" : "0",
      "Test": test ? "1" : "0",
      "Tester": tester ? "1" : "0",
      "View_Group": viewGroup ? "1" : "0",
      "View_Groups": viewGroups ? "1" : "0",
      "View_People": viewPeople ? "1" : "0",
      "View_Recite": viewRecite ? "1" : "0",
      "View_Log": viewLog ? "1" : "0",
      "View_Person": viewPerson ? "1" : "0",
      "View_Attendance": viewAttendance ? "1" : "0",
      "Adder": adder ? "1" : "0",
    };
  }

  refreshPermissionAfterRule(bool activate) {
    if (activate) {
      appoint = appoint || (admin);
      addGroup = addGroup || (admin);
      editGroup = editGroup || (admin);
      deleteGroup = deleteGroup || (admin);
      deletePerson = deletePerson || (admin);

      evaluation = evaluation || (admin || moderator);
      viewPerson =
          viewPerson || (isAdminstration || tester || adder || moderator);
      viewRecite =
          viewRecite || (isAdminstration || tester || moderator || assistant);
      viewGroups = viewGroups || (isAdminstration || adder || moderator);
      viewPeople = viewPeople || (isAdminstration || adder || moderator);
      addPerson = addPerson || (admin || manager || adder || moderator);
      viewGroup = viewGroup ||
          (isAdminstration || tester || adder || moderator || assistant);

      recite = recite || (isAdminstration || moderator || assistant);
      test = test || (admin || tester || moderator);
      viewAttendance = viewAttendance || (isAdminstration || moderator);
      attendance = attendance || (admin || manager || moderator);
      appointStudent =
          appointStudent || (admin || manager || adder || moderator);
      editPerson = true;
      // level = level || (isAdminstration || adder || moderator);
      // viewLog = viewLog || (isAdminstration || adder || moderator);
      // sell = sell || (isAdminstration || adder || moderator);
      // observe = observe || (isAdminstration || adder || moderator);
    } else {
      appoint = appoint && (admin);
      addGroup = addGroup && (admin);
      editGroup = editGroup && (admin);
      deleteGroup = deleteGroup && (admin);
      deletePerson = deletePerson && (admin);

      evaluation = evaluation && (admin || moderator);
      viewPerson =
          viewPerson && (isAdminstration || tester || adder || moderator);
      viewRecite =
          viewRecite && (isAdminstration || tester || moderator || assistant);
      viewGroups = viewGroups && (isAdminstration || adder || moderator);
      viewPeople = viewPeople && (isAdminstration || adder || moderator);
      addPerson = addPerson && (admin || manager || adder || moderator);
      viewGroup = viewGroup &&
          (isAdminstration || tester || adder || moderator || assistant);

      recite = recite && (isAdminstration || moderator || assistant);
      test = test && (admin || tester || moderator);
      viewAttendance = viewAttendance && (isAdminstration || moderator);
      attendance = attendance && (admin || manager || moderator);
      appointStudent =
          appointStudent && (admin || manager || adder || moderator);
      editPerson = true;
      // level = level && (isAdminstration || adder || moderator);
      // observe = observe && (isAdminstration || adder || moderator);
      // sell = sell && (isAdminstration || adder || moderator);
      // viewLog = viewLog && (isAdminstration || adder || moderator);
    }
  }

  get getRules => [
        admin,
        manager,
        adder,
        tester,
        supervisor,
        moderator,
        assistant,
      ];

  get getPermissions => [
        addPerson,
        editPerson,
        viewPerson,
        viewPeople,
        appoint,
        appointStudent,
        addGroup,
        viewGroup,
        editGroup,
        viewGroups,
        recite,
        viewRecite,
        test,
        attendance,
        viewAttendance,
        evaluation,
        deleteGroup,
        deletePerson
      ];

  bool get isAdminstration => admin || manager || supervisor;

  List<IdNameModel> get getGroups {
    List<IdNameModel> groups = [];
    for (var element in (moderatorGroups
                ?.map((e) => e..myRank = IdNameModel.asModerator)
                .toList() ??
            []) +
        (superVisorGroups
                ?.map((e) => e..myRank = IdNameModel.asSupervisor)
                .toList() ??
            []) +
        (assitantsGroups
                ?.map((e) => e..myRank = IdNameModel.asAssistant)
                .toList() ??
            [])) {
      if (groups.where((e) => e.id == element.id).isEmpty) {
        groups.add(element);
      }
    }
    return groups;
  }
}
