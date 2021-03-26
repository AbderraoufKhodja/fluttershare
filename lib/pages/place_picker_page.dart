import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

class PlacePickerPage extends StatefulWidget {
  @override
  _PlacePickerPage createState() => _PlacePickerPage();
}

class _PlacePickerPage extends State<PlacePickerPage> {
  String countryValue;
  String stateValue;
  String cityValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country State and City Picker'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 600,
          child: Column(
            children: [
              SelectState(
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                  });
                },
              ),
              InkWell(
                  onTap: () {
                    print('country selected is $countryValue');
                    print('country selected is $stateValue');
                    print('country selected is $cityValue');
                  },
                  child: Text(' Check'))
            ],
          )),
    );
  }
}

Future<Map> showPlacePickerPage(context) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PlacePickerPage(),
    ),
  );
}
