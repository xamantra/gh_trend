/// Enum for github trending date range.
enum GhTrendDateRange {
  today,
  thisWeek,
  thisMonth,
}

/// Transform the date range enum into url parameter. Only uses internally by the package.
String ghDateRangeValue(GhTrendDateRange from) {
  switch (from) {
    case GhTrendDateRange.today:
      return 'daily';
    case GhTrendDateRange.thisWeek:
      return 'weekly';
    case GhTrendDateRange.thisMonth:
      return 'monthly';
  }
}

/// Transform the date range enum into proper label. Can be used for UI.
String ghDateRangeLabel(GhTrendDateRange from) {
  switch (from) {
    case GhTrendDateRange.today:
      return 'Today';
    case GhTrendDateRange.thisWeek:
      return 'This week';
    case GhTrendDateRange.thisMonth:
      return 'This month';
  }
}
