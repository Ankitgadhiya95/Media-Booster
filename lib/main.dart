import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediabooster/mediaboosterprovider.dart';
import 'package:mediabooster/videoscreen.dart';
import 'package:provider/provider.dart';

import 'musicscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MediaBoosterProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor:  Color(0XFF060316)),
          useMaterial3: true,
        ),
        home: MyHomePage(title: '',),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget  build(BuildContext context) {
    final provider = Provider.of<MediaBoosterProvider>(context, listen: true);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0XFF060316),
          centerTitle: true,
          title: Text('Media Booster', style: GoogleFonts.caveat(
              fontSize: 30, color: Colors.white),),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.music_video_outlined,color: Colors.white,size: 30,),
              ),
              Tab(
                icon: Icon(Icons.ondemand_video,color: Colors.white,size: 30),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
                child: MusicScreen()
            ),
            Center(
              child: VideoScreen()
            ),
          ],
        ),


      ),
    );
  }
}
