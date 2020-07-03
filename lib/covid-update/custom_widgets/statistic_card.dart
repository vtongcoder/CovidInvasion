import 'package:flutter/material.dart';

import '../network_covid/network_call.dart';
import '../utils/calc_growth.dart';

class StatisticCard extends StatefulWidget {
  final String text;
  // final int stats;
  final Color color;
  final IconData icon;
  final int currentData;
  final int previousData;

  const StatisticCard({
    Key key,
    this.text,
    // this.stats,
    this.color,
    this.icon,
    this.currentData,
    this.previousData,
  }) : super(key: key);

  @override
  _StatisticCardState createState() => _StatisticCardState();
}

class _StatisticCardState extends State<StatisticCard> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = calculateGrowthPercentage(widget.currentData, widget.previousData);
    final bool isRecovered = (widget.color == Colors.green);
    final int different = widget.currentData - widget.previousData;
    final String caseDiff = different > 0 ? '+${different.toString().replaceAllMapped(reg, mathFunc)}' : '${different.toString().replaceAllMapped(reg, mathFunc)}';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),

      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  widget.color,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/virus.png'),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.text,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        Text(
                          widget.currentData.toString().replaceAllMapped(reg, mathFunc),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold, fontSize: 24, color: Theme.of(context).primaryColor).copyWith(
                                color: Colors.white,
                              ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      widget.icon,
                      size: 80.0,
                      color: widget.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 50,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  colors: [
                    widget.color.withOpacity(0.1),
                    Colors.white54,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              height: 48,
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      showGrowthIcon(widget.currentData, widget.previousData, isRecovered),
                      Text('$percentage%'),
                    ],
                  ),
                  Text(
                    '$caseDiff',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // ),
    );
  }
}
