import 'package:flutter/material.dart';
import 'package:ishop_sellers/models/items.dart';
import 'package:ishop_sellers/screens/items/items_details_screen.dart';

class ItemsUiDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemsUiDesignWidget({
    this.model,
    this.context,
  });

  @override
  State<ItemsUiDesignWidget> createState() => _ItemsUiDesignWidgetState();
}

class _ItemsUiDesignWidgetState extends State<ItemsUiDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsDetailsScreen(
          model: widget.model,
        )));
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.network(
                    widget.model!.thumbnailUrl.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  widget.model!.itemInfo.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
