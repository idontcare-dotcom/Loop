import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import './custom_icon_widget.dart';

class ErrorBoundaryWidget extends StatefulWidget {
  final Widget child;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ErrorBoundaryWidget({
    super.key,
    required this.child,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<ErrorBoundaryWidget> createState() => _ErrorBoundaryWidgetState();
}

class _ErrorBoundaryWidgetState extends State<ErrorBoundaryWidget> {
  bool _hasError = false;
  String? _errorDetails;

  @override
  void initState() {
    super.initState();
    _hasError = false;
  }

  @override
  void didUpdateWidget(ErrorBoundaryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      setState(() {
        _hasError = false;
        _errorDetails = null;
      });
    }
  }

  void _handleError(dynamic error, StackTrace stackTrace) {
    setState(() {
      _hasError = true;
      _errorDetails = error.toString();
    });

    debugPrint('ErrorBoundary caught error: $error');
    debugPrint('StackTrace: $stackTrace');
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _errorDetails = null;
    });

    if (widget.onRetry != null) {
      widget.onRetry!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    return ErrorBoundary(
      onError: _handleError,
      child: widget.child,
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Card(
        elevation: 2,
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: Theme.of(context).colorScheme.error,
                size: 32,
              ),
              SizedBox(height: 2.h),
              Text(
                widget.errorMessage ?? 'Something went wrong',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'We encountered an error while loading this section.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(153),
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              ElevatedButton.icon(
                onPressed: _retry,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 18,
                ),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Function(dynamic, StackTrace)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  @override
  Widget build(BuildContext context) {
    try {
      return widget.child;
    } catch (error, stackTrace) {
      if (widget.onError != null) {
        widget.onError!(error, stackTrace);
      }
      // Return a fallback widget if error occurs during build
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Something went wrong'),
            const SizedBox(height: 8),
            Text(error.toString(), style: const TextStyle(fontSize: 12)),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Set up global error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      if (widget.onError != null && mounted) {
        widget.onError!(details.exception, details.stack ?? StackTrace.empty);
      }
    };
  }
}
