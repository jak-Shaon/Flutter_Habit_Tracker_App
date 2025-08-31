class Quote {
  final String id;
  final String content;
  final String author;

  Quote({required this.id, required this.content, required this.author});

  static Quote fromMap(Map<String, dynamic> json) {
    return Quote(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      content: (json['content'] ?? json['q'] ?? '').toString(),
      author: (json['author'] ?? json['a'] ?? 'Unknown').toString(),
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'content': content, 'author': author};
}
