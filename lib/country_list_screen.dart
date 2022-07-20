import 'package:apitest/country.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({Key? key}) : super(key: key);

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  Future<List<Country>> getAllCountries() async {
    const url = 'https://countriesnow.space/api/v0.1/countries/flag/images';

    var response = await http.get(Uri.parse(url));

    var jsonData = response.body;

    var parsingData = json.decode(jsonData);

    var jsonArray = parsingData['data'];

    List<Country> countries = [];

    for (var jsonCountry in jsonArray) {
      Country country =
          Country(name: jsonCountry['name'], flag: jsonCountry['flag']);
      countries.add(country);
    }

    return countries; // Country클래스 [name:Yemen, flag:korea]
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country List'),
      ),
      body: FutureBuilder<List<Country>>(
          // future : 값을 불러오는 곳
          // snapshot : 값을 불러온 곳에 데이터
          future: getAllCountries(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Country> countries = snapshot.data!;
              return ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    Country country = countries[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.network(
                            country.flag,
                            width: 80,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              country.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            }
          }),
    );
  }
}
