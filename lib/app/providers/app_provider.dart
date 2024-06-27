import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:youtube/core/notifier/auth_notifier.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AuthNotifier())
  ];
}
