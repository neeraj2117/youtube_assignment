import 'package:supabase/supabase.dart';

class SupabaseCred {
  static const String APIKEY =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2a2V2aWNocmZvZ2ZkYXd2aWh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkyMTI3MzMsImV4cCI6MjAzNDc4ODczM30.3mkxQPnbc-FWZL6jyLdsdDvykglMP04yFUCM0VKXcHI';
  static const String APIURL = 'https://xvkevichrfogfdawvihz.supabase.co';

  static SupabaseClient supabaseClient = SupabaseClient(APIURL, APIKEY);
}
