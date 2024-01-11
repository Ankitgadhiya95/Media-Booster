import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediabooster/mediaboosterprovider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class MusicPlayScreen extends StatefulWidget {
  final String image;
  final String sogname;
  final String music;
  final String cover;

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
  @override
  void initState() {
    var provider = Provider.of<MediaBoosterProvider>(context, listen: false);
    // TODO: implement initState
    super.initState();
    provider.setupPlaylist(widget.music);
    FlutterVolumeController.getVolume().then((v) {
      provider.setVolumeValue = v ?? 0.0;
    });

    FlutterVolumeController.addListener((volume) {
      setState(() {
        provider.setVolumeValue = volume;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    FlutterVolumeController.removeListener();
    super.dispose();
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MediaBoosterProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Color(0XFF310E37),
          centerTitle: true,
          title: Text(
            widget.sogname,
            style: GoogleFonts.dosis(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            Icon(
              Icons.menu,
              color: Colors.white,
            )
          ]),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter:
                  ColorFilter.mode(Color(0XFF310E37), BlendMode.multiply),
              image: ExactAssetImage(
                widget.image,
              ),
              fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            child: provider.audioPlayer.builderRealtimePlayingInfos(
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
                          icon: Icon(Icons.keyboard_double_arrow_left_outlined),
                          onPressed: () =>
                              provider.audioPlayer.forwardOrRewind(10),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey, shape: BoxShape.circle),
                          child: IconButton(
                            iconSize: 40,
                            color: Colors.white,
                            highlightColor: Colors.black,
                            icon: Icon(realtimePlayingInfos.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded),
                            onPressed: () => provider.audioPlayer.playOrPause(),
                          ),
                        ),
                        IconButton(
                          iconSize: 40,
                          color: Colors.red,
                          icon:
                              Icon(Icons.keyboard_double_arrow_right_outlined),
                          onPressed: () => provider.audioPlayer.next(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                print("setVolumeValue");
                                // print(setVolumeValue);
                                if (provider.getVolume > 0) {
                                  provider.setVolume = provider.getVolume - 0.1;
                                  // print(setVolumeValue);
                                  FlutterVolumeController.setVolume(
                                      provider.setVolumeValue);
                                  provider.audioPlayer
                                      .setVolume(provider.setVolumeValue);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.volume_down,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Slider.adaptive(
                              value: provider.getVolume,
                              min: 0,
                              max: 1,
                              divisions: 10,
                              activeColor: Colors.white,
                              onChanged: (double value) {
                                setState(() {
                                  provider.setVolume = value;
                                  FlutterVolumeController.setVolume(
                                      provider.setVolumeValue);
                                  provider.audioPlayer.setVolume(0.4);
                                });
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                print("setVolumeValue");
                                // print(setVolumeValue);
                                if (provider.setVolumeValue < 1) {
                                  provider.setVolumeValue =
                                      provider.setVolumeValue + 0.1;
                                  // print(setVolumeValue);
                                  FlutterVolumeController.setVolume(
                                      provider.setVolumeValue);
                                  provider.audioPlayer
                                      .setVolume(provider.setVolumeValue);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.volume_up,
                              color: Colors.white,
                            ),
                          ),
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
      ),
    );
  }
}
