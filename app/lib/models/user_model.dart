import 'package:app/models/project.dart';
import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier{
  int budget;
  Map<String, int> budgetForProject =  Map<String, int>();
  Map<String, Project> idToProject = Map<String, Project>();
  Set<String> likedProjects = new Set();
  Set<String> dislikedProjects = new Set();

  bool red = true;

  bool getRed() {
    return red;
  }

  void toggleRed() {
    red = !red;
    notifyListeners();
  }

  bool likes(String proj) {
    return likedProjects.contains(proj);
  }

  bool dislikes(String proj) {
    return dislikedProjects.contains(proj);
  }

  void like(String proj) {
    likedProjects.add(proj);

    notifyListeners();
  }

  void unLike(String proj) {
    likedProjects.remove(proj);

    notifyListeners();
  }

  void dislike(String proj) {
    dislikedProjects.add(proj);

    notifyListeners();
  }

  void unDislike(String proj) {
    dislikedProjects.remove(proj);

    notifyListeners();
  }


  UserModel({this.budget = 10});
}