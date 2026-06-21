import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

import 'core/config/supabase_config.dart';

// ==========================
// AUTH
// ==========================

import 'features/auth/data/datasources/auth_datasource_impl.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';

import 'features/auth/domain/usecases/sign_up_usecase.dart';

import 'features/auth/domain/usecases/sign_in_usecase.dart';

import 'features/auth/domain/usecases/sign_out_usecase.dart';

import 'features/auth/domain/usecases/forgot_password_usecase.dart';

import 'features/auth/domain/usecases/get_current_user_usecase.dart';

import 'features/auth/presentation/providers/auth_provider.dart';

// ==========================
// PROFILE
// ==========================

import 'features/profile/data/datasources/profile_datasource_impl.dart';

import 'features/profile/data/repositories/profile_repository_impl.dart';

import 'features/profile/domain/usecases/get_profile_usecase.dart';

import 'features/profile/domain/usecases/update_profile_usecase.dart';

import 'features/profile/presentation/providers/profile_provider.dart';

// ==========================
// COMPANY
// ==========================

import 'features/company/data/datasources/company_datasource_impl.dart';

import 'features/company/data/repositories/company_repository_impl.dart';

import 'features/company/domain/usecases/get_company_usecase.dart';

import 'features/company/domain/usecases/create_company_usecase.dart';

import 'features/company/domain/usecases/update_company_usecase.dart';

import 'features/company/domain/usecases/check_company_usecase.dart';

import 'features/company/presentation/providers/company_provider.dart';

// ==========================
// JORNADA
// ==========================

import 'features/jornada/data/datasources/jornada_datasource.dart';

import 'features/jornada/data/repositories/jornada_repository_impl.dart';

import 'features/jornada/domain/usecases/registrar_entrada.dart';

import 'features/jornada/domain/usecases/registrar_inicio_intervalo.dart';

import 'features/jornada/domain/usecases/registrar_fim_intervalo.dart';

import 'features/jornada/domain/usecases/registrar_saida.dart';

import 'features/jornada/domain/usecases/get_jornadas.dart';

import 'features/jornada/presentation/providers/jornada_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,

    publishableKey: SupabaseConfig.anonKey,
  );

  final client = Supabase.instance.client;

  // ==========================
  // AUTH DEPENDENCIES
  // ==========================

  final authDatasource = AuthDatasourceImpl(client);

  final authRepository = AuthRepositoryImpl(authDatasource);

  final signUpUseCase = SignUpUseCase(authRepository);

  final signInUseCase = SignInUseCase(authRepository);

  final signOutUseCase = SignOutUseCase(authRepository);

  final forgotPasswordUseCase = ForgotPasswordUseCase(authRepository);

  final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);

  // ==========================
  // PROFILE DEPENDENCIES
  // ==========================

  final profileDatasource = ProfileDatasourceImpl(client);

  final profileRepository = ProfileRepositoryImpl(profileDatasource);

  final getProfileUseCase = GetProfileUseCase(profileRepository);

  final updateProfileUseCase = UpdateProfileUseCase(profileRepository);

  // ==========================
  // COMPANY DEPENDENCIES
  // ==========================

  final companyDatasource = CompanyDatasourceImpl(client);

  final companyRepository = CompanyRepositoryImpl(companyDatasource);

  final getCompanyUseCase = GetCompanyUseCase(companyRepository);

  final createCompanyUseCase = CreateCompanyUseCase(companyRepository);

  final updateCompanyUseCase = UpdateCompanyUseCase(companyRepository);

  final checkCompanyUseCase = CheckCompanyUseCase(companyRepository);

  // ==========================
  // JORNADA DEPENDENCIES
  // ==========================

  final jornadaDatasource = JornadaDatasource(client: client);

  final jornadaRepository = JornadaRepositoryImpl(
    datasource: jornadaDatasource,
  );

  final registrarEntrada = RegistrarEntrada(repository: jornadaRepository);

  final registrarInicioIntervalo = RegistrarInicioIntervalo(
    repository: jornadaRepository,
  );

  final registrarFimIntervalo = RegistrarFimIntervalo(
    repository: jornadaRepository,
  );

  final registrarSaida = RegistrarSaida(repository: jornadaRepository);

  final getJornadas = GetJornadas(repository: jornadaRepository);

  // ==========================
  // APP START
  // ==========================

  runApp(
    MultiProvider(
      providers: [
        // AUTH
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            signUpUseCase: signUpUseCase,

            signInUseCase: signInUseCase,

            signOutUseCase: signOutUseCase,

            forgotPasswordUseCase: forgotPasswordUseCase,

            getCurrentUserUseCase: getCurrentUserUseCase,
          ),
        ),

        // PROFILE
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            getProfileUseCase: getProfileUseCase,

            updateProfileUseCase: updateProfileUseCase,
          ),
        ),

        // COMPANY
        ChangeNotifierProvider(
          create: (_) => CompanyProvider(
            getCompanyUseCase: getCompanyUseCase,

            createCompanyUseCase: createCompanyUseCase,

            updateCompanyUseCase: updateCompanyUseCase,

            checkCompanyUseCase: checkCompanyUseCase,
          ),
        ),

        // JORNADA
        ChangeNotifierProvider(
          create: (_) => JornadaProvider(
            registrarEntradaUseCase: registrarEntrada,

            registrarInicioIntervaloUseCase: registrarInicioIntervalo,

            registrarFimIntervaloUseCase: registrarFimIntervalo,

            registrarSaidaUseCase: registrarSaida,

            getJornadasUseCase: getJornadas,
          ),
        ),
      ],

      child: const App(),
    ),
  );
}
