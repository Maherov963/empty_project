import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/domain/repositories/person_repo.dart';
import 'package:flutter/material.dart';

class PersonProvider extends ChangeNotifier with StatesHandler {
  final PersonRepository _repositoryImpl;
  PersonProvider(this._repositoryImpl);
  bool isLoadingSupervisors = false;
  bool isLoadingModerators = false;
  bool isLoadingAssistants = false;
  bool isLoadingTesters = false;
  bool isLoadingIn = false;
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

  Future<ProviderStates> addPerson(Person person) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.addPerson(person);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> deletePerson(int id) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.deletePerson(id);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> editPerson(Person person) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.editPerson(person);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> addPermission(Custom custom) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.addPermission(custom);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> editPermission(Custom custom) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.editPermission(custom);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> addStudent(Student student) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.addStudent(student);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> editStudent(Student student) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.editStudent(student);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> getAllPersons({Person? person}) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.getAllPerson(person);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> getTheAllPersons() async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.getTheAllPeople();
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> getSupervisors() async {
    isLoadingSupervisors = true;
    notifyListeners();
    final state = await _repositoryImpl.getSupervisors();
    isLoadingSupervisors = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> getAssistants() async {
    isLoadingAssistants = true;
    notifyListeners();
    final state = await _repositoryImpl.getAssistants();
    isLoadingAssistants = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> getModerators() async {
    isLoadingModerators = true;
    notifyListeners();
    final state = await _repositoryImpl.getModerators();
    isLoadingModerators = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> getTesters() async {
    isLoadingTesters = true;
    notifyListeners();
    final state = await _repositoryImpl.getTesters();
    isLoadingTesters = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> getStudentsForTesters() async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.getStudentsForTesters();
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> getPerson(int id) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.getPerson(id);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> addImage(String imageLink, int id) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.addImage(imageLink, id);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }
}
