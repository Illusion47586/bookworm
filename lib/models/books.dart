import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'books.g.dart';

@HiveType(typeId: 1, adapterName: "BookAdapter")
class Book {
  @HiveField(0)
  String title;
  @HiveField(1)
  String authorName;
  @HiveField(2)
  String bookCoverURL;
  @HiveField(3)
  String chapterName;
  @HiveField(4)
  int chapterNumber;
  @HiveField(5)
  int pageNumber;
  @HiveField(6)
  int hours;
  @HiveField(7)
  int minutes;
  @HiveField(8)
  String AMorPM;

  Book({
    this.title,
    this.authorName,
    this.bookCoverURL,
    this.chapterName,
    this.chapterNumber,
    this.pageNumber,
    this.hours,
    this.minutes,
    this.AMorPM,
  });
}
