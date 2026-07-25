import 'package:flutter/material.dart';

class NodeData {
  const NodeData(
    this.name,
    this.role,
    this.cpu,
    this.memory,
    this.disk,
    this.statusColor,
  );

  final String name;
  final String role;
  final String cpu;
  final String memory;
  final String disk;
  final Color statusColor;
}