// To parse this JSON data, do
//
//     final classCovidDaily = classCovidDailyFromJson(jsonString);

import 'dart:convert';

ClassCovidDaily classCovidDailyFromJson(String str) => ClassCovidDaily.fromJson(json.decode(str));

String classCovidDailyToJson(ClassCovidDaily data) => json.encode(data.toJson());

class ClassCovidDaily {
    ClassCovidDaily({
        required this.lastUpdated,
        required this.data,
    });

    DateTime lastUpdated;
    List<Datum> data;

    factory ClassCovidDaily.fromJson(Map<String, dynamic> json) => ClassCovidDaily(
        lastUpdated: DateTime.parse(json["lastUpdated"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "lastUpdated": "${lastUpdated.year.toString().padLeft(4, '0')}-${lastUpdated.month.toString().padLeft(2, '0')}-${lastUpdated.day.toString().padLeft(2, '0')}",
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.date,
        required this.confirmed,
        required this.recovered,
        required this.deaths,
    });

    DateTime date;
    int confirmed;
    int recovered;
    int deaths;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: DateTime.parse(json["date"]),
        confirmed: json["confirmed"],
        recovered: json["recovered"],
        deaths: json["deaths"],
    );

    Map<String, dynamic> toJson() => {
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "confirmed": confirmed,
        "recovered": recovered,
        "deaths": deaths,
    };
}
