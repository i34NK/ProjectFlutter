import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text('id',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        children: [
                          Text("Name",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('email'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}