import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'musicmodelclass.dart';

class MusicPlayScreen extends StatefulWidget {
  final String image;
  final String sogname;
  final String music;
  final String cover;

  // final List<MusicModel> sogname;
  const MusicPlayScreen(
      {super.key,
      required this.image,
      required this.sogname,
      required this.music,
      required this.cover});

  @override
  State<MusicPlayScreen> createState() => _MusicPlayScreenState();
}

class _MusicPlayScreenState extends State<MusicPlayScreen> {
  // String image = '';
  //late AssetsAudioPlayer player;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   player = AssetsAudioPlayer();
  //   player.open(Audio('Assets/Music/1.mp3'), autoStart: false);
  //   super.initState();
  // }

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  double setVolumeValue = 0;
  late Duration maxDuration;
  late Duration elapsedDuration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPlaylist();
    FlutterVolumeController.getVolume().then((volume) {
      print("volume");
      print(volume);
      setVolumeValue = volume ?? 0.0;
    });

    FlutterVolumeController.addListener((volume) {
      setState(() => setVolumeValue = volume);
    });
  }

  void setupPlaylist() async {
    await audioPlayer.open(Playlist(audios: [Audio(widget.music)]),
        showNotification: true, autoStart: false, loopMode: LoopMode.playlist);
  }

  playMusic() async {
    await audioPlayer.play();
    // maxDuration = audioPlayer.realtimePlayingInfos.value.duration;
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  skipPrevious() async {
    await audioPlayer.previous();
  }

  skipNext() async {
    await audioPlayer.next();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    FlutterVolumeController.removeListener();
    super.dispose();
    audioPlayer.dispose();

    // super.dispose();
  }

  Widget getTimeText(Duration seconds) {
    return Text(
      transformString(seconds.inSeconds),
      style: TextStyle(color: Colors.white),
    );
  }

  String transformString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  Widget circularAudioPlayer(
      RealtimePlayingInfos realtimePlayingInfos, double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
        ),
        CircularPercentIndicator(
          radius: screenWidth / 3.5,
          arcType: ArcType.FULL,
          backgroundColor: Colors.black,
          progressColor: Colors.white,
          percent: realtimePlayingInfos.currentPosition.inSeconds /
              realtimePlayingInfos.duration.inSeconds,

          center: Container(
            width: screenWidth / 2,
            height: screenWidth / 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(
                    widget.image,
                  ),
                  fit: BoxFit.cover),
            ),
          ),

          // center: IconButton(
          //   iconSize: screenWidth / 8,
          //   color: Colors.black,
          //   highlightColor: Colors.yellow,
          //   splashColor: Colors.green,
          //   icon: Icon(realtimePlayingInfos.isPlaying
          //       ? Icons.pause_rounded
          //       : Icons.play_arrow_rounded),
          //   onPressed: () => audioPlayer.playOrPause(),
          // ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Color(0XFF310E37),
            centerTitle: true,

            title: Text(widget.sogname,style: GoogleFonts.dosis(
                fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),),
            actions: [Icon(Icons.menu,color: Colors.white,)]),

        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(colorFilter: ColorFilter.mode(Color(0XFF310E37),BlendMode.multiply),
                image: ExactAssetImage(
                  widget.image,
                ),
                fit: BoxFit.cover),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              child: audioPlayer.builderRealtimePlayingInfos(
                  builder: (context, realtimePlayingInfos) {
                if (realtimePlayingInfos != null) {
                  return Column(
                    children: [
                      circularAudioPlayer(realtimePlayingInfos,
                          MediaQuery.of(context).size.width),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getTimeText(
                            realtimePlayingInfos.currentPosition,
                          ),
                          Text(
                            "  |  ",
                            style: TextStyle(color: Colors.white),
                          ),
                          // linearProgressBar(realtimePlayingInfos.currentPosition,
                          //     realtimePlayingInfos.duration),
                          getTimeText(
                            realtimePlayingInfos.duration,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            iconSize: 40,
                            color: Colors.red,
                            // highlightColor: Colors.yellow,
                            // splashColor: Colors.green,
                            icon:
                                Icon(Icons.keyboard_double_arrow_left_outlined),
                            onPressed: () => audioPlayer.forwardOrRewind(10),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey, shape: BoxShape.circle),
                            child: IconButton(
                              iconSize: 40,
                              // iconSize: screenWidth / 8,
                              color: Colors.white,
                              highlightColor: Colors.black,
                              // splashColor: Colors.green,
                              icon: Icon(realtimePlayingInfos.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded),
                              onPressed: () => audioPlayer.playOrPause(),
                            ),
                          ),
                          IconButton(
                            iconSize: 40,
                            // iconSize: screenWidth / 8,
                            color: Colors.red,
                            // highlightColor: Colors.yellow,
                            // splashColor: Colors.green,
                            icon: Icon(
                                Icons.keyboard_double_arrow_right_outlined),
                            onPressed: () => audioPlayer.next(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),


                      /*   Container(
                  height: MediaQuery.of(context).size.height - 530,
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Column(
                      children: listData
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.white)
                                ),
                                child: ListTile(

                                  leading: Container(
                                    width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(

                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(e.img.toString()),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    e.songname.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    iconSize: 35,
                                    // iconSize: screenWidth / 8,
                                    // color: Colors.white,
                                    highlightColor: Colors.black,
                                    // splashColor: Colors.green,
                                    icon: Icon(realtimePlayingInfos.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,color: Colors.white,),
                                    onPressed: () => audioPlayer.playOrPause(),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),*/
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                         width: double.infinity,
                        // color: Colors.red,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    print("setVolumeValue");
                                    print(setVolumeValue);
                                    if (setVolumeValue > 0) {
                                      setVolumeValue = setVolumeValue - 0.1;
                                      print(setVolumeValue);
                                      FlutterVolumeController.setVolume(
                                          setVolumeValue);
                                      audioPlayer.setVolume(setVolumeValue);
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.volume_down,
                                  color: Colors.white,
                                )),
                            Expanded(
                              child: Slider.adaptive(

                                value: setVolumeValue,
                                min: 0,
                                max: 1,
                                divisions: 10,
                                activeColor: Colors.white,
                                onChanged: (double value) {
                                  setState(() {
                                    setVolumeValue = value;
                                    FlutterVolumeController.setVolume(
                                        setVolumeValue);
                                    audioPlayer.setVolume(0.4);
                                  });
                                },
                                // value:  setVolumeValue,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    print("setVolumeValue");
                                    print(setVolumeValue);
                                    if (setVolumeValue < 1) {
                                      setVolumeValue = setVolumeValue + 0.1;
                                      print(setVolumeValue);
                                      FlutterVolumeController.setVolume(
                                          setVolumeValue);
                                      audioPlayer.setVolume(setVolumeValue);
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.volume_up,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
            ),
          ),
          /*Container(
        child: audioPlayer.builderRealtimePlayingInfos(
            builder: (context, realtimePlayingInfos) {
          if (realtimePlayingInfos != null) {
            return Column(
              children: [
                circularAudioPlayer(
                    realtimePlayingInfos, MediaQuery.of(context).size.width),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getTimeText(
                      realtimePlayingInfos.currentPosition,
                    ),
                    Text("  |  "),
                    // linearProgressBar(realtimePlayingInfos.currentPosition,
                    //     realtimePlayingInfos.duration),
                    getTimeText(
                      realtimePlayingInfos.duration,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      iconSize: 35,
                      color: Colors.deepOrange,
                      // highlightColor: Colors.yellow,
                      // splashColor: Colors.green,
                      icon: Icon(Icons.keyboard_double_arrow_left_outlined),
                      onPressed: () => audioPlayer.previous(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey, shape: BoxShape.circle),
                      child: IconButton(
                        iconSize: 35,
                        // iconSize: screenWidth / 8,
                        color: Colors.white,
                        highlightColor: Colors.black,
                        // splashColor: Colors.green,
                        icon: Icon(realtimePlayingInfos.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded),
                        onPressed: () => audioPlayer.playOrPause(),
                      ),
                    ),
                    IconButton(
                      iconSize: 35,
                      // iconSize: screenWidth / 8,
                      color: Colors.deepOrange,
                      // highlightColor: Colors.yellow,
                      // splashColor: Colors.green,
                      icon: Icon(Icons.keyboard_double_arrow_right_outlined),
                      onPressed: () => audioPlayer.next(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 580,
                  color: Colors.blueAccent,
                  child: SingleChildScrollView(
                    child: Column(
                      children: listData
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ListTile(
                                  leading: Container(
                                    width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(e.img.toString()),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    e.songname.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    iconSize: 35,
                                    // iconSize: screenWidth / 8,
                                    // color: Colors.white,
                                    highlightColor: Colors.black,
                                    // splashColor: Colors.green,
                                    icon: Icon(realtimePlayingInfos.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded),
                                    onPressed: () => audioPlayer.playOrPause(),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),SizedBox(
                  height: 50,
                ),
                Container(
                  // width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              print("setVolumeValue");
                              print(setVolumeValue);
                              if (setVolumeValue >0) {
                                setVolumeValue = setVolumeValue - 0.1;
                                print(setVolumeValue);
                                FlutterVolumeController.setVolume(setVolumeValue);
                                audioPlayer.setVolume(setVolumeValue);
                              }
                            });
                          },
                          icon: Icon(Icons.volume_down)),
                      Slider.adaptive(
                        value: setVolumeValue,
                        min: 0,
                        max: 1,
                        divisions: 10,
                        activeColor: Colors.black,
                        onChanged: (double value) {
                          setState(() {
                            setVolumeValue = value;
                            FlutterVolumeController.setVolume(setVolumeValue);
                            audioPlayer.setVolume(0.4);
                          });
                        },
                        // value:  setVolumeValue,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              print("setVolumeValue");
                              print(setVolumeValue);
                              if (setVolumeValue <1) {
                                setVolumeValue = setVolumeValue + 0.1;
                                print(setVolumeValue);
                                FlutterVolumeController.setVolume(setVolumeValue);
                                audioPlayer.setVolume(setVolumeValue);
                              }
                            });
                          },
                          icon: Icon(Icons.volume_up)),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        }),
      ),*/
        ));
  }
}
