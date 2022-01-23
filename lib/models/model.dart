
class Adds {
  int id;
  String title;
  String price;
  String time;
  String img;
  int isTop;

  Adds({
    this.id,
    this.price,
    this.title,
    this.img,
    this.time,
    this.isTop
  });

  Adds.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    title = json['title'];
    price = json['price'];
    time = json['time'];
    img = json['img'];
    isTop = int.parse(json['isTop']);
  }
}
