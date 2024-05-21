dynamic formatNumber(double number) {
  if (number % 1 == 0) {
    return number.toInt();
  } else {
    return number;
  }
}

int countNonNull(List<dynamic> values) {
  int count = 0;

  // Iterate through the list and check for non-null values
  for (var value in values) {
    if (value != null) {
      count++;
    }
  }
  return count;
}
