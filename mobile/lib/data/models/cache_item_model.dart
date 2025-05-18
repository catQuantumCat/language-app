class CacheItemModel<T> {
  final String key;
  final T value;
  final DateTime expiration;

  CacheItemModel({
    required this.key,
    required this.value,
    required this.expiration,
  });
}
