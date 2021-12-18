// ignore_for_file: prefer_const_constructors





import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytfy_desktop/pages/favouritesPage.dart';
import 'package:ytfy_desktop/pages/home.dart';
import 'package:ytfy_desktop/pages/searchpage.dart';
import 'package:ytfy_desktop/providers/currentsong.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({ Key? key }) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  var selectedindex = 0;
  var currentPage;
  double _currentSliderValue = 0;
  var currentPlaying;

  var player = AudioPlayer();
  bool isplaying = false;
  var sonhfindex =0;
  var songIndex = 0;
  var after = [];
  

  
  

  double songduration = 0.0;
  double position = 0.0;
  bool isplay = false;
  bool playready = true;

  setPlaying(song){
    print(song);
  }

  void changePage(){
    if(selectedindex==0){
      currentPage=HomePage(changePlaying: setPlaying,);
    }else if(selectedindex==1){
      currentPage=SearchPage();
    }else if(selectedindex==2){
      currentPage=FavouritePage();
    }
  }



  // ignore: non_constant_identifier_names
  void play_song(String realurl) async {
    setState(() {
      sonhfindex=0;
    });
    print(player.playing);
    if(player.playing){
      player.dispose();
      setState(() {
        player = new AudioPlayer();
      });
      var dd = await player.setUrl(realurl);
      var duration = await player.load();
      await player.play();
    }else{
      player.dispose();
      setState(() {
        player = new AudioPlayer();
      });
      var dd = await player.setUrl(realurl);
      var duration = await player.load();
      await player.play();
    }
    
    

    print(player.duration!.inSeconds.toDouble());
    setState(() {
      songduration = player.duration!.inSeconds.toDouble();
    });

    

  }

  



  Future<void> getUrl() async {
    var yt = YoutubeExplode();
    
    var manifest = await yt.videos.streamsClient.getManifest(currentPlaying['id']);
    // var manifest1 = yt.videos.streamsClient.getHttpLiveStreamUrl(currentPlaying.id);

    // setState(() {
    //   realurl = manifest.audioOnly.first.url.toString();
    // });
    // print(manifest1);
    var readUrl = await manifest.audioOnly.first.url;
    print(readUrl);
    yt.close();
    play_song(readUrl.toString());

    
  }

  void getAfter(String channel)async{
    var yt = YoutubeExplode();
    var aff = await yt.search.getVideos(channel);
    setState(() {
      after=aff.toList();
    });
  }

  void playAfter()async{
    if(after[songIndex]!=null){
      setState(() {
        currentPlaying['img']=after[songIndex].thumbnails.mediumResUrl.toString();
        currentPlaying['id']=after[songIndex].id;
      });
      getUrl();
    }
   
  }


  @override
  void initState() {
    changePage();
    // setPlaying();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
   

    final appState = Provider.of<CurrentSong>(context,listen: true);

    appState.addListener((){
      if(currentPlaying!=appState.currentlyPlaying){
        playready = false;
        currentPlaying = appState.currentlyPlaying;
        print("changed");
        getUrl();
        getAfter(appState.currentlyPlaying['author'].toString());
      }
      currentPlaying = appState.currentlyPlaying;
      
    });


    player.positionStream.listen((state){
      if(player.playing){
        if(state.inMilliseconds>0){
          setState(() {
            playready=true;
            isplaying=true;
          });
        }
        setState(() {
          position= state.inSeconds.toDouble();
        });
        if(state.inSeconds>=songduration.toInt()-2 && sonhfindex==0){
          print("song finished");
          sonhfindex++;
          songIndex++;
          playAfter();
        }
        // print(position.inSeconds.toDouble());
      }
    });

    

    


    return Scaffold(
      backgroundColor: Colors.grey[150],
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Colors.blue),
                height: MediaQuery.of(context).size.height * 0.85,
                width: MediaQuery.of(context).size.width * 0.05,
                child: Column(
                  children: [
                    //home ...........................
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedindex = 0;
                          changePage();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0,bottom: 12.0),
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle,color:selectedindex==0?Colors.white:Colors.blue),
                          height: 30,
                          width: 30,
                          child: Icon(Icons.music_note_rounded ,color:selectedindex==0?Colors.blue:Colors.white),
                        ),
                      ),
                    ),


                    //musics.....................................
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedindex = 1;
                          changePage();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0,bottom: 12.0),
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle,color: selectedindex==1?Colors.white:Colors.blue),
                          height: 30,
                          width: 30,
                          child: Icon(Icons.search_rounded ,color: selectedindex==1?Colors.blue:Colors.white,),
                        ),
                      ),
                    ),
                    

                    //favourites................................
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedindex = 2;
                          changePage();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0,bottom: 20.0),
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle,color: selectedindex==2?Colors.white:Colors.blue),
                          height: 30,
                          width: 30,
                          child: Icon(Icons.favorite_rounded ,color: selectedindex==2?Colors.blue:Colors.white,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),



            //body here .....................
            Container(
              width: MediaQuery.of(context).size.width*0.92,
              height: MediaQuery.of(context).size.height*0.9,
              child: Container(
                child: currentPage,
              ),
            )
          ],
        ),


        //music player........
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),color: Colors.blue),
          height: MediaQuery.of(context).size.height*0.08,
          width: MediaQuery.of(context).size.width*1,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CircleAvatar(
                  backgroundImage:NetworkImage(currentPlaying!=null? currentPlaying['img'].toString():"https://user-images.githubusercontent.com/39475600/146644520-f90d31b7-6325-4fc9-985e-496ce0a81a06.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle , color: Colors.white),
                  child:playready? IconButton(onPressed: (){
                    setState(() {
                      isplaying=!isplaying;
                      if(isplaying){
                        player.play();
                      }else{
                        player.pause();
                      }
                    });
                  }, icon: isplaying?Icon(Icons.pause_rounded):Icon(Icons.play_arrow_rounded)):CircularProgressIndicator(backgroundColor: Colors.transparent,)
                ),
              ),
              Container(
                width:MediaQuery.of(context).size.width*0.5,
                child: Slider(
              activeColor: Colors.white60,
              inactiveColor: Colors.white38,
              min: 0.0,
              max: songduration,
              value: position,
              
              onChanged: (double value) {
                setState(() {
                  player.seek(new Duration(seconds: value.toInt()));
                });
              }),
              )
            ],
          )
        )
          ],
        )
      )
    );
  }
}