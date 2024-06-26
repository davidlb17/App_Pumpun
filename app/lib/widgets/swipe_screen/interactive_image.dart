import 'package:app/controllers/database/bookList_service.dart';
import 'package:app/controllers/database/book_service.dart';
import 'package:app/controllers/database/sqlite_service.dart';
import 'package:app/data/dummy/dummy_brais.dart';
import 'package:app/models/book.dart';
import 'package:app/models/booklist.dart';
import 'package:app/models/enums.dart';
import 'package:app/widgets/swipe_screen/book_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class InteractiveImage extends StatelessWidget {
  InteractiveImage({super.key, required this.controller});

  CardSwiperController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
        future: BookService.getAllBooks(SQLiteService.database!),
        builder: (context, snapshot) {
          //placeholder while charging
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error state
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Book> allBooks = [];
            for (Book book in snapshot.data!) {
              allBooks.add(book);
            }
            return Scaffold(
              body: Expanded(
                child: CardSwiper(
                  controller: controller,
                  cardsCount: allBooks.length,
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) {
                    return Container(
                        child: BookLayout(
                      book: allBooks[index],
                    ));
                  },
                  numberOfCardsDisplayed: 2,
                  //3 actions: update record, push that change to the database and add them to a list if necessary

                  //TOFIX: all books are updated at once with the update of each
                  onSwipe: (previousIndex, currentIndex, direction) async {
                    if (direction == CardSwiperDirection.left) {
                      print('${allBooks[previousIndex].title} was disliked');
                      allBooks[previousIndex].record = Record.disliked;
                      BookService.updateBook(
                          SQLiteService.database!, allBooks[previousIndex]);
                    }
                    if (direction == CardSwiperDirection.top) {
                      print('${allBooks[previousIndex].title} was skipped');
                      allBooks[previousIndex].record = Record.none;
                      BookService.updateBook(
                          SQLiteService.database!, allBooks[previousIndex]);
                    }
                    if (direction == CardSwiperDirection.right) {
                      print('${allBooks[previousIndex].title} was liked');
                      allBooks[previousIndex].record = Record.liked;
                      BookService.updateBook(
                          SQLiteService.database!, allBooks[previousIndex]);
                      //TODO add the book to the user defaultLists[0]
                    }
                    if (direction == CardSwiperDirection.bottom) {
                      print(
                          '${allBooks[previousIndex].title} was mark as reading');
                      allBooks[previousIndex].record = Record.read;
                      BookService.updateBook(
                          SQLiteService.database!, allBooks[previousIndex]);
                      //TODO add the book to the user defaultLists[1]
                    }
                    return true;
                  },
                ),
              ),
            );
          }
        });
  }
}
