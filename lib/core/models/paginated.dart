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

  int get totalPages => (total / pageSize).ceil();
  bool get hasNextPage => pageNum < totalPages;
  bool get hasPreviousPage => pageNum > 1;
}
