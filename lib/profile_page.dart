import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'professional_dashboard.dart';
import 'views_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditingEnabled = false;
  File? selectedProfileImage;
  final ImagePicker _picker = ImagePicker();

  // Editable text controllers
  final TextEditingController nameController = TextEditingController(
    text: 'dontez.clipprzz',
  );
  final TextEditingController bioController = TextEditingController(
    text: '💰💸 | Take a look into Dontez Akram\'s\n📌 | Follow main account @_therealtez',
  );
  final TextEditingController postsController = TextEditingController(
    text: '1',
  );
  final TextEditingController followersController = TextEditingController(
    text: '137',
  );
  final TextEditingController followingController = TextEditingController(
    text: '3',
  );
  final TextEditingController viewsController = TextEditingController(
    text: '1.8K',
  );

  // Sample posts/reels data - exactly 9 posts for 3 rows of 3
  final List<Map<String, dynamic>> posts = [
    {
      'type': 'post',
      'thumbnail': null,
      'views': '1,234',
      'isReel': false,
    }
  ];

  String selectedTab = 'posts'; // 'posts', 'reels', 'tagged'
  
  // TextEditingController for username
  final TextEditingController usernameController = TextEditingController(text: 'dontez.clipprzz');

  void _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          selectedProfileImage = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Widget _buildEditableText({
    required TextEditingController controller,
    required TextStyle style,
    TextAlign textAlign = TextAlign.left,
  }) {
    if (isEditingEnabled) {
      return Container(
        constraints: BoxConstraints(maxWidth: 300),
        child: TextField(
          controller: controller,
          style: style,
          textAlign: textAlign,
          maxLines: null, // Allow multiple lines
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.white, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.white, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
      );
    } else {
      return Text(controller.text, style: style, textAlign: textAlign);
    }
  }

  Widget _buildStatItem(String label, TextEditingController controller) {
    return Column(
      children: [
        _buildEditableText(
          controller: controller,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF Pro Display',
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ],
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post, int index) {
    return GestureDetector(
      onTap: () async {
        // Show image picker when post is tapped - this should update post image
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        
        if (image != null) {
          // Update post image, not profile picture
          setState(() {
            posts[index]['thumbnail'] = File(image.path);
          });
        }
      },
      child: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
          color: const Color(0xFF2E3337),
        ),
        child: Stack(
          children: [
            // Post content - show selected image or placeholder
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D21),
                image: post['thumbnail'] != null
                    ? DecorationImage(
                        image: FileImage(post['thumbnail']),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: post['thumbnail'] == null
                  ? Center(
                      child: Icon(
                        post['isReel'] ? Icons.play_circle_outline : Icons.image,
                        color: Colors.white,
                        size: 32,
                      ),
                    )
                  : null,
            ),
            // Reel icon on top right
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Image.asset(
                  'reel.png',
                  width: 16,
                  height: 16,
                  color: Colors.white,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 16,
                    );
                  },
                ),
              ),
            ),
            // Views count at bottom left
            Positioned(
              bottom: 8,
              left: 8,
              child: Row(
                children: [
                  Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                    size: 12,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '4,285',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                // Header with username, down arrow, and top icons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                  child: Row(
                    children: [
                      _buildEditableText(
                        controller: usernameController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 24,
                      ),
                      Spacer(),
                      Image.asset(
                        'threads.png',
                        width: 29,
                        height: 29,
                        color: Colors.white,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 32,
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Stack(
                        children: [
                          Image.asset(
                            'add-post.png',
                            width: 29,
                            height: 29,
                            color: Colors.white,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.add_box_outlined,
                                color: Colors.white,
                                size: 32,
                              );
                            },
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Image.asset(
                        'menu.png',
                        width: 29,
                        height: 29,
                        color: Colors.white,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 32,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Profile Picture and Stats Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Profile Picture with overlay
                      GestureDetector(
                        onTap: _pickProfileImage,
                        child: Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: selectedProfileImage != null
                                    ? DecorationImage(
                                        image: FileImage(selectedProfileImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: selectedProfileImage == null
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.grey[600],
                                      size: 40,
                                    )
                                  : null,
                            ),
                            // Thinking cloud overlay
                            Positioned(
                              top: -5,
                              right: -5,
                              child: Container(
                                width: 30,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E3337).withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Stack(
                                  children: [
                                    // Main cloud bubble
                                    Positioned(
                                      top: 5,
                                      left: 5,
                                      child: Container(
                                        width: 20,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2E3337).withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    // Small thinking dot
                                    Positioned(
                                      top: 8,
                                      left: 12,
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Stats
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem('posts', postsController),
                            _buildStatItem('followers', followersController),
                            _buildStatItem('following', followingController),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Bio Section - Transparent with edge-to-edge text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildEditableText(
                      controller: bioController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Professional Dashboard Section - No icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfessionalDashboardPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E3337),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Professional dashboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildEditableText(
                                controller: viewsController,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                              Text(
                                ' views in the last 30 days',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 13,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Action Buttons - More rounded
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E3337),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            'Edit profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E3337),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Share profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // Tab Bar
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 'posts';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: selectedTab == 'posts'
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Image.asset(
                              'post.png',
                              width: 24,
                              height: 24,
                              color: selectedTab == 'posts'
                                  ? Colors.white
                                  : Colors.grey[400],
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.grid_on,
                                  color: selectedTab == 'posts'
                                      ? Colors.white
                                      : Colors.grey[400],
                                  size: 24,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewsPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Image.asset(
                              'reel.png',
                              width: 24,
                              height: 24,
                              color: Colors.grey[400],
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.play_circle_outline,
                                  color: selectedTab == 'reels'
                                      ? Colors.white
                                      : Colors.grey[400],
                                  size: 24,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // Toggle editing mode when tagged is tapped
                              isEditingEnabled = !isEditingEnabled;
                              if (isEditingEnabled) {
                                selectedTab = 'tagged';
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isEditingEnabled
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Image.asset(
                              'tagged.png',
                              width: 24,
                              height: 24,
                              color: isEditingEnabled
                                  ? Colors.white
                                  : Colors.grey[400],
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person_outline,
                                  color: isEditingEnabled
                                      ? Colors.white
                                      : Colors.grey[400],
                                  size: 24,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Grid - 300x400 posts with no edge spacing
                Container(
                  height: 400, // Fixed height for the grid
                  width: double.infinity,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(), // Disable scrolling for the grid
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: 0.75, // For 300x400 posts
                    ),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return _buildPostItem(posts[index], index);
                    },
                  ),
                ),
              ],
            ),
          ),
          ),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0F14),
        border: Border(
          top: BorderSide(
            color: Colors.grey[800]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'home.png',
            width: 28,
            height: 28,
            color: Colors.grey[400],
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.home,
                color: Colors.grey[400],
                size: 28,
              );
            },
          ),
          Image.asset(
            'search.png',
            width: 28,
            height: 28,
            color: Colors.grey[400],
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.search,
                color: Colors.grey[400],
                size: 28,
              );
            },
          ),
          Image.asset(
            'create.png',
            width: 28,
            height: 28,
            color: Colors.grey[400],
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.add_box_outlined,
                color: Colors.grey[400],
                size: 28,
              );
            },
          ),
          Image.asset(
            'reel.png',
            width: 28,
            height: 28,
            color: Colors.grey[400],
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.play_circle_outline,
                color: Colors.grey[400],
                size: 28,
              );
            },
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              image: selectedProfileImage != null
                  ? DecorationImage(
                      image: FileImage(selectedProfileImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: selectedProfileImage == null
                ? Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}
