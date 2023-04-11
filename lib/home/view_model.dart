import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

final futureProvider = FutureProvider<List<User>>((ref) async {
  await Future<void>.delayed(const Duration(seconds: 5));
  return [
    User(name: 'mohamed'),
    User(name: 'ahamed'),
    User(name: 'hamed'),
    User(name: 'amed'),
    User(name: 'med'),
    User(name: 'ed'),
    User(name: 'd'),
  ];
});

class User {
  final String name;

  User({required this.name});
}

/*
abstract class UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;
  UsersLoaded(this.users);
}

class UsersError extends UsersState {
  final String message;
  UsersError(this.message);
}
*/

class HomeState {
  final bool isSelected;
  final int count;
  // final List<User> users;

  const HomeState({
    required this.isSelected,
    required this.count,
  });

  factory HomeState.initial() => const HomeState(isSelected: false, count: 0);
  HomeState copyWith({
    bool? isSelected,
    int? count,
  }) {
    return HomeState(
      count: count ?? this.count,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

@LazySingleton()
class UsersRepo {
  Future<User> getUser() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    return User(name: 'mo');
  }
}

@Injectable()
class HomeController extends AppStateNotifier<HomeState>
    implements ControllerLifeCycle {
  HomeController(this._repo) : super(HomeState.initial()) {}
  final UsersRepo _repo;

  void toggle() {
    state = state.copyWith(isSelected: !state.isSelected);
  }

  void onChanged(bool value) {
    state = state.copyWith(isSelected: value);
  }

  void increment() {
    state = state.copyWith(count: state.count + 1);
  }

  @override
  void onInit() {
    print('home controller onInit');
  }

  @override
  void onClose() {
    print('home controller onClose');
  }
}

abstract class ControllerLifeCycle {
  void onInit();
  void onClose();
}

abstract class AppStateNotifier<T> extends StateNotifier<T>
    implements ControllerLifeCycle {
  AppStateNotifier(super.state) {
    onInit();
  }
  @override
  void dispose() {
    onClose();
    super.dispose();
  }
}

class HomeOldController extends ChangeNotifier {}
