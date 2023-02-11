class CacheModel {
  DateTime time;
  String model;

  CacheModel({required this.time, required this.model});

  factory CacheModel.fromJson(Map<String, dynamic> json) => CacheModel(
        time: DateTime.parse(json['time']),
        model: json["model"],
      );

  Map<String, dynamic> toJson() => {
        "time": time.toString(),
        "model": model,
      };
}
