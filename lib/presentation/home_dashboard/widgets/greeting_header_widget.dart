import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './weather_widget.dart';

class GreetingHeaderWidget extends StatelessWidget {
  final String userName;
  final String location;
  final String weather;

  const GreetingHeaderWidget({
    super.key,
    required this.userName,
    required this.location,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final timeOfDay = DateTime.now().hour;
    String greeting;

    if (timeOfDay < 12) {
      greeting = 'Good Morning';
    } else if (timeOfDay < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting,',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(179),
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      userName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                  ],
                ),
              ),
              // Replace static weather display with WeatherWidget
              const WeatherWidget(),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                location,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(153),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
