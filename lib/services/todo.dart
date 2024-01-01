import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'todo.g.dart';

@RestApi(baseUrl: 'https://65927080bb129707198fb9bb.mockapi.io/api/v1')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/tasks')
  Future<List<Task>> getTasks();

  @GET('/tasks/{id}')
  Future<Task> getTask(@Path('id') String id);

  @POST('/tasks')
  Future<Task> createTask(@Body() Task task);

  @PATCH('/tasks/{id}')
  Future<Task> updateTaskPart(
      @Path() String id, @Body() Map<String, dynamic> map);

  @PUT('/tasks/{id}')
  Future<Task> updateTask(@Path() String id, @Body() Task task);

  @DELETE('/tasks/{id}')
  Future<void> deleteTask(@Path() String id);
}

@JsonSerializable()
class Task {
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "completed")
  bool? completed;
  @JsonKey(name: "id")
  String? id;

  Task({
    this.createdAt,
    this.title,
    this.completed,
    this.id,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
