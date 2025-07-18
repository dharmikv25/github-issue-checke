import 'package:flutter/material.dart';
import 'package:githubproject/viewmodel/provider.dart';
import 'package:githubproject/view/issuetile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final provider = Provider.of<IProvider>(context, listen: false);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoading &&
          provider.hasMore) {
        provider.fetchIssues(_controller.text, loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GitHub Issue Check',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'GitHub Repo URL',
                hintText: 'e.g. https://github.com/flutter/flutter',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 1, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Filter: '),
                DropdownButton<String>(
                  borderRadius: BorderRadius.circular(10),
                  dropdownColor: Colors.grey,
                  value: provider.issueState,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'open', child: Text('Open')),
                    DropdownMenuItem(value: 'closed', child: Text('Closed')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      provider.setIssueState(value);
                      provider.fetchIssues(_controller.text);
                    }
                  },
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(elevation: WidgetStateProperty.all(5)),
              onPressed: () {
                provider.fetchIssues(_controller.text);
              },
              child: const Text('Click'),
            ),
            const SizedBox(height: 10),
            if (provider.errorMessage != null)
              Text(
                provider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            if (provider.isLoading && provider.issues.isEmpty)
              const CircularProgressIndicator(),
            if (provider.issues.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      provider.issues.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < provider.issues.length) {
                      return IssueTile(issue: provider.issues[index]);
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
