import 'package:al_khalil/data/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../models/models.dart';

abstract class PersonRepository {
  Future<Either<Failure, int>> addPerson(Person person);
  Future<Either<Failure, Unit>> editPerson(Person person);
  Future<Either<Failure, Unit>> deletePerson(int id);
  Future<Either<Failure, Unit>> addStudent(Student student);
  Future<Either<Failure, Unit>> editStudent(Student student);
  Future<Either<Failure, Unit>> addPermission(Custom custom);
  Future<Either<Failure, Unit>> editPermission(Custom custom);
  Future<Either<Failure, Unit>> addImage(String imageLink, int id);
  Future<Either<Failure, Person>> getPerson(int id);
  Future<Either<Failure, List<Person>>> getAllPerson(Person? person);
  Future<Either<Failure, List<Person>>> getSupervisors();
  Future<Either<Failure, List<Person>>> getTheAllPeople();
  Future<Either<Failure, List<Person>>> getAssistants();
  Future<Either<Failure, List<Person>>> getModerators();
  Future<Either<Failure, List<Person>>> getTesters();
  Future<Either<Failure, List<Person>>> getStudentsForTesters();
}
