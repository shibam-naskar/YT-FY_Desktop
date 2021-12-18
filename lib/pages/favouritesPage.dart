// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ytfy_desktop/providers/currentsong.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({ Key? key }) : super(key: key);

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {

  List songs = [];

  void getFavourites()async{
    var box = await Hive.openBox("Favourites");
    setState(() {
      songs = box.values.toList();
    });
  }

  @override
  void initState() {
    getFavourites();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {

    final appState = Provider.of<CurrentSong>(context);



    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context,index){
        return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: ()=>{
                          appState.setCurrent(songs[index]),
                          print(songs[index])
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
                                icon: Icon(Icons.delete_rounded),
                                onPressed: ()async{
                                  var box = await Hive.box("Favourites");
                                  box.delete(songs[index]['id']);
                                  getFavourites();
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
      },
    );
  }
}