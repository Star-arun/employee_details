import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import 'add_edit_employee_screen.dart';
import 'employee_cubit.dart';
import 'employee_model.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(EmployeeAdapter()); 
   final employeeBox = await Hive.openBox<Employee>('employeeBox');

  // runApp(EmployeeListApp(employeeBox: employeeBox));
  runApp(
    BlocProvider(
      create: (context) => EmployeeCubit(employeeBox)..loadEmployees(),
      child: const EmployeeListApp(),
    ),
  );
}


class EmployeeListApp extends StatelessWidget {
  const EmployeeListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const EmployeeListScreen(),
    );
  }
}

//===========================new
class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoaded) {
            final currentEmployees = state.employees.where((e) => e.endDate == null).toList();
            final previousEmployees = state.employees.where((e) => e.endDate != null).toList();

            return currentEmployees.isEmpty && previousEmployees.isEmpty ? Center(child: 
            // Text('No employees found')
            Image.asset("assets/nodata.png",scale: 4,)
            
            )  : ListView(
              children: [
                _buildSectionTitle('Current Employees'),
                ...currentEmployees.map((emp) => _buildEmployeeTile(emp, context)),

                _buildSectionTitle('Previous Employees'),
                ...previousEmployees.map((emp) => _buildEmployeeTile(emp, context)),

                const SizedBox(height: 20),
                const Center(child: Text('Swipe left to delete', style: TextStyle(color: Colors.grey))),
              ],
            );
          } else if (state is EmployeeInitial) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return  Center(child: 
            // Text('No employees found')
            Image.asset("assets/nodata.png")
            
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
          );
        },
        backgroundColor: Colors.blue,elevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
    );
  }

  Widget _buildEmployeeTile(Employee employee, BuildContext context) {
    String dateText = employee.endDate == null
        ? 'From ${DateFormat('d MMM, yyyy').format(employee.startDate)}'
        : '${DateFormat('d MMM, yyyy').format(employee.startDate)} - ${DateFormat('d MMM, yyyy').format(employee.endDate!)}';

    return Slidable(
       key: ValueKey('${employee.name}-${employee.startDate}'),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
                context.read<EmployeeCubit>().deleteEmployee(employee,context);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_forever_outlined,
          ),
        ],
      ),
      child: GestureDetector(
         onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEmployeeScreen(employee: employee), 
          ),
        );
      },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white,border: Border(bottom:BorderSide(width: 1,color: Colors.black12),)),
             child:  Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                 Text(employee.name,style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                 const SizedBox(
                  height: 4,
                 ),
                Text(employee.role, style: const TextStyle(color: Colors.grey,fontSize: 14)),
                 const SizedBox(
                  height: 4,
                 ),
                Text(dateText, style: const TextStyle(color: Colors.grey,fontSize: 14)),
              ],
            ),
             ),
        
        ),
      ),
    );
  }
}