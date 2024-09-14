import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // playlist of songs
  final List<Song> _playlist = [
    // song 1
    Song(
      songName: '夜に駆ける',
      artistName: 'YOASOBI',
      albumArtImagePath: 'assets/images/yoru_ni_kakeru.webp',
      audioPath: 'audio/夜に駆ける.mp3',
    ),

    // song 2
    Song(
      songName: 'あの夢をなぞって',
      artistName: 'YOASOBI',
      albumArtImagePath: 'assets/images/ano_yume_o_nazotte.webp',
      audioPath: 'audio/あの夢をなぞって.mp3',
    ),

    // song 3
    Song(
      songName: 'アイドル',
      artistName: 'YOASOBI',
      albumArtImagePath: 'assets/images/idol.webp',
      audioPath: 'audio/アイドル.mp3',
    ),
  ];

  // current playing song index
  int _currentSongIndex = 0;

  /*

  AUDIO PLAYER

  */

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[currentSongIndex].audioPath;
    await _audioPlayer.stop(); // stop any song if currently playing
    await _audioPlayer.play(AssetSource(path)); // play new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause curr song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  // seek to a spesific position in curr song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() {
    currentSongIndex = (_currentSongIndex + 1) % _playlist.length;
  }

  // play prev song
  void playPreviousSong() async {
    // if not in the beginning of curr song, go back to beginning
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      currentSongIndex = (_currentSongIndex - 1) % _playlist.length;
    }
  }

  // listen to duration
  void listenToDuration() {
    // listen to total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen to curr duration
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

  /*

  GETTERS

  */

  List<Song> get playList => _playlist;
  int get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*

  SETTERS

  */

  set currentSongIndex(int newIndex) {
    // update index
    _currentSongIndex = newIndex;

    // play song
    play();

    // update UI
    notifyListeners();
  }
}
