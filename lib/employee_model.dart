import 'package:hive/hive.dart';
part 'employee_model.g.dart';

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final String role;
  
  @HiveField(2)
  final DateTime startDate;
  
  @HiveField(3)
  final DateTime? endDate;

  Employee({
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });
}