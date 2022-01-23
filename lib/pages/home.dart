import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:test/pages/newAdd.dart';

import '../bloc/adds_bloc.dart';
import '../config.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AddsBloc addsBloc;
  @override
  void initState() {
    super.initState();

    addsBloc = AddsBloc();
    addsBloc.add(FetchAdds());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: getTopAdds(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data;
                    return CarouselSlider.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          buildTopAddCard(data, itemIndex, context),
                      options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
            buidAdds(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child:const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NewAdd())),
      ),
    );
  }

  Container buildTopAddCard(data, int itemIndex, BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              "$url/uploads/${data[itemIndex]['img']}",
            ),
          ),
          color: kBackgroundColor),
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(kPaddingHorizontal / 2),
        height: 50,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.75),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "${data[itemIndex]['title']}\n".toUpperCase(),
                  style: Theme.of(context).textTheme.button),
              TextSpan(
                text:
                    "USD ${double.parse(data[itemIndex]['price']).toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buidAdds() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
      child: BlocBuilder(
          bloc: addsBloc,
          builder: (context, state) {
            if (state is LoadedAdds) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LazyLoadScrollView(
                    onEndOfPage: () => addsBloc.add(FetchAdds()),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.addsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildAddCard(state, index, context);
                      },
                    ),
                  ),
                ],
              );
            } else {
              if (state is! AddsErrorState) {
                return const CircularProgressIndicator();
              }
              return const SizedBox();
            }
          }),
    );
  }

  Widget buildAddCard(LoadedAdds state, int index, BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direx) {
        deleteAdd(state.addsList[index].id);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        width: double.maxFinite,
        height: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                "$url/uploads/${state.addsList[index].img}",
              ),
            ),
            color: kBackgroundColor),
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(kPaddingHorizontal / 2),
          height: 50,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "${state.addsList[index].title}\n".toUpperCase(),
                    style: Theme.of(context).textTheme.button),
                TextSpan(
                  text:
                      "USD ${double.parse(state.addsList[index].price).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getTopAdds() async {
    try {
      String path = "$url/php/getTopAdds.php";
      final response =
          await http.post(Uri.parse(path), body: {"key": accessKey});
      var data = jsonDecode(response.body);
      return data;
    } catch (e) {
      Flushbar(
        message: e.toString(),
        messageColor: Colors.red,
        backgroundColor: kPrimaryColor,
        duration: const Duration(seconds: 3),
        icon: const Icon(
          Icons.warning_rounded,
          color: Colors.red,
        ),
      ).show(context);
    }
  }

  void deleteAdd(int id) async {
    try {
      String path = "$url/php/deleteAdd.php";
      await http.post(Uri.parse(path), body: {"key": accessKey, "id": "$id"});
    } catch (e) {
      Flushbar(
        message: e.toString(),
        messageColor: Colors.red,
        backgroundColor: kPrimaryColor,
        duration: const Duration(seconds: 3),
        icon: const Icon(
          Icons.warning_rounded,
          color: Colors.red,
        ),
      ).show(context);
    }
  }
}
