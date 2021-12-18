import 'package:flutter/material.dart';

class CurrentSong with ChangeNotifier{
  CurrentSong();
  dynamic currentlyPlaying ;
  

  void setCurrent(dynamic currentSong){
    currentlyPlaying = currentSong;
    // ignore: avoid_print
    print(currentlyPlaying);
    notifyListeners();
  }
  dynamic get _curreentlyPlaying => currentlyPlaying;
}

class StreamUrl with ChangeNotifier{
  StreamUrl();
  dynamic currentstring;

  void setStream(dynamic currentstream){
    currentstring = currentstream;
    print(currentstream);
    notifyListeners();
  }
  dynamic get _curentstring => currentstring;
}