import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'cache_service.dart';

class ViewsPage extends StatefulWidget {
  const ViewsPage({super.key});

  @override
  _ViewsPageState createState() => _ViewsPageState();
}

class _ViewsPageState extends State<ViewsPage> with TickerProviderStateMixin {
  bool isEditingEnabled = false;
  bool isSaving = false;
  String selectedFilter = 'All';
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  // TextEditingControllers for editable fields
  final TextEditingController totalViewsController = TextEditingController(
    text: '1.7T',
  );
  final TextEditingController dateController = TextEditingController(
    text: '8 Jul - 6 Aug',
  );
  final TextEditingController reelsPercentController = TextEditingController(
    text: '97.2%',
  );
  final TextEditingController storiesPercentController = TextEditingController(
    text: '0.2%',
  );
  final TextEditingController accountsReachedController = TextEditingController(
    text: '1.1T',
  );
  final TextEditingController profileActivityController = TextEditingController(
    text: '87',
  );
  final TextEditingController profileActivityGrowthController =
      TextEditingController(text: '+2,800%');
  final TextEditingController profileVisitsController = TextEditingController(
    text: '85',
  );
  final TextEditingController profileVisitsGrowthController =
      TextEditingController(text: '+2,733.3%');
  final TextEditingController externalLinksController = TextEditingController(
    text: '2',
  );
  final TextEditingController externalLinksGrowthController =
      TextEditingController(text: '0%');

  // City controllers
  final TextEditingController newYorkController = TextEditingController(
    text: '12.3%',
  );
  final TextEditingController losAngelesController = TextEditingController(
    text: '8.7%',
  );
  final TextEditingController chicagoController = TextEditingController(
    text: '6.2%',
  );
  final TextEditingController houstonController = TextEditingController(
    text: '4.1%',
  );

  // Country controllers
  final TextEditingController unitedStatesController = TextEditingController(
    text: '45.2%',
  );
  final TextEditingController unitedKingdomController = TextEditingController(
    text: '12.8%',
  );
  final TextEditingController canadaController = TextEditingController(
    text: '8.1%',
  );
  final TextEditingController australiaController = TextEditingController(
    text: '6.3%',
  );

  // Age controllers
  final TextEditingController age25to34Controller = TextEditingController(
    text: '32.4%',
  );
  final TextEditingController age18to24Controller = TextEditingController(
    text: '28.7%',
  );
  final TextEditingController age35to44Controller = TextEditingController(
    text: '19.2%',
  );
  final TextEditingController age45to54Controller = TextEditingController(
    text: '12.1%',
  );

  // Gender controllers
  final TextEditingController genderMenController = TextEditingController(
    text: '78.4%',
  );
  final TextEditingController genderWomenController = TextEditingController(
    text: '21.6%',
  );

