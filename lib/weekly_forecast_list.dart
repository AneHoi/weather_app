import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';
import 'chart_screen.dart';
import 'models.dart';

class WeeklyForecastList extends StatelessWidget {
  final WeeklyForecastDto weeklyForecast;

  const WeeklyForecastList({super.key, required this.weeklyForecast});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final daily = weeklyForecast.daily!;
          final date = DateTime.parse(daily.time![index]);
          final weatherCode = WeatherCode.fromInt(daily.weatherCode![index]);
          final tempMax = daily.temperature2MMax![index];
          final tempMin = daily.temperature2MMin![index];
          final sunrise = getTime(daily.sunrise![index]);
          final sunset = getTime(daily.sunset![index]);

          return GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder:
                          (context) => ChartScreen(),
                          //(context) => DayScreen()
                  )
              );

            },
            child: Card(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: <Color>[
                                Colors.grey[800]!,
                                Colors.transparent
                              ],
                            ),
                          ),
                          child: BoxedIcon(
                            WeatherIcons.fromString(weatherCode.icon,
                                fallback: WeatherIcons.na),
                            size: 70,
                          ),

                          // child: Image.asset(
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        Center(
                          child: Text(
                            date.day.toString(),
                            style: textTheme.displayMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            weekdayAsString(date),
                            style: textTheme.headlineMedium,
                          ),
                          SizedBox(
                            height: 20.0,
                            child: Row(children: <Widget>[
                              Image.asset(
                                'assets/images/sunrise.png',
                                fit: BoxFit.cover,
                              ),
                              //Text(weatherCode.description),
                              Text('$sunrise'),
                              Image.asset(
                                'assets/images/sunset.png',
                                fit: BoxFit.cover,
                              ),
                              //Text(weatherCode.description),
                              Text('$sunset'),

                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: <Widget>[
                      Text('Min: $tempMin °C'),
                      Text(
                        'Max $tempMax °C',
                        style: textTheme.titleMedium,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: 7,
      ),
    );
  }

  String weekdayAsString(DateTime time) {
    return switch (time.weekday) {
      DateTime.monday => 'Mandag',
      DateTime.tuesday => 'Tirsdag',
      DateTime.wednesday => 'Onsdag',
      DateTime.thursday => 'Torsdag',
      DateTime.friday => 'Fredag',
      DateTime.saturday => 'Lørdag',
      DateTime.sunday => 'Søndag',
      _ => ''
    };
  }

  getTime(String dateString) {
    // Parse the string to DateTime
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime to get the time
    String formattedTime = DateFormat.Hm().format(dateTime);

    return formattedTime; // Output: HH:MM
  }
}
