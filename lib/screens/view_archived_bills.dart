import 'package:billtracker/models/bill_model.dart';
import 'package:billtracker/widgets/recent_bill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewArchivedBills extends StatefulWidget {
  ViewArchivedBills({Key key}) : super(key: key);

  @override
  ViewArchivedBillsState createState() => ViewArchivedBillsState();
}

class ViewArchivedBillsState extends State<ViewArchivedBills> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Archived"),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection("archived")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            scrollDirection: Axis.vertical,
            children: [
              Container(
                height: (MediaQuery.of(context).size.height / 4.0) * 3.0,
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  children: snapshot.data.docs.map((doc) {
                    Bill bill = Bill(
                      billTitle: doc['billTitle'],
                      billAmount: doc['billAmount'],
                      billDate: doc['billDate'],
                      billFrom: doc['billFrom'],
                      billTo: doc['billTo'],
                      photoUrl: doc['photoUrl'],
                      id: doc['id'],
                    );

                    return Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                      child: RecentBill(
                        bill: bill,
                        alreadyInArchive: true,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
