import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  bool _isPlaying = false;
  Duration _duration;
  Duration _position;
  bool _isEnd = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",

    )..addListener(() {
      final bool isPlaying = _controller.value.isPlaying;
      if (isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
      Timer.run(() {
        this.setState((){
          _position = _controller.value.position;
        });
      });
      setState(() {
        _duration = _controller.value.duration;
      });
      _duration?.compareTo(_position) == 0 || _duration?.compareTo(_position) == -1 ? this.setState((){
        _isEnd = true;
      }) : this.setState((){
        _isEnd = false;
      });
    })..initialize().then((_) {
      setState(() {
        _controller.play();
      });
    });
     // ..initialize();
//    VideoPlayerPlatform.instance() a = _controller;
    //_initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Player"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            //width: 300,
            height: 500,
            alignment: Alignment.center,
//            child: FutureBuilder(
//              future: _initializeVideoPlayerFuture,
//              builder: (context, snapshot) {
//                if (snapshot.connectionState == ConnectionState.done) {
//                  // If the VideoPlayerController has finished initialization, use
//                  // the data it provides to limit the aspect ratio of the VideoPlayer.
//                  return AspectRatio(
//                    aspectRatio: _controller.value.aspectRatio,
//                    // Use the VideoPlayer widget to display the video.
//                    child: VideoPlayer(_controller),
//                  );
//                } else {
//                  // If the VideoPlayerController is still initializing, show a
//                  // loading spinner.
//                  return Center(child: CircularProgressIndicator());
//                }
//              },
//            ),
          ),
          Text(" ${_controller.dataSource}"),
          Text(" ${_isPlaying}"),
          Text("${_duration}"),
          Text("${_position}"),
          Text("${_isEnd}"),
          VideoProgressIndicator(_controller, allowScrubbing: true),

          InkWell(
            child: RaisedButton(
              child: Text("Quase final"),
              onPressed: (){
                setState(() {
                  _controller.seekTo(Duration(minutes: 5));

                });
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

}
