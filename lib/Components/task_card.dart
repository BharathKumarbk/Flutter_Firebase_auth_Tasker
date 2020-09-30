import 'package:firebase_flutter_todo/Components/color_as_string.dart';
import 'package:firebase_flutter_todo/Components/constants.dart';
import 'package:firebase_flutter_todo/Components/final.dart';
import 'package:firebase_flutter_todo/Models/task.dart';
import 'package:firebase_flutter_todo/Screens/add_task.dart';
import 'package:firebase_flutter_todo/Services/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskGrid extends StatefulWidget {
  final Task task;
  const TaskGrid({
    Key key,
    this.task,
  }) : super(key: key);

  @override
  _TaskGridState createState() => _TaskGridState();
}

class _TaskGridState extends State<TaskGrid> {
  bool isChecked;
  final SnackBar deleteSnackBar =
      SnackBar(content: Text("Task deleted Successfully"));
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    isChecked = widget.task.isChecked;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreStorage firestoreStorage =
        Provider.of<FirestoreStorage>(context);
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: HexColor(widget.task.color),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 4.0,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: Text(
              widget.task.title,
              overflow: TextOverflow.ellipsis,
              style: googleMont.copyWith(
                  color: kWhiteColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 2.0,
            color: Colors.white30,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                widget.task.subTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: googleMont.copyWith(
                  color: kWhiteColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              DateFormat("dd/MM/yyyy hh:mm a")
                  .format(DateTime.parse(widget.task.dateTime)),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: googleMont.copyWith(
                color: Colors.white70,
                fontSize: 14.0,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white30,
              // borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(20.0),
              //     bottomRight: Radius.circular(20.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: kWhiteColor,
                  ),
                  onPressed: () {
                    firestoreStorage
                        .deleteTask(widget.task, widget.task.taskId)
                        .then((value) {
                      _scaffold.currentState.showSnackBar(deleteSnackBar);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: kWhiteColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => AddForm(
                              isUpdate: true,
                              task: widget.task,
                            )));
                  },
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(unselectedWidgetColor: kWhiteColor),
                  child: Checkbox(
                      activeColor: kWhiteColor,
                      checkColor: HexColor(widget.task.color),
                      value: isChecked,
                      onChanged: (value) async {
                        await firestoreStorage.updateTasks(Task(
                          taskId: widget.task.taskId,
                          title: widget.task.title,
                          subTitle: widget.task.subTitle,
                          dateTime: widget.task.dateTime,
                          color: widget.task.color,
                          isChecked: value,
                        ));

                        setState(() {
                          isChecked = value;
                        });
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
