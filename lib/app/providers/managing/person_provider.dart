import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/domain/usecases/accounts/person/get_testers_usecase.dart';
import 'package:flutter/material.dart';
import '../../../domain/usecases/accounts/person/person_usecases.dart';

class PersonProvider extends ChangeNotifier with StatesHandler {
  final AddPersonUsecase _addPersonUsecase;
  final EditPersonUsecase _editPersonUsecase;
  final DeletePersonUsecase _deletePersonUsecase;
  final AddPermissionUsecase _addPermissionUsecase;
  final EditPermissionUsecase _editPermissionUsecase;
  final AddStudentUsecase _addStudentUsecase;
  final EditStudentUsecase _editStudentUsecase;
  final AddImageUsecase _addImageUsecase;
  final GetAllPersonUsecase _getAllPersonUsecase;
  final GetPersonUsecase _getPersonUsecase;
  final GetSupervisorsUsecase _getSupervisorsUsecase;
  final GetAssistantsUsecase _getAssistantsUsecase;
  final GetModeratorsUsecase _getModeratorsUsecase;
  final GetTheAllPersonUsecase _getTheAllPersonUsecase;
  final GetTestersUsecase _getTestersUsecase;
  final GetStudentsForTestersUsecase _getStudentsForTestersUsecase;

  bool isLoadingSupervisors = false;
  bool isLoadingModerators = false;
  bool isLoadingAssistants = false;
  bool isLoadingTesters = false;
  bool isLoadingIn = false;
  int? isLoadingPerson;
  List<Person> students = [];
  List<Person> supervisors = [];
  List<Person> moderators = [];
  List<Person> assistants = [];
  List<Person> customs = [];
  List<Person> people = [];
  bool withMother = false;
  bool withKin = false;
  bool withFather = false;
  bool withPersonal = false;
  final List<String> numbers = const [
    "0رقم الأب",
    "0رقم الأم",
    "0الرقم الشخصي",
    "0رقم القريب",
  ];

  PersonProvider(
    this._addPersonUsecase,
    this._editPersonUsecase,
    this._deletePersonUsecase,
    this._addPermissionUsecase,
    this._editPermissionUsecase,
    this._addStudentUsecase,
    this._editStudentUsecase,
    this._addImageUsecase,
    this._getAllPersonUsecase,
    this._getPersonUsecase,
    this._getSupervisorsUsecase,
    this._getAssistantsUsecase,
    this._getModeratorsUsecase,
    this._getTheAllPersonUsecase,
    this._getTestersUsecase,
    this._getStudentsForTestersUsecase,
  );

  Future<ProviderStates> addPerson(Person person) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrId = await _addPersonUsecase(person);
    isLoadingIn = false;
    notifyListeners();
    return eitherIdOrErrorState(failureOrId);
  }

  Future<ProviderStates> deletePerson(int id) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrId = await _deletePersonUsecase(id);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrId);
  }

  Future<ProviderStates> editPerson(Person person) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrMessage = await _editPersonUsecase(person);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrMessage);
  }

  Future<ProviderStates> addPermission(Custom custom) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _addPermissionUsecase(custom);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrDone);
  }

  Future<ProviderStates> editPermission(Custom custom) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrMessage = await _editPermissionUsecase(custom);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrMessage);
  }

  Future<ProviderStates> addStudent(Student student) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _addStudentUsecase(student);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrDone);
  }

  Future<ProviderStates> editStudent(Student student) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrMessage = await _editStudentUsecase(student);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrMessage);
  }

  Future<ProviderStates> getAllPersons({Person? person}) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrPersons = await _getAllPersonUsecase(person);
    isLoadingIn = false;
    notifyListeners();
    return eitherPersonsOrErrorState(failureOrPersons);
  }

  Future<ProviderStates> getTheAllPersons() async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrPersons = await _getTheAllPersonUsecase();
    isLoadingIn = false;
    notifyListeners();
    return eitherPersonsOrErrorState(failureOrPersons);
  }

  Future<ProviderStates> getSupervisors() async {
    isLoadingSupervisors = true;
    notifyListeners();
    final failureOrPersons = await _getSupervisorsUsecase();
    isLoadingSupervisors = false;
    notifyListeners();
    return eitherPersonsOrErrorState(failureOrPersons);
  }

  Future<ProviderStates> getAssistants() async {
    isLoadingAssistants = true;
    notifyListeners();
    final failureOrPersons = await _getAssistantsUsecase();
    isLoadingAssistants = false;
    notifyListeners();
    return eitherPersonsOrErrorState(failureOrPersons);
  }

  Future<ProviderStates> getModerators() async {
    isLoadingModerators = true;
    notifyListeners();
    final failureOrPersons = await _getModeratorsUsecase();
    isLoadingModerators = false;
    notifyListeners();
    return eitherPersonsOrErrorState(failureOrPersons);
  }

  Future<ProviderStates> getTesters() async {
    isLoadingTesters = true;
    notifyListeners();
    final failureOrPersons = await _getTestersUsecase();
    isLoadingTesters = false;
    notifyListeners();
    return eitherPersonsOrErrorState(failureOrPersons);
  }

  Future<ProviderStates> getStudentsForTesters() async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrPersons = await _getStudentsForTestersUsecase();
    isLoadingIn = false;
    notifyListeners();
    return eitherPersonsOrErrorState(failureOrPersons);
  }

  Future<ProviderStates> getPerson(int id) async {
    if (isLoadingPerson == null) {
      isLoadingPerson = id;
      notifyListeners();
      final failureOrPerson = await _getPersonUsecase(id);
      isLoadingPerson = null;
      notifyListeners();
      return eitherPersonOrErrorState(failureOrPerson);
    } else {
      return LoadingState();
    }
  }

  Future<ProviderStates> addImage(String imageLink, int id) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrMessage = await _addImageUsecase(imageLink, id);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrMessage);
  }
}
