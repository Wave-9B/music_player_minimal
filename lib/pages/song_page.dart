import 'package:flutter/material.dart';
import 'package:music_player_minimal/components/neumorph_box.dart';
import 'package:music_player_minimal/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  // convert duration into min:sec
  String formatTime(Duration duration) {
    String twoDigitsSeconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitsSeconds";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        // get playlist var
        final playlist = value.playlist;

        // get current song
        final currentSong = playlist[value.currentSongIndex ?? 0];

        // return scaffold UI
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // custom app bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // back button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back),
                      ),

                      // title
                      Text("P L A Y L I S T"),

                      // menu button
                      IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
                    ],
                  ),
                  SizedBox(height: 25),

                  // album atwork
                  NeumorphBox(
                    child: Column(
                      //song cover art
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(16),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),
                        // song name and artist name
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(currentSong.artistName),
                                ],
                              ),

                              // heart icon (fav song type shit)
                              Icon(Icons.favorite, color: Colors.red),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // song duration progress
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // start time
                            Text(formatTime(value.currentDuration)),

                            // shuffle icon
                            Icon(Icons.shuffle),

                            // repeat icon
                            Icon(Icons.repeat),

                            // end time
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),
                      ),
                      // slider: the progress music bar
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                        ),
                        child: Slider(
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble() > 0
                              ? value.totalDuration.inSeconds.toDouble()
                              : 1.0,
                          value: value.currentDuration.inSeconds.toDouble(),
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey.shade400,
                          onChanged: (double double_) {
                            // during when user is sliding the slider
                          },
                          onChangeEnd: (double double_) {
                            // user has finished sliding,  go to the position user slided
                            value.seek(Duration(seconds: double_.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  //playback controls
                  Row(
                    children: [
                      // skip previous
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPreviousSong,
                          child: NeumorphBox(child: Icon(Icons.skip_previous)),
                        ),
                      ),

                      SizedBox(width: 20),

                      // play pause
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NeumorphBox(
                            child: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),

                      // skip forward
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNextSong,
                          child: NeumorphBox(child: Icon(Icons.skip_next)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
