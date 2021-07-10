class Bill {
  String billTitle;
  String billAmount;
  String billDate;
  String billFrom;
  String billTo;
  String photoUrl;
  String id;

  Bill({
    this.billTitle,
    this.billAmount,
    this.billDate,
    this.billFrom,
    this.billTo,
    this.photoUrl,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'billTitle': this.billTitle,
      'billAmount': this.billAmount,
      'billDate': this.billDate,
      'billFrom': this.billFrom,
      'billTo': this.billTo,
      'photoUrl': this.photoUrl,
      'id': this.id,
    };
  }

  Bill.fromJson(Map<String, dynamic> json) {
    this.billTitle = json['billTitle'];
    this.billAmount = json['billAmount'];
    this.billDate = json['billDate'];
    this.billFrom = json['billFrom'];
    this.billTo = json['billTo'];
    this.photoUrl = json['photoUrl'];
    this.id = json['id'];
  }
}
