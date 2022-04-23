// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagran_tute/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShower = false;
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width - 4,
      height: MediaQuery.of(context).size.height - 80,
      padding: EdgeInsets.all(20),
      color: mobileBackgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 10),
                Text(
                  userProvider.getUser.username,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.post_add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 0.3,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: mobileSearchColor,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Icon(Icons.search),
                  const SizedBox(width: 10),
                  Container(
                    width: 300,
                    height: 50,
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search here',
                        border: InputBorder.none,
                      ),
                      onFieldSubmitted: (String _) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Row(
                children: [
                  Text('Messages'),
                  Spacer(),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      '1 request',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                return Column(
                    children: snapshots.data!.docs.map((e) {
                  return MessageUserItem(
                    snap: e.data(),
                    userProvider: userProvider,
                  );
                }).toList());
              },
            )
          ],
        ),
      ),
    );
  }
}

class MessageUserItem extends StatelessWidget {
  final Map<String, dynamic> snap;
  final UserProvider userProvider;
  const MessageUserItem({
    Key? key,
    required this.snap,
    required this.userProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (userProvider.getUser.uid == snap['uid'])
        ? Container()
        : InkWell(
            onTap: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) => Dialog(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 4,
                    height: MediaQuery.of(context).size.height - 80,
                    padding: EdgeInsets.all(20),
                    color: mobileBackgroundColor,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back),
                              ),
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      snap['photoUrl'],
                                    ),
                                    radius: 25,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    snap['username'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.call_outlined),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 0.3,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).size.height / 7 * 2,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(snap['photoUrl']),
                                        radius: 60,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        snap['username'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text('Instagram'),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${snap['followers'].length} Followers . ${snap['following'].length} Following',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'You guys are following each other on Instagram',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Follow ${snap['username']} and 33 others',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.9,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue),
                                    child: Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 230,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Send Message',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.mic_outlined),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.photo),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.gif_box_rounded),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Stack(
                    overflow: Overflow.visible,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          snap['photoUrl'],
                        ),
                        radius: 25,
                      ),
                      Positioned(
                        top: 40,
                        left: 40,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 77, 174, 80),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snap['username'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text('Message nearest'),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
