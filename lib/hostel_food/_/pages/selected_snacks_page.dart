import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_cart_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'cart_page.dart';

class SnackDialog extends StatefulWidget {
  final ItemDetails itemDetails;

  SnackDialog({
    @required this.itemDetails,
  });

  @override
  _SnackDialogState createState() => _SnackDialogState();
}

class _SnackDialogState extends State<SnackDialog> {
  Runes input = Runes('\u20a6');
  var symbol;
  int number = 1;

  int getTotal() {
    int _initialTotal = widget.itemDetails.price;
    return _initialTotal * number;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    symbol = String.fromCharCodes(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        actions: [
          IconButton(
            color: Colors.black87,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(
          children: <Widget>[
            widget.itemDetails.imageUrl != null
                ? Container(
                    margin: EdgeInsets.all(10.0),
                    height: 150,
                    width: double.infinity,
                    child: ExtendedImage.network(
                      widget.itemDetails.imageUrl,
                      fit: BoxFit.contain,
                      handleLoadingProgress: true,
                      shape: BoxShape.circle,
                      cache: false,
                      enableMemoryCache: true,
                    ),
                  )
                : Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
//                        padding: EdgeInsets.symmetric(horizontal: 1.5),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: number == 1 ? Colors.grey : Color(0xFFF27507),
                      ),
                    ),
                    child: InkWell(
                      child: Icon(
                        Icons.remove,
                        color: number == 1 ? Colors.grey : Color(0xFFF27507),
                      ),
                      onTap: () {
                        if (number > 1) {
                          if (mounted) {
                            setState(() {
                              number--;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  Text('$number'),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFF27507),
                      ),
                    ),
                    child: InkWell(
                      child: Icon(
                        Icons.add,
                        color: Color(0xFFF27507),
                      ),
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            number++;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${widget.itemDetails.itemName}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$symbol${widget.itemDetails.price}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${widget.itemDetails.shortDescription}',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$symbol${getTotal()}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: RaisedButton.icon(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(20),
                  onPressed: () {
                    Map map = FoodCartModel(
                      itemDetails: widget.itemDetails,
                      totalPrice: getTotal(),
                      numberOfPlates: number,
                    ).toMap();
                    HiveMethods().saveFoodCartToDb(map: map);
//              Navigator.maybePop(context);
                  },
                  color: Color(0xFFF27507),
                  label: Text(
                    "Add to Cart",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
