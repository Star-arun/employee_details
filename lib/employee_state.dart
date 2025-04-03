part of 'employee_cubit.dart';

@immutable
abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  EmployeeLoaded(this.employees);
}
