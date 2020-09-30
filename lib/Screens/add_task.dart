import 'package:firebase_flutter_todo/Components/color_as_string.dart';
import 'package:firebase_flutter_todo/Components/constants.dart';
import 'package:firebase_flutter_todo/Components/final.dart';
import 'package:firebase_flutter_todo/Models/task.dart';
import 'package:firebase_flutter_todo/Services/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddForm extends StatefulWidget {
  final bool isUpdate;
  final Task task;

  const AddForm({Key key, this.isUpdate, this.task}) : super(key: key);

  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController subTitleEditingController =
      TextEditingController();
  bool isAdding = true;
  @override
  void initState() {
    if (widget.isUpdate == false) {
      titleEditingController.text = "";
      subTitleEditingController.text = "";
    } else {
      titleEditingController.text = widget.task.title;
      subTitleEditingController.text = widget.task.subTitle;
      isSelected = HexColor(widget.task.color);
    }
    super.initState();
  }

  List<String> colors = [
    "#F44336",
    "#4CAF50",
    "#2196F3",
    "#3F51B5",
    "#FF9800",
    "#9C27B0",
    "#009688"
  ];

  Color isSelected = HexColor("#4CAF50");
  String selected = "#4CAF50";

  @override
  Widget build(BuildContext context) {
    final FirestoreStorage firestoreStorage =
        Provider.of<FirestoreStorage>(context);
    print(isSelected.toString());
    return Scaffold(
        backgroundColor: isSelected,
        appBar: AppBar(
          title: Text(
            widget.isUpdate == false ? "Add Task" : "Update Task",
            style: googleMont.copyWith(
                fontSize: 34.0,
                fontWeight: FontWeight.bold,
                color: kWhiteColor),
          ),
          backgroundColor: isSelected,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              isAdding = false;
            });
            if (widget.isUpdate == false) {
              firestoreStorage
                  .addTask(Task(
                title: titleEditingController.text,
                subTitle: subTitleEditingController.text,
                color: selected,
                dateTime: DateTime.now().toString(),
                isChecked: false,
              ))
                  .then((value) {
                Navigator.of(context).pop();
              });
            } else {
              firestoreStorage
                  .updateTasks(Task(
                taskId: widget.task.taskId,
                title: titleEditingController.text,
                subTitle: subTitleEditingController.text,
                color: selected,
                dateTime: DateTime.now().toString(),
                isChecked: false,
              ))
                  .then((value) {
                Navigator.of(context).pop();
              });
            }
          },
          backgroundColor: Colors.white,
          label: Text(
            widget.isUpdate == false ? "Add" : "Update",
            style: googleMont.copyWith(
                fontSize: 16.0, fontWeight: FontWeight.bold, color: isSelected),
          ),
          icon: Icon(
            widget.isUpdate == false ? Icons.done_all : Icons.update,
            color: isSelected,
          ),
        ),
        body: isAdding
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    TextFormField(
                        controller: titleEditingController,
                        decoration: inputDecoration.copyWith(
                            hintText: "Title", fillColor: kWhiteColor)),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                        controller: subTitleEditingController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: inputDecoration.copyWith(
                            hintText: "Description", fillColor: kWhiteColor)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 55.0,
                      child: ListView.builder(
                        itemCount: colors.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (c, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected = HexColor(colors[i]);
                                  selected = colors[i];
                                });
                              },
                              child: ClipOval(
                                child: Container(
                                    height: 40.0,
                                    width: 40.0,
                                    color: HexColor(colors[i]),
                                    child: isSelected == HexColor(colors[i])
                                        ? Icon(
                                            Icons.done,
                                            color: kWhiteColor,
                                          )
                                        : null),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 30.0,
                    ),
                    Text(
                      widget.isUpdate == false ? "Adding..." : "Upating...",
                      style: googleMont.copyWith(color: Colors.white),
                    )
                  ],
                ),
              )));
  }
}
