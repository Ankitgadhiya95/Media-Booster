import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediabooster/videoplayscreen.dart';

import 'musicmodelclass.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(


      body: Container(
        decoration: BoxDecoration(
            color: Color(0XFF060316)
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: CarouselSlider(
                items: video
                    .map(
                      (e) => Center(
                    child: Container(

                      // color: Colors.red,

                      height: 240,
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VideoPlayScreen(
                                image: e.img!,
                                sogname: e.songname!,
                                video: e.song!,
                                cover: e.coverimg!,
                              )));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.transparent,
                                image: DecorationImage(

                                    image: AssetImage(e.img.toString()),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              e.songname.toString(),style: GoogleFonts.dosis(
                                fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                    .toList(),
                options: CarouselOptions(
                  disableCenter: true,
                  enlargeCenterPage: true,
                  autoPlay: true,
                ),
              ),
            ),
            Container(
              height: height - 400,
              child: ListView.builder(
                  itemCount: video.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment(0.8, 1),
                              colors: <Color>[ Color(0xff120D24),
                                Color(0xff310E37),
                              ],
                              tileMode: TileMode.mirror,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              /*mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,*/
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => VideoPlayScreen(
                                            image: video[index].img!,
                                            sogname: video[index].songname!,
                                            video: video[index].song!,
                                            cover: video[index].coverimg!,
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                video[index].img.toString()),
                                            fit: BoxFit.cover),
                                        border: Border.all(color: Colors.black),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  video[index].songname!,
                                  style: GoogleFonts.caveat(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ],
                            ),
                          )),
                    );
                  }),
            )
          ],
        ),
      )
    );
  }
}
