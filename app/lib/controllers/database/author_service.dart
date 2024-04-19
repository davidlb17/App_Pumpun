import 'package:app/controllers/database/sqlite_service.dart';
import 'package:app/models/author.dart';
import 'package:app/models/book.dart';
import 'package:app/models/enums.dart';
import 'package:sqflite/sqflite.dart';

class AuthorService {
  static Future<int> createAuthor(Database database, Author author) async {
    //insert the data and put the id to the author class
    return await database.insert('author', author.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //put an author on a book
  static Future<void> addAuthorToBook(
      Database database, Author author, Book book) async {
    await database.insert(
        'bookauthor', {'author_id': author.id, 'book_id': book.id},
        conflictAlgorithm: ConflictAlgorithm.replace);
    book.authorList.add(author.name);
  }

  //get all the authors a book has
  static Future<List<String>> getAuthorsByBookId(
      Database database, int id) async {
    final List<Map<String, dynamic>> authorBookMaps =
        await database.query('bookauthor', where: 'book_id=?', whereArgs: [id]);

    //TODO change the author to the names and not the IDs
    return authorBookMaps.map((e) => e['author_id'].toString()).toList();
  }
}
