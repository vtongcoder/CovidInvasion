import 'package:admob_flutter/admob_flutter.dart';
import 'package:covid_invasion/admob/admob_service.dart';
import 'package:covid_invasion/covid-update/simple-chart.dart';
import 'package:covid_invasion/localization/lang_constant.dart';
import 'package:covid_invasion/routes/route_name_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/fade_in.dart';
import 'custom_widgets/header_view.dart';
import 'custom_widgets/k_loader_indicator.dart';
import 'custom_widgets/statistic_card.dart';
import 'network_covid/connectivity_check.dart';
import 'network_covid/covid_data.dart';
import 'utils/search_delegate.dart';

class CovidUpdate extends StatefulWidget {
  CovidUpdate({Key key}) : super(key: key);

  @override
  _CovidUpdateState createState() => _CovidUpdateState();
}

class _CovidUpdateState extends State<CovidUpdate> {
  static const _globalStr = 'Global';

  String _selectedRegion;

  bool _isLoading = false;
  bool _isGettingHistoryData = false;
  bool _fetchDataError = false;
  String _errorMsg = '';

  String _updatedAt;
  bool _isInit = true;

  List<Map<String, String>> _countriesListWithNameAndFlag = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _updateData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final scaffold = Scaffold.of(context);

    return Scaffold(
      body: SafeArea(
        top: false,
        child: _isLoading
            ? KLoader()
            : _fetchDataError
                ? buildErrorMessage(_errorMsg)
                : WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: RefreshIndicator(
                      onRefresh: () => _refreshAllData(context),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Card(
                                  elevation: 1,
                                  shadowColor: Colors.black54,
                                  margin: const EdgeInsets.only(top: 70.0, bottom: 20.0, left: 30.0, right: 30),
                                  child: Column(
                                    children: <Widget>[
                                      Text(getTranslated(context, 'covidupdate.chartTitle')),
                                      Container(
                                        height: MediaQuery.of(context).size.height / 2,
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10.0),
                                        child: _isGettingHistoryData ? Center(child: CircularProgressIndicator()) : SimpleTimeSeriesChart(),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 30,
                                  left: 14,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    color: Colors.black,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  padding: const EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Theme.of(context).backgroundColor,
                                      )),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Consumer<CovidData>(
                                          builder: (context, data, _) {
                                            //NOTE Dropdown list
                                            return DropdownButton(
                                              isExpanded: true,
                                              elevation: 16,
                                              underline: SizedBox(),
                                              style: TextStyle(color: Theme.of(context).primaryColor),
                                              icon: SvgPicture.asset('assets/icons/dropdown.svg'),
                                              value: _selectedRegion,
                                              items: _countriesListWithNameAndFlag
                                                  .map((rCountry) => DropdownMenuItem(
                                                        value: rCountry['country'],
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            Container(
                                                              width: 32,
                                                              height: 32,
                                                              child: rCountry['country'] == _globalStr
                                                                  ? SvgPicture.asset(
                                                                      'assets/icons/global.svg',
                                                                    )
                                                                  : Image.network(rCountry['flag']),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Expanded(
                                                                child: Text(
                                                              rCountry['country'],
                                                              overflow: TextOverflow.fade,
                                                              style: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).accentColor),
                                                            )),
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                              //NOTE country selected dropdown
                                              onChanged: (value) async {
                                                if (value == _globalStr) {
                                                  try {
                                                    await _getGlobalData();
                                                    await _getHistoryInfo();
                                                  } catch (e) {}
                                                } else {
                                                  try {
                                                    await _getCountryInfo(value);
                                                    await _getHistoryInfo(rCountryName: value);
                                                  } catch (e) {}
                                                }
                                                setState(() {
                                                  _selectedRegion = value;
                                                  updateSelectedRegion(_selectedRegion);
                                                });
                                              },
                                            );
                                          },
                                          //
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.search),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () async {
                                    final result = await showSearch(context: context, delegate: Search(countriesListWithNameAndFlag: _countriesListWithNameAndFlag));
                                    if (result.toString().isNotEmpty) {
                                      setState(() {
                                        _selectedRegion = result.toString();
                                        updateSelectedRegion(_selectedRegion);
                                        if (_selectedRegion.contains(_globalStr)) {
                                          _getGlobalData();
                                        } else
                                          _getCountryInfo(_selectedRegion);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: getTranslated(context, 'covidupdate.caseUpdate') + '\n',
                                        style: Theme.of(context).textTheme.headline6,
                                      ),
                                      TextSpan(
                                        text: getTranslated(context, 'covidupdate.updatedAt') + ' $_updatedAt',
                                        style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.grey.shade700, fontSize: 12),
                                      ),
                                    ]),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      print('D/Show details of $_selectedRegion');
                                      Navigator.of(context).pushNamed(covidDetailsInfo);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Consumer<CovidData>(
                              builder: (ctx, data, _) => FadeIn(
                                1,
                                StatisticCard(
                                  color: Colors.orange,
                                  text: getTranslated(context, 'covidupdate.cases'),
                                  icon: Icons.timeline,
                                  currentData: data.currentCovidData.cases,
                                  previousData: data.yesterdayCovidData.cases,
                                ),
                              ),
                            ),
                            Consumer<CovidData>(
                              builder: (ctx, data, _) => FadeIn(
                                1.5,
                                StatisticCard(
                                  color: Colors.green,
                                  text: getTranslated(context, 'covidupdate.recovered'),
                                  icon: Icons.verified_user,
                                  currentData: data.currentCovidData.recovered,
                                  previousData: data.yesterdayCovidData.recovered,
                                ),
                              ),
                            ),
                            Consumer<CovidData>(
                              builder: (ctx, data, _) => FadeIn(
                                2.0,
                                StatisticCard(
                                  color: Colors.red,
                                  text: getTranslated(context, 'covidupdate.death'),
                                  icon: Icons.airline_seat_individual_suite,
                                  currentData: data.currentCovidData.deaths,
                                  previousData: data.yesterdayCovidData.deaths,
                                ),
                              ),
                            ),
                            context.watch<ConnectivityCheck>().isInternetAvailable
                                ? Center(
                                    // margin: EdgeInsets.only(bottom: 20.0),
                                    child: AdmobBanner(
                                      adUnitId: AdMobService().getBannerAdUnitId(),
                                      adSize: AdmobBannerSize.LARGE_BANNER,
                                      // listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                                      //   ams.handleEvent(event, args, 'Banner');
                                      // },
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  void _updateData() async {
    final covidData = Provider.of<CovidData>(context, listen: false);

    _countriesListWithNameAndFlag = covidData.countriesListWithNameAndFlag;
    _updatedAt = covidData.convertToDate(covidData.currentCovidData.updatedAt);

    setState(() {
      _selectedRegion = covidData.selectedRegion;
    });
  }

  //NOTE for Pull to Refresh data
  Future<void> _refreshAllData(BuildContext context) async {
    final covidData = Provider.of<CovidData>(context, listen: false);

    setState(() {
      _isLoading = true;
      _fetchDataError = false;
    });
    try {
      await covidData.refreshAllData();
      setState(() {
        _isLoading = false;
        _fetchDataError = false;
        _selectedRegion = covidData.selectedRegion;
      });
      _updatedAt = covidData.convertToDate(covidData.currentCovidData.updatedAt);
    } catch (e) {
      print('Got error');
      setState(() {
        // _isLoading = false;
        _fetchDataError = true;
      });
    }
  }

  Future<void> _getGlobalData() async {
    final covidData = Provider.of<CovidData>(context, listen: false);

    setState(() {
      _isLoading = true;
      _fetchDataError = false;
    });

    try {
      await covidData.fetchGlobalData();
      _updatedAt = covidData.convertToDate(covidData.currentCovidData.updatedAt);
      setState(() {
        _isLoading = false;
        _fetchDataError = false;
      });
    } catch (err) {
      print('Fetch global data got error: $err');
      setState(() {
        _isLoading = false;
        _fetchDataError = true;
        _errorMsg = 'Check internet connection then try again!';
      });
      throw err;
    }
  }

  Future<void> _getCountryInfo(String rCountryName) async {
    setState(() {
      _isLoading = true;
      _fetchDataError = false;
    });
    try {
      final covidData = Provider.of<CovidData>(context, listen: false);
      await covidData.fetchCountryData(rCountryName);

      _updatedAt = covidData.convertToDate(covidData.currentCovidData.updatedAt);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _fetchDataError = true;
      });
    }
  }

  Future<void> _getHistoryInfo({String rCountryName}) async {
    print('Get history data from changed country');
    _isGettingHistoryData = true;
    final covidData = Provider.of<CovidData>(context, listen: false);
    if (rCountryName == null) {
      try {
        await covidData.getGlobalHistoryData();
        setState(() {
          _isGettingHistoryData = false;
        });
      } catch (e) {
        // _isGettingHistoryData = false;
      }
    } else
      try {
        await covidData.getCountryHistoryData(rCountryName);

        setState(() {
          _isGettingHistoryData = false;
        });
      } catch (e) {
        // _isGettingHistoryData = false;
      }
  }

  //STUB Widgets

  SnackBar showMySnackBar(String rMessage) {
    Scaffold.of(context).hideCurrentSnackBar();
    return SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: Color(0x80000000),
      content: Text(
        rMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.yellow,
        ),
      ),
    );
  }

  Center buildErrorMessage(String rMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Unable to fetch data',
            style: Theme.of(context).textTheme.caption.copyWith(color: Colors.grey),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            rMessage.isNotEmpty ? '\"$rMessage\"' : '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: RaisedButton(
              color: Color(0x9806A4FF),
              textColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.arrow_back),
                  Text('Back to home'),
                ],
              ),
              shape: StadiumBorder(),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void updateSelectedRegion(String newSelectedRegion) {
    final covidData = Provider.of<CovidData>(context, listen: false);
    covidData.selectedRegion = newSelectedRegion;
  }
}
