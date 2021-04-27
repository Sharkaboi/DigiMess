extension ListExtensions<T> on List<T> {
  T takeFirstOrNull() {
    if (this.isEmpty) {
      return null;
    } else {
      return this.first;
    }
  }

  ListResult<T> splitWhere(bool Function(T element) matchFunction) {
    final listMatch = ListResult<T>();
    for (final element in this) {
      if (matchFunction(element)) {
        listMatch.matched.add(element);
      } else {
        listMatch.unmatched.add(element);
      }
    }
    return listMatch;
  }
}

class ListResult<T> {
  List<T> matched = <T>[];
  List<T> unmatched = <T>[];
}
