// To parse this JSON data, do
//
//     final classCovid = classCovidFromJson(jsonString);

import 'dart:convert';

ClassCovid classCovidFromJson(String str) => ClassCovid.fromJson(json.decode(str));

String classCovidToJson(ClassCovid data) => json.encode(data.toJson());

class ClassCovid {
    ClassCovid({
        required this.thai,
        required this.world,
        required this.date,
    });

    Thai thai;
    World world;
    int date;

    factory ClassCovid.fromJson(Map<String, dynamic> json) => ClassCovid(
        thai: Thai.fromJson(json["thai"]),
        world: World.fromJson(json["world"]),
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "thai": thai.toJson(),
        "world": world.toJson(),
        "date": date,
    };
}

class Thai {
    Thai({
        required this.newCases,
        required this.recovered,
        required this.activeCases,
        required this.deaths,
        required this.totalCases,
        required this.tracked,
    });

    String newCases;
    String recovered;
    String activeCases;
    String deaths;
    String totalCases;
    String tracked;

    factory Thai.fromJson(Map<String, dynamic> json) => Thai(
        newCases: json["new_cases"],
        recovered: json["recovered"],
        activeCases: json["active_cases"],
        deaths: json["deaths"],
        totalCases: json["total_cases"],
        tracked: json["tracked"],
    );

    Map<String, dynamic> toJson() => {
        "new_cases": newCases,
        "recovered": recovered,
        "active_cases": activeCases,
        "deaths": deaths,
        "total_cases": totalCases,
        "tracked": tracked,
    };
}

class World {
    World({
        required this.totalCases,
        required this.deaths,
        required this.recovered,
        required this.top5,
    });

    String totalCases;
    String deaths;
    String recovered;
    List<Top5> top5;

    factory World.fromJson(Map<String, dynamic> json) => World(
        totalCases: json["total_cases"],
        deaths: json["deaths"],
        recovered: json["recovered"],
        top5: List<Top5>.from(json["top5"].map((x) => Top5.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_cases": totalCases,
        "deaths": deaths,
        "recovered": recovered,
        "top5": List<dynamic>.from(top5.map((x) => x.toJson())),
    };
}

class Top5 {
    Top5({
        required this.country,
        required this.totalCases,
        required this.deaths,
    });

    String country;
    String totalCases;
    String deaths;

    factory Top5.fromJson(Map<String, dynamic> json) => Top5(
        country: json["country"],
        totalCases: json["total_cases"],
        deaths: json["deaths"],
    );

    Map<String, dynamic> toJson() => {
        "country": country,
        "total_cases": totalCases,
        "deaths": deaths,
    };
}
