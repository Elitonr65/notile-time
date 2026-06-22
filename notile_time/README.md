# Notile Time

Aplicativo Flutter para controle de jornada, autenticação, empresa, perfil, histórico de ponto e relatórios.

## Produção

- Configure Supabase com `--dart-define=SUPABASE_URL=...` e `--dart-define=SUPABASE_ANON_KEY=...` quando precisar trocar o ambiente sem alterar código.
- Para assinar Android em release, crie `android/key.properties` com `storeFile`, `storePassword`, `keyAlias` e `keyPassword`. O arquivo já é ignorado pelo Git.
- Validações atuais: `flutter analyze`, `flutter test` e `flutter build web --release`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
