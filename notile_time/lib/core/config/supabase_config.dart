class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://prkvgpmhsvebfjsfbpys.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_f7ll4POE5tk-ohYMhwwpmg_U4VUHISp',
  );
}
