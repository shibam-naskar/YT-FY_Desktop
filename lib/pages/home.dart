// ignore_for_file: prefer_const_constructors



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytfy_desktop/navigator.dart';
import 'package:ytfy_desktop/providers/currentsong.dart';
import 'package:provider/provider.dart';


//music genres.........................
var data = [
    {
        "genre":"ROCK",
        "img":"https://media.kidadl.com/large_60408d296ad9d5dd92cbed07_rock_and_roll_quotes_are_loved_by_one_and_all_889d37c607.jpeg"
    },
    {
        "genre":"CLASSIC",
        "img":"https://images.outlookindia.com/public/uploads/articles/2020/12/16/Tabla_4)_570_850_571_855.jpg"
    },
    {
        "genre":"ROCK",
        "img":"https://media.kidadl.com/large_60408d296ad9d5dd92cbed07_rock_and_roll_quotes_are_loved_by_one_and_all_889d37c607.jpeg"
    },
    {
        "genre":"CLASSIC",
        "img":"https://images.outlookindia.com/public/uploads/articles/2020/12/16/Tabla_4)_570_850_571_855.jpg"
    },
    {
        "genre":"ROCK",
        "img":"https://media.kidadl.com/large_60408d296ad9d5dd92cbed07_rock_and_roll_quotes_are_loved_by_one_and_all_889d37c607.jpeg"
    },
    {
        "genre":"CLASSIC",
        "img":"https://images.outlookindia.com/public/uploads/articles/2020/12/16/Tabla_4)_570_850_571_855.jpg"
    },
    {
        "genre":"ROCK",
        "img":"https://media.kidadl.com/large_60408d296ad9d5dd92cbed07_rock_and_roll_quotes_are_loved_by_one_and_all_889d37c607.jpeg"
    },
    {
        "genre":"CLASSIC",
        "img":"https://images.outlookindia.com/public/uploads/articles/2020/12/16/Tabla_4)_570_850_571_855.jpg"
    },
    {
        "genre":"ROCK",
        "img":"https://media.kidadl.com/large_60408d296ad9d5dd92cbed07_rock_and_roll_quotes_are_loved_by_one_and_all_889d37c607.jpeg"
    },
    {
        "genre":"CLASSIC",
        "img":"https://images.outlookindia.com/public/uploads/articles/2020/12/16/Tabla_4)_570_850_571_855.jpg"
    },
];

class HomePage extends StatefulWidget {
  final Function(Future) changePlaying;
  const HomePage({ Key? key ,required this.changePlaying}) : super(key: key);
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List songs=[];

  

  fetchSongs(String value) async {
    // var REQURL = "https://youtube-music-shibam.herokuapp.com/youtube-data/songs";
    var yt = YoutubeExplode();
    var playlist = await yt.search.getVideos(value.toString());
    // var afterPlay = await yt.channels.get(playlist[1].channelId.toString());
    // print(afterPlay);
    var favouriteBox = await Hive.box("Favourites");
    // print(playlist[1].channelId);

    for(int i=0;i<playlist.length;i++){
      var one = favouriteBox.get(playlist[i].id.toString());
      if(one==null){
        
          songs.add({
          'id':playlist[i].id.toString(),
          'title':playlist[i].title,
          'img':playlist[i].thumbnails.mediumResUrl.toString(),
          'author':playlist[i].author.toString(),
          'isLive':false
        
        });
      }else{
        
          songs.add({
          'id':playlist[i].id.toString(),
          'title':playlist[i].title,
          'img':playlist[i].thumbnails.mediumResUrl.toString(),
          'author':playlist[i].author.toString(),
          'isLive':true
        
        });
      }
    }
    setState(() {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          bottomColor = Colors.blue;
        });
      });
    });
    
  }


  void getspeed(String url) async {
    var yt = YoutubeExplode();
    var manifest = await yt.videos.streamsClient.getManifest(url);
    var readUrl = await manifest.audioOnly.first.url;
    yt.close();
    // return readUrl;
    // play_song(readUrl.toString());
    Future.delayed(Duration(minutes: 1), (){
          print("Executed after 1 minuit");
          getspeed(url);
    });
    
  }

  void storeSong(dynamic dataA)async{

    var data = {
      'title':dataA['title'].toString(),
      'id':dataA['id'].toString(),
      'img':dataA['img'].toString(),
      'author':dataA['author'].toString()
    };
    
    var FavouritesBox = await Hive.box("Favourites");
    if(FavouritesBox.get(dataA['id'].toString())==null){
      await FavouritesBox.put(dataA['id'].toString(),data);
    }
    
    
    
  }
  
  void getSearched()async{
    var preferedBox = await Hive.box("prefered");
    var pr = await preferedBox.values.toList();
    if(pr.length==0){
       fetchSongs("taylor swift");
    }else{
      print(pr[0]);
      fetchSongs(pr[0].toString());
    }
    
  }


  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Colors.red;
  Color topColor = Colors.yellow;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  


  @override
  void initState() {
    getSearched();
    getspeed("wGwHQYtvNRw");
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final appState = Provider.of<CurrentSong>(context);
    




    return Scaffold(
      backgroundColor:  Colors.grey[150],
      body:songs.length==0?Center(child: CircularProgressIndicator(),): SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30,),
            
            
      
            //colour gradient animation
            Padding(
              padding: const EdgeInsets.only(left: 15,bottom: 15),
              child: Stack(
                children: [
                  AnimatedContainer(
                    width: MediaQuery.of(context).size.width*0.9,
                    height: 300,
                    duration: Duration(seconds: 3),
                    onEnd: () {
                      setState(() {
                        index = index + 1;
                        // animate the color
                        bottomColor = colorList[index % colorList.length];
                        topColor = colorList[(index + 1) % colorList.length];

                        //// animate the alignment
                        // begin = alignmentList[index % alignmentList.length];
                        // end = alignmentList[(index + 2) % alignmentList.length];
                      });
                    },
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            begin: begin, end: end, colors: [bottomColor, topColor])),
                  ),
                  Positioned.fill(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50,),
                        Row(children: [
                          Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Image.asset('lib/assets/ytfy-logo.png',height: 170,),
                        ),
                          Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text("YT-FY Desktop",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.w900),),
                        ),
                        ],),
                        SizedBox(height: 55,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text("Made by Shibam Naskar",style: TextStyle(color: Colors.white,fontSize: 10),),
                            )
                          ],
                        )
                        
                        
                      ],
                    )
                  ),
                ],
              ),
            ),
      
      
            //populer music section..............
      
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.9,
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (BuildContext context,int index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: ()async{
                          appState.setCurrent(songs[index]);
                          print(songs[index]);
                          var preferedBox = await Hive.box("prefered");
                          preferedBox.clear();
                          preferedBox.add(songs[index]['author'].toString());
                          
                        },
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white,),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 100,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(songs[index]['img'].toString()),
                              ),

                              SizedBox(width:10),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15,),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.6,
                                    child: Text(songs[index]["title"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold , color: Colors.grey[700],overflow: TextOverflow.ellipsis))
                                    ),
                                  // SizedBox(height: 1,),
                                  Text(songs[index]["author"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.blue),)
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.favorite_rounded,color: songs[index]["isLive"]?Colors.red:Colors.grey[700],),
                                onPressed: ()async{
                                  storeSong(songs[index]);
                                  // var box = await Hive.openBox("Favourites");
                                  // print(box.values.toList());
                                  setState(() {
                                    songs[index]['isLive']=true;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}