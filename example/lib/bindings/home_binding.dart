/// Home Binding - Dependency injection for home page
library;

import 'package:flutter_flows/flows.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends FlowBinding {
  @override
  void dependencies() {
    Flow.lazyPut(() => HomeController());
  }
}
