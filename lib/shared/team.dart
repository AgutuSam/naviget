class Team {
  Team({
    this.name = '',
    this.imagePath = '',
    this.title = '',
    this.org = '',
  });

  String name;
  String title;
  String org;
  String imagePath;

  static List<Team> teamList = <Team>[
    Team(
      imagePath: 'assets/users/pexels-nappy-935969.jpg',
      name: 'Drew Cerutti',
      title: 'Physicist',
      org: 'Fahey Inc',
    ),
    Team(
      imagePath: 'assets/users/pexels-wallace-chuck-2287252.jpg',
      name: 'Rickey Levert',
      title: 'Executive',
      org: 'Jones Group',
    ),
    Team(
      imagePath: 'assets/users/pexels-pixabay-157661.jpg',
      name: 'Donnette Hudson',
      title: 'Microbiologist',
      org: 'Kerluke LLC',
    ),
    Team(
      imagePath: 'assets/users/pexels-bharat-kumar-2232981.jpg',
      name: 'Jordan Simerly',
      title: 'Programmer',
      org: 'Lehner Inc',
    ),
    Team(
      imagePath: 'assets/users/pexels-ali-pazani-2878373.jpg',
      name: 'Beth Havlik',
      title: 'Director',
      org: 'JayJey Ltd',
    ),
    Team(
      imagePath: 'assets/users/pexels-ali-madad-sakhirani-997472.jpg',
      name: 'Virgilio Palmer',
      title: 'Developer',
      org: "O'Hara Co.",
    ),
    Team(
      imagePath: 'assets/users/pexels-grisha-stern-2120114.jpg',
      name: 'Julia Privette',
      title: 'Professor',
      org: 'Kautzer Trust',
    ),
    Team(
      imagePath: 'assets/users/pexels-italo-melo-2379005.jpg',
      name: 'Ollie Pascoe',
      title: 'Designer',
      org: 'Hilpert Ltd',
    ),
    Team(
      imagePath: 'assets/users/pexels-alexander-krivitskiy-2101796.jpg',
      name: 'Zina Blatter',
      title: 'Architect',
      org: 'Bruen Group',
    ),
    Team(
      imagePath: 'assets/users/pexels-nappy-936119.jpg',
      name: 'Benito Duet',
      title: 'Analyst',
      org: 'Howell Inc',
    ),
  ];
}
