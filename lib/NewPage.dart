import 'package:book_app/add_book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_book_page.dart'; // Import the edit book page

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final List<Map<String, dynamic>> books = [
    {
      'title': 'Give and Take',
      'author': 'Adam Grant',
      'coverUrl': 'Assets/Images/Give and Take.jpg',
      'description':
          'A groundbreaking look at how success is driven by how we interact with others.',
      'rating': 0.0,
      'read': false,
    },
    {
      'title': 'Daily Stoic',
      'author': 'Ryan Holiday',
      'coverUrl': 'Assets/Images/daily stoic.jpg',
      'description':
          '366 meditations on wisdom, perseverance, and the art of living.',
      'rating': 0.0,
      'read': false,
    },
    {
      'title': 'Boundaries',
      'author': 'Henry Cloud',
      'coverUrl': 'Assets/Images/boundraries.jpg',
      'description':
          'When to say yes, how to say no to take control of your life.',
      'rating': 0.0,
      'read': false,
    },
    {
      'title': 'When the Moon Split',
      'author': 'Safiur Rahman Mubarakpuri',
      'coverUrl': 'Assets/Images/When the moon split.jpg',
      'description': 'A biography of Prophet Muhammad (PBUH).',
      'rating': 0.0,
      'read': false,
    },
  ];

  List<Map<String, dynamic>> filteredBooks = [];
  TextEditingController searchController = TextEditingController();
  String _sortBy = 'title'; // Default sorting option

  @override
  void initState() {
    super.initState();
    _loadSortingPreference();
    filteredBooks = books;
    searchController.addListener(() {
      filterBooks();
    });
  }

  void _loadSortingPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sortBy = prefs.getString('sort_by') ?? 'title';
      _sortBooks();
    });
  }

  void _saveSortingPreference(String sortBy) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sort_by', sortBy);
  }

  void filterBooks() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        return book['title']!.toLowerCase().contains(query) ||
            book['author']!.toLowerCase().contains(query);
      }).toList();
      _sortBooks();
    });
  }

  void toggleReadStatus(int index) {
    setState(() {
      filteredBooks[index]['read'] = !filteredBooks[index]['read'];
    });
  }

  void updateRating(int index, double rating) {
    setState(() {
      filteredBooks[index]['rating'] = rating;
    });
  }

  void _sortBooks() {
    setState(() {
      if (_sortBy == 'title') {
        filteredBooks.sort((a, b) => a['title'].compareTo(b['title']));
      } else if (_sortBy == 'author') {
        filteredBooks.sort((a, b) => a['author'].compareTo(b['author']));
      } else if (_sortBy == 'rating') {
        filteredBooks.sort((a, b) => b['rating'].compareTo(a['rating']));
      }
    });
  }

  void _editBook(int index) async {
    final updatedBook = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookPage(
          book: filteredBooks[index],
          onSave: (book) {
            setState(() {
              filteredBooks[index] = book;
            });
          },
        ),
      ),
    );

    if (updatedBook != null) {
      setState(() {
        filteredBooks[index] = updatedBook;
      });
    }
  }

  void _deleteBook(int index) {
    setState(() {
      filteredBooks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title or author',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: _sortBy,
                  items: [
                    DropdownMenuItem(value: 'title', child: Text('Title')),
                    DropdownMenuItem(value: 'author', child: Text('Author')),
                    DropdownMenuItem(value: 'rating', child: Text('Rating')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sortBy = value;
                        _saveSortingPreference(value);
                        _sortBooks();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: filteredBooks.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final book = filteredBooks[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  book['coverUrl']!,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 80,
                ),
              ),
              title: Text(
                book['title']!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['author']!,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    book['description']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 5),
                  RatingBar.builder(
                    initialRating: book['rating']!,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      updateRating(index, rating);
                    },
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: book['read']!,
                        onChanged: (bool? value) {
                          toggleReadStatus(index);
                        },
                      ),
                      Text(
                        book['read']! ? 'Read' : 'Unread',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                _editBook(index);
              },
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmation(index);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBookPage(
                onSave: (book) {
                  setState(() {
                    filteredBooks.add(book);
                    _sortBooks(); // Ensure the new book is sorted
                  });
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Book',
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Book'),
          content: Text('Are you sure you want to delete this book?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteBook(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
