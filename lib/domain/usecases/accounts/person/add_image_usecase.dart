import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';
import '../../../repositories/person_repo.dart';

class AddImageUsecase {
  final PersonRepository repository;

  AddImageUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String imageLink, int id) async {
    return await repository.addImage(imageLink, id);
  }
}
