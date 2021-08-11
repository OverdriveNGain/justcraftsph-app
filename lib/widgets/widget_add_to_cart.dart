import 'package:flutter/material.dart';

class AddToCart extends StatelessWidget {
  AddToCart({
    this.btnIcon = Icons.add_shopping_cart_rounded,
    this.message = 'Add to Cart',
    this.enabled = true,
    this.func,
    this.toast = "Item added to cart!"
  });

  final String message;
  final bool enabled;
  final String toast;
  final Function func;
  final IconData btnIcon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(btnIcon,
                color: enabled ? Colors.white : Colors.grey[400]),
            SizedBox(width: 10.0),
            Text(message,
                style: TextStyle(
                    fontSize: 25.0,
                    color: enabled ? Colors.white : Colors.grey[400],
                    fontWeight: FontWeight.bold)),
          ],
        ),
        onPressed: (enabled)
            ? () {func();}
            : null);
  }
}
