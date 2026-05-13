import 'dart:math' as math;

import 'package:flutter/material.dart';

class WeatherShowcaseScreen extends StatelessWidget {
  const WeatherShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const pagePadding = EdgeInsets.fromLTRB(24, 18, 24, 28);

    return Scaffold(
      backgroundColor: const Color(0xFFE9EEF2),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF4F7FA), Color(0xFFE4EBF0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final showWideLayout = constraints.maxWidth >= 980;

              return SingleChildScrollView(
                padding: pagePadding,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: showWideLayout
                        ? const _WideWeatherLayout()
                        : const _CompactWeatherLayout(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WideWeatherLayout extends StatelessWidget {
  const _WideWeatherLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 12,
          child: _MainForecastCard(),
        ),
        SizedBox(width: 28),
        Expanded(
          flex: 11,
          child: Column(
            children: [
              _HourlyForecastPanel(compact: false),
              SizedBox(height: 28),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 220,
                  child: _MiniForecastCard(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompactWeatherLayout extends StatelessWidget {
  const _CompactWeatherLayout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MainForecastCard(),
        SizedBox(height: 22),
        _HourlyForecastPanel(compact: true),
        SizedBox(height: 22),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 220,
            child: _MiniForecastCard(),
          ),
        ),
      ],
    );
  }
}

class _MainForecastCard extends StatelessWidget {
  const _MainForecastCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 760),
      padding: const EdgeInsets.fromLTRB(26, 20, 26, 26),
      decoration: _glassCardDecoration(radius: 30),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopBar(),
          SizedBox(height: 18),
          _CityHeader(),
          SizedBox(height: 34),
          _CurrentWeatherRow(),
          SizedBox(height: 26),
          Text(
            'Cloudy conditions from 1AM-9AM, with\nshowers expected at 9AM.',
            style: TextStyle(
              fontSize: 17,
              height: 1.3,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 22),
          _DividerLine(),
          SizedBox(height: 20),
          _HourlyStrip(),
          SizedBox(height: 38),
          _WeekLabel(),
          SizedBox(height: 16),
          _DividerLine(opacity: 0.14),
          SizedBox(height: 14),
          _WeeklyForecastList(),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.menu_rounded, color: Colors.white, size: 31),
        Spacer(),
        Text(
          '9:41',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 0.2,
          ),
        ),
        Spacer(),
        Icon(Icons.add_rounded, color: Colors.white, size: 35),
      ],
    );
  }
}

class _CityHeader extends StatelessWidget {
  const _CityHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Center(
          child: Text(
            'London',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
        SizedBox(height: 4),
        Center(
          child: Text(
            'Mon. June 22, 9:41 AM',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xECFFFFFF),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrentWeatherRow extends StatelessWidget {
  const _CurrentWeatherRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.cloudy_snowing, color: Colors.white, size: 31),
                  SizedBox(width: 10),
                  Text(
                    'Rainy',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                '15°',
                style: TextStyle(
                  fontSize: 126,
                  height: 0.85,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 18),
        Padding(
          padding: EdgeInsets.only(top: 48),
          child: _TemperatureRange(
            high: '21°',
            low: '12°',
            height: 128,
          ),
        ),
      ],
    );
  }
}

class _HourlyStrip extends StatelessWidget {
  const _HourlyStrip();

