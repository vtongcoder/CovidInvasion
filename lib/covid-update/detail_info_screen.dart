import 'package:covid_invasion/localization/lang_constant.dart';

import 'custom_widgets/fade_in.dart';
import 'custom_widgets/header_view.dart';
import 'custom_widgets/k_loader_indicator.dart';
import 'custom_widgets/statistic_card.dart';
import 'network_covid/display_data_model.dart';
import 'network_covid/covid_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailInfoScreen extends StatefulWidget {
  // static const routeName = '/detail-info';

  const DetailInfoScreen({
    Key key,
  }) : super(key: key);

  @override
  _DetailInfoScreenState createState() => _DetailInfoScreenState();
}

class _DetailInfoScreenState extends State<DetailInfoScreen> {
  bool _isLoading = true;
  bool _isInit = true;

  String _updatedAt;
  String _selectedRegion = '';

  DisplayDataModel _currentData = DisplayDataModel();
  DisplayDataModel _yesterdayData = DisplayDataModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      _updateData();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    _selectedRegion = context.watch<CovidData>().selectedRegion;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  HeaderView(
                    imagePath: 'assets/images/virus_fighting.png',
                    headlineText: 'Together',
                    detailsText: 'we fight.',
                    gradientColors: [Colors.orange.shade200, Colors.deepOrange.shade400],
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              // SizedBox(),
              Text(
                _selectedRegion == 'Global' ? getTranslated(context, 'detailinfo.titleForGlobal') : getTranslated(context, 'detailinfo.title') + ' $_selectedRegion',
                style: Theme.of(context).textTheme.headline5,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: getTranslated(context, 'covidupdate.updatedAt') + ' $_updatedAt',
                    style: Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).accentColor),
                  ),
                ]),
              ),
              _currentData.affectedCountries > 0
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 4.0,
                        child: ListTile(
                          leading: Icon(Icons.sentiment_very_dissatisfied),
                          title: Text(getTranslated(context, 'detailinfo.affectedCountriesNo')),
                          trailing: Text(
                            '${_currentData.affectedCountries}',
                            style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              FadeIn(
                1.0,
                StatisticCard(
                  color: Colors.orange,
                  text: getTranslated(context, 'covidupdate.cases'),
                  icon: Icons.timeline,
                  currentData: _currentData.cases,
                  previousData: _yesterdayData.cases,
                ),
              ),
              FadeIn(
                1.5,
                StatisticCard(
                  color: Colors.green,
                  text: getTranslated(context, 'covidupdate.recovered'),
                  icon: Icons.verified_user,
                  currentData: _currentData.recovered,
                  previousData: _yesterdayData.recovered,
                ),
              ),
              FadeIn(
                2.0,
                StatisticCard(
                  color: Colors.red,
                  text: getTranslated(context, 'covidupdate.death'),
                  icon: Icons.airline_seat_individual_suite,
                  currentData: _currentData.deaths,
                  previousData: _yesterdayData.deaths,
                ),
              ),
              FadeIn(
                2.5,
                StatisticCard(
                  color: Colors.blue,
                  text: getTranslated(context, 'detailinfo.activeCases'),
                  icon: Icons.whatshot,
                  currentData: _currentData.active,
                  previousData: _yesterdayData.active,
                ),
              ),
              FadeIn(
                3.0,
                StatisticCard(
                  color: Colors.black,
                  text: getTranslated(context, 'detailinfo.criticalCases'),
                  icon: Icons.battery_alert,
                  currentData: _currentData.critical,
                  previousData: _yesterdayData.critical,
                ),
              ),
              FadeIn(
                3.5,
                StatisticCard(
                  color: Colors.blueGrey,
                  text: getTranslated(context, 'detailinfo.totalTest'),
                  icon: Icons.youtube_searched_for,
                  currentData: _currentData.tests,
                  previousData: _yesterdayData.tests,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateData() {
    final covidData = Provider.of<CovidData>(context, listen: false);
    // _isLoading = true;
    // if (_currentData.updatedAt != null) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // } else {
    _currentData = covidData.currentCovidData;
    _yesterdayData = covidData.yesterdayCovidData;
    _updatedAt = covidData.convertToDate(covidData.currentCovidData.updatedAt);
    setState(() {});
    // }
  }
}
