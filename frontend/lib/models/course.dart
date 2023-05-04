import 'dart:convert';

import 'package:uscheduler/models/event.dart';

// DELETE WHEN DONE
import 'package:flutter/foundation.dart' show debugPrint;

List<Course> courseFromJson(String str) {
  var decoded = json.decode(str);
  debugPrint("doign stufff");
  debugPrint("Half");
  List<Course> value = (decoded == null)
      ? (<Course>[])
      : (List<Course>.from(json.decode(str).map((x) => Course.fromJson(x))));
  return value;
}

String courseToJson(List<Course> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Course implements Event {
  Course(
      {this.updatedAt,
      this.description,
      this.details,
      this.enrollmentInformation,
      this.id,
      this.number,
      this.offerings,
      this.subject,
      this.title,
      this.url,
      this.token});

  DateTime? updatedAt;
  String? description;
  Details? details;
  EnrollmentInformation? enrollmentInformation;
  String? id;
  String? number;
  List<Offering>? offerings;
  Subject? subject;
  String? title;
  String? url;
  List<dynamic>? token;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
      updatedAt: json["_updated_at"] == null
          ? null
          : DateTime.parse(json["_updated_at"]),
      description: json["description"],
      details:
          json["details"] == null ? null : Details.fromJson(json["details"]),
      enrollmentInformation: json["enrollment_information"] == null
          ? null
          : EnrollmentInformation.fromJson(json["enrollment_information"]),
      id: json["id"],
      number: json["number"],
      offerings: json["offerings"] == null
          ? []
          : List<Offering>.from(
              json["offerings"]!.map((x) => Offering.fromJson(x))),
      subject:
          json["subject"] == null ? null : Subject.fromJson(json["subject"]),
      title: json["title"],
      url: json["url"],
      token: json["token"]);

  Map<String, dynamic> toJson() => {
        "_updated_at": updatedAt?.toIso8601String(),
        "description": description,
        "details": details?.toJson(),
        "enrollment_information": enrollmentInformation?.toJson(),
        "id": id,
        "number": number,
        "offerings": offerings == null
            ? []
            : List<dynamic>.from(offerings!.map((x) => x.toJson())),
        "subject": subject?.toJson(),
        "title": title,
        "url": url,
        "token": token
      };

  @override
  String type = EventType.COURSE;
}

class Details {
  Details({
    this.academicGroup,
    this.academicOrganization,
    this.campus,
    this.career,
    this.courseComponents,
    this.gradingBasis,
    this.units,
  });

  String? academicGroup;
  String? academicOrganization;
  dynamic campus;
  String? career;
  List<String>? courseComponents;
  String? gradingBasis;
  Units? units;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        academicGroup: json["academic_group"],
        academicOrganization: json["academic_organization"],
        campus: json["campus"],
        career: json["career"],
        courseComponents: json["course_components"] == null
            ? []
            : List<String>.from(json["course_components"]!.map((x) => x)),
        gradingBasis: json["grading_basis"],
        units: json["units"] == null ? null : Units.fromJson(json["units"]),
      );

  Map<String, dynamic> toJson() => {
        "academic_group": academicGroup,
        "academic_organization": academicOrganization,
        "campus": campus,
        "career": career,
        "course_components": courseComponents == null
            ? []
            : List<dynamic>.from(courseComponents!.map((x) => x)),
        "grading_basis": gradingBasis,
        "units": units?.toJson(),
      };
}

class Units {
  Units({
    this.base,
    this.max,
    this.min,
  });

  int? base;
  dynamic max;
  dynamic min;

  factory Units.fromJson(Map<String, dynamic> json) => Units(
        base: json["base"].toInt(),
        max: json["max"],
        min: json["min"],
      );

  Map<String, dynamic> toJson() => {
        "base": base,
        "max": max,
        "min": min,
      };
}

class EnrollmentInformation {
  EnrollmentInformation({
    this.addConsent,
    this.courseAttribute,
    this.enrollmentRequirement,
  });

  dynamic addConsent;
  List<String>? courseAttribute;
  String? enrollmentRequirement;

  factory EnrollmentInformation.fromJson(Map<String, dynamic> json) =>
      EnrollmentInformation(
        addConsent: json["add_consent"],
        courseAttribute: json["course_attribute"] == null
            ? []
            : List<String>.from(json["course_attribute"]!.map((x) => x)),
        enrollmentRequirement: json["enrollment_requirement"],
      );

  Map<String, dynamic> toJson() => {
        "add_consent": addConsent,
        "course_attribute": courseAttribute == null
            ? []
            : List<dynamic>.from(courseAttribute!.map((x) => x)),
        "enrollment_requirement": enrollmentRequirement,
      };
}

class Offering {
  Offering({
    this.id,
    this.term,
    this.url,
  });

  int? id;
  Term? term;
  String? url;

  factory Offering.fromJson(Map<String, dynamic> json) => Offering(
        id: json["id"],
        term: json["term"] == null ? null : Term.fromJson(json["term"]),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "term": term?.toJson(),
        "url": url,
      };
}

class Term {
  Term({
    this.id,
    this.ordinal,
    this.season,
    this.url,
    this.year,
  });

  String? id;
  int? ordinal;
  Season? season;
  String? url;
  int? year;

  factory Term.fromJson(Map<String, dynamic> json) => Term(
        id: json["id"],
        ordinal: json["ordinal"],
        season: seasonValues.map[json["season"]]!,
        url: json["url"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ordinal": ordinal,
        "season": seasonValues.reverse[season],
        "url": url,
        "year": year,
      };
}

enum Season { SPRING, WINTER, SUMMER, FALL }

final seasonValues = EnumValues({
  "Fall": Season.FALL,
  "Spring": Season.SPRING,
  "Summer": Season.SUMMER,
  "Winter": Season.WINTER
});

class Subject {
  Subject({
    this.id,
    this.title,
    this.url,
  });

  String? id;
  String? title;
  String? url;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json["id"],
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "url": url,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
