import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Maps Autocomplete Example'),
        ),
        body: PlaceAutocomplete(),
      ),
    );
  }
}

class PlaceAutocomplete extends StatefulWidget {
  @override
  _PlaceAutocompleteState createState() => _PlaceAutocompleteState();
}

class _PlaceAutocompleteState extends State<PlaceAutocomplete> {
  TextEditingController _searchController = TextEditingController();
  List<String> _predictions = [];

  Future<void> _fetchPredictions(String input) async {
    const apiKey =
        ''; // Replace with your API key
    final endpoint =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&key=$apiKey';

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'];

      setState(() {
        _predictions = predictions
            .map((prediction) => prediction['description'])
            .cast<String>()
            .toList();
        print(_predictions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) {
            if (value.isNotEmpty) {
              _fetchPredictions(value);
            } else {
              setState(() {
                _predictions.clear();
              });
            }
          },
          decoration: const InputDecoration(
            labelText: 'Search for a place',
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _predictions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_predictions[index]),
                onTap: () {
                  // Handle the selected place
                  print('Selected place: ${_predictions[index]}');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
