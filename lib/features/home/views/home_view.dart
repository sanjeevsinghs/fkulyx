import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/home/viewmodels/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Meal Planner',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Plan your weekly meals and track diet goals.',
                style: TextStyle(color: Color(0xFF666666)),
              ),
              const SizedBox(height: 14),
            
            ],
          ),
        ),
      ),
    );
  }
}
