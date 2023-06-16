extension ListExtension<E> on List{
  E equalItem(bool test(E element), {E orElse()?}) {
    for (E element in this) {
      if (test(element)) return element;
    }
    if (orElse != null) return orElse();
    throw "IterableElementError.noElement()";
  }
}