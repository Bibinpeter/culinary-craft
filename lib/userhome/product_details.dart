import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prj1/adminpages/models/model.dart';

class ProductItemScreen extends StatefulWidget {
  const ProductItemScreen({
    Key? key,
    required this.recipe
  }) : super(key: key);

   final Recipe recipe;

  @override
  State<ProductItemScreen> createState() => _ProductItemScreenState();
}

class _ProductItemScreenState extends State<ProductItemScreen>
    with TickerProviderStateMixin {
  late final Recipe culinary;
  final fontesh = GoogleFonts.poppins();
  bool isFavorite = false;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
  setState(() {
    isFavorite = !isFavorite;
    if (isFavorite) {
      _scaleController.forward();
    } else if (_scaleController.status == AnimationStatus.completed) {
      _scaleController.reverse().then((value) {
        // Reset the animation controller when it's reversed
        _scaleController.reset();
      });
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: FadeInImage(
                fadeInCurve: Curves.bounceInOut,
                placeholder: const AssetImage("assets/images/foodplaceholder.png"),
                image: FileImage(File(widget.recipe.photo)),
                width: double.infinity,
                height: 340,
                fit: BoxFit.cover,
              ),
            ),
            buttonArrow(context),
            scroll(),
          ],
        ),
      ),
    );
  }

  Widget buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget scroll() {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 1.0,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 35,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.recipe.title,
                  style: GoogleFonts.poppins(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.update,
                      color: Color.fromARGB(255, 225, 178, 9),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      ": ${widget.recipe.time}",
                      style: fontesh,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/user2.png"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Elena Shelby",
                          style: fontesh,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        isFavorite
                            ? const Text(
                                "You Added to Fav",
                                style: TextStyle(color: Colors.grey),
                              )
                            : const Text("Your Choosen Recipe Info")
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: _toggleFavorite,
                      child: Hero(
                        tag: 'favorite_icon',
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: isFavorite
                                ? Color.fromARGB(255, 246, 190, 190)
                                : Color.fromARGB(255, 243, 185, 185),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child:  Icon(
                                Icons.favorite,
                                color: isFavorite
                                ? Color.fromARGB(255, 255, 0, 0)
                                : Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(
                    height: 4,
                  ),
                ),
                Text(
                  "Description",
                  style: fontesh,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.recipe.description,
                  style: fontesh,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(
                    height: 4,
                  ),
                ),
                Text(
                  "Ingredients",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) => ingredients(context),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget ingredients(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Tapped on ingredient");
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              height: 5,
              width: 5,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                widget.recipe.incredients,
                style: fontesh.copyWith(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
    }