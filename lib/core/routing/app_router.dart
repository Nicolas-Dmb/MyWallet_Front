import 'package:go_router/go_router.dart';
import '../../welcome/presentation/welcome_widget.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => Welcome(),
      ),
    ],
  );
}
