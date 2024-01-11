import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';

import 'musicmodelclass.dart';

class MediaBoosterProvider with ChangeNotifier {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  double setVolumeValue = 0;
  late Duration maxDuration;
  late Duration elapsedDuration;

  List<MusicModel> get getSongData => listData;

  set setVolume(volume) {
    setVolumeValue = volume;

    notifyListeners();
  }

  playMusic() async {
    await audioPlayer.play();
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

  get getVolume => setVolumeValue;

  List<MusicModel> listData = [
    MusicModel(
        img: 'Assets/Img/papamerijaan.png',
        songname: 'Papa Meri Jaan',
        song: 'Assets/Music/PapaMeriJaan.mp3',
        coverimg: ''),
    MusicModel(
        img: 'Assets/Img/abrars.png',
        songname: 'Abrar’s Entry',
        song: 'Assets/Music/Abrars.mp3',
        coverimg: ''),
    MusicModel(
        img: 'Assets/Img/Arjan.png',
        songname: 'Arjan Vailly ',
        song: 'Assets/Music/Arjan.mp3',
        coverimg: ''),
    MusicModel(
        img: 'Assets/Img/TereHawaale.png',
        songname: 'Tere Hawale',
        song: 'Assets/Music/TereHawaale.mp3',
        coverimg: 'Assets/Img/abrars.png'),
    MusicModel(
        img: 'Assets/Img/meinnikla.png',
        songname: 'Main Nikla Gaddi Leke',
        song: 'Assets/Music/MainNikla.mp3',
        coverimg: ''),
    MusicModel(
        img: 'Assets/Img/TanejoimeJyarThi.png',
        songname: 'Tane Joy ME Jyarthi',
        song: 'Assets/Music/TaneJoimeJyarthi.mp3',
        coverimg: ''),
    MusicModel(
        img: 'Assets/Img/luttputt.png',
        songname: 'Lutt Putt Gaya',
        song: 'Assets/Music/LuttPutt.mp3',
        coverimg: ''),
    MusicModel(
        img: 'Assets/Img/KaliKaliZulfon.png',
        songname: 'Kali Kali Zulfon Ke',
        song: 'Assets/Music/KaliKaliZulfonke.mp3',
        coverimg: ''),
    MusicModel(
        img: 'Assets/Img/HuaMain.png',
        songname: 'Hua Main',
        song: 'Assets/Music/Huamain.mp3',
        coverimg: ''),
    MusicModel(
        img: 'Assets/Img/banda.png',
        songname: 'Banda',
        song: 'Assets/Music/Banda.mp3',
        coverimg: ''),
  ];

  void setupPlaylist(String music) async {
    await audioPlayer.open(Playlist(audios: [Audio(music)]),
        showNotification: true, autoStart: false, loopMode: LoopMode.playlist);
  }
}
