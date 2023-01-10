import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task.controller.dart';
import 'package:todo/models/task.model.dart';
import 'package:todo/services/date.service.dart';
import 'package:todo/ui/theme.dart';

import 'add_task_bar.dart';
import 'widgets/task_tile.dart';

class HomePageUi extends ConsumerStatefulWidget {
  const HomePageUi({super.key});

  @override
  ConsumerState<HomePageUi> createState() => _HomePageUiState();
}

class _HomePageUiState extends ConsumerState<HomePageUi> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          // _addTaskBar(),
          _addDateBar(),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Your tasks",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ],
          ),
          _showTasks(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          // Add tasks
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTaskPage()));
        }),
        child: const Icon(Icons.add),
      ),
    );
  }

  _showTasks() {
    final tasks = ref.watch(getTasksController);

    return Expanded(
        child: tasks.when(data: (data) {
      return data.isEmpty
          ? const Center(
              child: Text("Your TaskList is empty"),
            )
          : RefreshIndicator(
              onRefresh: () => ref.refresh(getTasksController.future),
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final reversedTask = data.reversed.toList();
                    final task = reversedTask[index];

                    print(task.toMap());

                    if (task.repeat == "Daily") {
                      DateTime date =
                          DateFormat.jm().parse(task.startTime.toString());

                      var myTime = DateFormat("HH:mm").format(date);

                      print("MyTime is :$myTime");

                      return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                              child: FadeInAnimation(
                                  child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task),
                              )
                            ],
                          ))));
                    }
                    if (task.date == DateFormat.yMd().format(_selectedDate)) {
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                              child: FadeInAnimation(
                                  child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task),
                              )
                            ],
                          ))));
                    } else {
                      return Container();
                    }
                  }),
            );
    }, error: (error, _) {
      return Center(
        child: Text(error.toString()),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    // final bool isDarkTheme = ref.watch(appThemeProvider).getTheme();

    showModalBottomSheet(
        clipBehavior: Clip.hardEdge,
        // backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: const BoxDecoration(
                  // color: isDarkTheme ? darkGreyClr : Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              height: task.isCompleted == 1
                  ? MediaQuery.of(context).size.height * 0.12
                  : MediaQuery.of(context).size.height * 0.20,
              child: Column(
                children: [
                  task.isCompleted == 1
                      ? Container()
                      : _bottomSheetButton(
                          context: context,
                          label: "Task Completed",
                          onTap: () {
                            ref.read(taskController).update(task);
                            ref.refresh(getTasksController.future);
                            Navigator.pop(context);
                          },
                          color: primaryClr),
                  _bottomSheetButton(
                    context: context,
                    label: "Delete Task",
                    onTap: () {
                      ref.read(taskController).delete(task);
                      ref.refresh(getTasksController.future);
                      Navigator.pop(context);
                    },
                    color: Colors.red[300]!,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        });
  }

  _bottomSheetButton({
    required BuildContext context,
    required String label,
    required Function()? onTap,
    required Color color,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isClose == true ? Colors.transparent : color,
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 90,
        width: 80,
        initialSelectedDate: _selectedDate,
        selectionColor: primaryClr,
        selectedTextColor: white,
        monthTextStyle: GoogleFonts.lato().copyWith(
            fontSize: 12, fontWeight: FontWeight.w200, color: Colors.grey),
        dateTextStyle: GoogleFonts.lato().copyWith(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
        dayTextStyle: GoogleFonts.lato().copyWith(
            fontSize: 12, fontWeight: FontWeight.w200, color: Colors.grey),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _appBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: () {},
          child: const Icon(Icons.menu),
        ),
      ),
      title: Text(getDate()),
      centerTitle: true,
      actions: [],
    );
  }
}
