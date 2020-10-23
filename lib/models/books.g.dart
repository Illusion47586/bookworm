// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final typeId = 1;

  @override
  Book read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      title: fields[0] as String,
      authorName: fields[1] as String,
      bookCoverURL: fields[2] as String,
      chapterName: fields[3] as String,
      chapterNumber: fields[4] as int,
      pageNumber: fields[5] as int,
      hours: fields[6] as int,
      minutes: fields[7] as int,
      AMorPM: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.authorName)
      ..writeByte(2)
      ..write(obj.bookCoverURL)
      ..writeByte(3)
      ..write(obj.chapterName)
      ..writeByte(4)
      ..write(obj.chapterNumber)
      ..writeByte(5)
      ..write(obj.pageNumber)
      ..writeByte(6)
      ..write(obj.hours)
      ..writeByte(7)
      ..write(obj.minutes)
      ..writeByte(8)
      ..write(obj.AMorPM);
  }
}
