import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/CategoryStoryList.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/providers/categoryData.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  String categoryNaam;

  List<DropdownMenuItem> categoryListDropDownItems(List<CategoryData> category){
    List<DropdownMenuItem> list=[];
    category.forEach((element) {
      list.add(
        DropdownMenuItem(
            child: Text(element.categoryName),
            value: element.categoryName,
        )
      );
    });
    return list;
  }

  CategoryData returnCategoryData(List<CategoryData> category,String name){
    int index = 0;
    for(int i=0;i<category.length;i++){
      if(category[i].categoryName==name){
        index = i;
      }
    }
    return category[index];
  }


  List<Color> col = [
    Color(0xFFDF5D90),
    Color(0xFFFFC687),
    Color(0xFF2D73D5),
    Color(0xFFFF9870),
    Color(0xFF6D60F8),
    Color(0xFF68E0E0),
    Color(0xFF1492E6),
    Color(0xFFF39358),
    Color(0xFF69DFA6),
    Color(0xFF9D8DFF),
  ];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<ImageProvider> img = [
    AssetImage(
      "assets/images/img1.png",
    ),
    AssetImage(
      "assets/images/img2.png",
    ),
    AssetImage(
      "assets/images/img3.png",
    ),
    AssetImage(
      "assets/images/img4.png",
    ),
    AssetImage(
      "assets/images/img5.png",
    ),
    AssetImage(
      "assets/images/img6.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        10.0 * ScreenSize.widthMultiplyingFactor,
        10.0 * ScreenSize.heightMultiplyingFactor,
        10.0 * ScreenSize.widthMultiplyingFactor,
        0.0 * ScreenSize.heightMultiplyingFactor,
      ),
      child: StreamBuilder(
        stream: firebaseFirestore.collection("categories").snapshots(),
        builder: (context, snapshot) {
          categories = [];
          if (snapshot.hasData) {
            snapshot.data.docs.forEach((result) {
              categories.add(CategoryData.fromSnapshot(result));
            });
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 8.0,bottom: 8.0),
                  child: DropdownButtonFormField(
                      hint: Text('Select Category',style: TextStyle(color: primaryColour),),
                      items: categoryListDropDownItems(categories),
                      onChanged: (value){
                        categoryNaam = value;
                        print(categoryNaam);
                      }

                  ),
                ),
                FlatButton(onPressed: (){
                  if(categoryNaam == null){
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Select a Category')),
                    );
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryStoryList(
                      heading: categoryNaam,
                      category: returnCategoryData(categories, categoryNaam),
                    ),
                    ));
                  }
                },
                  child: Container(
                    width: 150.0,
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(child: Text('Go to Category',style: TextStyle(color: Colors.white),)),
                      )),),
                SizedBox(height: 4.0,),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.vertical,
                    physics: physicsForApp,
                    itemBuilder: (context, index) {
                      var val = Random();
                      int next(int min, int max) => min + val.nextInt(max - min + 50);
                      var value = next(120, 180);
                      // print(value);
                      return Container(
                        padding: EdgeInsets.only(
                          top: 10.0 * ScreenSize.heightMultiplyingFactor,
                          bottom: 10.0 * ScreenSize.heightMultiplyingFactor,
                          left: 7.5 * ScreenSize.widthMultiplyingFactor,
                          right: 7.5 * ScreenSize.widthMultiplyingFactor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: col[((2 * index) % col.length)],
                                image: DecorationImage(
                                    image: img[((2 * index) % img.length)],
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center),
                              ),
                             // width: value.toDouble() *
                               //   ScreenSize.widthMultiplyingFactor,
                              width: MediaQuery.of(context).size.width/2.3,
                              height: 141.0 * ScreenSize.heightMultiplyingFactor,
                              child: Material(
                                type: MaterialType.transparency,
                                elevation: 6.0,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(25.0),
                                child: InkWell(
                                  splashColor: col[((2 * index) % col.length)]
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(25.0),
                                  onTap: () {
                                    print(
                                        categories[((2 * index) % categories.length)]
                                            .categoryName);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CategoryStoryList(
                                          heading: categories[
                                                  ((2 * index) % categories.length)]
                                              .categoryName,
                                          category: categories[
                                              ((2 * index) % categories.length)],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                        //  width: value.toDouble() - 10.0,

                                          child: Text(
                                            // "0 - 3 Years Old knowledge",
                                            categories[
                                                    ((2 * index) % categories.length)]
                                                .categoryName,
                                            style: TextStyle(
                                              fontFamily: "Poppins-Bold",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20.0 *
                                                  ScreenSize.heightMultiplyingFactor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 17.5 * ScreenSize.widthMultiplyingFactor,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Material(
                                  type: MaterialType.transparency,
                                  elevation: 6.0,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: InkWell(
                                    splashColor: col[((2 * index) + 1) % col.length]
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(25.0),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CategoryStoryList(
                                            heading: categories[((2 * index) + 1) %
                                                    categories.length]
                                                .categoryName,
                                            category: categories[((2 * index) + 1) %
                                                categories.length],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left:
                                              5.0 * ScreenSize.widthMultiplyingFactor,
                                          right:
                                              5.0 * ScreenSize.widthMultiplyingFactor,
                                        ),
                                        child: Text(
                                          categories[((2 * index) + 1) %
                                                  categories.length]
                                              .categoryName,
                                          style: TextStyle(
                                            fontFamily: "Poppins-Bold",
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20.0 *
                                                ScreenSize.heightMultiplyingFactor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: col[((2 * index) + 1) % col.length],
                                  image: DecorationImage(
                                    image: img[((2 * index) + 1) % img.length],
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                height: 141.0 * ScreenSize.heightMultiplyingFactor,

                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return circularProgressIndicator();
        },
      ),
    );
  }
}

