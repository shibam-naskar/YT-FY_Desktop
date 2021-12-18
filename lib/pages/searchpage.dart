

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytfy_desktop/providers/currentsong.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var songs = [];
  var hints = [];
  var searchterm = "";
  var searchready = true;


  fetchSongs(String searchText) async {
    // var REQURL = "https://youtube-music-shibam.herokuapp.com/youtube-data/songs";
    var yt = YoutubeExplode();
    var playlist = await yt.search.getVideos(searchText.toString());
    var favouriteBox = await Hive.box("Favourites");
    setState(() {
        songs=[];
      });

    for(int i=0;i<playlist.length;i++){
      var one = favouriteBox.get(playlist[i].id.toString());
      
      if(one==null){
        
          setState(() {
            songs.add({
          'id':playlist[i].id.toString(),
          'title':playlist[i].title,
          'img':playlist[i].thumbnails.mediumResUrl.toString(),
          'author':playlist[i].author.toString(),
          'isLive':false
        
        });
          });
      }else{
        
          setState(() {
            songs.add({
          'id':playlist[i].id.toString(),
          'title':playlist[i].title,
          'img':playlist[i].thumbnails.mediumResUrl.toString(),
          'author':playlist[i].author.toString(),
          'isLive':true
        
        });
          });
      }
    }
    setState(() {
      searchready=true;
    });
    // setState(() {
      
    // });
    
  }


  fetchHints(String searchText) async {
    // var REQURL = "https://youtube-music-shibam.herokuapp.com/youtube-data/songs";
    var yt = YoutubeExplode();
    var hintS = await yt.search.getQuerySuggestions(searchText);
    setState(() {
      hints=hintS;
    });
    print(hintS);
    
  }

  void storeSong(dynamic dataA)async{

    var data = {
      'title':dataA['title'].toString(),
      'id':dataA['id'].toString(),
      'img':dataA['img'].toString(),
      'author':dataA['author'].toString()
    };
    
    var FavouritesBox = await Hive.box("Favourites");
    await FavouritesBox.put(dataA['id'].toString(),data);
    
    
  }


  @override
  Widget build(BuildContext context) {

    final appState = Provider.of<CurrentSong>(context);
    final controller = FloatingSearchBarController();



    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          

          songs.length==0?Center(
            child:searchready? Text("Search Songs"):CircularProgressIndicator()
          )
          :ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context,index){
              if(index==0){
                return Column(
                  children: [
                    SizedBox(height: 60,),
                    

                    Padding(
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
                                  Text(songs[index]['author'],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.blue),)
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.favorite_rounded,color: songs[index]["isLive"]?Colors.red:Colors.grey[700],),
                                onPressed: ()async{
                                  storeSong(songs[index]);
                                  setState(() {
                                    songs[index]['isLive']=true;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }else{
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
                                  Text(songs[index]['author'],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.blue),)
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.favorite_rounded,color: songs[index]["isLive"]?Colors.red:Colors.grey[700],),
                                onPressed: ()async{
                                  storeSong(songs[index]);
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
              }
            },
          )
          ,



          //floating search bar .......................


          FloatingSearchBar(
            hint: 'Search.....',
            controller: controller,
            openAxisAlignment: 0.0,
            axisAlignment:0.0,
            scrollPadding: EdgeInsets.only(top: 16,bottom: 20),
            elevation: 4.0,
            physics: BouncingScrollPhysics(),
            onQueryChanged: (query){
              setState(() {
                searchterm=query;
              });
              fetchHints(query);
            },
            onSubmitted: ((data){
              fetchSongs(data);
              
              setState(() {
                searchready=false;
              });
              controller.close();
            }),
            transitionCurve: Curves.easeInOut,
            transitionDuration: Duration(milliseconds: 500),
            transition: CircularFloatingSearchBarTransition(),
            debounceDelay: Duration(milliseconds: 500),
            actions: [
              FloatingSearchBarAction(
                // showIfClosed: false,
                // showIfOpened: false,
                child: CircularButton(icon: Icon(Icons.search_rounded),
                    onPressed: (){
                  fetchSongs(searchterm);
                    },),
              ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
              FloatingSearchBarAction.back()
            ],
            builder: (context, transition){
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Material(
                  color: Colors.white,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 500,
                          height: hints.length<=6?hints.length*70:6*70,
                          child: ListView.builder(
                            itemCount: hints.length,
                            itemBuilder: (BuildContext context, int index) { 
                              return InkWell(
                                onTap: (){
                                  fetchSongs(hints[index]);
                                  controller.close();
                                },
                                child: ListTile(
                                  title: Text(hints[index]),
                                  subtitle: Text('click to search........'),
                                ),
                              );
                             },),
                        )
                        
                      ],
                    ),
                  ),
                ),
              );
            },

          ),
          
          //floating search bar.........................
        ],
      ),
    );
  }
}

// Widget searchBarUI(){

//     return FloatingSearchBar(
//       hint: 'Search.....',
//       openAxisAlignment: 0.0,
//       axisAlignment:0.0,
//       scrollPadding: EdgeInsets.only(top: 16,bottom: 20),
//       elevation: 4.0,
//       physics: BouncingScrollPhysics(),
//       onQueryChanged: (query){
//         //Your methods will be here
//       },
//       transitionCurve: Curves.easeInOut,
//       transitionDuration: Duration(milliseconds: 500),
//       transition: CircularFloatingSearchBarTransition(),
//       debounceDelay: Duration(milliseconds: 500),
//       actions: [
//         FloatingSearchBarAction(
//           showIfOpened: false,
//           child: CircularButton(icon: Icon(Icons.place),
//               onPressed: (){
//             print('Places Pressed');
//               },),
//         ),
//         FloatingSearchBarAction.searchToClear(
//           showIfClosed: false,
//         ),
//       ],
//       builder: (context, transition){
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(8.0),
//           child: Material(
//             color: Colors.white,
//             child: Container(
//               height: 200.0,
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Text('Home'),
//                     subtitle: Text('more info here........'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },

//     );
//   }
