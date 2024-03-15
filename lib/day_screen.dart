import 'package:community_charts_flutter/community_charts_flutter.dart'
as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'data_source.dart';
import 'models/time_series.dart';

class DayScreen extends StatelessWidget {
  const DayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<WeatherChartData>(
          future: context.read<DataSource>().getChartData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            final variables = snapshot.data!.daily!;
            charts.DateTimeAxisSpec(
              tickFormatterSpec: charts.BasicDateTimeTickFormatterSpec(
                    (datetime) => DateFormat("E").format(datetime),
              ),
            );

            final axisColor = charts.MaterialPalette.yellow.shadeDefault;
            charts.Color minTemp = charts.ColorUtil.fromDartColor(
                Color.fromRGBO(32, 150, 229, 1.0));
            charts.Color maxTemp = charts.ColorUtil.fromDartColor(
                Color.fromRGBO(229, 68, 32, 1.0));

            return charts.TimeSeriesChart(
              [
                charts.Series<TimeSeriesDatum, DateTime>(
                  id: 'Max',
                  domainFn: (datum, _) => datum.domain,
                  measureFn: (datum, _) => datum.measure,
                  colorFn: (datum, _) => maxTemp,
                  data: variables
                      .singleWhere(
                          (variable) => variable.name == "temperature_2m_max")
                      .values,
                ),
                charts.Series<TimeSeriesDatum, DateTime>(
                  id: 'Min',
                  domainFn: (datum, _) => datum.domain,
                  measureFn: (datum, _) => datum.measure,
                  colorFn: (datum, _) => minTemp,
                  data: variables
                      .singleWhere(
                          (variable) => variable.name == "temperature_2m_min")
                      .values,
                ),
              ],

              /// Assign a custom style for the domain axis. x-axis
              domainAxis: charts.DateTimeAxisSpec(
                tickFormatterSpec: charts.BasicDateTimeTickFormatterSpec(
                        (datetime) {
                      // Define Danish day names
                      List<String> danishDayNames = ['man', 'tir', 'ons', 'tor', 'fre', 'lør', 'søn'];

                      // Get the day of the week index (0 for Monday, 1 for Tuesday, etc.)
                      int dayOfWeekIndex = datetime.weekday - 1;

                      // Get the corresponding Danish day name
                      String danishDayName = danishDayNames[dayOfWeekIndex];

                      return danishDayName;
                    }
                ),
                renderSpec: charts.SmallTickRendererSpec(
                  // Tick and Label styling here.
                  labelStyle: charts.TextStyleSpec(color: axisColor),
                  // Change the line colors to match text color.
                  lineStyle: charts.LineStyleSpec(color: axisColor),
                ),
              ),


              /// Assign a custom style for the measure axis. y-axis
              primaryMeasureAxis: charts.NumericAxisSpec(
                tickProviderSpec: charts.BasicNumericTickProviderSpec(desiredTickCount: 6), // Adjust the desiredTickCount as needed

                renderSpec: charts.GridlineRendererSpec(
                  // Tick and Label styling here.
                  labelStyle: charts.TextStyleSpec(color: axisColor),
                  // Change the line colors to match text color.
                  lineStyle: charts.LineStyleSpec(color: axisColor),
                ),
              ),

              animate: true,
              defaultRenderer: charts.LineRendererConfig(includePoints: true),
              dateTimeFactory: const charts.LocalDateTimeFactory(),
              behaviors: [
                charts.SeriesLegend(),
                charts.ChartTitle(
                  "Temperatur",
                  titleStyleSpec: charts.TextStyleSpec(
                    color: charts.MaterialPalette.pink.shadeDefault,
                  ),
                )
              ],
            );
          },
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
