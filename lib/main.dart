import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quizz_app/commons/navigator_support.dart';

import 'commons/text_to_speech.dart';
import 'cubits/user/user_cubit.dart';
import 'feature/home/home_page.dart';
import 'feature/quizz/quiz_screen.dart';
import 'purchase/purchase_book_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TextToSpeech().initTTS();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MainPage(),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<bool> _loadingUserFuture;

  @override
  void initState() {
    super.initState();
    PurchaseBookServices().initApp(isBuyNonConsumable: false);
    PurchaseBookServices().getStoreInfo();
    _loadingUserFuture = _loadUser();
  }

  Future<bool> _loadUser() async {
    context.read<UserCubit>().loadUser();
    await Future.delayed(const Duration(milliseconds: 2000));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loadingUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 1.sh,
            width: 1.sw,
            decoration: const BoxDecoration(
              color: Color(0xff793ae7),
            //     image: DecorationImage(
                //   image: const AssetImage('assets/bg_image.png'),
                //   fit: BoxFit.fill,
                //   colorFilter: ColorFilter.mode(
                //       Colors.black.withOpacity(0.5), BlendMode.dstATop),
                // ),
                ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('App',
                      style: TextStyle(color: Colors.white, fontSize: 30.sp)),
                  SizedBox(
                    height: 20.h,
                  ),
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        }
        return NavigatorSupport(
          initialRoute: HomePage.routeName,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case HomePage.routeName:
                return MaterialPageRoute(
                  builder: (context) => const HomePage(),
                );

              case QuizScreen.routeName:
                return MaterialPageRoute(
                  builder: (context) => const QuizScreen(),
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => const HomePage(),
                );
            }
          },
        );
      },
    );
  }
}
