/// ```
/// NOTE
///
/// This file is now obsolete.
/// All functionality represented here has been ported to [select_laundry_page.dart]
/// and implemented there.
/// - Emmanuel Aliyu
/// ```

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_hire/model/hire_agent_model.dart';
import 'package:Ohstel_app/hostel_hire/model/laundry_basket_model.dart';
import 'package:Ohstel_app/hostel_hire/model/laundry_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");

class LaundryOptionPopUp extends StatefulWidget {
  final LaundryBookingModel laundryDetails;
  final HireWorkerModel hireWorkerDetails;

  LaundryOptionPopUp({
    @required this.laundryDetails,
    @required this.hireWorkerDetails,
  });

  @override
  _LaundryOptionPopUpState createState() => _LaundryOptionPopUpState();
}

class _LaundryOptionPopUpState extends State<LaundryOptionPopUp> {
  String dropdownValue = 'Wash Only';
  int unitValue = 1;

  Future<void> saveToBasket() async {
    LaundryBookingBasketModel laundry = LaundryBookingBasketModel(
      clothTypes: widget.laundryDetails.clothTypes,
      imageUrl: widget.laundryDetails.imageUrl,
      units: unitValue,
      laundryMode: dropdownValue,
      price: price(),
      laundryPersonName: widget.hireWorkerDetails.userName,
      laundryPersonEmail: widget.hireWorkerDetails.workerEmail,
      laundryPersonUniName: widget.hireWorkerDetails.uniName,
      laundryPersonPhoneNumber: widget.hireWorkerDetails.workerPhoneNumber,
    );
    print(laundry.toMap());

    await HiveMethods().saveLaundryToBasketCart(data: laundry.toMap());
    Navigator.pop(context);
  }

  int price() {
    int laundryModeAndPrice =
        widget.laundryDetails.laundryModeAndPrice[dropdownValue] ?? 0;
    print(laundryModeAndPrice);
    int currentSelectedPrice = laundryModeAndPrice * unitValue;

    print('($laundryModeAndPrice * $unitValue)');
    print(currentSelectedPrice);
    return currentSelectedPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.laundryDetails.clothTypes.toUpperCase()}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 1.0, color: Colors.black),
          dropDown(),
          unitController(),
          priceWidget(),
          addToCartButton(),
        ],
      ),
    );
  }

  Widget addToCartButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Theme.of(context).primaryColor,
      onPressed: () {
        saveToBasket();
      },
      child: Text(
        'Add To Basket',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget priceWidget() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Text(
        'Price: NGN ${price()}',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget unitController() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: InkWell(
              child: Icon(Icons.remove),
              onTap: () {
                if (unitValue > 1) {
                  setState(() {
                    unitValue--;
                  });
                }
              },
            ),
          ),
          SizedBox(width: 20),
          Text('$unitValue'),
          SizedBox(width: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: InkWell(
              child: Icon(Icons.add),
              onTap: () {
                if (unitValue < 99) {
                  setState(() {
                    unitValue++;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDown() {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: DropdownButton(
          underline: SizedBox(),
          value: dropdownValue,
          items: [
            DropdownMenuItem(
              child: Text("Wash Only"),
              value: 'Wash Only',
            ),
            DropdownMenuItem(
              child: Text("Wash And Iron"),
              value: 'Wash and Iron',
            ),
            DropdownMenuItem(
              child: Text("Dry Clean"),
              value: 'Dry Clean',
            ),
            DropdownMenuItem(
              child: Text("Iron Only"),
              value: 'Iron Only',
            ),
          ],
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
            });
          }),
    );
  }
}
