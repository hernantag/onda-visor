import 'package:draw_testing/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: AppRouter()));
}

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final GoRouter router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
