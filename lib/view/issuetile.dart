
import 'package:flutter/material.dart';
import 'package:githubproject/model/issue_model.dart';
import 'package:intl/intl.dart';

class IssueTile extends StatelessWidget {
  final GitIssue issue;
  const IssueTile({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text('#${issue.number} ${issue.title}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('State: ${issue.state}',   style: TextStyle(
        color: issue.state == 'open' ? Colors.green : Colors.red,
        fontWeight: FontWeight.bold,)),
            Text('Created at: ${DateFormat.yMMMd().format(DateTime.parse(issue.createdAt))}'),
            Text('User: ${issue.user}'),
            if (issue.labels.isNotEmpty)
              Wrap(
                spacing: 6,
                children: issue.labels.map((label) => Chip(label: Text(label))).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
