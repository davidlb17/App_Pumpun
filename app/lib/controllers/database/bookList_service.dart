import 'package:app/controllers/database/book_service.dart';
import 'package:app/models/book.dart';
import 'package:app/models/booklist.dart';
import 'package:app/controllers/database/sqlite_service.dart';
import 'package:sqflite/sqflite.dart';

class BookListService {
  static Future<int> createBookList(
      Database database, BookList bookList) async {
    //insert the data and put the id to the booklist class
    return await database.insert('booklist', bookList.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteBookList(Database database, int id) async {
    await database.delete('booklist', where: 'id=?', whereArgs: [id]);
  }

  static Future<List<BookList>> getAllBookLists(Database database) async {
    final List<Map<String, dynamic>> bookListMaps =
        await database.query('book');
    List<BookList> bookLists =
        bookListMaps.map((e) => BookList.fromMap(e)).toList();

    for (BookList bookList in bookLists) {
      bookList.books =
          await BookService.getBooksByListId(database, bookList.id);
    }

    return bookLists;
  }

  static Future<BookList> getBookListById(Database database, int id) async {
    final rows =
        await database.query('booklist', where: 'id=?', whereArgs: [id]);

    Map<String, dynamic> row = rows.first;

    BookList bookList = BookList.fromMap(row);

    bookList.books = await BookService.getBooksByListId(database, bookList.id);

    return bookList;
  }
}
