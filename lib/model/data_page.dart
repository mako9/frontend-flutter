class DataPage<E> {
  final List<E> content;
  final bool isFirstPage;
  final bool isLastPage;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;

  const DataPage({
    required this.content,
    required this.isFirstPage,
    required this.isLastPage,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
  });

  factory DataPage.emptyPage() {
    return DataPage(
        content: List<E>.empty(),
        isFirstPage: true,
        isLastPage: true,
        pageNumber: 0,
        pageSize: 0,
        totalElements: 0,
        totalPages: 0,
    );
  }

  factory DataPage.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) convert) {
    final content = json['content'] as List;
    final parsedContent = content.map((e) => convert(e)).toList().cast<E>();
    return DataPage(
      content: parsedContent,
      isFirstPage: json['firstPage'],
      isLastPage: json['lastPage'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }
}