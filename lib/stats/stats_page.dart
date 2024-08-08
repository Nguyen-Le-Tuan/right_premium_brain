import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:right_premium_brain/database.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late LineChart _lineChart;
  late PieChart _pieChart;

  late List count;
  String btnDeckText = "Total Decks";
  String btnCardText = "Total Cards";
  void getTotal() async {
    count = await DatabaseService().getTotalCount();
  }

  void totalDeck() {
    if (!mounted) return;
    setState(() {
      btnDeckText =
          (btnDeckText == "Total Decks") ? count[0].toString() : "Total Decks";
    });
  }

  void totalCard() {
    if (!mounted) return;
    setState(() {
      btnCardText =
          (btnCardText == "Total Cards") ? count[1].toString() : "Total Cards";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pieChart = PieChart(PieChartData());
    _lineChart = LineChart(LineChartData());
    getTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            "Statistics",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.orange, backgroundColor: Colors.orange.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          onPressed: totalDeck,
                          child: Text(btnDeckText),
                        ),

                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green, backgroundColor: Colors.green.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          onPressed: totalCard,
                          child: Text(btnCardText),
                        ),

                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _lineChart,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _pieChart,
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
