import 'package:audio_player/viewmodels/audio_player_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    final audioPLayerViewModel =
        Provider.of<AudioPlayerViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: height * .15,
          ),
          Container(
            height: height * .85,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(height * .05), // Adjust the value as needed
                topRight:
                    Radius.circular(height * .05), // Adjust the value as needed
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/music-mainscreen.jpg',
                  height: height * .7,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(audioPLayerViewModel.formattedCurrentPosition),
                    SizedBox(
                      width: width * .75,
                      child: Slider(
                        value: audioPLayerViewModel.listenCurrentPosition,
                        onChanged: (double value) {
                          // Seek to the position when the user drags the slider
                          final newPosition = value *
                              audioPLayerViewModel.duration!.inMilliseconds;
                          audioPLayerViewModel.player.seek(
                              Duration(milliseconds: newPosition.toInt()));
                        },
                      ),
                    ),
                    if (audioPLayerViewModel.duration != null)
                      Text(audioPLayerViewModel.formattedDuration),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.skip_previous,
                        size: height * .04,
                      ),
                    ),
                    SizedBox(
                      width: width * .05,
                    ),
                    IconButton(
                      onPressed: () {
                        audioPLayerViewModel.setAudioSource(
                            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3');
                      },
                      icon: Icon(audioPLayerViewModel.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                    ),
                    SizedBox(
                      width: width * .05,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.skip_next,
                        size: height * .04,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
