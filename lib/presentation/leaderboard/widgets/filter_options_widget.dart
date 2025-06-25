import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterOptionsWidget extends StatefulWidget {
  final int currentTab;
  final VoidCallback onFilterApplied;

  const FilterOptionsWidget({
    super.key,
    required this.currentTab,
    required this.onFilterApplied,
  });

  @override
  State<FilterOptionsWidget> createState() => _FilterOptionsWidgetState();
}

class _FilterOptionsWidgetState extends State<FilterOptionsWidget> {
  bool _showFilters = false;
  String _selectedTimeFilter = 'all';
  String _selectedFormatFilter = 'all';
  bool _showOnlyFriends = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _getTabTitle(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'filter_list',
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: _showFilters ? 'expand_less' : 'expand_more',
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_showFilters) _buildFilterOptions(),
      ],
    );
  }

  String _getTabTitle() {
    switch (widget.currentTab) {
      case 0:
        return 'Current Round Progress';
      case 1:
        return 'Tournament Leaderboard';
      case 2:
        return 'Friends Leaderboard';
      default:
        return 'Leaderboard';
    }
  }

  Widget _buildFilterOptions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.currentTab == 1) ...[
            Text(
              'Time Period',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              children: [
                _buildFilterChip('All Time', 'all', _selectedTimeFilter),
                _buildFilterChip('This Month', 'month', _selectedTimeFilter),
                _buildFilterChip('This Week', 'week', _selectedTimeFilter),
              ],
            ),
            SizedBox(height: 2.h),
          ],
          Text(
            'Format',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            children: [
              _buildFilterChip('All Formats', 'all', _selectedFormatFilter),
              _buildFilterChip('Stroke Play', 'stroke', _selectedFormatFilter),
              _buildFilterChip('Match Play', 'match', _selectedFormatFilter),
              _buildFilterChip('Skins', 'skins', _selectedFormatFilter),
            ],
          ),
          if (widget.currentTab != 2) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                Switch(
                  value: _showOnlyFriends,
                  onChanged: (value) {
                    setState(() {
                      _showOnlyFriends = value;
                    });
                  },
                ),
                SizedBox(width: 2.w),
                Text(
                  'Show only friends',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedTimeFilter = 'all';
                      _selectedFormatFilter = 'all';
                      _showOnlyFriends = false;
                    });
                    widget.onFilterApplied();
                  },
                  child: const Text('Clear All'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFilters = false;
                    });
                    widget.onFilterApplied();
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String selectedValue) {
    final isSelected = selectedValue == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (label.contains('Time')) {
            _selectedTimeFilter = value;
          } else {
            _selectedFormatFilter = value;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodySmall!.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
