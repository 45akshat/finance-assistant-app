import 'package:flutter/material.dart';

Column LoginHeaderWidget(Size size) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  
                  Align(alignment: Alignment.center, child: Image(image: const AssetImage('assets/img/man-on-dollar.png'), height: size.height*0.3)),
                  
                  Text("Welcome!", style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 30, fontWeight: FontWeight.bold)),
                  Text("Track and hack your finances like never before", style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16)),
                ],
              );
  }

