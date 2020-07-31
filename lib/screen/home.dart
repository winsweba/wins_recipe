import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wins_recipe/models/recipes_model.dart';
import 'package:wins_recipe/screen/recipe_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
//16025d37

//3a18a22bcaf6c87ce26a14e8c9be936e

//curl "https://api.edamam.com/search?q=chicken&app_id=${YOUR_APP_ID}&app_key=${YOUR_APP_KEY}&from=0&to=3&calories=591-722&health=alcohol-free"
class _HomeState extends State<Home> {
  List<RecipeModel> recipes = new List<RecipeModel>();
  TextEditingController textEditingController = new TextEditingController();

  getRecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=16025d37&app_key=3a18a22bcaf6c87ce26a14e8c9be936e";

    var response = await http.get(url);
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element) {
      print(element.toString());

      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);
    });

    setState(() { });
    print("${recipes.toString()}");
  }

  // startRecipes() async {
  //   String url =
  //       "https://api.edamam.com/search?q=mangos&app_id=16025d37&app_key=3a18a22bcaf6c87ce26a14e8c9be936e";

  //   var response = await http.get(url);
  //   Map<String, dynamic> jsonData = jsonDecode(response.body);

  //   jsonData["hits"].forEach((element) {
  //     print(element.toString());

  //     RecipeModel recipeModel = new RecipeModel();
  //     recipeModel = RecipeModel.fromMap(element["recipe"]);
  //     recipes.add(recipeModel);
  //   });

  //   setState(() { });
  //   print("${recipes.toString()}");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xffFFEBEE),
            Color(0xffBDBDBD),
          ])),
        ),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "WinsWeb",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Recipes",
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "WHAT ARE YOU GOING TO COOK TODAY",
                  style: TextStyle(
                      color: Color(0xffFFAB91), fontWeight: FontWeight.bold),
                ),
                Text(
                  "Just enter the name of your food and I will show you the best way to  cook it... As easy as that ",
                  style: TextStyle(color: Colors.black45),
                ),
                SizedBox(height: 30),
                Container(
                 
                  
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          if (textEditingController.text.isNotEmpty) {
                            getRecipes(textEditingController.text);
                            print("good to go");
                          } else {
                            print("I'm Empty");
                          }
                        },
                        child: Container(
                        
                          
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: textEditingController,
                          decoration: InputDecoration(
                            hintText: "I'm here for you",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                 
                Container(
                  child: GridView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    mainAxisSpacing: 8.0),
                    children:
                      List.generate(recipes.length ,(index) {
                        return GridTile( 
                          child:RecipieTile(
                            title: recipes[index].label,
                            desc: recipes[index].source,
                            imgUrl: recipes[index].image,
                            url: recipes[index].url,
                          ) ,);
                      })
     
                    ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeView(
                    postUrl: widget.url,
                  ),
                ),
              );
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
