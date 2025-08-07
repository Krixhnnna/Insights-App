import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'professional_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insights',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title
                Text(
                  'Insights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 40),

                // Reel Insights Option
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReelInsightsPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3337),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reel Insights',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Professional Dashboard Option
                GestureDetector(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3337),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Professional Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class ReelInsightsPage extends StatefulWidget {
  @override
  _ReelInsightsPageState createState() => _ReelInsightsPageState();
}

class _ReelInsightsPageState extends State<ReelInsightsPage> {
  bool isEditingEnabled = false;
  bool isRetentionHidden = false;
  String selectedDemographic = 'Gender';
  bool isLoadingReel = false;
  String? reelThumbnailUrl;
  String? reelCaption; // 'Gender', 'Country', 'Age'
  DateTime? lastTapTime;
  bool isLoading = false;

  // Editable text controllers
  final TextEditingController reelTitleController = TextEditingController(
    text: 'Dream Came True 💀...',
  );
  final TextEditingController reelDateController = TextEditingController(
    text: '30 July · Duration 0:33',
  );
  final TextEditingController likesController = TextEditingController(
    text: '63',
  );
  final TextEditingController commentsController = TextEditingController(
    text: '2',
  );
  final TextEditingController sharesController = TextEditingController(
    text: '3',
  );
  final TextEditingController savesController = TextEditingController(
    text: '3',
  );
  final TextEditingController viewsController = TextEditingController(
    text: '3,003',
  );
  final TextEditingController followersPercentController =
      TextEditingController(text: '21.4%');
  final TextEditingController nonFollowersPercentController =
      TextEditingController(text: '78.6%');

  // Overview metrics controllers
  final TextEditingController watchTimeController = TextEditingController(
    text: '3h 37m 34s',
  );
  final TextEditingController interactionsController = TextEditingController(
    text: '71',
  );
  final TextEditingController profileActivityController = TextEditingController(
    text: '1',
  );

  // Sources controllers
  final TextEditingController profileController = TextEditingController(
    text: '1.4%',
  );
  final TextEditingController reelsTabController = TextEditingController(
    text: '0.6%',
  );
  final TextEditingController exploreController = TextEditingController(
    text: '0.2%',
  );
  final TextEditingController feedController = TextEditingController(
    text: '0.2%',
  );

  // Reach controllers
  final TextEditingController accountsReachedController = TextEditingController(
    text: '2,847',
  );
  final TextEditingController fromHomeController = TextEditingController(
    text: '1,234',
  );
  final TextEditingController fromHashtagsController = TextEditingController(
    text: '567',
  );
  final TextEditingController fromProfileController = TextEditingController(
    text: '89',
  );

  // Impressions controllers
  final TextEditingController totalImpressionsController =
      TextEditingController(text: '4,521');
  final TextEditingController impressionsFromHomeController =
      TextEditingController(text: '2,123');
  final TextEditingController impressionsFromHashtagsController =
      TextEditingController(text: '1,456');
  final TextEditingController impressionsFromProfileController =
      TextEditingController(text: '942');

  // Saves controllers
  final TextEditingController totalSavesController = TextEditingController(
    text: '3',
  );
  final TextEditingController savesFromHomeController = TextEditingController(
    text: '2',
  );
  final TextEditingController savesFromHashtagsController =
      TextEditingController(text: '1');
  final TextEditingController savesFromProfileController =
      TextEditingController(text: '0');

  // Retention and View Rate controllers
  final TextEditingController viewRateController = TextEditingController(
    text: '98.7%',
  );
  final TextEditingController typicalViewRateController = TextEditingController(
    text: '--',
  );
  final TextEditingController watchTimeController2 = TextEditingController(
    text: '3h 37m 42s',
  );
  final TextEditingController averageWatchTimeController =
      TextEditingController(text: '20 sec');

  // Section title controllers
  final TextEditingController overviewTitleController = TextEditingController(
    text: 'Overview',
  );
  final TextEditingController viewsTitleController = TextEditingController(
    text: 'Views',
  );
  final TextEditingController topSourcesTitleController = TextEditingController(
    text: 'Top sources of views',
  );
  final TextEditingController retentionTitleController = TextEditingController(
    text: 'Retention',
  );
  final TextEditingController interactionsTitleController =
      TextEditingController(text: 'Interactions');
  final TextEditingController profileActivityTitleController =
      TextEditingController(text: 'Profile activity');
  final TextEditingController audienceTitleController = TextEditingController(
    text: 'Audience',
  );

  // Age percentage controllers
  final TextEditingController age25to34Controller = TextEditingController(
    text: '45.1%',
  );
  final TextEditingController age18to24Controller = TextEditingController(
    text: '23.9%',
  );
  final TextEditingController age35to44Controller = TextEditingController(
    text: '17.0%',
  );
  final TextEditingController age45to54Controller = TextEditingController(
    text: '6.7%',
  );
  final TextEditingController age13to17Controller = TextEditingController(
    text: '3.9%',
  );
  final TextEditingController age55to64Controller = TextEditingController(
    text: '2.2%',
  );
  final TextEditingController age65plusController = TextEditingController(
    text: '1.1%',
  );

  // Age range name controllers
  final TextEditingController age13to17NameController = TextEditingController(
    text: '13-17',
  );
  final TextEditingController age18to24NameController = TextEditingController(
    text: '18-24',
  );
  final TextEditingController age25to34NameController = TextEditingController(
    text: '25-34',
  );
  final TextEditingController age35to44NameController = TextEditingController(
    text: '35-44',
  );
  final TextEditingController age45to54NameController = TextEditingController(
    text: '45-54',
  );
  final TextEditingController age55to64NameController = TextEditingController(
    text: '55-64',
  );
  final TextEditingController age65plusNameController = TextEditingController(
    text: '65+',
  );

  // Country percentage controllers
  final TextEditingController countryUSController = TextEditingController(
    text: '45.2%',
  );
  final TextEditingController countryUKController = TextEditingController(
    text: '25.8%',
  );
  final TextEditingController countryCanadaController = TextEditingController(
    text: '15.6%',
  );
  final TextEditingController countryAustraliaController =
      TextEditingController(text: '8.4%');
  final TextEditingController countryGermanyController = TextEditingController(
    text: '5.0%',
  );

  // Country name controllers
  final TextEditingController countryUSNameController = TextEditingController(
    text: 'United States',
  );
  final TextEditingController countryUKNameController = TextEditingController(
    text: 'United Kingdom',
  );
  final TextEditingController countryCanadaNameController =
      TextEditingController(text: 'Canada');
  final TextEditingController countryAustraliaNameController =
      TextEditingController(text: 'Australia');
  final TextEditingController countryGermanyNameController =
      TextEditingController(text: 'Germany');

