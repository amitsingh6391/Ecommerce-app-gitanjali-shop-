import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/product/product_page.dart';
import 'package:ecommerce_int2/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class RecommendedList extends StatefulWidget {
  String category;
  RecommendedList({@required this.category});

  @override
  _RecommendedListState createState() => _RecommendedListState();
}

class _RecommendedListState extends State<RecommendedList> {
  Stream<QuerySnapshot> allitemss;

  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    var itemss = FirebaseFirestore.instance
        .collection("Category")
        .doc("Gift")
        .collection(widget.category)
        .snapshots();
    setState(() {
      allitemss = itemss;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              IntrinsicHeight(
                child: Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 8.0),
                  width: 4,
                  color: mediumYellow,
                ),
              ),
              Center(
                  child: Text(
                'Recommended',
                style: TextStyle(
                    color: darkGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              )),
            ],
          ),
        ),
        StreamBuilder(
          stream: allitemss,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Flexible(
                child: Container(
                  padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                  child: StaggeredGridView.countBuilder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    crossAxisCount: 4,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      Product items =
                          Product.fromDocument(snapshot.data.documents[index]);

                      print(items.description.length);
                      print("description");

                      return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: InkWell(
                              onTap: () {
                                Get.to(ProductPage(product: items));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                      colors: [
                                        Colors.grey[500],
                                        Colors.grey[700]
                                      ],
                                      center: Alignment(0, 0),
                                      radius: 0.6,
                                      focal: Alignment(0, 0),
                                      focalRadius: 0.1),
                                ),
                                child: Hero(
                                  tag: items.image,
                                  child: Image.network(items.image),
                                ),
                              )));
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(2, index.isEven ? 3 : 2),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
