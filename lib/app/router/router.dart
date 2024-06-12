import 'package:al_khalil/app/pages/person/new_add_person.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/models.dart';
import '../pages/group/group_profile.dart';
import '../pages/person/person_profile.dart';
import '../providers/core_provider.dart';
import '../providers/managing/person_provider.dart';

extension MyRouter on BuildContext {
  navigateToGroup(int id) async {
    if (read<CoreProvider>().myAccount!.custom!.viewGroup) {
      return myPush(GroupProfile(id: id));
    } else {
      CustomToast.showToast(CustomToast.noPermissionError);
    }
  }

  navigateToPerson(int? id, {Person? person}) async {
    if (read<CoreProvider>().myAccount!.custom!.viewPerson) {
      myPush(PersonProfile(id: id, person: person));
    } else {
      CustomToast.showToast(CustomToast.noPermissionError);
    }
  }

  navigateToEditPerson(int id) async {
    if (read<CoreProvider>().myAccount!.custom!.editPerson) {
      await read<PersonProvider>().getPerson(id).then((state) {
        if (state is DataState<Person>) {
          myPushReplacment(AddNewPerson(person: state.data, fromEdit: true));
        }
        if (state is ErrorState) {
          CustomToast.handleError(state.failure);
        }
      });
    } else {
      CustomToast.showToast(CustomToast.noPermissionError);
    }
  }

  Future<T> myPush<T>(Widget child) async {
    return await Navigator.of(this).push(
      MaterialPageRoute(
        builder: (_) => child,
      ),
    );
  }

  Future<T> myPushReplacment<T>(Widget child) async {
    return await Navigator.of(this).pushReplacement(
      MaterialPageRoute(
        builder: (_) => child,
      ),
    );
  }

  Future<T> myPushReplacmentAll<T>(Widget child) async {
    return await Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => child,
      ),
      (__) => false,
    );
  }
}
