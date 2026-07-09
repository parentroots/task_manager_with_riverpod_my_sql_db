import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/sign_in/presentation/provider/sign_in_provider.dart';
import '../../data/models/task_model.dart';
import '../../data/repository/task_repository.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());

final tasksProvider = FutureProvider<List<TaskModel>>((ref) async {
  final token = ref.watch(tokenProvider);
  final repository = ref.watch(taskRepositoryProvider);
  return repository.fetchTasks(token);
});
