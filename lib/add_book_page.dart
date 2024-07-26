import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddBookPage extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSave;

  AddBookPage({required this.onSave});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  double _rating = 0.0;
  bool _read = false;
  bool _isDarkMode = false; // Local state for dark mode

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = _isDarkMode
        ? ThemeData.dark().copyWith(
            appBarTheme: AppBarTheme(
              color: Colors.black,
              titleTextStyle: TextStyle(color: Colors.white),
            ),
          )
        : ThemeData.light().copyWith(
            appBarTheme: AppBarTheme(
              color: Colors.blue,
              titleTextStyle: TextStyle(color: Colors.white),
            ),
          );

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add New Book'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.brightness_7 : Icons.brightness_2),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: _coverUrlController,
                decoration: InputDecoration(labelText: 'Cover URL'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: _read,
                    onChanged: (bool? value) {
                      setState(() {
                        _read = value ?? false;
                      });
                    },
                  ),
                  Text('Read'),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  final newBook = {
                    'title': _titleController.text,
                    'author': _authorController.text,
                    'coverUrl': _coverUrlController.text,
                    'description': _descriptionController.text,
                    'rating': _rating,
                    'read': _read,
                  };
                  widget.onSave(newBook);
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
