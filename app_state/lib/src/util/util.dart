extension ElementAtOrNull<E> on Iterable<E> {
  E? elementAtOrNullIncludingNegative(int i) {
    if (i < 0 || i >= length) {
      return null;
    }

    return elementAt(i);
  }
}

class Wrapper<T> {
  T value;

  Wrapper(this.value);
}
