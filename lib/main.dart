import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swirl_news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:swirl_news_app/features/news/presentation/pages/news_page.dart';
import 'package:swirl_news_app/injection.dart';
import 'package:swirl_news_app/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init('e8895bd205eb41cf80aee0d2118ca7ad'); //api key
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(
          create: (_) => di.sl<NewsBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'swirl News',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const NewsPage(),
      ),
    );
  }
}

