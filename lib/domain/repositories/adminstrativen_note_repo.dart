import 'package:al_khalil/domain/models/management/adminstrative_note.dart';
import 'package:dartz/dartz.dart';
import '../../data/errors/failures.dart';

abstract class AdminstrativeNoteRepository {
  Future<Either<Failure, int>> addAdminstrativeNote(
      AdminstrativeNote adminstrativeNote);
  Future<Either<Failure, Unit>> editAdminstrativeNote(
      AdminstrativeNote adminstrativeNote);
  Future<Either<Failure, Unit>> deleteAdminstrativeNote(int id);
  Future<Either<Failure, List<AdminstrativeNote>>> viewAdminstrativeNote(
      AdminstrativeNote adminstrativeNote);
}
