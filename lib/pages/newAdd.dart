// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/config.dart';

class NewAdd extends StatefulWidget {
  const NewAdd({Key key}) : super(key: key);

  @override
  _NewAddState createState() => _NewAddState();
}

class _NewAddState extends State<NewAdd> {
  String base64Image;
  Image imageWidget;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerTitle =
      new TextEditingController();
  TextEditingController textEditingControllerPrice =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post New Add"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
          child: Column(
            children: [
              buildUploadImg(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: TextFormField(
                  controller: textEditingControllerTitle,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Enter Title';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Title",
                      counterText: "",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black87)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 8)),
                  maxLength: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: TextFormField(
                  controller: textEditingControllerPrice,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                  ],
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Enter Price';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Price",
                      counterText: "",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black87)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 8)),
                  maxLength: 30,
                  keyboardType: TextInputType.number,
                ),
              ),
              FlatButton(
                  color: kPrimaryColor,
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      postAdd();
                    } else {
                      return;
                    }
                  },
                  child: const Text(
                    "Post",
                    style: TextStyle(color: kBackgroundColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Container buildUploadImg() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.4,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.grey),
      child: GestureDetector(
        onTap: () {
          getImage();
        },
        child: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                // ignore: prefer_if_null_operators
                child: imageWidget != null
                    ? imageWidget
                    : const Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 80,
                      )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      color: Colors.grey[300].withOpacity(0.7)),
                  child: Text(
                    imageWidget != null ? "Change Image" : "Select Image",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black54),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      base64Image = base64Encode(file.readAsBytesSync());
      setState(() {
        imageWidget = Image.file(
          file,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.4,
        );
      });
    }
  }

  Future<void> postAdd() async {
    try {
      var response = await http.post(Uri.parse("$url/php/creteAdd.php "), body: {
        "key": accessKey,
        'image': base64Image,
        'name': textEditingControllerTitle.text,
        'price': textEditingControllerPrice.text,
      });

      var data = await json.decode(response.body);
      if (data.toString() == "false" || data.toString() == "-1") {
        Flushbar(
          message: 'Upload faild!',
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: const Duration(seconds: 3),
          icon: const Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      } else {
        Flushbar(
          message: 'New product added',
          messageColor: Colors.green,
          backgroundColor: kPrimaryColor,
          duration: const Duration(seconds: 3),
          icon: const Icon(
            Icons.info_rounded,
            color: Colors.green,
          ),
        ).show(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
