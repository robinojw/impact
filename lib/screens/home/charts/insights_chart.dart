/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:impact/models/user.dart';

class InsightsChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  InsightsChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory InsightsChart.loadData(List<Emission> emissions) {
    return new InsightsChart(
      _createData(emissions),

      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
        labelAnchor: charts.TickLabelAnchor.centered,
        labelJustification: charts.TickLabelJustification.inside,
      )),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      defaultRenderer: charts.LineRendererConfig(
        includePoints: true,
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<Emission, DateTime>> _createData(
      List<Emission> emissions) {
    final data = emissions;

    return [
      new charts.Series<Emission, DateTime>(
        id: 'Emission',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        patternColorFn: (_, __) => charts.MaterialPalette.white,
        domainFn: (Emission emission, _) => emission.time,
        measureFn: (Emission emission, _) => emission.ghGas,
        data: data,
      )
    ];
  }
}
