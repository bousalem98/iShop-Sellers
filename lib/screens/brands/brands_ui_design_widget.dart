import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishop_sellers/components/global.dart';
import 'package:ishop_sellers/components/snackbar.dart';
import 'package:ishop_sellers/models/brands.dart';
import 'package:ishop_sellers/screens/items/items_screen.dart';

class BrandsUiDesignWidget extends StatefulWidget {
  Brands? model;
  BuildContext? context;

  BrandsUiDesignWidget({
    this.model,
    this.context,
  });

  @override
  State<BrandsUiDesignWidget> createState() => _BrandsUiDesignWidgetState();
}

class _BrandsUiDesignWidgetState extends State<BrandsUiDesignWidget> {
  deleteBrandDialog(String brandUniqueID, String brandTitle) {
    return showDialog(
        context: context,
        builder: (context) {
          String brandTitle2;
          brandTitle.isEmpty ? brandTitle2 = "this" : brandTitle2 = brandTitle;
          return SimpleDialog(
            title: Text(
              'Do you want really delete "$brandTitle2" brand ?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              const SizedBox(
                height: 20,
              ),
              SimpleDialogOption(
                onPressed: () async {
                  deleteBrand(brandUniqueID);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "No",
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  deleteBrand(String brandUniqueID) {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("brands")
        .doc(brandUniqueID)
        .delete();

    showSnackBar(context, "Brand Deleted.");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemsScreen(
                      model: widget.model,
                    )));
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 180,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.network(
                      widget.model!.thumbnailUrl.toString(),
                      //height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.model!.brandTitle.toString(),
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 3,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteBrandDialog(widget.model!.brandID.toString(),
                              widget.model!.brandTitle.toString());
                        },
                        icon: const Icon(
                          Icons.delete_sweep,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
