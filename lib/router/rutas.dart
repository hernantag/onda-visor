import 'package:draw_testing/home_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'rutas.g.dart';

@TypedGoRoute<HomeRoute>(path: "/")
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}
