import 'package:equatable/equatable.dart';
import 'package:kakao_flutter_sdk_story/kakao_flutter_sdk_story.dart';
import 'package:meta/meta.dart';

@immutable
abstract class StoryDetailEvent extends Equatable {
  StoryDetailEvent([List props = const []]) : super(props);
}

class FetchStoryDetail extends StoryDetailEvent {
  final Story simpleStory;
  FetchStoryDetail(this.simpleStory) : super([simpleStory]);

  @override
  String toString() => "$runtimeType with story: $simpleStory";
}

class DeleteStory extends StoryDetailEvent {
  final Story story;
  DeleteStory(this.story) : super([story]);
}
