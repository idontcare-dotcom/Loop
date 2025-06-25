import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class RoundDetail extends StatelessWidget {
  final int roundId;
  const RoundDetail({super.key, required this.roundId});

  @override
  Widget build(BuildContext context) {
    // In a real app this data would come from a backend using [roundId].
    final Map<String, dynamic> round = {
      'courseName': 'Pebble Beach Golf Links',
      'date': 'March 15, 2024',
      'score': 78,
      'par': 72,
    };

    final List<Map<String, int>> holes = List.generate(18, (index) {
      final par = [4,4,5,4,3,4,5,4,4,4,3,5,4,4,3,5,4,4][index];
      final score = [4,5,5,4,3,5,5,4,4,4,3,5,4,5,3,5,4,4][index];
      return {
        'hole': index + 1,
        'par': par,
        'score': score,
      };
    });

    int totalScore = holes.fold(0, (sum, h) => sum + h['score']!);
    int totalPar = holes.fold(0, (sum, h) => sum + h['par']!);
    int toPar = totalScore - totalPar;

    Color scoreColor;
    if (toPar < 0) {
      scoreColor = Theme.of(context).colorScheme.primary;
    } else if (toPar > 0) {
      scoreColor = Theme.of(context).colorScheme.error;
    } else {
      scoreColor = Theme.of(context).colorScheme.onSurface;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Round Detail'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              // Share round details
            },
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'edit',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              // Edit round
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          round['courseName'] as String,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          round['date'] as String,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                              ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Text(
                              'Score: $totalScore',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.8.h),
                              decoration: BoxDecoration(
                                color: scoreColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                toPar == 0
                                    ? 'E'
                                    : toPar > 0
                                        ? '+$toPar'
                                        : '$toPar',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: scoreColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Hole Scores',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: holes.length,
                  itemBuilder: (context, index) {
                    final hole = holes[index];
                    final diff = hole['score']! - hole['par']!;
                    final Color color = diff < 0
                        ? Theme.of(context).colorScheme.primary
                        : diff > 0
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.onSurface;
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0.5.h),
                      title: Text('Hole ${hole['hole']}'),
                      subtitle: Text('Par ${hole['par']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${hole['score']}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.4.h),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              diff == 0
                                  ? 'E'
                                  : diff > 0
                                      ? '+$diff'
                                      : '$diff',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
