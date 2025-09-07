import 'package:flutter/material.dart';

class FavoriteIcon extends StatefulWidget {
  final String productId;

  const FavoriteIcon({super.key, required this.productId});

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    // Optional: Call controller or backend update
    // controller.toggleFavorite(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      child: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.black,
        ),
        onPressed: toggleFavorite,
      ),
    );
  }
}
