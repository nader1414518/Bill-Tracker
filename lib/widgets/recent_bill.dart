import 'package:billtracker/models/bill_model.dart';
import 'package:billtracker/screens/view_bill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentBill extends StatefulWidget {
  Bill bill = Bill();
  bool alreadyInArchive = false;

  RecentBill({
    Key key,
    this.bill,
    this.alreadyInArchive,
  }) : super(key: key);

  @override
  RecentBillState createState() => RecentBillState();
}

class RecentBillState extends State<RecentBill> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.bill.id),
      background: Container(
        color: Colors.red,
        child: widget.alreadyInArchive
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Remove",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Unarchive",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Remove",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Archive",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Container(
            width: 300,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: Container(
                          child: Text(
                            widget.bill.billTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          child: Text(
                            widget.bill.billDate,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 50.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          child: Text(
                            "Bill From",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          child: Text(
                            widget.bill.billFrom,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 50.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          child: Text(
                            "Bill To",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          child: Text(
                            widget.bill.billTo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 50.0, 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          child: Text(
                            "Amount",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          child: Text(
                            widget.bill.billAmount,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ViewBill(
              bill: widget.bill,
              editMode: false,
            );
          }));
        },
      ),
      onDismissed: (direction) {
        if (widget.alreadyInArchive) {
          if (direction == DismissDirection.endToStart) {
            // Unarchive
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection("bills")
                .add(widget.bill.toJson())
                .then(
              (t1) {
                var oldId = widget.bill.id;
                widget.bill.id = t1.id;
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection("bills")
                    .doc(t1.id)
                    .update(widget.bill.toJson())
                    .then((t2) {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection("archived")
                      .doc(oldId)
                      .delete()
                      .then((t3) {
                    print("Retrieved bill ... ");
                  });
                });
              },
            );
          }

          if (direction == DismissDirection.startToEnd) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection("archived")
                .doc(widget.bill.id)
                .delete()
                .then((t3) {
              print("Removed bill ... ");
            });
          }
        } else {
          if (direction == DismissDirection.endToStart) {
            // Archive
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection("archived")
                .add(widget.bill.toJson())
                .then(
              (t1) {
                var oldId = widget.bill.id;
                widget.bill.id = t1.id;
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection("archived")
                    .doc(t1.id)
                    .update(widget.bill.toJson())
                    .then((t2) {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection("bills")
                      .doc(oldId)
                      .delete()
                      .then((t3) {
                    print("Archived bill ... ");
                  });
                });
              },
            );
          }

          if (direction == DismissDirection.startToEnd) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection("bills")
                .doc(widget.bill.id)
                .delete()
                .then((t3) {
              print("Removed bill ... ");
            });
          }
        }
      },
    );
  }
}
