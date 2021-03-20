import 'package:app/models/project.dart';

class UserModel {
  int budget;
  Map<String, int> budgetForProject =  Map<String, int>();
  Map<String, Project> idToProject = Map<String, Project>();
  List<String> likedProjects = [];
  List<String> dislikedProjects = [];

  UserModel({this.budget = 10});
}