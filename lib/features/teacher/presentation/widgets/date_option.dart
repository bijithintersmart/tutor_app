import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateOption extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool hasAvailability;
  final VoidCallback onTap;

  const DateOption({
    super.key,
    required this.date,
    required this.isSelected,
    required this.hasAvailability,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hasAvailability ? onTap : null,
      child: Card(
        elevation: isSelected ? 4 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainer,
        child: Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('MMM').format(date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : hasAvailability
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('dd').format(date),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color:
                      isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : hasAvailability
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                hasAvailability ? Icons.check_circle : Icons.cancel,
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : hasAvailability
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
