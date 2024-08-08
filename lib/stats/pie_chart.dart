import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:right_premium_brain/database.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  late List<Level> pieData;
  late List<int> temp;

  Future<List<int>> getCount() async {
    List<dynamic> tempData = await DatabaseService().getLevelCount();
    return tempData.map((item) => item as int).toList();
  }

  void generateData() {
    pieData = [
      Level("Easy", temp[0], Colors.green),
      Level("Moderate", temp[1], Colors.yellow),
      Level("Hard", temp[2], Colors.orange),
      Level("Insane", temp[3], Colors.red),
    ];
  }

  @override
  void initState() {
    super.initState();
    temp = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: FutureBuilder<List<int>>(
            future: getCount(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                if (snapshot.hasData) {
                  temp = snapshot.data!;
                  generateData();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Current level",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: PieChart(
                            PieChartData(
                              sections: pieData.map((data) {
                                return PieChartSectionData(
                                  color: data.colorval,
                                  value: data.levelValue.toDouble(),
                                  title: '${data.levelValue}',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffffffff),
                                  ),
                                );
                              }).toList(),
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                            ),
                            swapAnimationDuration: const Duration(seconds: 2),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class Level {
  String level;
  int levelValue;
  Color colorval;

  Level(this.level, this.levelValue, this.colorval);
}
