import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediabooster/musicplayscreen.dart';

import 'musicmodelclass.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Color(0XFF060316)),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: CarouselSlider(
              items: listData
                  .map(
                    (e) => Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Container(
                          // color: Colors.red,
                          height: 220,
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MusicPlayScreen(
                                        image: e.img!,
                                        sogname: e.songname!,
                                        music: e.song!,
                                        cover: e.coverimg!)));
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: AssetImage(e.img.toString()),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  e.songname.toString(),
                                  style: GoogleFonts.dosis(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
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
            // color: Colors.red,
            child: ListView.builder(
                itemCount: listData.length,
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
                            colors: <Color>[
                              Color(0xff120D24),
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
                                        builder: (context) => MusicPlayScreen(
                                          image: listData[index].img!,
                                          sogname: listData[index].songname!,
                                          cover: listData[index].coverimg!,
                                          music: listData[index].song!,
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
                                              listData[index].img.toString()),
                                          fit: BoxFit.cover),
                                      border: Border.all(color: Colors.black),
                                      shape: BoxShape.circle),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                listData[index].songname!,
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
    ));
  }
}
