import 'package:flutter/material.dart';

class IssueForm extends StatelessWidget {
  final String bookId;

  const IssueForm({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TicketPage extends StatefulWidget {
  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.topCenter,
        child: Container(
            color: Color(0xFF365486),
            height: 50,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    print('Pressed return!');
                  },
                  color: Color(0xFF0F1035),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Ticket',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xFF0F1035),
                  ),
                ),
              ],
            )),
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 238, 238, 238),
                        width: 5.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/SWSG.jpg',
                      height: 300,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 220,
                          child: Flexible(
                            child: Text('Secret window, secret garden',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('BOOK-ID:x0000000000000',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                                color:
                                    const Color.fromARGB(255, 110, 110, 110))),
                        SizedBox(height: 20),
                        Text('TICKET-ID:'),
                        SizedBox(
                          width: 220,
                          child: Text('2211129-HoThaiHoa-abc-6/11',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ),
                        SizedBox(height: 20),
                        Text('Issue date:'),
                        SizedBox(
                          width: 220,
                          child: Text('6/11/2024',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ),
                        Text('Due date:'),
                        SizedBox(
                          width: 220,
                          child: Text('20/11/2024',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ),
                        SizedBox(
                          width: 220,
                          child: Text(
                              'After this date, if the book is not returned, account credit will be decreased',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w200,
                                  color:
                                      const Color.fromARGB(255, 75, 75, 75))),
                        )
                      ]),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          height: 1.8,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              style: TextStyle(fontWeight: FontWeight.w700),
                              text: 'Author: '),
                          TextSpan(text: 'Stephen King\n'),
                          TextSpan(
                              style: TextStyle(fontWeight: FontWeight.w700),
                              text: 'Language: '),
                          TextSpan(text: 'English\n'),
                          TextSpan(
                              style: TextStyle(fontWeight: FontWeight.w700),
                              text: 'Edition: '),
                          TextSpan(
                            text:
                                'First published in 1990 (Hardcover Edition)\n', // Second part of the text
                          ),
                          TextSpan(
                              style: TextStyle(fontWeight: FontWeight.w700),
                              text: 'Category: '),
                          TextSpan(
                            text:
                                'Fiction, Horror, Suspense, Short Stories\n', // Third part of the text
                          ),
                          TextSpan(
                              style: TextStyle(fontWeight: FontWeight.w700),
                              text: 'Description: \n'),
                          TextSpan(
                            text: _isExpanded
                                ? 'Secret Window, Secret Garden is a collection of four short stories by Stephen King. '
                                    'The stories explore different themes, from psychological terror to supernatural occurrences, '
                                    'keeping the reader engaged with King’s signature suspenseful and eerie storytelling. '
                                    'The most famous of the stories in the collection, “Secret Window, Secret Garden,” was later adapted into a film, '
                                    'starring Johnny Depp. The plot revolves around a writer, Mort Rainey, who is accused of plagiarism by a mysterious '
                                    'man, and it spirals into a twisted tale of mystery, paranoia, and horror'
                                : 'Secret Window, Secret Garden is a collection of four short stories by Stephen King. '
                                    'The stories explore...',
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Text(
                        _isExpanded ? 'Show Less' : 'Show More',
                        style: TextStyle(
                            color: const Color.fromRGBO(
                                131, 131, 131, 1), // Text color for the button
                            fontSize: 13, // Text size for the button
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  height: 40,
                  width: 110,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF365486),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        print('Issue Pressed!');
                      },
                      child: Text(
                        'Issue',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                ),
              )
            ]),
          ),
        ),
      ),
    ]);
  }
}

