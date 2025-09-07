import 'package:either_dart/either.dart';

import '../../feature/news/domain/failure/failures.dart';

abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

class NoParams {}
