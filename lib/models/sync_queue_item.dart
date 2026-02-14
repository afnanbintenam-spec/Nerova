// Note: Hive type adapters are optional for simple use cases
// Using JSON serialization instead for this implementation

class SyncQueueItem {
  final String id;
  final SyncOperation operation;
  final String endpoint;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  int retryCount;
  DateTime? lastAttempt;
  String? errorMessage;

  SyncQueueItem({
    required this.id,
    required this.operation,
    required this.endpoint,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
    this.lastAttempt,
    this.errorMessage,
  });

  SyncQueueItem copyWith({
    String? id,
    SyncOperation? operation,
    String? endpoint,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    int? retryCount,
    DateTime? lastAttempt,
    String? errorMessage,
  }) {
    return SyncQueueItem(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      endpoint: endpoint ?? this.endpoint,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastAttempt: lastAttempt ?? this.lastAttempt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operation': operation.name,
      'endpoint': endpoint,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'lastAttempt': lastAttempt?.toIso8601String(),
      'errorMessage': errorMessage,
    };
  }

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) {
    return SyncQueueItem(
      id: json['id'] as String,
      operation: SyncOperation.values.firstWhere(
        (e) => e.name == json['operation'],
      ),
      endpoint: json['endpoint'] as String,
      data: Map<String, dynamic>.from(json['data'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
      lastAttempt: json['lastAttempt'] != null
          ? DateTime.parse(json['lastAttempt'] as String)
          : null,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

enum SyncOperation { create, update, delete }
