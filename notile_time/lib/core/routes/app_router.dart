import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';

import '../../features/auth/presentation/pages/splash_page.dart';

import '../../features/company/presentation/pages/company_page.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';

import '../../features/profile/presentation/pages/profile_page.dart';

import '../../features/jornada/presentation/pages/jornada_page.dart';

import '../../features/jornada/presentation/pages/historico_jornada_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',

    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),

      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

      GoRoute(
        path: '/register',

        builder: (context, state) => const RegisterPage(),
      ),

      GoRoute(
        path: '/forgot-password',

        builder: (context, state) => const ForgotPasswordPage(),
      ),

      GoRoute(
        path: '/dashboard',

        builder: (context, state) => const DashboardPage(),
      ),

      GoRoute(
        path: '/profile',

        builder: (context, state) => const ProfilePage(),
      ),

      GoRoute(
        path: '/company',

        builder: (context, state) => const CompanyPage(),
      ),

      GoRoute(
        path: '/jornada',

        builder: (context, state) => const JornadaPage(),
      ),

      GoRoute(
        path: '/jornada/historico',

        builder: (context, state) => const HistoricoJornadaPage(),
      ),
    ],
  );
}
