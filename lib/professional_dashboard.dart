import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'views_page.dart';
import 'cache_service.dart';

class ProfessionalDashboardPage extends StatefulWidget {
  @override
  _ProfessionalDashboardPageState createState() =>
      _ProfessionalDashboardPageState();
}

class _ProfessionalDashboardPageState extends State<ProfessionalDashboardPage> {
  bool isEditingEnabled = false;
  bool isSaving = false;

  // Editable text controllers for insights
  final TextEditingController viewsController = TextEditingController(
    text: '1.7T',
  );
  final TextEditingController interactionsController = TextEditingController(
    text: '800',
  );
  final TextEditingController newFollowersController = TextEditingController(
    text: '202',
  );
  final TextEditingController contentSharedController = TextEditingController(
    text: '2',
  );
  final TextEditingController dateController = TextEditingController(
    text: '7 Jul-5 Aug',
  );

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    final cachedData = await CacheService.loadViewsData();
    if (cachedData != null) {
      _applyCachedData(cachedData);
      setState(() {}); // Trigger UI update
    }
  }

  void _applyCachedData(Map<String, dynamic> data) {
    if (data['totalViews'] != null) viewsController.text = data['totalViews'];
    if (data['date'] != null) dateController.text = data['date'];
    if (data['interactions'] != null)
      interactionsController.text = data['interactions'];
    if (data['newFollowers'] != null)
      newFollowersController.text = data['newFollowers'];
    if (data['contentShared'] != null)
      contentSharedController.text = data['contentShared'];
  }

  Future<void> _saveToCache() async {
    setState(() {
      isSaving = true;
    });

    final data = {
      'totalViews': viewsController.text,
      'date': dateController.text,
      'interactions': interactionsController.text,
      'newFollowers': newFollowersController.text,
      'contentShared': contentSharedController.text,
    };
    await CacheService.saveViewsData(data);

    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  const SizedBox(width: 16),
                  Text(
                    'Professional dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  const Spacer(),
                  isEditingEnabled
                      ? Row(
                          children: [
                            if (isSaving)
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditingEnabled = !isEditingEnabled;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                width: 50,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: const Color(0xFF2E3337),
                                ),
                                child: Stack(
                                  children: [
                                    // Toggle switch
                                    AnimatedPositioned(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                      left: 24,
                                      top: 2,
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFF63CF3),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isEditingEnabled = !isEditingEnabled;
                            });
                          },
                          child: SvgPicture.string(
                            '''<svg xmlns="http://www.w3.org/2000/svg" shape-rendering="geometricPrecision" text-rendering="geometricPrecision" image-rendering="optimizeQuality" fill-rule="evenodd" clip-rule="evenodd" viewBox="0 0 512 511.999"><path d="M308.407 37.815a222.645 222.645 0 0164.785 26.879l.597-.603c14.398-14.392 37.948-14.398 52.34 0l21.78 21.78c14.392 14.392 14.392 37.942 0 52.34l-.651.645a222.91 222.91 0 0126.781 64.743l.95-.006c20.355.006 37.011 16.655 37.011 37.011v30.798c0 20.355-16.656 37.011-37.011 37.011h-1.017a222.844 222.844 0 01-26.836 64.615l.773.766c14.392 14.398 14.392 37.949 0 52.347l-21.78 21.773c-14.392 14.398-37.948 14.398-52.34 0l-.785-.779.109-.109a222.945 222.945 0 01-64.773 26.854h.067v1.108c0 20.355-16.655 37.011-37.005 37.011h-30.804c-20.356 0-37.005-16.656-37.005-37.011v-1.108h.012a222.646 222.646 0 01-64.627-26.769l.012.012-.779.785c-14.398 14.392-37.948 14.392-52.34 0l-21.78-21.779c-14.398-14.392-14.392-37.943 0-52.341l.749-.742a222.952 222.952 0 01-26.836-64.633h-.993C16.65 308.413 0 291.757 0 271.402v-30.798c-.006-20.356 16.65-37.005 37.011-37.011l.901.006a222.893 222.893 0 0126.8-64.761l-.621-.621c-14.398-14.398-14.392-37.948 0-52.34l21.78-21.78c14.386-14.398 37.936-14.392 52.34 0l.585.597a222.962 222.962 0 0164.797-26.885v-.798C203.593 16.656 220.242 0 240.598 0h30.804c20.35 0 37.005 16.656 37.005 37.011v.804zm-52.413 50.453c92.638 0 167.731 75.094 167.731 167.732 0 92.637-75.093 167.731-167.731 167.731-92.638 0-167.731-75.094-167.731-167.731 0-92.638 75.093-167.732 167.731-167.732z"/></svg>''',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Insights Section
                    Row(
                      children: [
                        Text(
                          'Insights',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        const Spacer(),
                        isEditingEnabled
                            ? Container(
                                width: 100,
                                child: TextField(
                                  controller: dateController,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                  onChanged: (value) => _saveToCache(),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                dateController.text,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Insights Metrics
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewsPage()),
                        );
                        // Refresh data when returning from views page
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _loadCachedData();
                        });
                      },
                      child: _buildInsightMetric(
                        'Views',
                        '1.7T',
                        true,
                        controller: viewsController,
                      ),
                    ),
                    _buildInsightMetric(
                      'Interactions',
                      '800',
                      true,
                      controller: interactionsController,
                    ),
                    _buildInsightMetric(
                      'New followers',
                      '202',
                      true,
                      controller: newFollowersController,
                    ),
                    _buildInsightMetric(
                      'Content you shared',
                      '2',
                      false,
                      controller: contentSharedController,
                    ),

                    const SizedBox(height: 20),

                    // Divider
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: const Color.fromARGB(255, 46, 46, 46),
                    ),

                    const SizedBox(height: 20),

                    // Next Steps Section
                    Text(
                      'Next steps',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Get Meta Verified Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[600]!.withOpacity(0.3),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Image.asset(
                              'icons/verified.png',
                              width: 24,
                              height: 24,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Get Meta Verified',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sign up for a verified badge, account protection and more.',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.string(
                            '''<?xml version="1.0" encoding="utf-8"?><svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 66.91 122.88" style="enable-background:new 0 0 66.91 122.88" xml:space="preserve"><g><path d="M1.95,111.2c-2.65,2.72-2.59,7.08,0.14,9.73c2.72,2.65,7.08,2.59,9.73-0.14L64.94,66l-4.93-4.79l4.95,4.8 c2.65-2.74,2.59-7.11-0.15-9.76c-0.08-0.08-0.16-0.15-0.24-0.22L11.81,2.09c-2.65-2.73-7-2.79-9.73-0.14 C-0.64,4.6-0.7,8.95,1.95,11.68l48.46,49.55L1.95,111.2L1.95,111.2L1.95,111.2z"/></g></svg>''',
                            width: 12,
                            height: 12,
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Divider
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: const Color.fromARGB(255, 46, 46, 46),
                    ),

                    const SizedBox(height: 20),

                    // Your Tools Section
                    Row(
                      children: [
                        Text(
                          'Your tools',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'See all',
                          style: TextStyle(
                            color: const Color(0xFF4A5FF8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Tools List
                    _buildToolItem(
                      'Monthly recap',
                      'See what you made happen last\nmonth.',
                      Icons.refresh,
                      hasNewBadge: true,
                      customIconPath: 'icons/1.png',
                    ),
                    _buildToolItem(
                      'Best practices',
                      '',
                      Icons.school,
                      hasNewBadge: true,
                      customIconPath: 'icons/2.png',
                    ),
                    _buildToolItem(
                      'Inspiration',
                      '',
                      Icons.lightbulb_outline,
                      hasNewBadge: false,
                      customIconPath: 'icons/3.png',
                    ),
                    _buildToolItem(
                      'Partnership ads',
                      '',
                      Icons.people,
                      hasNewBadge: false,
                      customIconPath: 'icons/4.png',
                    ),
                    _buildToolItem(
                      'Ad tools',
                      '',
                      Icons.trending_up,
                      hasNewBadge: false,
                      customIconPath: 'icons/5.png',
                    ),
                    _buildToolItem(
                      'Your AIs',
                      '',
                      Icons.grid_view,
                      hasNewBadge: false,
                      customIconPath: 'icons/6.png',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightMetric(
    String label,
    String value,
    bool hasGrowth, {
    TextEditingController? controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro Display',
            ),
          ),
          const Spacer(),
          if (hasGrowth) ...[
            Image.asset('icons/grow.png', width: 12, height: 12),
            const SizedBox(width: 8),
          ],
          isEditingEnabled && controller != null
              ? Container(
                  width: 80,
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SF Pro Display',
                    ),
                    textAlign: TextAlign.right,
                    onChanged: (value) => _saveToCache(),
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                    ),
                  ),
                )
              : Text(
                  controller?.text ?? value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
          const SizedBox(width: 8),
          SvgPicture.string(
            '''<?xml version="1.0" encoding="utf-8"?><svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 66.91 122.88" style="enable-background:new 0 0 66.91 122.88" xml:space="preserve"><g><path d="M1.95,111.2c-2.65,2.72-2.59,7.08,0.14,9.73c2.72,2.65,7.08,2.59,9.73-0.14L64.94,66l-4.93-4.79l4.95,4.8 c2.65-2.74,2.59-7.11-0.15-9.76c-0.08-0.08-0.16-0.15-0.24-0.22L11.81,2.09c-2.65-2.73-7-2.79-9.73-0.14 C-0.64,4.6-0.7,8.95,1.95,11.68l48.46,49.55L1.95,111.2L1.95,111.2L1.95,111.2z"/></g></svg>''',
            width: 12,
            height: 12,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem(
    String title,
    String description,
    IconData icon, {
    required bool hasNewBadge,
    String? customIcon,
    String? customIconPath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: customIconPath != null
                ? Image.asset(
                    customIconPath,
                    width: 24,
                    height: 24,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(icon, color: Colors.white, size: 24);
                    },
                  )
                : customIcon != null
                ? SvgPicture.string(
                    customIcon,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro Display',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontFamily: 'SF Pro Display',
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),
          if (hasNewBadge) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4A5FF8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'New',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          SvgPicture.string(
            '''<?xml version="1.0" encoding="utf-8"?><svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 66.91 122.88" style="enable-background:new 0 0 66.91 122.88" xml:space="preserve"><g><path d="M1.95,111.2c-2.65,2.72-2.59,7.08,0.14,9.73c2.72,2.65,7.08,2.59,9.73-0.14L64.94,66l-4.93-4.79l4.95,4.8 c2.65-2.74,2.59-7.11-0.15-9.76c-0.08-0.08-0.16-0.15-0.24-0.22L11.81,2.09c-2.65-2.73-7-2.79-9.73-0.14 C-0.64,4.6-0.7,8.95,1.95,11.68l48.46,49.55L1.95,111.2L1.95,111.2L1.95,111.2z"/></g></svg>''',
            width: 12,
            height: 12,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Icon(
      icon,
      color: isActive ? Colors.white : Colors.grey[600],
      size: 24,
    );
  }

  @override
  void dispose() {
    viewsController.dispose();
    interactionsController.dispose();
    newFollowersController.dispose();
    contentSharedController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
