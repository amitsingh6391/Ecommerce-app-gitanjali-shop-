import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/product/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductList extends StatelessWidget {
  String feature;

  final SwiperController swiperController = SwiperController();

  ProductList({Key key, this.feature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height / 2.9;
    double cardWidth = MediaQuery.of(context).size.width / 1.8;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Category")
          .doc("Featured")
          .collection(feature)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SizedBox(
            height: cardHeight,
            child: Swiper(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (_, index) {
                Product products =
                    Product.fromDocument(snapshot.data.documents[index]);

                return ProductCard(
                    height: cardHeight, width: cardWidth, product: products);
              },
              scale: 0.8,
              controller: swiperController,
              viewportFraction: 0.6,
              loop: false,
              fade: 0.5,
              pagination: SwiperCustomPagination(
                builder: (context, config) {
                  if (config.itemCount > 20) {
                    print(
                        "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this sitituation");
                  }
                  Color activeColor = mediumYellow;
                  Color color = Colors.grey[300];
                  double size = 10.0;
                  double space = 5.0;

                  if (config.indicatorLayout != PageIndicatorLayout.NONE &&
                      config.layout == SwiperLayout.DEFAULT) {
                    return new PageIndicator(
                      count: config.itemCount,
                      controller: config.pageController,
                      layout: config.indicatorLayout,
                      size: size,
                      activeColor: activeColor,
                      color: color,
                      space: space,
                    );
                  }

                  List<Widget> dots = [];

                  int itemCount = config.itemCount;
                  int activeIndex = config.activeIndex;

                  for (int i = 0; i < itemCount; ++i) {
                    bool active = i == activeIndex;
                    dots.add(Container(
                      key: Key("pagination_$i"),
                      margin: EdgeInsets.all(space),
                      child: ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: active ? activeColor : color,
                          ),
                          width: size,
                          height: size,
                        ),
                      ),
                    ));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: dots,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final double height;
  final double width;

  const ProductCard({Key key, this.product, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(ProductPage(product: product));
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 30),
            height: height,
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3))
                ]
                // color: mediumYellow,
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {},
                  color: Colors.black,
                ),
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name ?? '',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        )),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 12.0, 4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            // color: Color.fromRGBO(224, 69, 10, 1),
                            color: mediumYellow),
                        child: Text(
                          '\$${product.price ?? 0.0}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            child: Hero(
              tag: product.image,
              child: Image.network(
                product.image ?? '',
                height: height / 1.7,
                width: width / 1.4,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
