import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:kakao_flutter_sdk/src/template/model/button.dart';
import 'package:kakao_flutter_sdk/src/template/model/content.dart';
import 'package:kakao_flutter_sdk/src/template/model/social.dart';

part 'location_template.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class LocationTemplate extends DefaultTemplate {
  LocationTemplate(this.address, this.content,
      {this.addressTitle, this.social, this.buttons});

  final String address;
  final Content content;
  final String addressTitle;
  final Social social;
  final List<Button> buttons;

  final String objectType = "location";

  factory LocationTemplate.fromJson(Map<String, dynamic> json) =>
      _$LocationTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$LocationTemplateToJson(this);
}