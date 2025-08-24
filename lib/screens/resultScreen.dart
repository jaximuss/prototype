import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultScreen extends StatelessWidget {
  final String summary;
  final List<String> possibleConditions;
  final String recommendation;
  final Map<String, double> scores;

  const ResultScreen({
    Key? key,
    required this.summary,
    required this.possibleConditions,
    required this.recommendation,
    required this.scores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Assessment Results"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Assessment Summary",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(summary, style: const TextStyle(color: Colors.white70)),

            const SizedBox(height: 24),
            Text(
              "Symptom Analysis",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white),
            ),

            // Radar Chart
            SizedBox(height: 250, child: RadarChart(_buildRadarData())),

            const SizedBox(height: 24),
            const Text("Possible Conditions",
                style: TextStyle(color: Colors.white)),
            ...possibleConditions.map((c) => ListTile(
              leading:
              const Icon(Icons.bubble_chart, color: Colors.blueAccent),
              title: Text(c, style: const TextStyle(color: Colors.white)),
            )),

            const SizedBox(height: 24),
            const Text("Recommendation",
                style: TextStyle(color: Colors.white)),
            Text(recommendation, style: const TextStyle(color: Colors.white70)),

            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple),
              child: const Text("Back to Chat"),
            )
          ],
        ),
      ),
    );
  }

  RadarChartData _buildRadarData() {
    final labels = scores.keys.toList();
    final values = scores.values.toList();

    return RadarChartData(
      radarBackgroundColor: Colors.transparent,
      borderData: FlBorderData(show: false),
      radarShape: RadarShape.polygon,
      getTitle: (index, angle) {
        return RadarChartTitle(
          text: labels[index],
        );
      },
      dataSets: [
        RadarDataSet(
          dataEntries: values.map((v) => RadarEntry(value: v)).toList(),
          fillColor: Colors.purpleAccent.withOpacity(0.3),
          borderColor: Colors.purpleAccent,
          entryRadius: 3,
          borderWidth: 2,
        ),
      ],
    );
  }
}
