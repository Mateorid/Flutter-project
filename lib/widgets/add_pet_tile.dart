import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../styles.dart';

class AddPetCard extends StatelessWidget {
  const AddPetCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: GestureDetector(
        onTap: () => {context.pushNamed("create_pet")},
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 50,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Container(
                    color: MAIN_GREEN,
                    width: 50,
                    height: 50,
                    child: Icon(Icons.pets, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'ADD PET',
                          style: TextStyle(
                            color: DARK_GREEN,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.add, color: MAIN_GREEN),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
