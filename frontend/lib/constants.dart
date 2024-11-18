import 'package:flutter/material.dart';

const Color kBase0Color = Color(0x88CBDCEB);
const Color kBase1Color = Color(0xFFDCF2F1);
const Color kBase2Color = Color(0xFF7FC7D9);
const Color kBase3Color = Color(0xFF365486);
const Color kBase4Color = Color(0xFF0F1035);

const apiUrl = 'http://192.168.22.170:3000/api';

// enum type for book category
enum BookFilter {
  newRelease,
  topRated,
  mostBorrowed,
}