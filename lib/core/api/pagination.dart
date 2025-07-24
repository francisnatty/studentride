// ignore_for_file: public_member_api_docs, sort_constructors_first
class Pagination {
  int page;
  int total;
  int size;
  String? search;
  Pagination({
    this.page = 0,
    this.total = 100,
    this.size = 10,
    this.search,
  });
  void reset() {
    page = 0;
    total = 0;
    search = null;
  }

  @override
  String toString() {
    return 'Pagination(page: $page, total: $total, size: $size, search: $search)';
  }
}
