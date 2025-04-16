import 'package:flutter/material.dart';

/// Support Nested Navigation Back Android
class NavigatorSupport extends StatefulWidget {
  const NavigatorSupport({
    super.key,
    this.pages = const <Page<dynamic>>[],
    this.onPopPage,
    this.initialRoute,
    this.onGenerateInitialRoutes = Navigator.defaultGenerateInitialRoutes,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
    this.observers = const <NavigatorObserver>[],
  });

  static const routeName = '/NavigatorSupport';

  final List<Page<dynamic>> pages;
  final PopPageCallback? onPopPage;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver> observers;
  static const String defaultRouteName = '/';
  final RouteListFactory onGenerateInitialRoutes;
  final TransitionDelegate<dynamic> transitionDelegate;

  @override
  NavigatorSupportState createState() => NavigatorSupportState();

  static NavigatorSupportState? of(BuildContext context) {
    // Handles the case where the input context is a navigator element.
    NavigatorSupportState? navigator;
    if (context is StatefulElement && context.state is NavigatorSupportState) {
      navigator = context.state as NavigatorSupportState;
    }
    navigator =
        navigator ?? context.findAncestorStateOfType<NavigatorSupportState>();
    return navigator;
  }
}

class NavigatorSupportState extends State<NavigatorSupport> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  NavigatorState? _parentNavigator;

  NavigatorState get parent => _parentNavigator!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_parentNavigator != Navigator.of(context)) {
      _parentNavigator = Navigator.of(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        // if (navigatorKey.currentState!.canPop()) {
        //   await navigatorKey.currentState!.maybePop();
        //   return false;
        // } else {
        //   return true;
        // }
      },
      child: Navigator(
        pages: widget.pages,
        key: navigatorKey,
        onGenerateRoute: widget.onGenerateRoute,
        initialRoute: widget.initialRoute,
        transitionDelegate: widget.transitionDelegate,
        onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
        onPopPage: widget.onPopPage,
        onUnknownRoute: widget.onUnknownRoute,
      ),
    );
  }
}
