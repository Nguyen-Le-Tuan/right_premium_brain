import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:right_premium_brain/database.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget(LineChartData lineChartData, {super.key});

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  String? name;
  Color? avatarColor;

  List<FlSpot>? lineData;
  Future<List<double>>? avgScoresFuture;

  void generateData(List<double> avgScores) {
    lineData = [];
    for (int i = 0; i < avgScores.length; i++) {
      lineData!.add(FlSpot(i.toDouble(), avgScores[i]));
    }
  }

  @override
  void initState() {
    super.initState();
    avatarColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    avgScoresFuture = DatabaseService().getAvgScore().then((avgScores) {
      if (avgScores != null) {
        return avgScores.cast<double>();
      } else {
        return <double>[]; // return an empty list if avgScores is null
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: FutureBuilder<List<double>>(
              future: avgScoresFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  generateData(snapshot.data!);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("15 days average score",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: LineChart(
                                LineChartData(
                                  minX: 0,
                                  maxX: lineData?.length.toDouble() ?? 0,
                                  minY: 0,
                                  maxY: snapshot.data?.reduce((max, score) => score > max ? score : max) ?? 0,
                                  gridData: FlGridData(
                                    show: true,
                                    getDrawingHorizontalLine: (value) => const FlLine(
                                      color: Color(0xFF868E96),
                                      strokeWidth: 1,
                                    ),
                                    getDrawingVerticalLine: (value) => const FlLine(
                                      color: Color(0xFF868E96),
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                    border: Border.all(color: Colors.grey),
                                    show: true,
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        interval: 3,
                                        getTitlesWidget: (value, meta) => Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, meta) => Text(
                                          value.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: lineData!,
                                      isCurved: false, // adjust for line style
                                      color: Colors.blue,
                                      barWidth: 2,
                                      belowBarData: BarAreaData(
                                        show: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return Container(
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
