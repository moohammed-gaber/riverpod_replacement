import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_replacement/home/view_model.dart';

final _homeProvider =
StateNotifierProvider.autoDispose<HomeController, HomeState>((ref) {
  return HomeController(UsersRepo());
});

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
        },
      ),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageTestState();
}

class _HomePageTestState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final result = ref.watch(futureProvider);
    final state = ref.watch(_homeProvider.select((value) => value.count));
    final controller = ref.read(_homeProvider.notifier);

    print('rebuild');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text(state.toString()),
        onPressed: controller.increment,
      ),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Expanded(
            child: result.when(
                data: (users) => ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (_, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user.name),
                      );
                    }),
                error: (_, __) => Text('eroor'),
                loading: () => Center(child: CircularProgressIndicator())),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final controller = ref.read(_homeProvider.notifier);
              final state = ref.watch(_homeProvider);
              // ref.watch(homeProvider.select((value) => value.isSelected));
              print('rebuild Consumer');
              return Column(
                children: [
                  SwitchListTile(
                      value: state.isSelected, onChanged: controller.onChanged),
                ],
              );
            },
          ),

          Spacer(),
        ],
      ),
    );
    return const Placeholder();
  }
}
