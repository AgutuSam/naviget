import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class DetailForm extends StatefulWidget {
  DetailForm({this.detailId, this.user});
  final detailId;
  final user;

  @override
  _DetailFormState createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  final quantity = TextEditingController();

  User auser = FirebaseAuth.instance.currentUser;

  final CollectionReference detailDoc =
      FirebaseFirestore.instance.collection('Detail');
  final CollectionReference userDoc =
      FirebaseFirestore.instance.collection('users');

  var prodId;

  var unitState;

  var transactionId;

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  AnimationController animationController;

  TextEditingController amountController = TextEditingController();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  final CollectionReference mapColl =
      FirebaseFirestore.instance.collection('Maps');
  var firebaseUser = FirebaseAuth.instance.currentUser;

  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController size = TextEditingController();
  TextEditingController price = TextEditingController();
  List measure = [];
  Map measureDropDownMap = {};

// Image Picker
  List<File> _images = [];
  bool saveBtn = false;
  File _image = File(''); // Used only if you need a single picture
  File myImage = File(
      '/data/data/com.example.manycooks/cache/image_picker702111491.jp'); // Used only if you need a single picture
  DocumentReference sightingRef =
      FirebaseFirestore.instance.collection('lands').doc();

  static const TextStyle label = TextStyle(
    // h6 -> title
    // fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 14,
    letterSpacing: 0.18,
    color: Colors.orange,
  );

  @override
  void initState() {
    super.initState();
  }

  Future<String> uploadFile(File _image) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('covers/${basename(_image.path)}');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    XFile pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = (await picker.pickImage(
        source: ImageSource.gallery,
      ));
      setState(() {});
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = (await picker.pickImage(
        source: ImageSource.camera,
      ));
      setState(() {});
    }

    setState(() {
      if (pickedFile != null) {
        // _images.add(File(pickedFile.path));
        saveBtn = !false;
        _image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> saveDetails(File _image, DocumentReference ref) async {
    Map<String, String> categories = Map<String, String>();
    measure.asMap().forEach(
        (key, value) => categories.putIfAbsent(key.toString(), () => value));
    String imageURL = await uploadFile(_image);

    await mapColl.doc(widget.detailId).update({
      "email": email.text,
      "phone": phone.text,
      "address": address.text,
      "size": size.text,
      "measure": measureDropDownMap['Measurement'],
      "price": price.text,
      "image": imageURL,
      'mapState': 'posted'
    });
  }

  Widget textInput(BuildContext context, String name,
      TextEditingController brothController) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      margin: EdgeInsets.only(bottom: 16, top: 16, right: 30, left: 30),
      width: MediaQuery.of(context).size.width * .75,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.white24, blurRadius: 10, offset: Offset(4, 3))
        ],
      ),
      child: TextFormField(
        onChanged: (_) => setState(() {}),
        controller: brothController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.file_copy,
              color: Colors.white,
            ),
            hintText: name,
            hintStyle: TextStyle(color: Colors.black54),
            filled: true,
            fillColor: Colors.white24,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
      ),
    );
  }

  Widget imageCoverButton(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      margin: EdgeInsets.only(bottom: 2, top: 2, right: 10, left: 10),
      width: MediaQuery.of(context).size.width * .60,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.white24, blurRadius: 10, offset: Offset(4, 3))
        ],
      ),
      child: ListTile(
        leading: Icon(
          Icons.image,
          color: Colors.white,
        ),
        title: Text(
          'Land Image',
          style: TextStyle(color: Colors.white),
        ),
        horizontalTitleGap: 2,
        onTap: () => getImage(true),
      ),
//
    );
  }

  Widget categoryDropdown(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      margin: EdgeInsets.only(bottom: 16, top: 16, right: 30, left: 30),
      width: MediaQuery.of(context).size.width * .70,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.white24, blurRadius: 10, offset: Offset(4, 3))
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            iconEnabledColor: Colors.black54,
            hint: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.category,
                    color: Colors.white,
                  ),
                ),
                Text(
                    measureDropDownMap['Measurement'] != null
                        ? measureDropDownMap['Measurement']
                        : 'Measurement',
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
            items:
                ['m²', 'ft²', 'yrd²', 'Acre', 'Ha'].asMap().entries.map((val) {
              return DropdownMenuItem(
                  value: val.value,
                  onTap: () {
                    !measure.contains(val.value)
                        ? measure.add(val.value)
                        : measure.remove(val.value);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(val.value),
                    ],
                  ));
            }).toList(),
            onChanged: (v) {
              setState(() {
                measureDropDownMap['Measurement'] = v;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      margin: EdgeInsets.only(bottom: 16, top: 16, right: 30, left: 30),
      width: MediaQuery.of(context).size.width * .75,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.white24, blurRadius: 10, offset: Offset(4, 3))
        ],
      ),
      child: ListTile(
          leading: Icon(Icons.save, color: Colors.white),
          title: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
          horizontalTitleGap: 2,
          onTap: () {
            saveDetails(_image, sightingRef);
          }),
//
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: Center(
        child: Form(
          child: Column(
            children: <Widget>[
              textInput(context, 'Phone', phone),
              textInput(context, 'Email', email),
              textInput(context, 'Land Address', address),
              textInput(context, 'Size', size),
              categoryDropdown(context),
              textInput(context, 'Price (Kshs)', price),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                margin:
                    EdgeInsets.only(bottom: 16, top: 16, right: 30, left: 50),
                child: Row(children: <Widget>[
                  CircleAvatar(
                    backgroundImage: Image.file(
                      _image,
                      color: Colors.white,
                      colorBlendMode: BlendMode.darken,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.contain,
                    ).image,
                  ),
                  imageCoverButton(context)
                ]),
              ),
              saveButton(context)
            ],
          ),
        ),
      ),
    );
  }
}
