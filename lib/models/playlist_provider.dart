import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player_minimal/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // song playlist
  final List<Song> _playlist = [
    // song 1
    Song(
      songName: "Nujilla",
      artistName: "Wave-9B",
      albumArtImagePath: "assets/images/nujabes_dilla.png",
      audioPath: "assets/audio/nuj_ill_wave9b.mp3",
    ),
    // song 2
    Song(
      songName: "Paradise",
      artistName: "Wave-9B",
      albumArtImagePath: "assets/images/paradise_cover.png",
      audioPath: "assets/audio/paradise.mp3",
    ),
    // song 3
    Song(
      songName: "Shoes n Cars",
      artistName: "Wave-9B",
      albumArtImagePath: "assets/images/shoes_n_cars_cover.png",
      audioPath: "assets/audio/shoes_n_cars.mp3",
    ),
  ];

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // audio duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // audio constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // play audio
  void play() async {
    // the ! == "hey dart, trust me man, this var is not null my boy"
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop current song
    await _audioPlayer.play(AssetSource(path)); // play new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause audio
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume audio
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume
   void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }

  }

  // seek to a specific position int he current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next audio
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // go tho next song if not the last song, playlist.lenght - 1 == penúltimo
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        // if last song, go back to first song
        currentSongIndex = 0;
      }
    }
  }

  // play previous audio
  void playPreviousSong() async {
    // if more than 2 seconds passed, restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    // but if 2 songs didn't pass, play previous song
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // if first song playing, go 'back' to last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // listen to duration
  void listenToDuration() {
    // listen total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // dispose audio player

  // current playing song index
  int? _currentSongIndex;

  // GETTERS
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  // SETTERS
  set currentSongIndex(int? newIndex) {
    // updates/changes the song
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }

    // updates UI
    notifyListeners();
  }
}
