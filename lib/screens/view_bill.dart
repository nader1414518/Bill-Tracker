import 'dart:io';

import 'package:billtracker/models/bill_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:photo_view/photo_view.dart';
import 'navdrawer.dart';

class ViewBill extends StatefulWidget {
  Bill bill = Bill();
  bool editMode = false;

  ViewBill({
    Key key,
    this.bill,
    this.editMode,
  }) : super(key: key);

  ViewBillState createState() => ViewBillState();
}

class ViewBillState extends State<ViewBill> {
  TextEditingController billNameController = TextEditingController();
  TextEditingController billAmountController = TextEditingController();
  TextEditingController billDateController = TextEditingController();
  TextEditingController billFromController = TextEditingController();
  TextEditingController billToController = TextEditingController();

  String photoUrl = "";

  bool loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    billNameController.text = widget.bill.billTitle;
    billAmountController.text = widget.bill.billAmount;
    billDateController.text = widget.bill.billDate;
    billFromController.text = widget.bill.billFrom;
    billToController.text = widget.bill.billTo;
    photoUrl = widget.bill.photoUrl;

    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                  child: Text("Please wait ..."),
                ),
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.bill.billTitle),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(
                () {
                  widget.editMode = !widget.editMode;
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white10,
              Colors.cyan,
            ],
          ),
        ),
        child: ListView(
          shrinkWrap: false,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                  child: Text(
                    "Bill Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
              child: TextFormField(
                readOnly: !widget.editMode,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      60.0,
                    ),
                  ),
                  hintText: "Bill title...",
                ),
                controller: billNameController,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
              child: TextFormField(
                readOnly: !widget.editMode,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      60.0,
                    ),
                  ),
                  hintText: "Amount...",
                ),
                keyboardType: TextInputType.number,
                controller: billAmountController,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        hintText: "Select Date...",
                      ),
                      controller: billDateController,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: widget.editMode
                        ? () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime(
                                2000,
                                1,
                                1,
                              ),
                              maxTime: DateTime(
                                2100,
                                12,
                                31,
                              ),
                              onChanged: (date) {
                                billDateController.text = date.year.toString() +
                                    "-" +
                                    date.month.toString() +
                                    "-" +
                                    date.day.toString();
                              },
                              onConfirm: (date) {
                                billDateController.text = date.year.toString() +
                                    "-" +
                                    date.month.toString() +
                                    "-" +
                                    date.day.toString();
                              },
                            );
                          }
                        : () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
              child: TextFormField(
                readOnly: !widget.editMode,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      60.0,
                    ),
                  ),
                  hintText: "From...",
                ),
                controller: billFromController,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
              child: TextFormField(
                readOnly: !widget.editMode,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      60.0,
                    ),
                  ),
                  hintText: "To...",
                ),
                controller: billToController,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
              child: Divider(
                thickness: 2.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                  child: Text(
                    "Photo",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                child: Container(
                  height: MediaQuery.of(context).size.height - 100.0,
                  width: MediaQuery.of(context).size.width - 20.0,
                  child: PhotoView(
                    imageProvider: NetworkImage(photoUrl),
                    tightMode: true,
                    enableRotation: true,
                  ),
                ),
              ),
              onLongPress: widget.editMode
                  ? () {
                      return showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Add a photo",
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text(
                                    "Add a photo to the bill?",
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  var imgPicker = ImagePicker();
                                  var pickedFile = await imgPicker.getImage(
                                    source: ImageSource.camera,
                                    imageQuality: 40,
                                  );

                                  if (pickedFile != null) {
                                    File img = File(pickedFile.path);

                                    setState(
                                      () {
                                        loading = true;
                                      },
                                    );

                                    FirebaseStorage.instance
                                        .ref()
                                        .child("Bills")
                                        .child(basename(img.path))
                                        .putFile(img)
                                        .then(
                                      (value) {
                                        FirebaseStorage.instance
                                            .ref()
                                            .child("Bills")
                                            .child(basename(img.path))
                                            .getDownloadURL()
                                            .then(
                                          (url) {
                                            setState(
                                              () {
                                                photoUrl = url.trim();
                                                loading = false;
                                              },
                                            );
                                          },
                                        ).onError(
                                          (error, stackTrace) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  error.toString(),
                                                ),
                                              ),
                                            );
                                            Navigator.of(context).pop();
                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                        );
                                      },
                                    ).onError(
                                      (error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              error.toString(),
                                            ),
                                          ),
                                        );

                                        Navigator.of(context).pop();
                                        setState(() {
                                          loading = false;
                                        });
                                      },
                                    );
                                  }

                                  Navigator.of(context).pop();
                                  // setState(() {
                                  //   loading = false;
                                  // });
                                },
                                child: Text(
                                  "Camera",
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  var imgPicker = ImagePicker();
                                  var pickedFile = await imgPicker.getImage(
                                      source: ImageSource.gallery);

                                  if (pickedFile != null) {
                                    File img = File(pickedFile.path);

                                    setState(
                                      () {
                                        loading = true;
                                      },
                                    );

                                    FirebaseStorage.instance
                                        .ref()
                                        .child("Bills")
                                        .child(basename(img.path))
                                        .putFile(img)
                                        .then(
                                      (value) {
                                        FirebaseStorage.instance
                                            .ref()
                                            .child("Bills")
                                            .child(basename(img.path))
                                            .getDownloadURL()
                                            .then(
                                          (url) {
                                            setState(
                                              () {
                                                photoUrl = url.trim();
                                                loading = false;
                                              },
                                            );
                                          },
                                        ).onError(
                                          (error, stackTrace) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  error.toString(),
                                                ),
                                              ),
                                            );
                                            Navigator.of(context).pop();
                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                        );
                                      },
                                    ).onError(
                                      (error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              error.toString(),
                                            ),
                                          ),
                                        );

                                        Navigator.of(context).pop();
                                        setState(() {
                                          loading = false;
                                        });
                                      },
                                    );
                                  }

                                  Navigator.of(context).pop();
                                  // setState(() {
                                  //   loading = false;
                                  // });
                                },
                                child: Text(
                                  "Local",
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancel",
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  : () {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                  child: TextButton(
                    onPressed: widget.editMode
                        ? () {
                            setState(() {
                              loading = true;
                            });

                            widget.bill.billTitle = billNameController.text;
                            widget.bill.billAmount = billAmountController.text;
                            widget.bill.billDate = billDateController.text;
                            widget.bill.billFrom = billFromController.text;
                            widget.bill.billTo = billToController.text;
                            widget.bill.photoUrl = photoUrl;

                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .collection("bills")
                                .doc(widget.bill.id)
                                .update(widget.bill.toJson())
                                .then((value) {
                              setState(() {
                                loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Updated bill data ... ",
                                  ),
                                ),
                              );
                              Navigator.of(context).pop();
                              return;
                            }).onError((error, stackTrace) {
                              setState(() {
                                loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error.toString(),
                                  ),
                                ),
                              );
                              Navigator.of(context).pop();
                              return;
                            });
                          }
                        : () {
                            Navigator.of(context).pop();
                          },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Text(
                        widget.editMode ? "Save bill" : "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        widget.editMode ? Colors.blue : Colors.grey,
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      elevation: MaterialStateProperty.all<double>(
                        2.0,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
