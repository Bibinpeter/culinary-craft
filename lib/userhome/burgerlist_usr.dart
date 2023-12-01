import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prj1/adminpages/hive_db.dart';
import 'package:prj1/userhome/constrains_usrp1.dart';

class BurgerList extends StatefulWidget {
  const BurgerList({Key? key, required this.selectedCategory}) : super(key: key);

  final String selectedCategory;

  @override
  _BurgerListState createState() => _BurgerListState();
}

class _BurgerListState extends State<BurgerList> {
  late ScrollController _scrollController;
  late Map<String, dynamic> post;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    post = FOOD_DATA.firstWhere((element) => element['name'] == widget.selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //////////////////////////////////////background image.................
          Image.asset(
            "assets/images/julius-9zy3GaH8NKM-unsplash.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [
                  0.2,
                  0.8
                ], // Adjust the stops for the desired effect
                colors: [
                  Colors.black.withOpacity(0.8), // Opacity at the top (0.8)
                  Colors.black.withOpacity(0.8), // Opacity at the bottom (0.5)
                ],
              ),
            ),
          ),
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: const Color.fromARGB(255, 0, 40, 46),
                  expandedHeight: 200.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Padding(
                      padding: const EdgeInsets.only(right: 40 ),
                      child: Text("Your "+post["name"]+ "  List",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Place the ColorFiltered Container below the Image
                        Image.asset(
                          "assets/images/julius-9zy3GaH8NKM-unsplash.jpg",
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Color.fromARGB(255, 0, 0, 0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ValueListenableBuilder(
              valueListenable: recipenotifier,
              builder: (context, foodlists, child) {
                return ListView.builder(
                  itemCount: foodlists.length,
                  itemBuilder: (context, index) {
                    var category = foodlists[index];
                    var imageUrl = category.photo;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          post = FOOD_DATA[index];
                        });
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>,))
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.2),
                                      BlendMode.multiply,
                                    ),
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.9),
                                            Colors.black,
                                          ],
                                        ).createShader(bounds);
                                      },
                                      blendMode: BlendMode.dstIn,
                                      child: Image.file(
                                        File(imageUrl),
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 150, left: 5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.update,
                                        color: Colors.amberAccent,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        category.time,
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 170, left: 10),
                                  child: Text(
                                    category.title,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 255, 255, 255)
                                          .withOpacity(0.7),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}