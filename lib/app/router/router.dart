import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/components/my_snackbar.dart';
import 'package:al_khalil/app/pages/person/add_person.dart';
import 'package:al_khalil/app/pages/person/person_profile.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/management/person.dart';
import '../pages/group/group_profile.dart';
import '../providers/states/provider_states.dart';

class MyRouter {
  static navigateToGroup(BuildContext context, int id) async {
    if (context.read<CoreProvider>().myAccount!.custom!.viewGroup) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupProfile(id: id),
          ));
    } else {
      MySnackBar.showMySnackBar("لا تملك الصلاحيات الكافية", context,
          contentType: ContentType.warning, title: "حدث خطأ");
    }
  }

  static navigateToPerson(BuildContext context, int? id,
      {Person? person}) async {
    if (context.read<CoreProvider>().myAccount!.custom!.viewPerson) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonProfile(id: id, person: person),
          ));
    } else {
      MySnackBar.showMySnackBar("لا تملك الصلاحيات الكافية", context,
          contentType: ContentType.warning, title: "حدث خطأ");
    }
  }

  static navigateToEditPerson(BuildContext context, int id) async {
    if (context.read<CoreProvider>().myAccount!.custom!.editPerson) {
      await context.read<PersonProvider>().getPerson(id).then((state) {
        if (state is PersonState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddPersonPage(person: state.person, fromEdit: true),
              ));
        }
        if (state is ErrorState) {
          MySnackBar.showMySnackBar(state.failure.message, context,
              contentType: ContentType.failure, title: "حدث خطأ");
        }
      });
    } else {
      MySnackBar.showMySnackBar("لا تملك الصلاحيات الكافية", context,
          contentType: ContentType.warning, title: "حدث خطأ");
    }
  }

  static Future<T> myPush<T>(BuildContext context, Widget child) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => child,
      ),
    );
  }

  static Future<T> myPushReplacment<T>(
      BuildContext context, Widget child) async {
    return await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => child,
      ),
    );
  }

  static Future<T> myPushReplacmentAll<T>(
      BuildContext context, Widget child) async {
    return await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => child,
      ),
      (route) => false,
    );
  }
}
