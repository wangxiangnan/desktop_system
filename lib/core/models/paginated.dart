/// Generic paginated result wrapper
class Paginated<T> {
  final List<T> rows;
  final int total;
  final int pageNum;
  final int pageSize;

  const Paginated({
    required this.rows,
    required this.total,
    required this.pageNum,
    required this.pageSize,
  });

  double get totalPages => total / pageSize;
  bool get hasNextPage => pageNum < totalPages;
  bool get hasPreviousPage => pageNum > 1;
}
