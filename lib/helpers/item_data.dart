
class ItemData {
  String id;
  String title;
  String description;
  int progress;
  int numberOfSub;
  int color;
///TODO: Vi skal have nogen datoer med. Start date, end date  
  ItemData({this.id, this.title, this.description, this.progress, this.numberOfSub, this.color});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "progress": progress,
      "numberOfSub": numberOfSub,
      "color": color
    };
  }
}