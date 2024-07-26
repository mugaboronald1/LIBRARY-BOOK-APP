import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EditBookPage extends StatefulWidget {
  final Map<String, dynamic> book;
  final Function(Map<String, dynamic>) onSave;

  EditBookPage({required this.book, required this.onSave});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController descriptionController;
  late TextEditingController coverUrlController;
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.book['title']);
    authorController = TextEditingController(text: widget.book['author']);
    descriptionController =
        TextEditingController(text: widget.book['description']);
    coverUrlController = TextEditingController(text: widget.book['coverUrl']);
    rating = widget.book['rating'];
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    descriptionController.dispose();
    coverUrlController.dispose();
    super.dispose();
  }

  void _save() {
    final updatedBook = {
      'title': titleController.text,
      'author': authorController.text,
      'coverUrl': coverUrlController.text,
      'description': descriptionController.text,
      'rating': rating,
      'read': widget.book['read'], // Keep read status unchanged
    };
    widget.onSave(updatedBook);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Book'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: authorController,
              decoration: InputDecoration(labelText: 'Author'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            TextField(
              controller: coverUrlController,
              decoration: InputDecoration(labelText: 'Cover URL'),
            ),
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