  static const _items = [
    _HourForecastItem('NOW', '15°', Icons.cloudy_snowing),
    _HourForecastItem('10am', '16°', Icons.cloudy_snowing),
    _HourForecastItem('11am', '17°', Icons.grain),
    _HourForecastItem('12am', '18°', Icons.grain),
    _HourForecastItem('1pm', '19°', Icons.grain),
    _HourForecastItem('2pm', '20°', Icons.wb_cloudy_outlined),
    _HourForecastItem('3pm', '21°', Icons.thunderstorm_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 152,
      child: Stack(
        children: [
          Positioned.fill(
            top: 22,
            bottom: 40,
            child: CustomPaint(
              painter: _CurvePainter(),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _items
                .map(
                  (item) => Expanded(
                    child: _HourColumn(item: item),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _HourColumn extends StatelessWidget {
  const _HourColumn({required this.item});

  final _HourForecastItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          item.temperature,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          width: 4,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(235),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        Text(
          item.label,
          style: const TextStyle(
            color: Color(0xE8FFFFFF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Icon(item.icon, color: Colors.white, size: 26),
      ],
    );
  }
}

class _WeekLabel extends StatelessWidget {
  const _WeekLabel();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20),
        SizedBox(width: 10),
        Text(
          'NEXT 7 DAYS',
          style: TextStyle(
            color: Color(0xF4FFFFFF),
            fontSize: 17,
            letterSpacing: 0.3,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _WeeklyForecastList extends StatelessWidget {
  const _WeeklyForecastList();

  static const _days = [
    _DailyForecastItem('Tue', '80%', '16°', Icons.cloudy_snowing),
    _DailyForecastItem('Wed', '60%', '17°', Icons.grain),
    _DailyForecastItem('Thu', '20%', '18°', Icons.wb_sunny_outlined),
    _DailyForecastItem('Fri', '', '19°', Icons.wb_cloudy_outlined),
    _DailyForecastItem('Sat', '', '19°', Icons.wb_cloudy_outlined),
    _DailyForecastItem('Sun', '20%', '20°', Icons.thunderstorm_outlined),
    _DailyForecastItem('Mon', '', '18°', Icons.wb_cloudy_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _days
            .map(
              (day) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    children: [
                      Text(
                        day.day,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        day.rainChance,
                        style: const TextStyle(
                          color: Color(0xCFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Icon(day.icon, color: Colors.white, size: 27),
                      const Spacer(),
                      Text(
                        day.temperature,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _HourlyForecastPanel extends StatelessWidget {
  const _HourlyForecastPanel({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(compact ? 18 : 24, 16, compact ? 18 : 24, 18),
      decoration: _glassCardDecoration(radius: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.navigation, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text(
                'London',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 14 : 12),
          const _HourlyStrip(),
        ],
      ),
    );
  }
}

class _MiniForecastCard extends StatelessWidget {
  const _MiniForecastCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 16, 18),
      decoration: _glassCardDecoration(radius: 28),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.navigation, color: Colors.white, size: 15),
              SizedBox(width: 6),
              Text(
                'London',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '15°',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  height: 0.9,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: _TemperatureRange(
                  high: '21°',
                  low: '12°',
                  height: 76,
                  compact: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.cloudy_snowing, color: Colors.white, size: 25),
              SizedBox(width: 8),
              Text(
                'Rainy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemperatureRange extends StatelessWidget {
  const _TemperatureRange({
    required this.high,
    required this.low,
    required this.height,
    this.compact = false,
  });

  final String high;
  final String low;
  final double height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Text(
            high,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 20 : 22,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                low,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 18 : 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: compact ? 4 : 5,
                height: compact ? 50 : 80,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(240),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine({this.opacity = 0.2});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.white.withOpacity(opacity),
    );
  }
}

BoxDecoration _glassCardDecoration({required double radius}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: const LinearGradient(
      colors: [Color(0xFF688A9C), Color(0xFFA9BFCC)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    boxShadow: const [
      BoxShadow(
        color: Color(0x24000000),
        blurRadius: 28,
        offset: Offset(0, 18),
      ),
    ],
  );
}

class _CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = [
      Offset(0, size.height * 0.72),
      Offset(size.width * 0.16, size.height * 0.68),
      Offset(size.width * 0.34, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.52),
      Offset(size.width * 0.67, size.height * 0.44),
      Offset(size.width * 0.84, size.height * 0.36),
      Offset(size.width, size.height * 0.3),
    ];

    path.moveTo(points.first.dx, points.first.dy);

    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final control = Offset(
        (current.dx + next.dx) / 2,
        math.min(current.dy, next.dy) - 4,
      );
      path.quadraticBezierTo(control.dx, control.dy, next.dx, next.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HourForecastItem {
  const _HourForecastItem(this.label, this.temperature, this.icon);

  final String label;
  final String temperature;
  final IconData icon;
}

class _DailyForecastItem {
  const _DailyForecastItem(
    this.day,
    this.rainChance,
    this.temperature,
    this.icon,
  );

  final String day;
  final String rainChance;
  final String temperature;
  final IconData icon;
}