  // Additional controllers for remaining sections
  final TextEditingController totalInteractionsController =
      TextEditingController(text: '71 Interactions');
  final TextEditingController interactionsFollowersPercentController =
      TextEditingController(text: '5.7%');
  final TextEditingController interactionsNonFollowersPercentController =
      TextEditingController(text: '94.3%');

  final TextEditingController followsController = TextEditingController(
    text: 'Follows: 1',
  );

  // Gender percentage controllers
  final TextEditingController genderMenController = TextEditingController(
    text: '78.4%',
  );
  final TextEditingController genderWomenController = TextEditingController(
    text: '21.6%',
  );

  void _resetToViralDemoData() {
    setState(() {
      // Reset to viral reel demo data
      reelTitleController.text = 'Viral Dance Challenge 🔥';
      reelDateController.text = '15 August · Duration 0:45';
      likesController.text = '12,450';
      commentsController.text = '1,234';
      sharesController.text = '5,678';
      savesController.text = '2,890';
      viewsController.text = '50,000';
      followersPercentController.text = '35.2%';
      nonFollowersPercentController.text = '64.8%';

      // Overview metrics
      watchTimeController.text = '8h 23m 12s';
      interactionsController.text = '22,252';
      profileActivityController.text = '156';

      // Sources
      profileController.text = '0.1%';
      reelsTabController.text = '8.6%';
      exploreController.text = '3.2%';
      feedController.text = '2.1%';

      // Reach
      accountsReachedController.text = '45,847';
      fromHomeController.text = '18,234';
      fromHashtagsController.text = '12,567';
      fromProfileController.text = '3,456';

      // Impressions
      totalImpressionsController.text = '67,521';
      impressionsFromHomeController.text = '28,123';
      impressionsFromHashtagsController.text = '18,456';
      impressionsFromProfileController.text = '8,942';

      // Saves
      totalSavesController.text = '2,890';
      savesFromHomeController.text = '1,234';
      savesFromHashtagsController.text = '567';
      savesFromProfileController.text = '89';

      // Retention and View Rate
      viewRateController.text = '99.2%';
      typicalViewRateController.text = '85.1%';
      watchTimeController2.text = '8h 23m 12s';
      averageWatchTimeController.text = '45 sec';

      // Tier 1 countries
      countryUSController.text = '45.2%';
      countryUKController.text = '25.8%';
      countryCanadaController.text = '15.6%';
      countryAustraliaController.text = '8.4%';
      countryGermanyController.text = '5.0%';

      // Country names
      countryUSNameController.text = 'United States';
      countryUKNameController.text = 'United Kingdom';
      countryCanadaNameController.text = 'Canada';
      countryAustraliaNameController.text = 'Australia';
      countryGermanyNameController.text = 'Germany';

      // Clear image data
      reelThumbnailUrl = null;
      reelCaption = null;
    });

    // Clear saved image data from cache
    _clearImageData();
  }

  void _setDemoData() {
    setState(() {
      // Set demo data with real date (2 days ago)
      final now = DateTime.now();
      final twoDaysAgo = now.subtract(Duration(days: 2));
      final monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      final dateString =
          '${twoDaysAgo.day} ${monthNames[twoDaysAgo.month - 1]} · Duration 0:33';

      reelTitleController.text = 'Dream Came True 💀...';
      reelDateController.text = dateString;
      likesController.text = '84';
      commentsController.text = '2';
      sharesController.text = '13';
      savesController.text = '2';
      viewsController.text = '3,071';
      followersPercentController.text = '21.4%';
      nonFollowersPercentController.text = '78.6%';
      watchTimeController.text = '3h 44m 38s';
      interactionsController.text = '101';
      profileActivityController.text = '3';
      profileController.text = '1.4%';
      reelsTabController.text = '0.6%';
      exploreController.text = '0.2%';
      feedController.text = '0.2%';
      accountsReachedController.text = '2,847';
      fromHomeController.text = '1,234';
      fromHashtagsController.text = '567';
      fromProfileController.text = '89';
      totalImpressionsController.text = '4,521';
      impressionsFromHomeController.text = '2,123';
      impressionsFromHashtagsController.text = '1,456';
      impressionsFromProfileController.text = '942';
      totalSavesController.text = '2';
      savesFromHomeController.text = '1';
      savesFromHashtagsController.text = '1';
      savesFromProfileController.text = '0';
      viewRateController.text = '98.7%';
      typicalViewRateController.text = '--';
      watchTimeController2.text = '3h 44m 38s';
      averageWatchTimeController.text = '20 sec';
      overviewTitleController.text = 'Overview';
      viewsTitleController.text = 'Views';
      topSourcesTitleController.text = 'Top sources of views';
      retentionTitleController.text = 'Retention';
      interactionsTitleController.text = 'Interactions';
      profileActivityTitleController.text = 'Profile activity';
      audienceTitleController.text = 'Audience';
      age25to34Controller.text = '45.1%';
      age18to24Controller.text = '23.9%';
      age35to44Controller.text = '17.0%';
      age45to54Controller.text = '6.7%';
      age13to17Controller.text = '3.9%';
      age55to64Controller.text = '2.2%';
      age65plusController.text = '1.1%';
      countryUSController.text = '45.2%';
      countryUKController.text = '25.8%';
      countryCanadaController.text = '15.6%';
      countryAustraliaController.text = '8.4%';
      countryGermanyController.text = '5.0%';
      totalInteractionsController.text = '101 Interactions';
      interactionsFollowersPercentController.text = '5.7%';
      interactionsNonFollowersPercentController.text = '94.3%';
      followsController.text = 'Follows: 1';
      genderMenController.text = '78.4%';
      genderWomenController.text = '21.6%';

      // Set demo caption
      reelCaption = 'Demo Reel Caption...';
      reelThumbnailUrl = null;
    });
  }