  // Video content controller
  final TextEditingController videoViewsController = TextEditingController(
    text: '4.7T',
  );
  final TextEditingController followersPercentController =
      TextEditingController(text: '6.3%');
  final TextEditingController nonFollowersPercentController =
      TextEditingController(text: '93.7%');

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    final cachedData = await CacheService.loadViewsData();
    if (cachedData != null) {
      _applyCachedData(cachedData);
    }
  }

  void _applyCachedData(Map<String, dynamic> data) {
    if (data['totalViews'] != null)
      totalViewsController.text = data['totalViews'];
    if (data['date'] != null) dateController.text = data['date'];
    if (data['reelsPercent'] != null)
      reelsPercentController.text = data['reelsPercent'];
    if (data['storiesPercent'] != null)
      storiesPercentController.text = data['storiesPercent'];
    if (data['accountsReached'] != null)
      accountsReachedController.text = data['accountsReached'];
    if (data['profileActivity'] != null)
      profileActivityController.text = data['profileActivity'];
    if (data['profileActivityGrowth'] != null)
      profileActivityGrowthController.text = data['profileActivityGrowth'];
    if (data['profileVisits'] != null)
      profileVisitsController.text = data['profileVisits'];
    if (data['profileVisitsGrowth'] != null)
      profileVisitsGrowthController.text = data['profileVisitsGrowth'];
    if (data['externalLinks'] != null)
      externalLinksController.text = data['externalLinks'];
    if (data['externalLinksGrowth'] != null)
      externalLinksGrowthController.text = data['externalLinksGrowth'];
    if (data['newYork'] != null) newYorkController.text = data['newYork'];
    if (data['losAngeles'] != null)
      losAngelesController.text = data['losAngeles'];
    if (data['chicago'] != null) chicagoController.text = data['chicago'];
    if (data['houston'] != null) houstonController.text = data['houston'];
    if (data['unitedStates'] != null)
      unitedStatesController.text = data['unitedStates'];
    if (data['unitedKingdom'] != null)
      unitedKingdomController.text = data['unitedKingdom'];
    if (data['canada'] != null) canadaController.text = data['canada'];
    if (data['australia'] != null) australiaController.text = data['australia'];
    if (data['age25to34'] != null) age25to34Controller.text = data['age25to34'];
    if (data['age18to24'] != null) age18to24Controller.text = data['age18to24'];
    if (data['age35to44'] != null) age35to44Controller.text = data['age35to44'];
    if (data['age45to54'] != null) age45to54Controller.text = data['age45to54'];
    if (data['genderMen'] != null) genderMenController.text = data['genderMen'];
    if (data['genderWomen'] != null)
      genderWomenController.text = data['genderWomen'];
    if (data['videoViews'] != null)
      videoViewsController.text = data['videoViews'];
    if (data['followersPercent'] != null)
      followersPercentController.text = data['followersPercent'];
    if (data['nonFollowersPercent'] != null)
      nonFollowersPercentController.text = data['nonFollowersPercent'];
  }

  Future<void> _saveToCache() async {
    setState(() {
      isSaving = true;
    });

    final data = {
      'totalViews': totalViewsController.text,
      'date': dateController.text,
      'reelsPercent': reelsPercentController.text,
      'storiesPercent': storiesPercentController.text,
      'accountsReached': accountsReachedController.text,
      'profileActivity': profileActivityController.text,
      'profileActivityGrowth': profileActivityGrowthController.text,
      'profileVisits': profileVisitsController.text,
      'profileVisitsGrowth': profileVisitsGrowthController.text,
      'externalLinks': externalLinksController.text,
      'externalLinksGrowth': externalLinksGrowthController.text,
      'newYork': newYorkController.text,
      'losAngeles': losAngelesController.text,
      'chicago': chicagoController.text,
      'houston': houstonController.text,
      'unitedStates': unitedStatesController.text,
      'unitedKingdom': unitedKingdomController.text,
      'canada': canadaController.text,
      'australia': australiaController.text,
      'age25to34': age25to34Controller.text,
      'age18to24': age18to24Controller.text,
      'age35to44': age35to44Controller.text,
      'age45to54': age45to54Controller.text,
      'genderMen': genderMenController.text,
      'genderWomen': genderWomenController.text,
      'videoViews': videoViewsController.text,
      'followersPercent': followersPercentController.text,
      'nonFollowersPercent': nonFollowersPercentController.text,
    };
    await CacheService.saveViewsData(data);

    setState(() {
      isSaving = false;
    });
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1D21),
          title: Text(
            'Reset to Default',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'SF Pro Display',
            ),
          ),
          content: Text(
            'This will clear all cached data and reset to default values. Continue?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'SF Pro Display',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _resetToDefaults();
                Navigator.of(context).pop();
              },
              child: Text(
                'Reset',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetToDefaults() async {
    await CacheService.clearCache();
    setState(() {
      // Reset all controllers to default values
      totalViewsController.text = '1.7T';
      dateController.text = '8 Jul - 6 Aug';
      reelsPercentController.text = '97.2%';
      storiesPercentController.text = '0.2%';
      accountsReachedController.text = '1.1T';
      profileActivityController.text = '87';
      profileActivityGrowthController.text = '+2,800%';
      profileVisitsController.text = '85';
      profileVisitsGrowthController.text = '+2,733.3%';
      externalLinksController.text = '2';
      externalLinksGrowthController.text = '0%';
      newYorkController.text = '12.3%';
      losAngelesController.text = '8.7%';
      chicagoController.text = '6.2%';
      houstonController.text = '4.1%';
      unitedStatesController.text = '45.2%';
      unitedKingdomController.text = '12.8%';
      canadaController.text = '8.1%';
      australiaController.text = '6.3%';
      age25to34Controller.text = '32.4%';
      age18to24Controller.text = '28.7%';
      age35to44Controller.text = '19.2%';
      age45to54Controller.text = '12.1%';
      genderMenController.text = '78.4%';
      genderWomenController.text = '21.6%';
      videoViewsController.text = '4.7T';
      followersPercentController.text = '6.3%';
      nonFollowersPercentController.text = '93.7%';
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Views',
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
                                  isEditingEnabled = false;
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: const Color(0xFF2E3337),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.info_outline,
                                    color: const Color(0xFFF63CF3),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isEditingEnabled = true;
                            });
                          },
                          onLongPress: () {
                            _showResetDialog();
                          },
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 20,
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
                    // Date and Filter
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E3337),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Last 30 days',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        isEditingEnabled
                            ? Container(
                                width: 120,
                                child: TextField(
                                  controller: dateController,
                                  style: TextStyle(
                                    color: Colors.white,
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
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Total Views
                    Center(
                      child: Column(
                        children: [
                          isEditingEnabled
                              ? Container(
                                  width: 120,
                                  child: TextField(
                                    controller: totalViewsController,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SF Pro Display',
                                    ),
                                    textAlign: TextAlign.center,
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
                                  totalViewsController.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                          const SizedBox(height: 4),
                          Text(
                            'Views',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Donut Chart Section with Labels
                    Center(
                      child: Container(
                        width: 320,
                        height: 80,
                        child: Stack(
                          children: [
                            // Chart
                            Center(
                              child: Container(
                                width: 80,
                                height: 80,
                                child: Stack(
                                  children: [
                                    // Background circle
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF111111),
                                      ),
                                    ),
                                    // Purple segment (non-followers percentage)
                                    CustomPaint(
                                      size: Size(80, 80),
                                      painter: DonutChartPainter(
                                        percentage:
                                            _getNonFollowersPercentage(),
                                        color: const Color(0xFF783AF7),
                                        startAngle: -90,
                                      ),
                                    ),
                                    // Pink segment (followers percentage)
                                    CustomPaint(
                                      size: Size(80, 80),
                                      painter: DonutChartPainter(
                                        percentage: _getFollowersPercentage(),
                                        color: const Color(0xFFF63CF3),
                                        startAngle:
                                            -90 +
                                            (_getNonFollowersPercentage() *
                                                360),
                                      ),
                                    ),
                                    // Black separator lines
                                    CustomPaint(
                                      size: Size(80, 80),
                                      painter: DonutSeparatorPainter(
                                        angle1: -90,
                                        angle2:
                                            -90 +
                                            (_getNonFollowersPercentage() *
                                                360),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Left label - Followers
                            Positioned(
                              left: 30,
                              top: 30,
                              child: Column(
                                children: [
                                  isEditingEnabled
                                      ? Container(
                                          width: 60,
                                          child: TextField(
                                            controller:
                                                followersPercentController,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'SF Pro Display',
                                            ),
                                            textAlign: TextAlign.center,
                                            onChanged: (value) {
                                              // Auto-adjust the other percentage to maintain 100% total
                                              double followersPercent =
                                                  double.tryParse(
                                                    value.replaceAll('%', ''),
                                                  ) ??
                                                  0;
                                              double nonFollowersPercent =
                                                  100 - followersPercent;
                                              nonFollowersPercentController
                                                      .text =
                                                  '${nonFollowersPercent.toStringAsFixed(1)}%';
                                              setState(() {});
                                              _saveToCache();
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 2,
                                                ),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                    vertical: 2,
                                                  ),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          followersPercentController.text,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'SF Pro Display',
                                          ),
                                        ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF63CF3),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Followers',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 10,
                                          fontFamily: 'SF Pro Display',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Right label - Non-followers
                            Positioned(
                              right: 17,
                              top: 30,
                              child: Column(
                                children: [
                                  Text(
                                    '${(100 - _getFollowersPercentage() * 100).toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SF Pro Display',
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF783AF7),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Non-followers',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 10,
                                          fontFamily: 'SF Pro Display',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Accounts Reached
                    Row(
                      children: [
                        Text(
                          'Accounts reached',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        const Spacer(),
                        isEditingEnabled
                            ? Container(
                                width: 80,
                                child: TextField(
                                  controller: accountsReachedController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                  textAlign: TextAlign.right,
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
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                accountsReachedController.text,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                        const SizedBox(width: 8),
                        Text(
                          '',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Divider
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: const Color.fromARGB(255, 46, 46, 46),
                    ),

                    const SizedBox(height: 24),

                    // By Content Type Section
                    Text(
                      'By content type',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Filter Buttons
                    Row(
                      children: [
                        _buildFilterButton('All', selectedFilter == 'All'),
                        const SizedBox(width: 8),
                        _buildFilterButton(
                          'Followers',
                          selectedFilter == 'Followers',
                        ),
                        const SizedBox(width: 8),
                        _buildFilterButton(
                          'Non-followers',
                          selectedFilter == 'Non-followers',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Content Type Bars
                    _buildCountryBar('Reels', reelsPercentController, []),
                    const SizedBox(height: 16),
                    _buildCountryBar('Stories', storiesPercentController, []),

                    const SizedBox(height: 16),

                    // Legend
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF63CF3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Followers',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFF783AF7),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Non-followers',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Divider
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: const Color.fromARGB(255, 46, 46, 46),
                    ),

                    const SizedBox(height: 24),

                    // By Top Content Section
                    Row(
                      children: [
                        Text(
                          'By top content',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'See All',
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

                    // Content Preview Cards
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 100,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xFF2E3337),
                            ),
                            child: Stack(
                              children: [
                                // Content image or placeholder
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFF1A1D21),
                                  ),
                                  child: selectedImage != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.file(
                                            selectedImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : null,
                                ),
                                // Reels icon
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: SvgPicture.string(
                                    '''<svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="100" height="100" viewBox="0 0 50 50">
<path d="M13.34 4.13L20.26 16H4v-1C4 9.48 8.05 4.92 13.34 4.13zM33.26 16L22.57 16 15.57 4 26.26 4zM46 15v1H35.57l-7-12H35C41.08 4 46 8.92 46 15zM4 18v17c0 6.08 4.92 11 11 11h20c6.08 0 11-4.92 11-11V18H4zM31 32.19l-7.99 4.54C21.68 37.49 20 36.55 20 35.04v-9.08c0-1.51 1.68-2.45 3.01-1.69L31 28.81C32.33 29.56 32.33 31.44 31 32.19z"></path>n 
</svg>''',
                                    width: 20,
                                    height: 20,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                // Views count
                                Positioned(
                                  bottom: 8,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF26282F),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: _buildEditableText(
                                        controller: videoViewsController,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'SF Pro Display',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 100,
                          child: Center(
                            child: Text(
                              '5 Aug',
                              style: TextStyle(
                                color: const Color(0xFFB0B0B0),
                                fontSize: 12,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Divider
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: const Color.fromARGB(255, 46, 46, 46),
                    ),

                    const SizedBox(height: 16),

                    // Audience Section
                    Row(
                      children: [
                        Text(
                          'Audience',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.info_outline, color: Colors.white, size: 16),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Swipeable Audience Sections
                    SizedBox(
                      height: isEditingEnabled ? 350 : 280,
                      child: PageView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          // Top Towns/Cities Section
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF2E3337),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Top towns/cities',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildCityBar(
                                  'New York',
                                  12.3,
                                  newYorkController,
                                ),
                                const SizedBox(height: 8),
                                _buildCityBar(
                                  'Los Angeles',
                                  8.7,
                                  losAngelesController,
                                ),
                                const SizedBox(height: 8),
                                _buildCityBar(
                                  'Chicago',
                                  6.2,
                                  chicagoController,
                                ),
                                const SizedBox(height: 8),
                                _buildCityBar(
                                  'Houston',
                                  4.1,
                                  houstonController,
                                ),
                              ],
                            ),
                          ),
                          // Top Countries Section
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF2E3337),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Top countries',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildCityBar(
                                  'United States',
                                  45.2,
                                  unitedStatesController,
                                ),
                                const SizedBox(height: 8),
                                _buildCityBar(
                                  'United Kingdom',
                                  12.8,
                                  unitedKingdomController,
                                ),
                                const SizedBox(height: 8),
                                _buildCityBar('Canada', 8.1, canadaController),
                                const SizedBox(height: 8),
                                _buildCityBar(
                                  'Australia',
                                  6.3,
                                  australiaController,
                                ),
                              ],
                            ),
                          ),
                          // Top Age Range Section
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF2E3337),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Top age range',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildCityBar(
                                  '25-34',
                                  32.4,
                                  age25to34Controller,
                                ),
                                const SizedBox(height: 8),
                                _buildCityBar(
                                  '18-24',
                                  28.7,
                                  age18to24Controller,
                                ),
                                const SizedBox(height: 8),
                                _buildCityBar(
                                  '35-44',
                                  19.2,
                                  age35to44Controller,
                                ),
                                const SizedBox(height: 8),
                                _buildCityBar(
                                  '45-54',
                                  12.1,
                                  age45to54Controller,
                                ),
                              ],
                            ),
                          ),
                          // Gender Section with Donut Chart
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF2E3337),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gender',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Gender Distribution Donut Chart (exactly like Reel Insights)
                                Center(
                                  child: Container(
                                    width: 320,
                                    height: 80,
                                    margin: EdgeInsets.only(top: 35),
                                    child: Stack(
                                      children: [
                                        // Chart
                                        Center(
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            child: Stack(
                                              children: [
                                                // Background circle
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: const Color(
                                                      0xFF111111,
                                                    ),
                                                  ),
                                                ),
                                                // Pink segment (men percentage) - left side
                                                CustomPaint(
                                                  size: Size(80, 80),
                                                  painter: DonutChartPainter(
                                                    percentage:
                                                        _getGenderMenPercentage(),
                                                    color: const Color(
                                                      0xFFF63CF3,
                                                    ),
                                                    startAngle: -90,
                                                  ),
                                                ),
                                                // Purple segment (women percentage) - right side
                                                CustomPaint(
                                                  size: Size(80, 80),
                                                  painter: DonutChartPainter(
                                                    percentage:
                                                        _getGenderWomenPercentage(),
                                                    color: const Color(
                                                      0xFF783AF7,
                                                    ),
                                                    startAngle:
                                                        -90 +
                                                        (_getGenderMenPercentage() *
                                                            360),
                                                  ),
                                                ),
                                                // Black separator lines
                                                CustomPaint(
                                                  size: Size(80, 80),
                                                  painter: DonutSeparatorPainter(
                                                    angle1: -90,
                                                    angle2:
                                                        -90 +
                                                        (_getGenderMenPercentage() *
                                                            360),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Left label - Men
                                        Positioned(
                                          left: 30,
                                          top: 30,
                                          child: Column(
                                            children: [
                                              _buildEditableText(
                                                controller: genderMenController,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'SF Pro Display',
                                                ),
                                                onChanged: (value) {
                                                  // Auto-adjust the other percentage to maintain 100% total
                                                  double menPercent =
                                                      double.tryParse(
                                                        value.replaceAll(
                                                          '%',
                                                          '',
                                                        ),
                                                      ) ??
                                                      0;
                                                  double womenPercent =
                                                      100 - menPercent;
                                                  genderWomenController.text =
                                                      '${womenPercent.toStringAsFixed(1)}%';
                                                  setState(() {});
                                                  _saveToCache();
                                                },
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFF63CF3,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    'Men',
                                                    style: TextStyle(
                                                      color: Colors.grey[400],
                                                      fontSize: 10,
                                                      fontFamily:
                                                          'SF Pro Display',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Right label - Women
                                        Positioned(
                                          right: 17,
                                          top: 30,
                                          child: Column(
                                            children: [
                                              Text(
                                                '${(100 - _getGenderMenPercentage() * 100).toStringAsFixed(1)}%',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'SF Pro Display',
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF783AF7,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    'Women',
                                                    style: TextStyle(
                                                      color: Colors.grey[400],
                                                      fontSize: 10,
                                                      fontFamily:
                                                          'SF Pro Display',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom spacing
                    const SizedBox(height: 20),

                    // Profile Activity Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile activity',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'vs 8 Jun-7 Jul',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 13,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildEditableText(
                              controller: profileActivityController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            _buildEditableText(
                              controller: profileActivityGrowthController,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 13,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Profile visits
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile visits',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildEditableText(
                              controller: profileVisitsController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            _buildEditableText(
                              controller: profileVisitsGrowthController,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // External link taps
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'External link taps',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildEditableText(
                              controller: externalLinksController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            _buildEditableText(
                              controller: externalLinksGrowthController,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Bottom spacing
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E3337) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFF2E3337),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),
    );
  }

  Widget _buildCountryBar(
    String country,
    TextEditingController controller,
    List<TextEditingController> allControllers,
  ) {
    // Use controller value if in edit mode, otherwise use filter percentage
    double percentage = isEditingEnabled
        ? double.tryParse(controller.text.replaceAll('%', '')) ??
              _getPercentageForFilter(country)
        : _getPercentageForFilter(country);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            country,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'SF Pro Display',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(color: const Color(0xFF2C3137)),
                    child:
                        selectedFilter == 'All' &&
                            country == 'Reels' &&
                            !isEditingEnabled
                        ? Row(
                            children: [
                              // Pink segment (3% followers)
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF63CF3),
                                  ),
                                ),
                              ),
                              // Purple segment (97% non-followers)
                              Expanded(
                                flex: 97,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF783AF7),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: (percentage / 100).clamp(0.0, 1.0),
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: selectedFilter == 'Followers'
                                    ? const Color(0xFFF63CF3)
                                    : const Color(0xFF783AF7),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              isEditingEnabled
                  ? Container(
                      width: 60,
                      child: TextField(
                        controller: controller,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SF Pro Display',
                        ),
                        textAlign: TextAlign.right,
                        onChanged: (value) {
                          // Update the bar width when percentage changes
                          setState(() {});
                          _saveToCache();
                        },
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
                            horizontal: 4,
                            vertical: 2,
                          ),
                        ),
                      ),
                    )
                  : Text(
                      isEditingEnabled
                          ? controller.text
                          : selectedFilter == 'All' && country == 'Reels'
                          ? '97.2%'
                          : '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      // Error picking image: $e
    }
  }

  Widget _buildEditableText({
    required TextEditingController controller,
    required TextStyle style,
    TextAlign textAlign = TextAlign.left,
    Function(String)? onChanged,
  }) {
    if (isEditingEnabled) {
      return Container(
        constraints: BoxConstraints(maxWidth: 200),
        child: TextField(
          controller: controller,
          onChanged: (value) {
            if (onChanged != null) onChanged(value);
            _saveToCache();
          },
          style: style,
          textAlign: textAlign,
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

  double _getPercentageForFilter(String contentType) {
    if (contentType == 'Reels') {
      if (selectedFilter == 'Followers') {
        return 98.1;
      } else if (selectedFilter == 'Non-followers') {
        return 99.9;
      } else {
        return 3.0; // All filter - 3% pink, rest purple
      }
    } else if (contentType == 'Stories') {
      if (selectedFilter == 'Followers') {
        return 1.9;
      } else if (selectedFilter == 'Non-followers') {
        return 0.1;
      } else {
        return 0.2; // All filter
      }
    }
    return 0.0;
  }

  Widget _buildCityBar(
    String city,
    double percentage, [
    TextEditingController? controller,
  ]) {
    // Get the current percentage from controller if available, otherwise use the parameter
    double currentPercentage = percentage;
    if (controller != null) {
      currentPercentage =
          double.tryParse(controller.text.replaceAll('%', '')) ?? percentage;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          city,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'SF Pro Display',
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(color: const Color(0xFF2C3137)),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (currentPercentage / 100).clamp(0.0, 1.0),
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(color: const Color(0xFFF63CF3)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            controller != null
                ? _buildEditableText(
                    controller: controller,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SF Pro Display',
                    ),
                  )
                : Text(
                    '${currentPercentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  double _getFollowersPercentage() {
    double percentage =
        double.tryParse(followersPercentController.text.replaceAll('%', '')) ??
        6.3;
    return percentage / 100;
  }

  double _getNonFollowersPercentage() {
    double percentage =
        double.tryParse(
          nonFollowersPercentController.text.replaceAll('%', ''),
        ) ??
        93.7;
    return percentage / 100;
  }

  double _getGenderMenPercentage() {
    double percentage =
        double.tryParse(genderMenController.text.replaceAll('%', '')) ?? 78.4;
    return percentage / 100;
  }

  double _getGenderWomenPercentage() {
    double percentage =
        double.tryParse(genderWomenController.text.replaceAll('%', '')) ?? 21.6;
    return percentage / 100;
  }

  @override
  void dispose() {
    totalViewsController.dispose();
    accountsReachedController.dispose();
    followersPercentController.dispose();
    nonFollowersPercentController.dispose();
    reelsPercentController.dispose();
    storiesPercentController.dispose();
    dateController.dispose();

    // Profile activity controllers
    profileActivityController.dispose();
    profileActivityGrowthController.dispose();
    profileVisitsController.dispose();
    profileVisitsGrowthController.dispose();
    externalLinksController.dispose();
    externalLinksGrowthController.dispose();

    // City controllers
    newYorkController.dispose();
    losAngelesController.dispose();
    chicagoController.dispose();
    houstonController.dispose();

    // Country controllers
    unitedStatesController.dispose();
    unitedKingdomController.dispose();
    canadaController.dispose();
    australiaController.dispose();

    // Age controllers
    age25to34Controller.dispose();
    age18to24Controller.dispose();
    age35to44Controller.dispose();
    age45to54Controller.dispose();

    // Gender controllers
    genderMenController.dispose();
    genderWomenController.dispose();

    // Video content controller
    videoViewsController.dispose();

    super.dispose();
  }
}

class DonutChartPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final double startAngle;

  DonutChartPainter({
    required this.percentage,
    required this.color,
    required this.startAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9;

    final rect = Rect.fromLTWH(6, 6, size.width - 12, size.height - 12);
    final sweepAngle = percentage * 2 * 3.14159;

    canvas.drawArc(rect, startAngle * 3.14159 / 180, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DonutSeparatorPainter extends CustomPainter {
  final double angle1;
  final double angle2;

  DonutSeparatorPainter({required this.angle1, required this.angle2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF111111)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    double outerRadius = (size.width - 12) / 2 + 12;
    double innerRadius = (size.width - 12) / 2 - 9;

    // Draw separator line at angle1 - radius only (from inner to outer)
    double x1Inner = centerX + innerRadius * cos(angle1 * (pi / 180));
    double y1Inner = centerY + innerRadius * sin(angle1 * (pi / 180));
    double x1Outer = centerX + outerRadius * cos(angle1 * (pi / 180));
    double y1Outer = centerY + outerRadius * sin(angle1 * (pi / 180));

    canvas.drawLine(Offset(x1Inner, y1Inner), Offset(x1Outer, y1Outer), paint);

    // Draw separator line at angle2 - radius only (from inner to outer)
    double x2Inner = centerX + innerRadius * cos(angle2 * (pi / 180));
    double y2Inner = centerY + innerRadius * sin(angle2 * (pi / 180));
    double x2Outer = centerX + outerRadius * cos(angle2 * (pi / 180));
    double y2Outer = centerY + outerRadius * sin(angle2 * (pi / 180));

    canvas.drawLine(Offset(x2Inner, y2Inner), Offset(x2Outer, y2Outer), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
