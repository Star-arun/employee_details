import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'employee_model.dart';
import 'package:meta/meta.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final Box<Employee> employeeBox;

  EmployeeCubit(this.employeeBox) : super(EmployeeInitial());

  void addEmployee(Employee employee) {
    employeeBox.add(employee);
    emit(EmployeeLoaded(employeeBox.values.toList()));
  }

  void loadEmployees() {
    emit(EmployeeLoaded(employeeBox.values.toList()));
  }

//   void deleteEmployee(int index) {
//   employeeBox.deleteAt(index); // Deletes employee from Hive
//   emit(EmployeeLoaded(employeeBox.values.toList())); // Updates UI
// }

void deleteEmployee(Employee employeeToDelete, context) {
  final employees = employeeBox.values.toList();
  final employeeIndex = employees.indexWhere((e) =>
      e.name == employeeToDelete.name &&
      e.role == employeeToDelete.role &&
      e.startDate == employeeToDelete.startDate &&
      e.endDate == employeeToDelete.endDate);

  if (employeeIndex != -1) {
    employeeBox.deleteAt(employeeIndex); 
    emit(EmployeeLoaded(employeeBox.values.toList()));  
      final snackBar =   SnackBar(
      content: const Text("Employee data has been deleted"),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: "Undo",textColor: 
         Colors.blue,
        onPressed: () {
          restoreEmployee(employeeToDelete); 
        },
      ),
    
  );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

void restoreEmployee(Employee employee) {
  employeeBox.add(employee); 
  emit(EmployeeLoaded(employeeBox.values.toList()));
}

void updateEmployee(Employee oldEmployee, Employee updatedEmployee) {
  final employees = employeeBox.values.toList();
  final index = employees.indexWhere((e) =>
      e.name == oldEmployee.name &&
      e.role == oldEmployee.role &&
      e.startDate == oldEmployee.startDate &&
      e.endDate == oldEmployee.endDate);

  if (index != -1) {
    employeeBox.putAt(index, updatedEmployee); 
    emit(EmployeeLoaded(employeeBox.values.toList())); 
  }
}
}