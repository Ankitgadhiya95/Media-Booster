import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayScreen extends StatefulWidget {
  final String image;
  final String sogname;
  final String video;
  final String cover;

  VideoPlayScreen(
      {super.key,
      required this.image,
      required this.sogname,
      required this.video,
      required this.cover});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  VideoPlayerController? _controller;
  ChewieController? chewieController;

  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  initializePlayer() async {
    _controller = VideoPlayerController.asset(widget.video);
    await Future.wait([_controller!.initialize()]);

    chewieController = ChewieController(

      videoPlayerController: _controller!,
      autoPlay: true,
      looping: true,
     // aspectRatio: double.infinity,
      fullScreenByDefault: true,
      allowFullScreen : true,
draggableProgressBar: true
    );

    final playerWidget = Chewie(
      controller: chewieController!,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            Text(widget.sogname),

            SizedBox(height: 20,),

            // chewieController==null?CircularProgressIndicator()
            //     : Chewie(controller: chewieController!),
            Container(
              height: 550,
              width: double.infinity,
              // color: Colors.red,
              padding: const EdgeInsets.all(20),
              child: (chewieController == null)
                  ? Center(child: CircularProgressIndicator())
                  : Chewie(controller: chewieController!),
            ),

          ],
        ),
      ),
    );
  }
}
