class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  
  // CAMBIO 1: Definir errors como Lista dinámica (puede ser List<String> o List<Object>)
  final List<dynamic>? errors;

  ApiResponse({
    required this.success, 
    this.message, 
    this.data, 
    this.errors
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] as T?,
      
      // CAMBIO 2: Parsear como Lista.
      // Si json['errors'] es null, asignamos null.
      // Si viene una lista (aunque esté vacía), la copiamos.
      errors: json['errors'] != null 
        ? List<dynamic>.from(json['errors']) 
        : null,
    );
  }
}