import 'package:app/controllers/database/sqlite_service.dart';
import 'package:app/models/book.dart';
import 'package:app/models/enums.dart';
import 'package:sqflite/sqflite.dart';

class GenreService {
  static Future<void> createGenre(Database database, Genre genre) async {
    await database.insert('genre', {'id': genre.index, 'name': genre.name},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //pass a genre to a book
  static Future<void> addGenreToBook(
      Database database, Genre genre, Book book) async {
    await database.insert(
        'bookgenre', {'genre_id': genre.index, 'book_id': book.id},
        conflictAlgorithm: ConflictAlgorithm.replace);
    book.genreList.add(genre);
  }

  //get all the genres of a book
  static Future<List<Genre>> getGenresByBookId(
      Database database, int id) async {
    final List<Map<String, dynamic>> genreBookMaps =
        await database.query('bookgenre', where: 'book_id=?', whereArgs: [id]);

    return genreBookMaps.map((genreMap) {
      return Genre.values[genreMap['genre_id']];
    }).toList();
  }
}
