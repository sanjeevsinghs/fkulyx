import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForumPost {
  final String id;
  final String title;
  final String image;
  final String category;
  final int views;
  final int likes;
  final int comments;
  final String authorName;
  final String authorTitle;
  final String authorImage;

  ForumPost({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.views,
    required this.likes,
    required this.comments,
    required this.authorName,
    required this.authorTitle,
    required this.authorImage,
  });
}

class ForumPerson {
  final String id;
  final String name;
  final String role;
  final String location;
  final String image;
  final List<String> tags;

  ForumPerson({
    required this.id,
    required this.name,
    required this.role,
    required this.location,
    required this.image,
    required this.tags,
  });
}

class CommunityForumController extends GetxController {
  final RxString selectedFilter = 'ALL'.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final RxList<ForumPost> allPosts = <ForumPost>[].obs;
  final RxList<ForumPerson> allPeople = <ForumPerson>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMockPosts();
    _initializeMockPeople();
  }

  void _initializeMockPosts() {
    allPosts.assignAll([
      ForumPost(
        id: '1',
        title: 'Quick Weeknight Dinners: Drop Your Go-To Recipe',
        image: 'assets/images/vagitable.png',
        category: 'Finance',
        views: 651324,
        likes: 36545,
        comments: 56,
        authorName: 'Pavel Gyay',
        authorTitle: '2 weeks ago',
        authorImage: 'assets/images/splash.png',
      ),
      ForumPost(
        id: '2',
        title: 'Best Kitchen Tools for Home Cooking',
        image: 'assets/images/glass_jar.png',
        category: 'bitcoin',
        views: 421000,
        likes: 28900,
        comments: 42,
        authorName: 'Sarah Chef',
        authorTitle: '1 week ago',
        authorImage: 'assets/images/splash.png',
      ),
      ForumPost(
        id: '3',
        title: 'Meal Prep Ideas for Busy Professionals',
        image: 'assets/images/vagitable.png',
        category: 'crypto',
        views: 532100,
        likes: 31200,
        comments: 38,
        authorName: 'John Diet',
        authorTitle: '3 days ago',
        authorImage: 'assets/images/splash.png',
      ),
      ForumPost(
        id: '4',
        title: 'Healthy Snack Recipes That Taste Amazing',
        image: 'assets/images/glass_jar.png',
        category: 'Finance',
        views: 789456,
        likes: 45123,
        comments: 67,
        authorName: 'Emma Health',
        authorTitle: '5 days ago',
        authorImage: 'assets/images/splash.png',
      ),
    ]);
  }

  void _initializeMockPeople() {
    allPeople.assignAll([
      ForumPerson(
        id: '1',
        name: 'Moosa Wasim Hadad',
        role: 'Commis Chef',
        location: 'Gustavo Nicolich',
        image: 'assets/images/splash.png',
        tags: const ['#RecipeSwap', '#Contests', '#ChefTalk'],
      ),
      ForumPerson(
        id: '2',
        name: 'Avery Dilan',
        role: 'Pastry Chef',
        location: 'Milo Crescent',
        image: 'assets/images/splash.png',
        tags: const ['#Baking', '#Desserts', '#ChefLife'],
      ),
    ]);
  }

  List<ForumPost> get filteredPosts {
    final currentFilter = selectedFilter.value;
    if (currentFilter != 'ALL' && currentFilter != 'Post') {
      return <ForumPost>[];
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return allPosts;
    }

    return allPosts.where((post) {
      return post.title.toLowerCase().contains(query) ||
          post.authorName.toLowerCase().contains(query);
    }).toList();
  }

  List<ForumPerson> get filteredPeople {
    final currentFilter = selectedFilter.value;
    if (currentFilter != 'ALL' && currentFilter != 'People') {
      return <ForumPerson>[];
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return allPeople;
    }

    return allPeople.where((person) {
      return person.name.toLowerCase().contains(query) ||
          person.role.toLowerCase().contains(query) ||
          person.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
