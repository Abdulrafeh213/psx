import 'database_service.dart';
import 'firebase_services.dart';
import 'supabase_services.dart';

class Services {
  static DatabaseService db = FirebaseService();

  static Future<void> init({bool useFirebase = true}) async {
    db = useFirebase ? FirebaseService() : SupabaseService();
    await db.init();
  }
}
