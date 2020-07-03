// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Timeseries chart example
// EXCLUDE_FROM_GALLERY_DOCS_START
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:covid_invasion/localization/lang_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'network_covid/covid_data.dart';

class SimpleTimeSeriesChart extends StatefulWidget {
  // final List<charts.Series> seriesList;
  // final bool animate;

  // SimpleTimeSeriesChart(this.seriesList, {this.animate});

  @override
  _SimpleTimeSeriesChartState createState() => _SimpleTimeSeriesChartState();
}

class _SimpleTimeSeriesChartState extends State<SimpleTimeSeriesChart> {
  List<charts.Series<CovidTimelineData, DateTime>> seriesList = [];

  bool _isInit = true;
  // final configAxis = DateTimeAxisSpecWorkaround();

  Future<void> updateCovidHistoryData(BuildContext context) async {
    final covidData = Provider.of<CovidData>(context, listen: false);

    List<CovidTimelineData> _historyCases = [];
    List<CovidTimelineData> _historyDeaths = [];
    List<CovidTimelineData> _historyRecovered = [];

    covidData.historyData.cases.forEach((key, value) {
      _historyCases.add(CovidTimelineData(DateFormat('MM/dd/yy').parse(key), value));
    });
    covidData.historyData.deaths.forEach((key, value) {
      _historyDeaths.add(CovidTimelineData(DateFormat('MM/dd/yy').parse(key), value));
    });
    covidData.historyData.recovered.forEach((key, value) {
      _historyRecovered.add(CovidTimelineData(DateFormat('MM/dd/yy').parse(key), value));
    });

    seriesList.add(
      charts.Series<CovidTimelineData, DateTime>(
        id: getTranslated(context, 'covidupdate.cases'),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (CovidTimelineData timelineData, _) => timelineData.time,
        measureFn: (CovidTimelineData timelineData, _) => timelineData.number / 1000,
        data: _historyCases,
      ),
    );
    seriesList.add(
      charts.Series<CovidTimelineData, DateTime>(
        id: getTranslated(context, 'covidupdate.recovered'),
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (CovidTimelineData timelineData, _) => timelineData.time,
        measureFn: (CovidTimelineData timelineData, _) => timelineData.number / 1000,
        data: _historyRecovered,
      ),
    );
    seriesList.add(
      charts.Series<CovidTimelineData, DateTime>(
        id: getTranslated(context, 'covidupdate.death'),
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (CovidTimelineData timelineData, _) => timelineData.time,
        measureFn: (CovidTimelineData timelineData, _) => timelineData.number / 1000,
        data: _historyDeaths,
      ),
    );
  }

  Future<bool> getHistoryData() async {
    await updateCovidHistoryData(context);
    return true;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      // await getHistoryData();
      await updateCovidHistoryData(context);
    }
    _isInit = false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: true,

      defaultRenderer: charts.LineRendererConfig(
        includeArea: true,
        includePoints: true,
        stacked: false,
      ),
      behaviors: [
        charts.PanAndZoomBehavior(),
        charts.SeriesLegend(
          position: charts.BehaviorPosition.bottom,
          desiredMaxRows: 3,
          showMeasures: true,
          horizontalFirst: false,

          outsideJustification: charts.OutsideJustification.endDrawArea,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          // Set show measures to true to display measures in series legend,
          // when the datum is selected.
          measureFormatter: (num value) {
            return value == null ? '-' : '${(value).toStringAsFixed(3)}k';
          },
        ),
      ],

      /// Customize the measure axis to have 2 ticks,
      primaryMeasureAxis: charts.NumericAxisSpec(tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 5)),

      domainAxis: charts.DateTimeAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 60,
          tickLengthPx: 5,
        ),
        viewport: charts.DateTimeExtents(
          start: seriesList[0].data[0].time,
          end: seriesList[0].data[0].time.add(
                Duration(days: seriesList[0].data.length - 10),
              ),
        ),
        tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
          day: new charts.TimeFormatterSpec(format: 'd', transitionFormat: 'MM/dd/yy'),
        ),
      ),
    );
  }
}

class CovidTimelineData {
  final DateTime time;
  final int number;

  CovidTimelineData(this.time, this.number);
}

class DateTimeAxisSpecWorkaround extends DateTimeAxisSpec {
  const DateTimeAxisSpecWorkaround({
    RenderSpec<DateTime> renderSpec,
    DateTimeTickProviderSpec tickProviderSpec,
    DateTimeTickFormatterSpec tickFormatterSpec,
    bool showAxisLine,
  }) : super(renderSpec: renderSpec, tickProviderSpec: tickProviderSpec, tickFormatterSpec: tickFormatterSpec, showAxisLine: showAxisLine);

  @override
  configure(charts.Axis<DateTime> axis, ChartContext context, GraphicsFactory graphicsFactory) {
    super.configure(axis, context, graphicsFactory);
    axis.autoViewport = false;
  }
}
