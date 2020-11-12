import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  ImageTile({
    this.imageUrl = 'https://via.placeholder.com/120x160.png',
    this.title = '',
    this.subTitle = '',
    this.onEdit,
  });

  final String imageUrl;
  final String title;
  final String subTitle;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          // 3 : 4
          minWidth: 45,
          minHeight: 60,
          maxWidth: 60,
          maxHeight: 80,
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(title),
      subtitle: Text(subTitle),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: onEdit,
      ),
    );
  }
}
