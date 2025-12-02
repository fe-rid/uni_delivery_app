import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String role; // 'student' or 'runner'
  final String? profileImageUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, phone, role, profileImageUrl, createdAt];
}