  Future<void> _clearImageData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('reelThumbnailUrl');
    await prefs.remove('reelCaption');
  }

  Future<void> _clearAllSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This will clear all saved data
  }

  String _extractDuration(String dateText) {
    // Extract duration from text like "15 December · Duration 0:33"
    final durationMatch = RegExp(r'Duration (\d+:\d+)').firstMatch(dateText);
    return durationMatch?.group(1) ?? '0:33';
  }

  void _handleReelInsightsTap() {
    final now = DateTime.now();
    if (lastTapTime != null &&
        now.difference(lastTapTime!).inMilliseconds < 500) {
      // Double tap detected - reset to 3k views demo data
      _setDemoData();
      lastTapTime = null;
    } else {
      lastTapTime = now;
    }
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reelTitle', reelTitleController.text);
    await prefs.setString('reelDate', reelDateController.text);
    await prefs.setString('likes', likesController.text);
    await prefs.setString('comments', commentsController.text);
    await prefs.setString('shares', sharesController.text);
    await prefs.setString('saves', savesController.text);
    await prefs.setString('views', viewsController.text);
    await prefs.setString('followersPercent', followersPercentController.text);
    await prefs.setString(
      'nonFollowersPercent',
      nonFollowersPercentController.text,
    );
    await prefs.setString('watchTime', watchTimeController.text);
    await prefs.setString('interactions', interactionsController.text);
    await prefs.setString('profileActivity', profileActivityController.text);
    await prefs.setString('profile', profileController.text);
    await prefs.setString('reelsTab', reelsTabController.text);
    await prefs.setString('explore', exploreController.text);
    await prefs.setString('feed', feedController.text);
    await prefs.setString('accountsReached', accountsReachedController.text);
    await prefs.setString('fromHome', fromHomeController.text);
    await prefs.setString('fromHashtags', fromHashtagsController.text);
    await prefs.setString('fromProfile', fromProfileController.text);
    await prefs.setString('totalImpressions', totalImpressionsController.text);
    await prefs.setString(
      'impressionsFromHome',
      impressionsFromHomeController.text,
    );
    await prefs.setString(
      'impressionsFromHashtags',
      impressionsFromHashtagsController.text,
    );
    await prefs.setString(
      'impressionsFromProfile',
      impressionsFromProfileController.text,
    );
    await prefs.setString('totalSaves', totalSavesController.text);
    await prefs.setString('savesFromHome', savesFromHomeController.text);
    await prefs.setString(
      'savesFromHashtags',
      savesFromHashtagsController.text,
    );
    await prefs.setString('savesFromProfile', savesFromProfileController.text);
    await prefs.setString('viewRate', viewRateController.text);
    await prefs.setString('typicalViewRate', typicalViewRateController.text);
    await prefs.setString('watchTime2', watchTimeController2.text);
    await prefs.setString('averageWatchTime', averageWatchTimeController.text);
    await prefs.setString('overviewTitle', overviewTitleController.text);
    await prefs.setString('viewsTitle', viewsTitleController.text);
    await prefs.setString('topSourcesTitle', topSourcesTitleController.text);
    await prefs.setString('retentionTitle', retentionTitleController.text);
    await prefs.setString(
      'interactionsTitle',
      interactionsTitleController.text,
    );
    await prefs.setString(
      'profileActivityTitle',
      profileActivityTitleController.text,
    );
    await prefs.setString('audienceTitle', audienceTitleController.text);
    await prefs.setString('age25to34', age25to34Controller.text);
    await prefs.setString('age18to24', age18to24Controller.text);
    await prefs.setString('age35to44', age35to44Controller.text);
    await prefs.setString('age45to54', age45to54Controller.text);
    await prefs.setString('age13to17', age13to17Controller.text);
    await prefs.setString('age55to64', age55to64Controller.text);
    await prefs.setString('age65plus', age65plusController.text);
    await prefs.setString('countryUS', countryUSController.text);
    await prefs.setString('countryUK', countryUKController.text);
    await prefs.setString('countryCanada', countryCanadaController.text);
    await prefs.setString('countryAustralia', countryAustraliaController.text);
    await prefs.setString('countryGermany', countryGermanyController.text);
    await prefs.setString(
      'totalInteractions',
      totalInteractionsController.text,
    );
    await prefs.setString(
      'interactionsFollowersPercent',
      interactionsFollowersPercentController.text,
    );
    await prefs.setString(
      'interactionsNonFollowersPercent',
      interactionsNonFollowersPercentController.text,
    );
    await prefs.setString('follows', followsController.text);
    await prefs.setString('genderMen', genderMenController.text);
    await prefs.setString('genderWomen', genderWomenController.text);

    // Save image data
    if (reelThumbnailUrl != null) {
      await prefs.setString('reelThumbnailUrl', reelThumbnailUrl!);
    }
    if (reelCaption != null) {
      await prefs.setString('reelCaption', reelCaption!);
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Force use new demo data by clearing old saved data
    await _clearAllSavedData();

    // Set demo data
    _setDemoData();
    // Mark as not first time anymore
    await prefs.setBool('isFirstTime', false);
  }

  @override
  void initState() {
    super.initState();

    _loadUserData();

    // Set loading to false immediately
    setState(() {
      isLoading = false;
    });

    // Add listeners to controllers that need to trigger rebuilds
    profileActivityController.addListener(() {
      setState(() {});
    });

    // Connect duplicate fields - when one updates, the other updates too
    watchTimeController.addListener(() {
      if (watchTimeController.text != watchTimeController2.text) {
        watchTimeController2.text = watchTimeController.text;
      }
    });

    watchTimeController2.addListener(() {
      if (watchTimeController2.text != watchTimeController.text) {
        watchTimeController.text = watchTimeController2.text;
      }
    });

    interactionsController.addListener(() {
      if (interactionsController.text !=
          totalInteractionsController.text.replaceAll(' Interactions', '')) {
        totalInteractionsController.text =
            '${interactionsController.text} Interactions';
      }
    });

    totalInteractionsController.addListener(() {
      String interactionsValue = totalInteractionsController.text.replaceAll(
        ' Interactions',
        '',
      );
      if (interactionsValue != interactionsController.text) {
        interactionsController.text = interactionsValue;
      }
    });
  }

  @override
  void dispose() {
    reelTitleController.dispose();
    reelDateController.dispose();
    likesController.dispose();
    commentsController.dispose();
    sharesController.dispose();
    savesController.dispose();
    viewsController.dispose();
    followersPercentController.dispose();
    nonFollowersPercentController.dispose();
    watchTimeController.dispose();
    interactionsController.dispose();
    profileActivityController.dispose();
    profileController.dispose();
    reelsTabController.dispose();
    exploreController.dispose();
    feedController.dispose();
    accountsReachedController.dispose();
    fromHomeController.dispose();
    fromHashtagsController.dispose();
    fromProfileController.dispose();
    totalImpressionsController.dispose();
    impressionsFromHomeController.dispose();
    impressionsFromHashtagsController.dispose();
    impressionsFromProfileController.dispose();
    totalSavesController.dispose();
    savesFromHomeController.dispose();
    savesFromHashtagsController.dispose();
    savesFromProfileController.dispose();
    viewRateController.dispose();
    typicalViewRateController.dispose();
    watchTimeController2.dispose();
    averageWatchTimeController.dispose();
    overviewTitleController.dispose();
    viewsTitleController.dispose();
    topSourcesTitleController.dispose();
    retentionTitleController.dispose();
    interactionsTitleController.dispose();
    profileActivityTitleController.dispose();
    audienceTitleController.dispose();
    age25to34Controller.dispose();
    age18to24Controller.dispose();
    age35to44Controller.dispose();
    age45to54Controller.dispose();
    age13to17Controller.dispose();
    age55to64Controller.dispose();
    age65plusController.dispose();
    countryUSController.dispose();
    countryUKController.dispose();
    countryCanadaController.dispose();
    countryAustraliaController.dispose();
    countryGermanyController.dispose();
    totalInteractionsController.dispose();
    interactionsFollowersPercentController.dispose();
    interactionsNonFollowersPercentController.dispose();
    followsController.dispose();
    genderMenController.dispose();
    genderWomenController.dispose();
    super.dispose();
  }

  Widget _buildEditableText({
    required TextEditingController controller,
    required TextStyle style,
    TextAlign textAlign = TextAlign.left,
    bool isCentered = false,
    Function(String)? onChanged,
  }) {
    if (isEditingEnabled) {
      return Container(
        constraints: BoxConstraints(maxWidth: 200),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
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

  Widget _buildMetric(String iconPath, String value) {
    return Column(
      children: [
        iconPath.endsWith('.svg')
            ? SvgPicture.asset(
                iconPath,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              )
            : Image.asset(
                iconPath,
                width:
                    iconPath.contains('comment.png') ||
                        iconPath.contains('save.png')
                    ? 20
                    : 18,
                height:
                    iconPath.contains('comment.png') ||
                        iconPath.contains('save.png')
                    ? 20
                    : 18,
                color: Colors.white,
              ),
        const SizedBox(height: 4),
        isEditingEnabled
            ? Container(
                width: 40,
                child: TextField(
                  controller: iconPath.contains('heart.svg')
                      ? likesController
                      : iconPath.contains('comment.png')
                      ? commentsController
                      : iconPath.contains('image.png')
                      ? sharesController
                      : savesController,
                  onChanged: (value) {
                    // Trigger rebuild when engagement metrics change
                    setState(() {});
                  },
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro Display',
                  ),
                  textAlign: TextAlign.center,
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
                iconPath.contains('heart.svg')
                    ? likesController.text
                    : iconPath.contains('comment.png')
                    ? commentsController.text
                    : iconPath.contains('image.png')
                    ? sharesController.text
                    : savesController.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro Display',
                ),
              ),
      ],
    );
  }

  Widget _buildOverviewMetric(String label, String value) {
    // Determine which controller to use based on label and value
    TextEditingController? controller;

    // Overview section
    if (label == 'Watch time' && value == '3h 37m 34s') {
      controller = watchTimeController;
    } else if (label == 'Interactions' && value == '71') {
      controller = interactionsController;
    } else if (label == 'Profile activity' && value == '1') {
      controller = profileActivityController;
      // Add onChanged to trigger rebuild when profile activity changes
      if (isEditingEnabled) {
        controller.addListener(() {
          setState(() {});
        });
      }
    } else if (label == 'Views' && value == '3,003') {
      controller = viewsController;
    }
    // Sources section
    else if (label == 'Profile' && value == '1.4%') {
      controller = profileController;
    } else if (label == 'Reels tab' && value == '0.6%') {
      controller = reelsTabController;
    } else if (label == 'Explore' && value == '0.2%') {
      controller = exploreController;
    } else if (label == 'Feed' && value == '0.2%') {
      controller = feedController;
    }
    // Reach section
    else if (label == 'Accounts reached' && value == '2,847') {
      controller = accountsReachedController;
    } else if (label == 'From home' && value == '1,234') {
      controller = fromHomeController;
    } else if (label == 'From hashtags' && value == '567') {
      controller = fromHashtagsController;
    } else if (label == 'From profile' && value == '89') {
      controller = fromProfileController;
    }
    // Impressions section
    else if (label == 'Total impressions' && value == '4,521') {
      controller = totalImpressionsController;
    } else if (label == 'From home' && value == '2,123') {
      controller = impressionsFromHomeController;
    } else if (label == 'From hashtags' && value == '1,456') {
      controller = impressionsFromHashtagsController;
    } else if (label == 'From profile' && value == '942') {
      controller = impressionsFromProfileController;
    }
    // Saves section
    else if (label == 'Total saves' && value == '3') {
      controller = totalSavesController;
    } else if (label == 'From home' && value == '2') {
      controller = savesFromHomeController;
    } else if (label == 'From hashtags' && value == '1') {
      controller = savesFromHashtagsController;
    } else if (label == 'From profile' && value == '0') {
      controller = savesFromProfileController;
    } else if (label == 'This reel\'s view rate' && value == '98.7%') {
      controller = viewRateController;
    } else if (label == 'Your typical view rate' && value == '--') {
      controller = typicalViewRateController;
    } else if (label == 'Watch time' && value == '3h 37m 42s') {
      controller = watchTimeController2;
    } else if (label == 'Average watch time' && value == '20 sec') {
      controller = averageWatchTimeController;
    } else if (label == 'Follows' && value == '1') {
      controller = followsController;
    } else if (label == 'Likes' && value == likesController.text) {
      controller = null; // Not editable, auto-sync
    } else if (label == 'Saves' && value == savesController.text) {
      controller = null; // Not editable, auto-sync
    } else if (label == 'Shares' && value == sharesController.text) {
      controller = null; // Not editable, auto-sync
    } else if (label == 'Comments' && value == commentsController.text) {
      controller = null; // Not editable, auto-sync
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'SF Pro Display',
            ),
          ),
          isEditingEnabled && controller != null
              ? Container(
                  width: 80,
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SF Pro Display',
                    ),
                    textAlign: TextAlign.right,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildAgeBar(
    String ageRange,
    TextEditingController controller,
    List<TextEditingController> allControllers,
  ) {
    double percentage =
        double.tryParse(controller.text.replaceAll('%', '')) ?? 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableText(
            controller: _getAgeNameController(ageRange),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
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
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (percentage / 100).clamp(0.0, 1.0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF63CF3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildEditableText(
                controller: controller,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro Display',
                ),
                onChanged: (value) {
                  _adjustOtherPercentages(controller, allControllers);
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _calculateAccountsEngaged() {
    // Extract numeric values from the controller texts, handling any non-numeric characters
    int likes =
        int.tryParse(likesController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    int saves =
        int.tryParse(savesController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    int shares =
        int.tryParse(sharesController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    int comments =
        int.tryParse(
          commentsController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
    return likes + saves + shares + comments;
  }

  int _calculateFollows() {
    // Calculate 10% of profile activity
    int profileActivity =
        int.tryParse(
          profileActivityController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
    return (profileActivity * 0.1).round();
  }

  double _getInteractionsFollowersPercentage() {
    double percentage =
        double.tryParse(
          interactionsFollowersPercentController.text.replaceAll('%', ''),
        ) ??
        5.7;
    return percentage / 100;
  }

  double _getInteractionsNonFollowersPercentage() {
    double percentage =
        double.tryParse(
          interactionsNonFollowersPercentController.text.replaceAll('%', ''),
        ) ??
        94.3;
    return percentage / 100;
  }

  double _getViewsFollowersPercentage() {
    double percentage =
        double.tryParse(followersPercentController.text.replaceAll('%', '')) ??
        21.4;
    return percentage / 100;
  }

  double _getViewsNonFollowersPercentage() {
    double percentage =
        double.tryParse(
          nonFollowersPercentController.text.replaceAll('%', ''),
        ) ??
        78.6;
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

  void _adjustOtherPercentages(
    TextEditingController changedController,
    List<TextEditingController> allControllers,
  ) {
    // Only adjust if the value is a valid number and user has finished typing
    String text = changedController.text;
    if (!text.contains('%') || text.isEmpty) return;

    // Parse the changed value
    double changedValue = double.tryParse(text.replaceAll('%', '')) ?? 0.0;

    // Don't adjust if the value is 0 or invalid
    if (changedValue <= 0) return;

    // Calculate total of other controllers
    double otherTotal = 0.0;
    for (TextEditingController controller in allControllers) {
      if (controller != changedController) {
        otherTotal +=
            double.tryParse(controller.text.replaceAll('%', '')) ?? 0.0;
      }
    }

    // Calculate new total
    double newTotal = changedValue + otherTotal;

    // Only adjust if total exceeds 100%
    if (newTotal > 100.0) {
      double maxAllowed = 100.0 - otherTotal;
      if (maxAllowed > 0) {
        changedController.text = '${maxAllowed.toStringAsFixed(1)}%';
      } else {
        changedController.text = '0.1%';
      }
    }
  }

  void _adjustAllPercentages() {
    // Adjust age percentages
    List<TextEditingController> ageControllers = [
      age13to17Controller,
      age18to24Controller,
      age25to34Controller,
      age35to44Controller,
      age45to54Controller,
      age55to64Controller,
      age65plusController,
    ];
    _normalizePercentages(ageControllers);

    // Adjust country percentages
    List<TextEditingController> countryControllers = [
      countryUSController,
      countryUKController,
      countryCanadaController,
      countryAustraliaController,
      countryGermanyController,
    ];
    _normalizePercentages(countryControllers);
  }

  void _normalizePercentages(List<TextEditingController> controllers) {
    // Calculate total
    double total = 0.0;
    for (TextEditingController controller in controllers) {
      total += double.tryParse(controller.text.replaceAll('%', '')) ?? 0.0;
    }

    // If total is not 100%, normalize all values
    if (total != 100.0 && total > 0) {
      double factor = 100.0 / total;
      for (TextEditingController controller in controllers) {
        double value =
            double.tryParse(controller.text.replaceAll('%', '')) ?? 0.0;
        controller.text = '${(value * factor).toStringAsFixed(1)}%';
      }
    }
  }

  TextEditingController _getAgeNameController(String ageRange) {
    switch (ageRange) {
      case '13-17':
        return age13to17NameController;
      case '18-24':
        return age18to24NameController;
      case '25-34':
        return age25to34NameController;
      case '35-44':
        return age35to44NameController;
      case '45-54':
        return age45to54NameController;
      case '55-64':
        return age55to64NameController;
      case '65+':
        return age65plusNameController;
      default:
        return age18to24NameController;
    }
  }

  TextEditingController _getCountryNameController(String country) {
    switch (country) {
      case 'United States':
        return countryUSNameController;
      case 'United Kingdom':
        return countryUKNameController;
      case 'Canada':
        return countryCanadaNameController;
      case 'Australia':
        return countryAustraliaNameController;
      case 'Germany':
        return countryGermanyNameController;
      default:
        return countryUSNameController;
    }
  }

  void _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 640,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          reelThumbnailUrl = image.path;
        });

        // Save data immediately after image selection
        _saveUserData();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 400,
        maxHeight: 640,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          reelThumbnailUrl = image.path;
        });

        // Save data immediately after image selection
        _saveUserData();
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Widget _buildCountryBar(
    String country,
    TextEditingController controller,
    List<TextEditingController> allControllers,
  ) {
    double percentage =
        double.tryParse(controller.text.replaceAll('%', '')) ?? 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableText(
            controller: _getCountryNameController(country),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
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
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (percentage / 100).clamp(0.0, 1.0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF63CF3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildEditableText(
                controller: controller,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro Display',
                ),
                onChanged: (value) {
                  _adjustOtherPercentages(controller, allControllers);
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          children: [
            // Header skeleton
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3337),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3337),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 50,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3337),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ],
              ),
            ),

            // Main content skeleton
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Video thumbnail skeleton
                    Center(
                      child: Container(
                        width: 100,
                        height: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E3337),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title skeleton
                    Center(
                      child: Container(
                        width: 200,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E3337),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Date skeleton
                    Center(
                      child: Container(
                        width: 150,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E3337),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Engagement metrics skeleton
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => Column(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E3337),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 40,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E3337),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
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
    );
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
                  GestureDetector(
                    onTap: _handleReelInsightsTap,
                    child: Text(
                      'Reel insights',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!isEditingEnabled) {
                          // Save all edited data when turning off edit mode
                          _saveUserData();
                        } else {
                          // When disabling edit mode, adjust percentages to make sum 100%
                          _adjustAllPercentages();
                        }
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
                        color: isEditingEnabled
                            ? const Color(0xFF2E3337)
                            : Colors.transparent,
                      ),
                      child: Stack(
                        children: [
                          // Toggle switch
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            left: isEditingEnabled ? 24 : 2,
                            top: 2,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isEditingEnabled
                                    ? const Color(0xFFF63CF3)
                                    : Colors.transparent,
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

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reel Thumbnail
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _pickImageFromGallery();
                        },
                        child: Container(
                          width: 100,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF2E3337),
                            border: Border.all(
                              color: const Color(0xFF232429),
                              width: 1,
                            ),
                          ),
                          child: isLoadingReel
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        duration: const Duration(
                                          milliseconds: 800,
                                        ),
                                        builder: (context, value, child) {
                                          return Transform.scale(
                                            scale: value,
                                            child: CircularProgressIndicator(
                                              color: const Color(0xFFF63CF3),
                                              strokeWidth: 2,
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        duration: const Duration(
                                          milliseconds: 600,
                                        ),
                                        builder: (context, value, child) {
                                          return Opacity(
                                            opacity: value,
                                            child: Text(
                                              'Loading...',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'SF Pro Display',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : reelThumbnailUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: reelThumbnailUrl!.startsWith('http')
                                      ? Image.network(
                                          reelThumbnailUrl!,
                                          width: 100,
                                          height: 160,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: const Color(0xFFF63CF3),
                                                strokeWidth: 2,
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(
                                                    Icons.play_circle_outline,
                                                    color: Colors.white,
                                                    size: 32,
                                                  ),
                                                );
                                              },
                                        )
                                      : Image.file(
                                          File(reelThumbnailUrl!),
                                          width: 100,
                                          height: 160,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(
                                                    Icons.play_circle_outline,
                                                    color: Colors.white,
                                                    size: 32,
                                                  ),
                                                );
                                              },
                                        ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Reel Title
                    Center(
                      child: _buildEditableText(
                        controller: reelTitleController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro Display',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Date and Duration
                    Center(
                      child: _buildEditableText(
                        controller: reelDateController,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                          fontFamily: 'SF Pro Display',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Engagement Metrics
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMetric('icons/heart.svg', '12,450'),
                        const SizedBox(width: 20),
                        _buildMetric('icons/image.png', '1,234'),
                        const SizedBox(width: 20),
                        _buildMetric('icons/comment.png', '5,678'),
                        const SizedBox(width: 20),
                        _buildMetric('icons/save.png', '2,890'),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Divider
                    Container(
                      width: double.infinity,
                      height: 4,
                      color: const Color(0xFF232429),
                    ),

                    const SizedBox(height: 24),

                    // Overview Section
                    Row(
                      children: [
                        _buildEditableText(
                          controller: overviewTitleController,
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

                    // Overview Metrics
                    _buildOverviewMetric('Views', '3,003'),
                    _buildOverviewMetric('Watch time', '3h 37m 34s'),
                    _buildOverviewMetric('Interactions', '71'),
                    _buildOverviewMetric('Profile activity', '1'),

                    const SizedBox(height: 32),

                    // Divider
                    Container(
                      width: double.infinity,
                      height: 4,
                      color: const Color(0xFF232429),
                    ),

                    const SizedBox(height: 24),

                    // Views Section
                    Row(
                      children: [
                        _buildEditableText(
                          controller: viewsTitleController,
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

                    // Total Views
                    Center(
                      child: _buildEditableText(
                        controller: viewsController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro Display',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: _buildEditableText(
                        controller: viewsTitleController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

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
                                            _getViewsNonFollowersPercentage(),
                                        color: const Color(0xFF783AF7),
                                        startAngle: -90,
                                      ),
                                    ),
                                    // Pink segment (followers percentage)
                                    CustomPaint(
                                      size: Size(80, 80),
                                      painter: DonutChartPainter(
                                        percentage:
                                            _getViewsFollowersPercentage(),
                                        color: const Color(0xFFF63CF3),
                                        startAngle:
                                            -90 +
                                            (_getViewsNonFollowersPercentage() *
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
                                  _buildEditableText(
                                    controller: followersPercentController,
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
                                      nonFollowersPercentController.text =
                                          '${nonFollowersPercent.toStringAsFixed(1)}%';
                                      setState(() {});
                                    },
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
                                  _buildEditableText(
                                    controller: nonFollowersPercentController,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SF Pro Display',
                                    ),
                                    textAlign: TextAlign.center,
                                    onChanged: (value) {
                                      // Auto-adjust the other percentage to maintain 100% total
                                      double nonFollowersPercent =
                                          double.tryParse(
                                            value.replaceAll('%', ''),
                                          ) ??
                                          0;
                                      double followersPercent =
                                          100 - nonFollowersPercent;
                                      followersPercentController.text =
                                          '${followersPercent.toStringAsFixed(1)}%';
                                      setState(() {});
                                    },
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

                    // Top Sources of Views
                    _buildEditableText(
                      controller: topSourcesTitleController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Sources List
                    _buildOverviewMetric('Reels tab', '0.6%'),
                    _buildOverviewMetric('Explore', '0.2%'),
                    _buildOverviewMetric('Feed', '0.2%'),
                    _buildOverviewMetric('Profile', '1.4%'),

                    const SizedBox(height: 24),

                    // Accounts Reached
                    Row(
                      children: [
                        Text(
                          'Accounts reached: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        if (isEditingEnabled)
                          Container(
                            width: 80,
                            child: TextField(
                              controller: accountsReachedController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SF Pro Display',
                              ),
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
                        else
                          Text(
                            accountsReachedController.text,
                            style: TextStyle(
                              color: Colors.white,
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
                      height: 4,
                      color: const Color(0xFF232429),
                    ),

                    const SizedBox(height: 24),

                    // Retention Section
                    if (!isRetentionHidden) ...[
                      // Retention Section
                      Row(
                        children: [
                          _buildEditableText(
                            controller: retentionTitleController,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                          const Spacer(),
                          if (isEditingEnabled)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRetentionHidden = !isRetentionHidden;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isRetentionHidden
                                      ? Colors.red
                                      : Colors.grey[700],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isRetentionHidden ? 'Show' : 'Hide',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Retention Image
                      Center(
                        child: Container(
                          width: 100,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFF2E3337),
                            border: Border.all(
                              color: const Color(0xFF232429),
                              width: 1,
                            ),
                          ),
                          child: reelThumbnailUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: reelThumbnailUrl!.startsWith('http')
                                      ? Image.network(
                                          reelThumbnailUrl!,
                                          width: 100,
                                          height: 160,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(
                                                    Icons.play_circle_outline,
                                                    color: Colors.white,
                                                    size: 32,
                                                  ),
                                                );
                                              },
                                        )
                                      : Image.file(
                                          File(reelThumbnailUrl!),
                                          width: 100,
                                          height: 160,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(
                                                    Icons.play_circle_outline,
                                                    color: Colors.white,
                                                    size: 32,
                                                  ),
                                                );
                                              },
                                        ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Retention Graph
                      Container(
                        height: 150,
                        child: CustomPaint(
                          size: Size(double.infinity, 150),
                          painter: RetentionGraphPainter(
                            duration: _extractDuration(reelDateController.text),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // View Rate Section
                      Text(
                        'View rate past first 3 seconds',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // View Rate Metrics
                      _buildOverviewMetric('This reel\'s view rate', '98.7%'),
                      _buildOverviewMetric('Your typical view rate', '--'),

                      const SizedBox(height: 16),

                      // Watch Time Metrics
                      _buildOverviewMetric('Watch time', '3h 37m 42s'),
                      _buildOverviewMetric('Average watch time', '20 sec'),

                      const SizedBox(height: 32),

                      // Divider
                      Container(
                        width: double.infinity,
                        height: 4,
                        color: const Color(0xFF232429),
                      ),
                    ] else ...[
                      // Show only the hide/show button when hidden
                      if (isEditingEnabled)
                        Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRetentionHidden = !isRetentionHidden;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Show',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],

                    const SizedBox(height: 24),

                    // Interactions Section
                    Row(
                      children: [
                        _buildEditableText(
                          controller: interactionsTitleController,
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

                    // Total Interactions
                    Center(
                      child: _buildEditableText(
                        controller: totalInteractionsController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Interactions Donut Chart
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
                                            _getInteractionsNonFollowersPercentage(),
                                        color: const Color(0xFF783AF7),
                                        startAngle: -90,
                                      ),
                                    ),
                                    // Pink segment (followers percentage)
                                    CustomPaint(
                                      size: Size(80, 80),
                                      painter: DonutChartPainter(
                                        percentage:
                                            _getInteractionsFollowersPercentage(),
                                        color: const Color(0xFFF63CF3),
                                        startAngle:
                                            -90 +
                                            (_getInteractionsNonFollowersPercentage() *
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
                                  _buildEditableText(
                                    controller:
                                        interactionsFollowersPercentController,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SF Pro Display',
                                    ),
                                    onChanged: (value) {
                                      // Auto-adjust the other percentage to maintain 100% total
                                      double followersPercent =
                                          double.tryParse(
                                            value.replaceAll('%', ''),
                                          ) ??
                                          0;
                                      double nonFollowersPercent =
                                          100 - followersPercent;
                                      interactionsNonFollowersPercentController
                                              .text =
                                          '${nonFollowersPercent.toStringAsFixed(1)}%';
                                      setState(() {});
                                    },
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
                                  _buildEditableText(
                                    controller:
                                        interactionsNonFollowersPercentController,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SF Pro Display',
                                    ),
                                    onChanged: (value) {
                                      // Auto-adjust the other percentage to maintain 100% total
                                      double nonFollowersPercent =
                                          double.tryParse(
                                            value.replaceAll('%', ''),
                                          ) ??
                                          0;
                                      double followersPercent =
                                          100 - nonFollowersPercent;
                                      interactionsFollowersPercentController
                                              .text =
                                          '${followersPercent.toStringAsFixed(1)}%';
                                      setState(() {});
                                    },
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

                    // Interaction Types - Auto-sync with engagement metrics above
                    _buildOverviewMetric('Likes', likesController.text),
                    _buildOverviewMetric('Saves', savesController.text),
                    _buildOverviewMetric('Shares', sharesController.text),
                    _buildOverviewMetric('Comments', commentsController.text),

                    const SizedBox(height: 16),

                    // Thin divider line
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: const Color(0xFF232429),
                    ),

                    const SizedBox(height: 16),

                    // Accounts Engaged - Auto-calculate sum
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Accounts engaged',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        Text(
                          '${_calculateAccountsEngaged()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Divider
                    Container(
                      width: double.infinity,
                      height: 4,
                      color: const Color(0xFF232429),
                    ),

                    const SizedBox(height: 24),

                    // Profile Activity Section
                    Row(
                      children: [
                        _buildEditableText(
                          controller: profileActivityTitleController,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.info_outline, color: Colors.white, size: 16),
                        const Spacer(),
                        Text(
                          profileActivityController.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Follows - 10% of profile activity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Follows',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        Text(
                          '${_calculateFollows()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Divider
                    Container(
                      width: double.infinity,
                      height: 4,
                      color: const Color(0xFF232429),
                    ),

                    const SizedBox(height: 24),

                    // Audience Section
                    Row(
                      children: [
                        _buildEditableText(
                          controller: audienceTitleController,
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

                    // Demographics Tabs
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDemographic = 'Gender';
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDemographic == 'Gender'
                                  ? const Color(0xFF2E3337)
                                  : Colors.transparent,
                              border: selectedDemographic == 'Gender'
                                  ? null
                                  : Border.all(
                                      color: const Color(0xFF2E3337),
                                      width: 1,
                                    ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Gender',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDemographic = 'Country';
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDemographic == 'Country'
                                  ? const Color(0xFF2E3337)
                                  : Colors.transparent,
                              border: selectedDemographic == 'Country'
                                  ? null
                                  : Border.all(
                                      color: const Color(0xFF2E3337),
                                      width: 1,
                                    ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Country',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDemographic = 'Age';
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDemographic == 'Age'
                                  ? const Color(0xFF2E3337)
                                  : Colors.transparent,
                              border: selectedDemographic == 'Age'
                                  ? null
                                  : Border.all(
                                      color: const Color(0xFF2E3337),
                                      width: 1,
                                    ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Age',
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

                    const SizedBox(height: 24),

                    // Content based on selected demographic
                    if (selectedDemographic == 'Gender') ...[
                      // Gender Distribution Donut Chart
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
                                      // Pink segment (men percentage)
                                      CustomPaint(
                                        size: Size(80, 80),
                                        painter: DonutChartPainter(
                                          percentage: _getGenderMenPercentage(),
                                          color: const Color(0xFFF63CF3),
                                          startAngle: -90,
                                        ),
                                      ),
                                      // Purple segment (women percentage)
                                      CustomPaint(
                                        size: Size(80, 80),
                                        painter: DonutChartPainter(
                                          percentage:
                                              _getGenderWomenPercentage(),
                                          color: const Color(0xFF783AF7),
                                          startAngle:
                                              -90 +
                                              (_getGenderMenPercentage() * 360),
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
                                              value.replaceAll('%', ''),
                                            ) ??
                                            0;
                                        double womenPercent = 100 - menPercent;
                                        genderWomenController.text =
                                            '${womenPercent.toStringAsFixed(1)}%';
                                        setState(() {});
                                      },
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
                                          'Men',
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

                              // Right label - Women
                              Positioned(
                                right: 17,
                                top: 30,
                                child: Column(
                                  children: [
                                    _buildEditableText(
                                      controller: genderWomenController,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF Pro Display',
                                      ),
                                      onChanged: (value) {
                                        // Auto-adjust the other percentage to maintain 100% total
                                        double womenPercent =
                                            double.tryParse(
                                              value.replaceAll('%', ''),
                                            ) ??
                                            0;
                                        double menPercent = 100 - womenPercent;
                                        genderMenController.text =
                                            '${menPercent.toStringAsFixed(1)}%';
                                        setState(() {});
                                      },
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
                                          'Women',
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
                    ] else if (selectedDemographic == 'Country') ...[
                      // Country Distribution Bar Chart
                      Column(
                        children: [
                          _buildCountryBar(
                            'United States',
                            countryUSController,
                            [
                              countryUSController,
                              countryUKController,
                              countryCanadaController,
                              countryAustraliaController,
                              countryGermanyController,
                            ],
                          ),
                          _buildCountryBar(
                            'United Kingdom',
                            countryUKController,
                            [
                              countryUSController,
                              countryUKController,
                              countryCanadaController,
                              countryAustraliaController,
                              countryGermanyController,
                            ],
                          ),
                          _buildCountryBar('Canada', countryCanadaController, [
                            countryUSController,
                            countryUKController,
                            countryCanadaController,
                            countryAustraliaController,
                            countryGermanyController,
                          ]),
                          _buildCountryBar(
                            'Australia',
                            countryAustraliaController,
                            [
                              countryUSController,
                              countryUKController,
                              countryCanadaController,
                              countryAustraliaController,
                              countryGermanyController,
                            ],
                          ),
                          _buildCountryBar(
                            'Germany',
                            countryGermanyController,
                            [
                              countryUSController,
                              countryUKController,
                              countryCanadaController,
                              countryAustraliaController,
                              countryGermanyController,
                            ],
                          ),
                        ],
                      ),
                    ] else if (selectedDemographic == 'Age') ...[
                      // Age Distribution Bar Chart
                      Column(
                        children: [
                          _buildAgeBar('13-17', age13to17Controller, [
                            age13to17Controller,
                            age18to24Controller,
                            age25to34Controller,
                            age35to44Controller,
                            age45to54Controller,
                            age55to64Controller,
                            age65plusController,
                          ]),
                          _buildAgeBar('18-24', age18to24Controller, [
                            age13to17Controller,
                            age18to24Controller,
                            age25to34Controller,
                            age35to44Controller,
                            age45to54Controller,
                            age55to64Controller,
                            age65plusController,
                          ]),
                          _buildAgeBar('25-34', age25to34Controller, [
                            age13to17Controller,
                            age18to24Controller,
                            age25to34Controller,
                            age35to44Controller,
                            age45to54Controller,
                            age55to64Controller,
                            age65plusController,
                          ]),
                          _buildAgeBar('35-44', age35to44Controller, [
                            age13to17Controller,
                            age18to24Controller,
                            age25to34Controller,
                            age35to44Controller,
                            age45to54Controller,
                            age55to64Controller,
                            age65plusController,
                          ]),
                          _buildAgeBar('45-54', age45to54Controller, [
                            age13to17Controller,
                            age18to24Controller,
                            age25to34Controller,
                            age35to44Controller,
                            age45to54Controller,
                            age55to64Controller,
                            age65plusController,
                          ]),
                          _buildAgeBar('55-64', age55to64Controller, [
                            age13to17Controller,
                            age18to24Controller,
                            age25to34Controller,
                            age35to44Controller,
                            age45to54Controller,
                            age55to64Controller,
                            age65plusController,
                          ]),
                          _buildAgeBar('65+', age65plusController, [
                            age13to17Controller,
                            age18to24Controller,
                            age25to34Controller,
                            age35to44Controller,
                            age45to54Controller,
                            age55to64Controller,
                            age65plusController,
                          ]),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Divider
                    Container(
                      width: double.infinity,
                      height: 4,
                      color: const Color(0xFF232429),
                    ),

                    const SizedBox(height: 24),

                    // Ad Section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: const Color(0xFF0D0F14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ad label
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 12,
                              bottom: 4,
                            ),
                            child: Text(
                              'Ad',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ),
                          // Boost this Reel section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.trending_up_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Boost this Reel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

class RetentionGraphPainter extends CustomPainter {
  final String duration;

  RetentionGraphPainter({this.duration = '0:33'});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw light horizontal grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[900]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Line at 100% level
    canvas.drawLine(
      Offset(40, size.height * 0.05),
      Offset(size.width - 20, size.height * 0.05),
      gridPaint,
    );

    // Line at 50% level
    canvas.drawLine(
      Offset(40, size.height * 0.5),
      Offset(size.width - 20, size.height * 0.5),
      gridPaint,
    );

    // Line at 0% level
    canvas.drawLine(
      Offset(40, size.height - 10),
      Offset(size.width - 20, size.height - 10),
      gridPaint,
    );

    // Draw retention line for viral reel with high retention
    final linePaint = Paint()
      ..color =
          const Color(0xFFF63CF3) // Pink/magenta color
      ..strokeWidth =
          5 // Thicker line
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Start at 100% retention after the percentage labels
    path.moveTo(40, 10);

    // Viral video pattern - starts at 100%, ends at 0%
    path.lineTo(size.width * 0.15 + 20, size.height * 0.1);
    path.lineTo(size.width * 0.3 + 20, size.height * 0.25);
    path.lineTo(size.width * 0.45 + 20, size.height * 0.4);
    path.lineTo(size.width * 0.6 + 20, size.height * 0.6);
    path.lineTo(size.width * 0.75 + 20, size.height * 0.8);
    path.lineTo(size.width * 0.9 + 20, size.height * 0.95);
    path.lineTo(size.width - 20, size.height - 10);

    canvas.drawPath(path, linePaint);

    // Draw start point circle
    final circlePaint = Paint()
      ..color =
          const Color(0xFFF63CF3) // Same pink color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(40, 10), 4, circlePaint);

    // Draw Y-axis labels with clear visibility
    final textStyle = TextStyle(
      color: Colors.white, // White color for better visibility
      fontSize: 12, // Larger font size
      fontWeight: FontWeight.w500, // Medium weight
      fontFamily: 'SF Pro Display',
    );

    // Draw "100%" at very top-left
    final textSpan = TextSpan(text: '100%', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(5, 5));

    // Draw "50%" at middle-left
    final textSpan2 = TextSpan(text: '50%', style: textStyle);
    final textPainter2 = TextPainter(
      text: textSpan2,
      textDirection: TextDirection.ltr,
    );
    textPainter2.layout();
    textPainter2.paint(canvas, Offset(5, size.height / 2 - 5));

    // Draw "0%" at bottom-left
    final textSpan3 = TextSpan(text: '0%', style: textStyle);
    final textPainter3 = TextPainter(
      text: textSpan3,
      textDirection: TextDirection.ltr,
    );
    textPainter3.layout();
    textPainter3.paint(canvas, Offset(5, size.height - 15));

    // Draw X-axis labels with exact positioning
    final textSpan4 = TextSpan(text: '0:00', style: textStyle);
    final textPainter4 = TextPainter(
      text: textSpan4,
      textDirection: TextDirection.ltr,
    );
    textPainter4.layout();
    textPainter4.paint(canvas, Offset(25, size.height - 5));

    final textSpan5 = TextSpan(text: duration, style: textStyle);
    final textPainter5 = TextPainter(
      text: textSpan5,
      textDirection: TextDirection.ltr,
    );
    textPainter5.layout();
    textPainter5.paint(canvas, Offset(size.width - 30, size.height - 5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
