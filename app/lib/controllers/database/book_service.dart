import 'package:app/controllers/database/author_service.dart';
import 'package:app/controllers/database/bookList_service.dart';
import 'package:app/controllers/database/genre_service.dart';
import 'package:app/models/book.dart';
import 'package:app/controllers/database/sqlite_service.dart';
import 'package:app/models/booklist.dart';
import 'package:app/models/enums.dart';
import 'package:sqflite/sqflite.dart';

class BookService {
  static Future<int> createBook(Database database, Book book) async {
    //insert the data and put the id to the book class
    return await database.insert('book', book.toMap(false),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateBook(Database database, Book book) async {
    await database.update('book', book.toMap(true),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Book>> getBooksByListId(Database database, int id) async {
    final List<Map<String, dynamic>> bookMaps = await database
        .query('bookOnList', where: 'booklist_id=?', whereArgs: [id]);

    List<Book> books = bookMaps.map((e) => Book.fromMap(e)).toList();

    for (Book book in books) {
      book.genreList = await GenreService.getGenresByBookId(database, book.id);
      book.authorList =
          await AuthorService.getAuthorsByBookId(database, book.id);
    }
    return books;
  }

  static Future<List<Book>> getAllBooks(Database database) async {
    final List<Map<String, dynamic>> bookMaps = await database.query('book');
    List<Book> books = bookMaps.map((e) => Book.fromMap(e)).toList();

    for (Book book in books) {
      book.genreList = await GenreService.getGenresByBookId(database, book.id);
      book.authorList =
          await AuthorService.getAuthorsByBookId(database, book.id);
    }
    return books;
  }

  static Future<void> addBookToList(
      Database database, Book book, BookList bookList) async {
    await database.insert(
        'bookonlist', {'book_id': book.id, 'booklist_id': bookList.id},
        conflictAlgorithm: ConflictAlgorithm.replace);
    bookList.books.add(book);
  }
}
