import 'package:flutter/cupertino.dart';

class StreamWrapper<T> extends StatelessWidget {

  final Stream<T> stream;
  final Widget Function(BuildContext, T) builder;

  const StreamWrapper({required this.stream, required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data as T);
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else {
          return const Center(child: CupertinoActivityIndicator());
        }
      },
    );
  }
}
