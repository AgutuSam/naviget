class Point {
  Point({
    this.name = '',
    this.imagePath = '',
    this.title = '',
    this.marker,
    this.latlng,
    this.org = '',
  });

  String name;
  String title;
  List marker;
  List latlng;
  String org;
  String imagePath;

  static List<Point> teamList = <Point>[
    Point(
      imagePath: 'assets/users/pexels-nappy-935969.jpg',
      name: 'Drew Cerutti',
      marker: [],
      org: 'Fahey Inc',
    ),
    Point(
      imagePath: 'assets/users/pexels-wallace-chuck-2287252.jpg',
      name: 'Rickey Levert',
      marker: [],
      org: 'Jones Group',
    ),
    Point(
      imagePath: 'assets/users/pexels-pixabay-157661.jpg',
      name: 'Donnette Hudson',
      marker: [],
      org: 'Kerluke LLC',
    ),
    Point(
      imagePath: 'assets/users/pexels-bharat-kumar-2232981.jpg',
      name: 'Jordan Simerly',
      marker: [],
      org: 'Lehner Inc',
    ),
    Point(
      imagePath: 'assets/users/pexels-ali-pazani-2878373.jpg',
      name: 'Beth Havlik',
      marker: [],
      org: 'JayJey Ltd',
    ),
    Point(
      imagePath: 'assets/users/pexels-ali-madad-sakhirani-997472.jpg',
      name: 'Virgilio Palmer',
      marker: [],
      org: "O'Hara Co.",
    ),
    Point(
      imagePath: 'assets/users/pexels-grisha-stern-2120114.jpg',
      name: 'Julia Privette',
      marker: [],
      org: 'Kautzer Trust',
    ),
    Point(
      imagePath: 'assets/users/pexels-italo-melo-2379005.jpg',
      name: 'Ollie Pascoe',
      marker: [],
      org: 'Hilpert Ltd',
    ),
    Point(
      imagePath: 'assets/users/pexels-alexander-krivitskiy-2101796.jpg',
      name: 'Zina Blatter',
      marker: [],
      org: 'Bruen Group',
    ),
    Point(
      imagePath: 'assets/users/pexels-nappy-936119.jpg',
      name: 'Benito Duet',
      marker: [],
      org: 'Howell Inc',
    ),
  ];
}
