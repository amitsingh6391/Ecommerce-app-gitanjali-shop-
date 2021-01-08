import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/category.dart';

import 'package:flutter/material.dart';

import 'category_card.dart';
import 'recommended_list.dart';

class TabView extends StatelessWidget {
  final TabController tabController;

  TabView({Key key, this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height / 9);
    return TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 16.0,
                ),
                Flexible(
                    child: RecommendedList(
                  category: "Trending",
                )),
              ],
            ),
          ),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(
                child: RecommendedList(
              category: "Teddy",
            ))
          ]),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(
                child: RecommendedList(
              category: "TopGifts",
            ))
          ]),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(
                child: RecommendedList(
              category: "Pop",
            ))
          ]),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(child: RecommendedList(category: "Toys"))
          ]),
        ]);
  }
}
