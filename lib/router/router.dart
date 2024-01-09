import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:termostato/provider/settings_provider.dart';
import 'package:termostato/router/routing_path.dart';
import 'package:termostato/view/initial_config.dart';
import 'package:termostato/view/tabs.dart';
import 'package:termostato/view/config.dart';

class AppRouter extends GoRouter {
  AppRouter()
      : super(
          redirect: (context, state) {
            final settings = context.read<SettingsProvider>();
            if (settings.devices.isEmpty) {
              return RoutingPath.initialConfig;
            }
            return null;
          },
          routes: [
            GoRoute(
              path: RoutingPath.home,
              builder: (context, state) => const TabView(
                title: "Termostato",
              ),
            ),
            GoRoute(
              path: RoutingPath.initialConfig,
              builder: (context, state) => const ConfigPage(),
            ),
            GoRoute(
              path: RoutingPath.config,
              builder: (context, state) => const UserPage(),
            ),
          ],
          initialLocation: RoutingPath.home,
        );
}
