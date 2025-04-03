import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'employee_cubit.dart';
import 'employee_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;
  const AddEmployeeScreen({super.key, this.employee});

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController nameController = TextEditingController();
  String selectedRole = 'Select role';
  DateTime? startDate;
  DateTime? endDate;

    DateTime? selectedDate;
    String selectDirectText = "";

 DateTime _focusedDay = DateTime.now();
 DateTime? _selectedDay;
     void showYearPicker(BuildContext context,DateTime focusedDay,setStateDialog,fromWhere) async {
    final selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(elevation: 0,
          child: SizedBox(
            height: 300,
            child: Theme(data: ThemeData(  colorScheme: const ColorScheme.light(
                                            primary: Colors.blueAccent,
                                            onPrimary: Colors.white, 
                                            onSurface: Colors.black, 
                                          ),),
              child: YearPicker(
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                initialDate: focusedDay,
                selectedDate: focusedDay,
                onChanged: (DateTime date) {
                  Navigator.pop(context, date.year);
                },
              ),
            ),
          ),
        );
      },
    );

    if (selectedYear != null) {
      if(fromWhere){

      setState(() {
        _focusedDay = DateTime(selectedYear, _focusedDay.month, _focusedDay.day);
        selectedDate = DateTime(selectedYear);
      });
       setStateDialog((){
       _focusedDay = DateTime(selectedYear, _focusedDay.month, _focusedDay.day);
        selectedDate = DateTime(selectedYear);
        selectDirectText = "";
    });
      }else{
         setState(() {
        _focusedDay = DateTime(selectedYear, _focusedDay.month, _focusedDay.day);
        selectedEndDate = DateTime(selectedYear);
      });
       setStateDialog((){
       _focusedDay = DateTime(selectedYear, _focusedDay.month, _focusedDay.day);
        selectedEndDate = DateTime(selectedYear);
        selectDirectEndText = "";
    });
      }
    }

   
  }


 void _showPopupDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
        return  Dialog(
          elevation: 0,insetPadding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _dateButton("Today", DateTime.now(),setStateDialog),
                          const SizedBox(
                            width: 8,
                          ),
                          _dateButton("Next Monday", _getNextMonday(),setStateDialog),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _dateButton("Next Tuesday", _getNextTuesday(),setStateDialog),
                            const SizedBox(
                            width: 8,
                          ),
                          _dateButton("After 1 week", DateTime.now().add(const Duration(days: 7)),setStateDialog),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 410,
                        child: Theme(
                          data: ThemeData(
                                          colorScheme: const ColorScheme.light(
                                            primary: Colors.blueAccent,
                                            onPrimary: Colors.white, 
                                            onSurface: Colors.black, 
                                          ),),
                          child:  TableCalendar(
                                  firstDay: DateTime.utc(2020, 1, 1),
                                  lastDay: DateTime.utc(2030, 12, 31),
                                  focusedDay:  selectedDate ?? DateTime.now(),
                                  selectedDayPredicate: (day) {
                                  return isSameDay(selectedDate ?? DateTime.now(), day);
                          
                                  },
                                  onDaySelected: (selectedDay, focusedDay) {
                                    setState(() {
                                       _selectedDay = selectedDay;
              _focusedDay = focusedDay;
                              selectedDate = selectedDay;
                            });
                            setStateDialog(() {
                               _selectedDay = selectedDay;
              _focusedDay = focusedDay;
                              selectedDate = selectedDay;
                              selectDirectText = "";
                            });
                                  },
                                  calendarStyle: const CalendarStyle(todayTextStyle: TextStyle(color: Colors.blue),
                                    todayDecoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue),left: BorderSide(color: Colors.blue),right: BorderSide(color: Colors.blue),top: BorderSide(color: Colors.blue)),
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    selectedDecoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                   onHeaderTapped: (focusedDay) =>
              showYearPicker(context, focusedDay,setStateDialog,true),
                                  headerStyle: const HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                     leftChevronIcon: Icon(Icons.arrow_left,size: 40,color: Colors.grey),
              rightChevronIcon: Icon(Icons.arrow_right,size: 40,color: Colors.grey,),
                                  ),
                                ),
                          
                          // CalendarDatePicker(
                          //   initialDate: selectedDate ?? DateTime.now(),
                          //   firstDate: DateTime(2000),
                          //   lastDate: DateTime(2100),
                          //   onDateChanged: (date) {
                          //     setState(() {
                          //       selectedDate = date;
                          //     });
                                          
                          //     setStateDialog((){
                          //          selectedDate = date;
                          //           selectDirectText = "";
                          //     });
                          //   },
                          // ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black12,
                        height: 2,
                      ),
                            selectedDateWid(context,setStateDialog)
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }
    DateTime? selectedEndDate;
    String selectDirectEndText = "";

 void _showPopupEndDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
        return  Dialog(
             elevation: 0,insetPadding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                             _dateButtonEnd("No Date",  DateTime.now(),setStateDialog),
                               const SizedBox(
                            width: 8,
                          ),
                          _dateButtonEnd("Today", DateTime.now(),setStateDialog),
                        ],
                      ),
                      const SizedBox(height: 10),
                     
                      SizedBox(
                        height: 410,
                        child: Theme(
                          data: ThemeData(
                  colorScheme: const ColorScheme.light(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white, 
                    onSurface: Colors.black, 
                  ),),
                          child: 
                          TableCalendar(
                                  firstDay: DateTime.utc(2020, 1, 1),
                                  lastDay: DateTime.utc(2030, 12, 31),
                                  focusedDay:  selectedEndDate ?? DateTime.now(),
                                  selectedDayPredicate: (day) {
                                  return isSameDay(selectedEndDate ?? DateTime.now(), day);
                          
                                  },
                                      onHeaderTapped: (focusedDay) =>
              showYearPicker(context, focusedDay,setStateDialog,false),
                                  onDaySelected: (selectedDay, focusedDay) {
                                    setState(() {
                              selectedEndDate = selectedDay;
                            });
                            
                            setStateDialog(() {
                              selectedEndDate = selectedDay;
                              selectDirectEndText = "";
                            });
                                  },
                                  calendarStyle: const CalendarStyle(todayTextStyle: TextStyle(color: Colors.blue),
                                    todayDecoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue),left: BorderSide(color: Colors.blue),right: BorderSide(color: Colors.blue),top: BorderSide(color: Colors.blue)),
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    selectedDecoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  headerStyle: const HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                     leftChevronIcon: Icon(Icons.arrow_left,size: 40,color: Colors.grey),
              rightChevronIcon: Icon(Icons.arrow_right,size: 40,color: Colors.grey,),
                                  ),
                                )
                          
                          // CalendarDatePicker(
                          //   initialDate: selectedEndDate ?? DateTime.now(),
                          //   firstDate: DateTime(2000),
                          //   lastDate: DateTime(2100),
                          //   onDateChanged: (date) {
                          //     setState(() {
                          //       selectedEndDate = date;
                          //     });
                  
                          //     setStateDialog((){
                          //          selectedEndDate = date;
                          //           selectDirectEndText = "";
                          //     });
                          //   },
                          // ),
                        ),
                      ),
                            selectedEndDateWid(context,setStateDialog)
                        
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }

 Padding selectedDateWid(BuildContext context,setStateDialog) {
   return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Text(
                              selectedDate != null
                                  ? DateFormat('d MMM yyyy').format(selectedDate!)
                                  : "Select Date",
                              style: const TextStyle(fontSize: 13),
                            ),
                            const Spacer(),
                             InkWell(
                              onTap:() => Navigator.pop(context),
                               child: Container(
                                    height: 30,
                                    width: 65,
                                    decoration:  BoxDecoration(color: Colors.blue[100],borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  child:  const Center(child: Text('Cancel', style: TextStyle(color: Colors.blueAccent))),
                                  ),
                             ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                               InkWell(
                              onTap:() => Navigator.pop(context),
                               child: Container(
                                    height: 30,
                                    width: 65,
                                   decoration: const BoxDecoration(color: Colors.blueAccent,borderRadius: BorderRadius.all(Radius.circular(8))),
                                  child:  const Center(child: Text('Save', style: TextStyle(color: Colors.white))),
                                  ),
                             ),
                            // TextButton(
                            //   onPressed: () => Navigator.pop(context),
                            //   child: const Text("Cancel", style: TextStyle(color: Colors.blueAccent)),
                            // ),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     Navigator.pop(context);
                            //   },
                            //   child: const Text("Save"),
                            // ),
                          ],
                        ),
                      );
 }
 Padding selectedEndDateWid(BuildContext context,setStateDialog) {
   return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Text(
                           selectDirectEndText == "No Date" ? "No Date":  selectedEndDate != null
                                  ? DateFormat('d MMM yyyy').format(selectedEndDate!)
                                  : "Select Date",
                              style: const TextStyle(fontSize: 13),
                            ),
                            const Spacer(),
                             InkWell(
                              onTap:() => Navigator.pop(context),
                               child: Container(
                                    height: 30,
                                    width: 65,
                                    decoration:  BoxDecoration(color: Colors.blue[100],borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  child:  const Center(child: Text('Cancel', style: TextStyle(color: Colors.blueAccent))),
                                  ),
                             ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                               InkWell(
                              onTap:() => Navigator.pop(context),
                               child: Container(
                                    height: 30,
                                    width: 65,
                                   decoration: const BoxDecoration(color: Colors.blueAccent,borderRadius: BorderRadius.all(Radius.circular(8))),
                                  child:  const Center(child: Text('Save', style: TextStyle(color: Colors.white))),
                                  ),
                             ),
                          ],
                        ),
                      );
 }

  Widget _dateButton(String label, DateTime date,stste) {
    return StatefulBuilder(
        builder: (context, setStateDialog) {
        return Expanded(
          child: InkWell(
            onTap: () {
              stste((){});
               setStateDialog(() {
                    selectedDate = date; 
                     selectDirectText = label;
                     setState(() {
                        selectDirectText = label;
                     });
                  });
              setState(() {
                selectedDate = date;
                selectDirectText = label;
              });
              Navigator.pop(context);
            },
            child: Container(
              height: 35,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: selectDirectText == label ? Colors.blueAccent :  Colors.blue.shade50),
              child:  Center(child: Text(label,style:  TextStyle(color:  selectDirectText == label ? Colors.white : Colors.blueAccent),)),
            ),
          )
          
          
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       selectedDate = date;
          //     });
          //     Navigator.pop(context);
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: selectedDate == date ? Colors.blueAccent : Colors.blue.shade50,
          //     foregroundColor: selectedDate == date ? Colors.white : Colors.blueAccent,
          //   ),
          //   child: Text(label),
          // ),
        );
      }
    );
  }
  Widget _dateButtonEnd(String label, DateTime date,stste) {
    return StatefulBuilder(
        builder: (context, setStateDialog) {
        return Expanded(
          child: InkWell(
            onTap: () {
              stste((){});
               setStateDialog(() {
                    selectedEndDate = date; 
                     selectDirectEndText = label;
                     setState(() {
                        selectDirectEndText = label;
                     });
                  });
              setState(() {
                selectedEndDate = date;
                selectDirectEndText = label;
              });
              Navigator.pop(context);
            },
            child: Container(
              height: 35,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: selectDirectEndText == label ? Colors.blueAccent :  Colors.blue.shade50),
              child:  Center(child: Text(label,style:  TextStyle(color:  selectDirectEndText == label ? Colors.white : Colors.blueAccent),)),
            ),
          )
        );
      }
    );
  }

  DateTime _getNextMonday() {
    DateTime now = DateTime.now();
    int daysUntilMonday = DateTime.monday - now.weekday;
    if (daysUntilMonday <= 0) daysUntilMonday += 7;
    return now.add(Duration(days: daysUntilMonday));
  }

  DateTime _getNextTuesday() {
    DateTime now = DateTime.now();
    int daysUntilTuesday = DateTime.tuesday - now.weekday;
    if (daysUntilTuesday <= 0) daysUntilTuesday += 7;
    return now.add(Duration(days: daysUntilTuesday));
  }


   void _saveEmployee() {
    String name = nameController.text.trim();

    if (name.isEmpty || selectedRole == 'Select Role' || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    Employee newEmployee = Employee(
      name: name,
      role: selectedRole,
      startDate: selectedDate!,
      endDate: selectDirectEndText == "No Date"? null : selectedEndDate,
    );

    if (widget.employee == null) {
      context.read<EmployeeCubit>().addEmployee(newEmployee);
    } else {
      context.read<EmployeeCubit>().updateEmployee(widget.employee!, newEmployee);
    }

    Navigator.pop(context); 
  }

   @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      nameController.text = widget.employee!.name;
      selectedRole = widget.employee!.role;
      selectedDate = widget.employee!.startDate;
      selectedEndDate = widget.employee!.endDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      appBar: AppBar(
         automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(
    color: Colors.white, 
  ),
        title:  Text(widget.employee == null ? 'Add Employee Details' : 'Edit Employee Details',style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          if(widget.employee != null)
          IconButton(onPressed: (){
              context.read<EmployeeCubit>().deleteEmployee(widget.employee!,context);
          
           Navigator.pop(context); 
          }, icon: const Icon(Icons.delete_forever_outlined))
        ],
      ),
      body: Stack(
        children: [Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                  labelText: 'Employee Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              roleList(context),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      // onTap: () => _selectDate(context, true),
                      onTap: () => _showPopupDatePicker(context),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 2,color: Colors.black26)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                             const Icon(Icons.calendar_today, color: Colors.blueAccent),
                            const SizedBox(width: 8,), 
                              Flexible(child: Text(selectedDate == null ? 'Start Date' : DateFormat('d MMM, yyyy').format(selectedDate!),style: const TextStyle(overflow: TextOverflow.ellipsis),)),
                              // Text(selectedDate == null ? 'Start Date' : '${selectedDate!.day} ${selectedDate!.month} ${selectedDate!.year}'),
                          ],),
                        )
                        
                        // TextButton.icon(
                        //   icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                        //   label: Text(startDate == null ? 'Start Date' : '${startDate!.day} ${startDate!.month} ${startDate!.year}'),
                        //   onPressed: () => _selectDate(context, true),
                        // ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward, color: Colors.blueAccent),
                  ),
                  Expanded(
                    child: InkWell(
                      // onTap: () => _selectDate(context, false),
                      onTap: () => _showPopupEndDatePicker(context),
                      child: Container(
                          decoration: BoxDecoration(border: Border.all(width: 2,color: Colors.black26)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.blueAccent),
                              const SizedBox(width: 8,), 
                               Flexible(
                                 child: Text(
                                  selectDirectEndText == "No Date" ? "No Date" :
                                  selectedEndDate == null ? 'End Date' :  DateFormat('d MMM, yyyy').format(selectedEndDate!),style: const TextStyle(overflow: TextOverflow.ellipsis),),
                               ),
                                // selectedEndDate == null ? 'End Date' : '${selectedEndDate!.day} ${selectedEndDate!.month} ${selectedEndDate!.year}'),
                              // TextButton.icon(
                              //   icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                              //   label: Text(endDate == null ? 'End Date' : '${endDate!.day} ${endDate!.month} ${endDate!.year}'),
                              //   onPressed: () => _selectDate(context, false),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
             
            ],
          ),
        ),
         Positioned(
          bottom: 0,
           child: Container(
            height: 60,
          width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(border: Border(top: BorderSide(width: 2,color: Colors.black12))),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                      children: [
                       const Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: 70,
                            decoration:  BoxDecoration(color: Colors.blue[100],borderRadius: const BorderRadius.all(Radius.circular(8))),
                          child:  const Center(child: Text('Cancel', style: TextStyle(color: Colors.blueAccent))),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          onTap: _saveEmployee,
                          child: Container(
                            height: 40,
                            width: 70,
                            decoration: const BoxDecoration(color: Colors.blueAccent,borderRadius: BorderRadius.all(Radius.circular(8))),
                          child:  const Center(child: Text('Save', style: TextStyle(color: Colors.white))),
                          ),
                        ),
                       
                      ],
                    ),
             ),
           ),
         ),
        ]
      ),
    );
  }


Widget roleList(BuildContext context) {
  return InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _roleOption(context, "Product Designer"),
                _roleOption(context, "Flutter Developer"),
                _roleOption(context, "QA Tester"),
                _roleOption(context, "Product Owner"),
              ],
            ),
          );
        },
      );
    },
    child: InputDecorator(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.work, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        hintText: selectedRole,
        suffixIcon:  const Icon(Icons.arrow_drop_down, color: Colors.blueAccent,size: 40,),
      ),
      child: Text(
        selectedRole ,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    ),
  );
}

Widget _roleOption(BuildContext context, String role) {
  return ListTile(
    title: Center(child: Text(role)),
    onTap: () {
      Navigator.pop(context); 
      setState(() {
        selectedRole = role;
      });
    },
  );
}

}