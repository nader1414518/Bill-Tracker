import 'dart:io';

import 'package:billtracker/models/bill_model.dart';
import 'package:billtracker/screens/view_archived_bills.dart';
import 'package:billtracker/screens/view_bills.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'navdrawer.dart';
import 'add_new_bill.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return WillPopScope(
        child: Scaffold(
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
        ),
        onWillPop: () async {
          return false;
        },
      );
    }

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Bill Tracker"),
          backgroundColor: Colors.blueGrey,
        ),
        drawer: NavDrawer(),
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
            padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello ${FirebaseAuth.instance.currentUser.email.split('@')[0]}!!\nBrowse bills or create a new one ... ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                child: Divider(
                  color: Colors.black,
                  height: 10.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 11.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return AddNewBill();
                          },
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Text(
                            "Add New Bill",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.black,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
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
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 11.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ViewBills();
                          },
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Text(
                            "View Bills",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.black,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
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
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 11.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ViewArchivedBills();
                          },
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          child: Text(
                            "Archived",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.black,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
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
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 11.0,
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection("bills")
                          .get()
                          .then((value) async {
                        try {
                          List<Bill> bills = [];
                          if (value != null) {
                            if (value.docs != null) {
                              if (value.docs.isNotEmpty) {
                                for (var doc in value.docs) {
                                  bills.add(Bill.fromJson(doc.data()));
                                }
                              }
                            }
                          }

                          final pdf = pw.Document();

                          double total = 0;
                          for (var bill in bills) {
                            try {
                              total += double.parse(bill.billAmount);
                            } catch (ex) {
                              print(ex.toString());
                            }
                          }

                          pdf.addPage(
                            pw.MultiPage(
                              header: (pw.Context context) {
                                return pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      "Bill Report",
                                      style: pw.TextStyle(
                                        fontSize: 16,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              footer: (pw.Context context) {
                                return pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text(
                                      "Date: ${DateTime.now().year.toString()}-${DateTime.now().month.toString()}-${DateTime.now().day.toString()}",
                                    ),
                                    pw.Text(
                                      "Author: ${FirebaseAuth.instance.currentUser.email.split('@')[0]}",
                                    ),
                                  ],
                                );
                              },
                              build: (pw.Context context) {
                                return [
                                  pw.Padding(
                                    padding: pw.EdgeInsets.fromLTRB(
                                        0.0, 50.0, 0.0, 5.0),
                                    child: pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text(
                                          "Summary",
                                          style: pw.TextStyle(
                                            fontSize: 14,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.fromLTRB(
                                        0.0, 20.0, 0.0, 5.0),
                                    child: pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text(
                                          "Date: ",
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                        pw.Text(
                                          "${DateTime.now().year.toString()}-${DateTime.now().month.toString()}-${DateTime.now().day.toString()}",
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.fromLTRB(
                                        0.0, 10.0, 0.0, 5.0),
                                    child: pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text(
                                          "Total: ",
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                        pw.Text(
                                          total.toStringAsFixed(2) + "  EGP",
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.fromLTRB(
                                        0.0, 10.0, 0.0, 5.0),
                                    child: pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text(
                                          "Number of bills: ",
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                        pw.Text(
                                          bills.length.toString() + "  bills",
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                            ),
                          );

                          for (var bill in bills) {
                            dynamic file;

                            if (bill.photoUrl != "" && bill.photoUrl != null) {
                              file = await networkImage(bill.photoUrl);
                            }

                            pdf.addPage(
                              pw.MultiPage(
                                footer: (pw.Context context) {
                                  return pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text(
                                        "Date: ${DateTime.now().year.toString()}-${DateTime.now().month.toString()}-${DateTime.now().day.toString()}",
                                      ),
                                      pw.Text(
                                        "Author: ${FirebaseAuth.instance.currentUser.email.split('@')[0]}",
                                      ),
                                    ],
                                  );
                                },
                                build: (pw.Context context) {
                                  return [
                                    pw.Table.fromTextArray(
                                      headerAlignment: pw.Alignment.centerLeft,
                                      data: <List<String>>[
                                        <String>[
                                          'Title:',
                                          bill.billTitle,
                                        ],
                                        <String>[
                                          'Value:',
                                          bill.billAmount + "  EGP",
                                        ],
                                        <String>[
                                          'Date:',
                                          bill.billDate,
                                        ],
                                        <String>[
                                          'From:',
                                          bill.billFrom,
                                        ],
                                        <String>[
                                          'To:',
                                          bill.billTo,
                                        ],
                                      ],
                                    ),
                                    pw.Padding(
                                      padding: pw.EdgeInsets.fromLTRB(
                                        0.0,
                                        40.0,
                                        0.0,
                                        5.0,
                                      ),
                                      child: pw.Table(
                                        border: pw.TableBorder(
                                          horizontalInside: pw.BorderSide(
                                            width: 5.0,
                                            color: PdfColor.fromRYB(0, 0, 0),
                                          ),
                                          verticalInside: pw.BorderSide(
                                            width: 5.0,
                                            color: PdfColor.fromRYB(0, 0, 0),
                                          ),
                                        ),
                                        children: [
                                          pw.TableRow(
                                            verticalAlignment: pw
                                                .TableCellVerticalAlignment
                                                .middle,
                                            children: [
                                              bill.photoUrl == ""
                                                  ? pw.Center(
                                                      child: pw.Text(
                                                          "No image available"),
                                                    )
                                                  : pw.Center(
                                                      child: pw.Image(
                                                        file,
                                                        width: PdfPageFormat
                                                                .a4.width *
                                                            0.7,
                                                        height: PdfPageFormat
                                                                .a4.height *
                                                            0.4,
                                                      ),
                                                    )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            );
                          }

                          var outputPath = await getExternalStorageDirectory();

                          final file = File(
                            outputPath.path + "/output.pdf",
                          );

                          var fileExists = await file.exists();
                          if (fileExists) {
                            await file.delete();
                          }
                          await file.writeAsBytes(
                            await pdf.save(),
                          );

                          if (Platform.isAndroid) {
                            OpenFile.open(file.path);
                          }
                        } catch (ex) {
                          print(ex.toString());
                        }

                        setState(() {
                          loading = false;
                        });
                      }).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              error.toString(),
                            ),
                          ),
                        );
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Text(
                            "Generate PDF",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.black,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
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
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
