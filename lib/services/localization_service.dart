import 'package:flutter/material.dart';

class LocalizationService extends ChangeNotifier {
  // Default to English
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  // All the translated text for the app
  final Map<String, Map<String, String>> _translations = {
    'en': {
      // Home Screen
      'welcome_title': 'Welcome, Raj Kumar',
      'home_active_plots': 'Active Plots',
      'home_crop_advisory': 'Crop Advisory',
      'home_pest_detection': 'Pest Detection',
      'home_market_prices': 'Market Insights',
      'home_community': 'Community',

      // Schemes Screen
      'schemes_title': 'Government Schemes',
      'schemes_subtitle': 'Access government benefits and subsidies for farmers',
      'schemes_pm_kisan_title': 'PM-KISAN',
      'schemes_pm_kisan_desc':
      '₹6000 per year income support for farmer families',
      'schemes_crop_insurance_title': 'Crop Insurance',
      'schemes_crop_insurance_desc':
      'Comprehensive risk coverage for crops against natural calamities',
      'schemes_status_active': 'Active',
      'schemes_status_open': 'Open',
      'schemes_amount_per_year': '₹6,000/year',
      'schemes_amount_upto': 'Up to ₹2 Lakh',
      'schemes_deadline': 'Deadline',
      'schemes_helpline': 'Helpline',

      // Updates Screen
      'updates_title': "Today's Updates",
      'updates_tab_all': 'All',
      'updates_tab_alerts': 'Alerts',
      'updates_tab_tasks': 'Tasks',
      'updates_tab_market': 'Market',
      'updates_tab_weather': 'Weather',
      'updates_pest_alert_title': 'Pest Alert: Aphids Detected',
      'updates_pest_alert_desc':
      'High aphid activity reported in your area. Check your crops and apply neem oil spray if affected.',
      'updates_task_fertilizer_title': "Today's Task: Apply Fertilizer",
      'updates_task_fertilizer_desc':
      "It's time to apply NPK fertilizer to your wheat crop. Weather conditions are ideal.",
      'updates_market_price_title': 'Market Price Update',
      'updates_market_price_desc':
      'Tomato prices have increased by 20% this week. Good time to sell your harvest.',
      'updates_load_more': 'Load More Updates',
      'priority_high': 'High',
      'priority_medium': 'Medium',
      'priority_low': 'Low',

      // Diary Screen
      'diary_my_crop_plans': 'My Crop Plans',
      'diary_day_of_plan': 'Day {days} of plan',
      'diary_progress': 'Progress',
      'diary_view_full_calendar': 'View Full Calendar →',
      'diary_no_tasks_today': 'No tasks scheduled for today. Relax!',
      'diary_no_activities': 'No activities on this day.',
      'diary_no_specific_steps': 'No specific steps provided for this task.',
      'diary_steps': 'Steps:',
      'diary_add_details': 'Add Details',
      'diary_view_edit_details': 'View/Edit Details',
      'diary_details_for': 'Details for: {activity}',
      'diary_expenses': 'Expenses (e.g., 500)',
      'diary_add_notes': 'Add Notes',
      'diary_save_details': 'Save Details',
      'diary_no_plans': 'No crop plans found.',

      // Profile Screen
      'profile_title': 'Profile',
      'profile_farm_info': 'Farm Information',
      'profile_farm_size': 'Farm Size',
      'profile_experience': 'Experience',
      'profile_primary_language': 'Primary Language',
      'profile_member_since': 'Member Since',
      'profile_offline_capability': 'Offline Capability',
      'profile_offline_desc':
      'Your essential farm data is available offline. Last synced: 2 hours ago',
      'profile_offline_cta':
      'Weather data, crop info, and treatment guides available offline',
      'profile_settings': 'Settings',
      'profile_settings_desc': 'App preferences, notifications',
      'profile_offline_data': 'Offline Data',
      'profile_offline_data_desc': 'Download data for offline use',
      'profile_help_support': 'Help & Support',
      'profile_help_support_desc': 'Get help, contact support',
      'profile_contact_info': 'Contact Information',
      'profile_primary_contact': 'Primary contact number',
      'profile_emergency_contacts': 'Emergency Contacts',
      'profile_sign_out': 'Sign Out',

      // Crop Advisory Flow
      'crop_advisory_title': 'Crop Advisory',
      'crop_advisory_subtitle':
      'Select your crop to get personalized farming guidance',
      'crop_advisory_customize': 'Customize Crop',
      'crop_advisory_rice': 'Rice',
      'crop_advisory_wheat': 'Wheat',
      'crop_advisory_cotton': 'Cotton',
      'crop_advisory_maize': 'Maize',
      'crop_advisor_form_title': 'Crop Advisor',
      'crop_advisor_form_land_details': 'Land Details',
      'crop_advisor_form_land_area': 'Land Area (acres)',
      'crop_advisor_form_soil_type': 'Land Soil Type',
      'crop_advisor_form_irrigation_type': 'Irrigation Type',
      'crop_advisor_form_get_recommendation': 'Get Recommendation',
      'crop_advisor_form_get_plan': 'Get Plan',
      'personalized_plan_title': 'Your Personalized Plan',
      'personalized_plan_summary_title': 'Recommendation Summary',
      'personalized_plan_summary_desc':
      'Based on your input of Loamy Soil and Drip Irrigation, the recommended crop is Wheat.',
      'personalized_plan_step1_title': 'Step 1: Land Preparation',
      'personalized_plan_step2_title': 'Step 2: Sowing & Planting',
      'personalized_plan_step3_title': 'Step 3: Fertilization Schedule',
      'crop_advisor_form_hint_area': 'e.g., 5.0',
      'crop_advisor_form_hint_soil': 'e.g., Loamy, Sandy',
      'crop_advisor_form_hint_irrigation': 'Select an irrigation method',
      'irrigation_drip': 'Drip Irrigation',
      'irrigation_sprinkler': 'Sprinkler',
      'irrigation_canal': 'Canal',

      // Market Insights
      'market_prices_title': 'Market Insights',
      'market_prices_live': 'Live',
      'market_prices_per_quintal': 'per quintal',
      'market_prices_vs_yesterday': 'vs yesterday',
      'market_search_hint': 'Search by Crop or Mandi...',
      'market_all_markets': 'All Markets',
      'market_mandi': 'Mandi',
      'market_market_yard': 'Market Yard',
      'market_bazaar': 'Bazaar',
      'market_forecast_button': '1-Month Forecast',
      'market_prediction_title': 'Forecast for {crop}',
      'market_predicted_price': 'Predicted Price (30 days):',
      'market_prediction_note': 'This is a sample AI prediction. Market conditions may vary.',
      'market_close': 'Close',

      // Community Forum
      'community_title': 'Community Forum',
      'community_share_experience': 'Share Your Experience',
      'community_share_experience_subtitle':
      'Record a 30-second voice message for the community',
      'community_record_button': 'Record 30s Question',
      'community_tag_crops': 'Crops',
      'community_tag_tips': 'Tips',
      'community_tag_govt': 'Govt. Schemes',
      'community_post_1_text':
      'My wheat crop is showing yellow leaves. What should I do?',
      'community_post_2_text':
      'I use neem oil mixed with soap water for pest control. Very effective and organic!',
      'community_post_3_text':
      'PM-KISAN installment received today. ₹2000 credited to account. Check your status!',

      // Pest Detection
      'pest_detection_title': 'Pest Detection',
      'pest_detection_subtitle':
      'Scan your plants to identify diseases and get treatment advice',
      'pest_detection_viewfinder_title': 'Camera Viewfinder',
      'pest_detection_viewfinder_subtitle':
      'Point camera at affected plant area',
      'pest_detection_instructions_title': 'How to scan effectively:',
      'pest_detection_instruction_1':
      'Hold phone steady and close to the plant',
      'pest_detection_instruction_2': 'Ensure good lighting conditions',
      'pest_detection_instruction_3':
      'Focus on the affected area (leaves, stems, fruits)',
      'pest_detection_instruction_4':
      'Keep background simple and uncluttered',
      'pest_detection_capture_button': 'Capture Photo',
      'pest_detection_upload_button': 'Upload Image',

      // New translations for crop advisory
      'validation_land_area_required': 'Please enter land area',
      'validation_land_area_number': 'Please enter a valid number',
      'validation_land_area_positive': 'Land area must be greater than 0',
      'validation_soil_type_required': 'Please enter soil type',
      'validation_soil_type_valid': 'Please enter a valid soil type',
      'validation_irrigation_required': 'Please select an irrigation method',
      'recommendation_success': 'Recommendation generated successfully!',
      'reset_form_tooltip': 'Reset Form',
      'reset_form_button': 'Reset Form',
      'not_selected': 'Not selected',
      'acres_unit': 'acres',
      'form_summary': 'Form Summary:',
      'Step': 'Step',

      // Crop recommendation texts
      'recommendation_based_on': 'Based on your input of',
      'recommendation_land_area': 'acres with',
      'recommendation_soil': 'soil and',
      'recommendation_irrigation': 'irrigation, the recommended crop is',
      'recommendation_crop_loamy': 'Wheat',
      'recommendation_crop_sandy': 'Groundnut',
      'recommendation_crop_clay': 'Rice',
      'recommendation_crop_default': 'Maize',

      // Plan step tasks
      'plan_task_plow': 'Plow the field 2-3 times to get a fine tilth.',
      'plan_task_manure': 'Apply 10-15 tons of farmyard manure per acre.',
      'plan_task_seeds': 'Use certified seeds for best results.',
      'plan_task_spacing': 'Maintain a row-to-row spacing of 30 cm.',
      'plan_task_npk1': 'Apply first dose of NPK fertilizer after 25 days.',
      'plan_task_npk2': 'Second dose should be applied at the flowering stage.',

      // Add to all three language maps
      'location_permission_title': 'Location Access',
      'location_permission_message': 'Krishi Rath needs access to your location to show local weather information and provide accurate farming recommendations.',
      'location_permission_allow': 'Allow',
      'location_permission_deny': 'Deny',
      'weather_title': 'Weather',
      'weather_loading': 'Loading weather data...',
      'weather_refresh': 'Refresh weather',
      'weather_humidity': 'Humidity',
      'weather_wind': 'Wind Speed',
      'weather_using_default_location': 'Using default location',

      // Add these keys to your English localization file
      'home_chatbot': 'AI Assistant',
      'home_weather': 'Weather',
      'feature_coming_soon': 'Feature coming soon!',

// Chatbot translations
      'chatbot_title': 'Krishi Rath AI Assistant',
      'chatbot_welcome_message': 'Hello! I\'m your farming assistant. Ask me about crops, weather, diseases, prices, or upload images for analysis.',
      'chatbot_type_message': 'Type your question...',
      'chatbot_send_message': 'Send message',
      'chatbot_upload_image': 'Upload image',
      'chatbot_voice_input': 'Voice input',
      'chatbot_voice_coming_soon': 'Voice input coming soon!',
      'chatbot_image_uploaded': 'Image uploaded for analysis',
      'chatbot_image_analysis': 'Analyzing uploaded image',

// Bot responses
      'chatbot_response_greeting': 'Hello! How can I help with your farming today?',
      'chatbot_response_weather': 'For accurate weather information, check the weather card on the home screen. For Nashik region, expect moderate temperatures with possible rainfall.',
      'chatbot_response_crop': 'Based on your soil type and season, I recommend crops like wheat, rice, or vegetables. Visit Crop Advisory for personalized recommendations.',
      'chatbot_response_disease': 'For pest and disease detection, use the Pest Detection feature to scan plant images. Common issues include fungal infections and insect damage.',
      'chatbot_response_price': 'Check Market Prices for current rates. Wheat is trading at ₹2,100-2,300 per quintal in Nashik market.',
      'chatbot_response_soil': 'Loamy soil is best for most crops. Get soil testing done and use organic manure for better yield.',
      'chatbot_response_fertilizer': 'Use balanced NPK fertilizers. For wheat: 120:60:40 kg/ha of N:P:K. Always test soil before application.',
      'chatbot_response_irrigation': 'Drip irrigation saves 30-50% water. Water requirements vary by crop stage and season.',
      'chatbot_response_default': 'I understand you\'re asking about farming. For detailed assistance, try our specialized features: Crop Advisory, Pest Detection, or Market Prices.',

      'chatbot_error_response': 'Sorry, I encountered an error. Please try again.',
      'chatbot_image_error': 'Sorry, I could not analyze the image. Please try again.',


// English
      'ok_button': 'OK',
      'chatbot_info_content': 'This AI assistant uses Google Gemini to provide farming advice. You can ask questions about crops, weather, diseases, prices, or upload images for analysis.',



    },
    'hi': {

      // Hindi
      'chatbot_error_response': 'क्षमा करें, मुझे एक त्रुटि का सामना करना पड़ा। कृपया पुनः प्रयास करें।',
      'chatbot_image_error': 'क्षमा करें, मैं छवि का विश्लेषण नहीं कर सका। कृपया पुनः प्रयास करें।',

      // Home Screen
      'welcome_title': 'स्वागत है, राज कुमार',
      'home_active_plots': 'सक्रिय प्लॉट',
      'home_crop_advisory': 'फसल सलाहकार',
      'home_pest_detection': 'कीट पहचान',
      'home_market_prices': 'बाजार अंतर्दृष्टि',
      'home_community': 'समुदाय',

      // Schemes Screen
      'schemes_title': 'सरकारी योजनाएं',
      'schemes_subtitle': 'किसानों के लिए सरकारी लाभ और सब्सिडी प्राप्त करें',
      'schemes_pm_kisan_title': 'पीएम-किसान',
      'schemes_pm_kisan_desc': 'किसान परिवारों के लिए ₹6000 प्रति वर्ष आय सहायता',
      'schemes_crop_insurance_title': 'फसल बीमा',
      'schemes_crop_insurance_desc':
      'प्राकृतिक आपदाओं के खिलाफ फसलों के लिए व्यापक जोखिम कवरेज',
      'schemes_status_active': 'सक्रिय',
      'schemes_status_open': 'खुला',
      'schemes_amount_per_year': '₹6,000/वर्ष',
      'schemes_amount_upto': '₹2 लाख तक',
      'schemes_deadline': 'अंतिम तिथि',
      'schemes_helpline': 'हेल्पलाइन',

      // Updates Screen
      'updates_title': 'आज की जानकारी',
      'updates_tab_all': 'सभी',
      'updates_tab_alerts': 'चेतावनी',
      'updates_tab_tasks': 'कार्य',
      'updates_tab_market': 'बाजार',
      'updates_tab_weather': 'मौसम',
      'updates_pest_alert_title': 'कीट चेतावनी: माहू का पता चला',
      'updates_pest_alert_desc':
      'आपके क्षेत्र में माहू की उच्च गतिविधि की सूचना मिली है। अपनी फसलों की जांच करें और प्रभावित होने पर नीम के तेल का छिड़काव करें।',
      'updates_task_fertilizer_title': 'आज का कार्य: उर्वरक डालना',
      'updates_task_fertilizer_desc':
      'गेहूं की फसल में एनपीके उर्वरक डालने का समय है। मौसम की स्थिति आदर्श है।',
      'updates_market_price_title': 'बाजार मूल्य अद्यतन',
      'updates_market_price_desc':
      'इस सप्ताह टमाटर की कीमतों में 20% की वृद्धि हुई है। अपनी फसल बेचने का यह अच्छा समय है।',
      'updates_load_more': 'और अपडेट लोड करें',
      'priority_high': 'उच्च',
      'priority_medium': 'मध्यम',
      'priority_low': 'कम',

      //dairy screen
      'diary_my_crop_plans': 'मेरी फसल योजनाएं',
      'diary_day_of_plan': 'योजना का दिन {days}',
      'diary_progress': 'प्रगति',
      'diary_view_full_calendar': 'पूरा कैलेंडर देखें →',
      'diary_no_tasks_today': 'आज के लिए कोई कार्य निर्धारित नहीं है। आराम करें!',
      'diary_no_activities': 'इस दिन कोई गतिविधि नहीं है।',
      'diary_no_specific_steps': 'इस कार्य के लिए कोई विशेष चरण प्रदान नहीं किए गए हैं।',
      'diary_steps': 'चरण:',
      'diary_add_details': 'विवरण जोड़ें',
      'diary_view_edit_details': 'विवरण देखें/संपादित करें',
      'diary_details_for': 'के लिए विवरण: {activity}',
      'diary_expenses': 'खर्च (उदा., 500)',
      'diary_add_notes': 'नोट्स जोड़ें',
      'diary_save_details': 'विवरण सहेजें',
      'diary_no_plans': 'कोई फसल योजना नहीं मिली।',

      // Profile Screen
      'profile_title': 'प्रोफ़ाइल',
      'profile_farm_info': 'खेत की जानकारी',
      'profile_farm_size': 'खेत का आकार',
      'profile_experience': 'अनुभव',
      'profile_primary_language': 'प्राथमिक भाषा',
      'profile_member_since': 'सदस्यता जबसे',
      'profile_offline_capability': 'ऑफ़लाइन क्षमता',
      'profile_offline_desc':
      'आपका आवश्यक कृषि डेटा ऑफ़लाइन उपलब्ध है। अंतिम सिंक: 2 घंटे पहले',
      'profile_offline_cta':
      'मौसम डेटा, फसल की जानकारी, और उपचार गाइड ऑफ़लाइन उपलब्ध हैं',
      'profile_settings': 'सेटिंग्स',
      'profile_settings_desc': 'ऐप प्राथमिकताएं, सूचनाएं',
      'profile_offline_data': 'ऑफ़लाइन डेटा',
      'profile_offline_data_desc': 'ऑफ़लाइन उपयोग के लिए डेटा डाउनलोड करें',
      'profile_help_support': 'सहायता और समर्थन',
      'profile_help_support_desc': 'सहायता प्राप्त करें, समर्थन से संपर्क करें',
      'profile_contact_info': 'संपर्क जानकारी',
      'profile_primary_contact': 'प्राथमिक संपर्क नंबर',
      'profile_emergency_contacts': 'आपातकालीन संपर्क',
      'profile_sign_out': 'साइन आउट',

      // Crop Advisory Flow
      'crop_advisory_title': 'फसल सलाहकार',
      'crop_advisory_subtitle':
      'व्यक्तिगत खेती मार्गदर्शन के लिए अपनी फसल चुनें',
      'crop_advisory_customize': 'फसल अनुकूलित करें',
      'crop_advisory_rice': 'चावल',
      'crop_advisory_wheat': 'गेहूं',
      'crop_advisory_cotton': 'कपास',
      'crop_advisory_maize': 'मक्का',
      'crop_advisor_form_title': 'फसल सलाहकार',
      'crop_advisor_form_land_details': 'भूमि का विवरण',
      'crop_advisor_form_land_area': 'भूमि क्षेत्र (एकड़)',
      'crop_advisor_form_soil_type': 'भूमि मिट्टी का प्रकार',
      'crop_advisor_form_irrigation_type': 'सिंचाई का प्रकार',
      'crop_advisor_form_get_recommendation': 'सिफारिश प्राप्त करें',
      'crop_advisor_form_get_plan': 'योजना प्राप्त करें',
      'personalized_plan_title': 'आपकी व्यक्तिगत योजना',
      'personalized_plan_summary_title': 'सिफारिश सारांश',
      'personalized_plan_summary_desc':
      'आपकी दोमट मिट्टी और ड्रिप सिंचाई के इनपुट के आधार पर, अनुशंसित फसल गेहूं है।',
      'personalized_plan_step1_title': 'चरण 1: भूमि की तैयारी',
      'personalized_plan_step2_title': 'चरण 2: बुवाई और रोपण',
      'personalized_plan_step3_title': 'चरण 3: उर्वरीकरण अनुसूची',
      'crop_advisor_form_hint_area': 'उदा., 5.0',
      'crop_advisor_form_hint_soil': 'उदा., दोमट, रेतीली',
      'crop_advisor_form_hint_irrigation': 'सिंचाई विधि चुनें',
      'irrigation_drip': 'ड्रिप सिंचाई',
      'irrigation_sprinkler': 'स्प्रिंकलर',
      'irrigation_canal': 'नहर',

      // Market Insights
      'market_prices_title': 'बाजार अंतर्दृष्टि',
      'market_prices_live': 'लाइव',
      'market_prices_per_quintal': 'प्रति क्विंटल',
      'market_prices_vs_yesterday': 'कल की तुलना में',
      'market_search_hint': 'फसल या मंडी से खोजें...',
      'market_all_markets': 'सभी बाजार',
      'market_mandi': 'मंडी',
      'market_market_yard': 'मार्केट यार्ड',
      'market_bazaar': 'बाजार',
      'market_forecast_button': '1-महीने का पूर्वानुमान',
      'market_prediction_title': '{crop} के लिए पूर्वानुमान',
      'market_predicted_price': 'अनुमानित मूल्य (30 दिन):',
      'market_prediction_note': 'यह एक नमूना एआई पूर्वानुमान है। बाजार की स्थितियां बदल सकती हैं।',
      'market_close': 'बंद करें',

      // Community Forum
      'community_title': 'किसान समुदाय',
      'community_share_experience': 'अपना अनुभव साझा करें',
      'community_share_experience_subtitle':
      'समुदाय के लिए 30 सेकंड का ध्वनि संदेश रिकॉर्ड करें',
      'community_record_button': '30 सेकंड का सवाल रिकॉर्ड करें',
      'community_tag_crops': 'फसलें',
      'community_tag_tips': 'सुझाव',
      'community_tag_govt': 'सरकारी योजनाएं',
      'community_post_1_text':
      'मेरी गेहूं की फसल में पीली पत्तियां हो रही हैं। मुझे क्या करना चाहिए?',
      'community_post_2_text':
      'मैं कीट नियंत्रण के लिए नीम के तेल को साबुन के पानी में मिलाकर इस्तेमाल करता हूं। बहुत प्रभावी और जैविक!',
      'community_post_3_text':
      'पीएम-किसान की किस्त आज मिली। खाते में ₹2000 जमा हुए। अपनी स्थिति जांचें!',

      // Pest Detection
      'pest_detection_title': 'कीट पहचान',
      'pest_detection_subtitle':
      'रोगों की पहचान और उपचार सलाह के लिए अपने पौधों को स्कैन करें',
      'pest_detection_viewfinder_title': 'कैमरा व्यूफाइंडर',
      'pest_detection_viewfinder_subtitle':
      'प्रभावित पौधे के हिस्से पर कैमरा पॉइंट करें',
      'pest_detection_instructions_title': 'प्रभावी ढंग से स्कैन कैसे करें:',
      'pest_detection_instruction_1':
      'फोन को स्थिर रखें और पौधे के पास ले जाएं',
      'pest_detection_instruction_2': 'अच्छी रोशनी सुनिश्चित करें',
      'pest_detection_instruction_3':
      'प्रभावित क्षेत्र पर ध्यान दें (पत्तियां, तना, फल)',
      'pest_detection_instruction_4':
      'पृष्ठभूमि को सरल और अव्यवस्थित रखें',
      'pest_detection_capture_button': 'फोटो लें',
      'pest_detection_upload_button': 'छवि अपलोड करें',

      // New translations for crop advisory
      'validation_land_area_required': 'कृपया भूमि क्षेत्र दर्ज करें',
      'validation_land_area_number': 'कृपया एक वैध संख्या दर्ज करें',
      'validation_land_area_positive': 'भूमि क्षेत्र 0 से अधिक होना चाहिए',
      'validation_soil_type_required': 'कृपया मिट्टी का प्रकार दर्ज करें',
      'validation_soil_type_valid': 'कृपया एक वैध मिट्टी प्रकार दर्ज करें',
      'validation_irrigation_required': 'कृपया सिंचाई विधि चुनें',
      'recommendation_success': 'सिफारिश सफलतापूर्वक उत्पन्न हुई!',
      'reset_form_tooltip': 'फॉर्म रीसेट करें',
      'reset_form_button': 'फॉर्म रीसेट करें',
      'not_selected': 'चयनित नहीं',
      'acres_unit': 'एकड़',
      'form_summary': 'फॉर्म सारांश:',
      'Step': 'चरण',

      // Crop recommendation texts
      'recommendation_based_on': 'आपके इनपुट के आधार पर',
      'recommendation_land_area': 'एकड़ के साथ',
      'recommendation_soil': 'मिट्टी और',
      'recommendation_irrigation': 'सिंचाई, अनुशंसित फसल है',
      'recommendation_crop_loamy': 'गेहूं',
      'recommendation_crop_sandy': 'मूंगफली',
      'recommendation_crop_clay': 'चावल',
      'recommendation_crop_default': 'मक्का',

      // Plan step tasks
      'plan_task_plow': 'खेत की 2-3 बार जुताई करें ताकि मिट्टी भुरभुरी हो जाए।',
      'plan_task_manure': 'प्रति एकड़ 10-15 टन गोबर की खाद डालें।',
      'plan_task_seeds': 'सर्वोत्तम परिणामों के लिए प्रमाणित बीजों का उपयोग करें।',
      'plan_task_spacing': 'पंक्ति से पंक्ति की दूरी 30 सेमी बनाए रखें।',
      'plan_task_npk1': '25 दिनों के बाद एनपीके उर्वरक की पहली खुराक डालें।',
      'plan_task_npk2': 'दूसरी खुराक फूल आने की अवस्था में दी जानी चाहिए।',

      'location_permission_title': 'स्थान का उपयोग',
      'location_permission_message': 'कृषि रथ को आपके स्थान तक पहुंच की आवश्यकता है ताकि स्थानीय मौसम की जानकारी दिखाई जा सके और सटीक खेती की सिफारिशें प्रदान की जा सकें।',
      'location_permission_allow': 'अनुमति दें',
      'location_permission_deny': 'अस्वीकार करें',
      'weather_title': 'मौसम',
      'weather_loading': 'मौसम डेटा लोड हो रहा है...',
      'weather_refresh': 'मौसम ताज़ा करें',
      'weather_humidity': 'नमी',
      'weather_wind': 'हवा की गति',
      'weather_using_default_location': 'डिफ़ॉल्ट स्थान का उपयोग कर रहे हैं',

      'home_chatbot': 'एआई सहायक',
      'home_weather': 'मौसम',
      'feature_coming_soon': 'जल्द ही आ रहा है!',

// Chatbot translations
      'chatbot_title': 'कृषि रथ एआई सहायक',
      'chatbot_welcome_message': 'नमस्ते! मैं आपका कृषि सहायक हूं। मुझसे फसलों, मौसम, बीमारियों, कीमतों के बारे में पूछें या विश्लेषण के लिए छवियां अपलोड करें।',
      'chatbot_type_message': 'अपना प्रश्न टाइप करें...',
      'chatbot_send_message': 'संदेश भेजें',
      'chatbot_upload_image': 'छवि अपलोड करें',
      'chatbot_voice_input': 'आवाज इनपुट',
      'chatbot_voice_coming_soon': 'आवाज इनपुट जल्द ही आ रहा है!',
      'chatbot_image_uploaded': 'विश्लेषण के लिए छवि अपलोड की गई',
      'chatbot_image_analysis': 'अपलोड की गई छवि का विश्लेषण कर रहा हूं',

// Bot responses
      'chatbot_response_greeting': 'नमस्ते! आज मैं आपकी खेती में कैसे मदद कर सकता हूं?',
      'chatbot_response_weather': 'सटीक मौसम की जानकारी के लिए होम स्क्रीन पर वेदर कार्ड देखें। नासिक क्षेत्र के लिए, संभावित बारिश के साथ मध्यम तापमान की उम्मीद है।',
      'chatbot_response_crop': 'आपकी मिट्टी के प्रकार और मौसम के आधार पर, मैं गेहूं, चावल या सब्जियों जैसी फसलों की सलाह देता हूं। व्यक्तिगत सिफारिशों के लिए क्रॉप एडवाइजरी पर जाएं।',
      'chatbot_response_disease': 'कीट और बीमारी का पता लगाने के लिए, पौधों की छवियों को स्कैन करने के लिए पेस्ट डिटेक्शन फीचर का उपयोग करें। आम समस्याओं में फंगल संक्रमण और कीट क्षति शामिल हैं।',
      'chatbot_response_price': 'वर्तमान दरों के लिए मार्केट प्राइस देखें। नासिक बाजार में गेहूं ₹2,100-2,300 प्रति क्विंटल पर कारोबार कर रहा है।',
      'chatbot_response_soil': 'ज्यादातर फसलों के लिए दोमट मिट्टी सबसे अच्छी होती है। बेहतर उपज के लिए मिट्टी की जांच कराएं और जैविक खाद का उपयोग करें।',
      'chatbot_response_fertilizer': 'संतुलित एनपीके उर्वरकों का उपयोग करें। गेहूं के लिए: एन:पी:के 120:60:40 किग्रा/हेक्टेयर। आवेदन से पहले हमेशा मिट्टी की जांच करें।',
      'chatbot_response_irrigation': 'ड्रिप सिंचाई 30-50% पानी बचाती है। पानी की आवश्यकताएं फसल के चरण और मौसम के अनुसार अलग-अलग होती हैं।',
      'chatbot_response_default': 'मैं समझता हूं कि आप खेती के बारे में पूछ रहे हैं। विस्तृत सहायता के लिए, हमारे विशेष सुविधाओं का प्रयोग करें: क्रॉप एडवाइजरी, पेस्ट डिटेक्शन, या मार्केट प्राइस।',

      // Hindi
      'ok_button': 'ठीक है',
      'chatbot_info_content': 'यह एआई सहायक कृषि सलाह प्रदान करने के लिए Google Gemini का उपयोग करता है। आप फसलों, मौसम, बीमारियों, कीमतों के बारे में प्रश्न पूछ सकते हैं या विश्लेषण के लिए छवियां अपलोड कर सकते हैं।',
    },
    'mr': {
// Marathi
      'ok_button': 'ठीक',
      'chatbot_info_content': 'हे कृत्रिम बुद्धिमत्ता सहाय्यक शेती सल्ला देण्यासाठी Google Gemini वापरते. आपण पिके, हवामान, रोग, किंमती याबद्दल प्रश्न विचारू शकता किंवा विश्लेषणासाठी प्रतिमा अपलोड करू शकता.',

      // Marathi
      'chatbot_error_response': 'माफ करा, मला एक त्रुटी आली. कृपया पुन्हा प्रयत्न करा.',
      'chatbot_image_error': 'माफ करा, मी प्रतिमेचे विश्लेषण करू शकलो नाही. कृपया पुन्हा प्रयत्न करा.',

      // Home Screen
      'welcome_title': 'स्वागत आहे, राज कुमार',
      'home_active_plots': 'सक्रिय भूखंड',
      'home_crop_advisory': 'पीक सल्ला',
      'home_pest_detection': 'कीड ओळख',
      'home_market_prices': 'बाजार अंतर्दृष्टी',
      'home_community': 'समुदाय',

      // Schemes Screen
      'schemes_title': 'सरकारी योजना',
      'schemes_subtitle': 'शेतकऱ्यांसाठी सरकारी लाभ आणि अनुदान मिळवा',
      'schemes_pm_kisan_title': 'पीएम-किसान',
      'schemes_pm_kisan_desc':
      'शेतकरी कुटुंबांसाठी प्रति वर्ष ₹6000 उत्पन्न समर्थन',
      'schemes_crop_insurance_title': 'पीक विमा',
      'schemes_crop_insurance_desc':
      'नैसर्गिक आपत्तींपासून पिकांसाठी व्यापक धोका कवच',
      'schemes_status_active': 'सक्रिय',
      'schemes_status_open': 'उघडा',
      'schemes_amount_per_year': '₹6,000/वर्ष',
      'schemes_amount_upto': '₹2 लाख पर्यंत',
      'schemes_deadline': 'अंतिम मुदत',
      'schemes_helpline': 'हेल्पलाइन',

      // Updates Screen
      'updates_title': 'आजची अद्यतने',
      'updates_tab_all': 'सर्व',
      'updates_tab_alerts': 'सूचना',
      'updates_tab_tasks': 'कामे',
      'updates_tab_market': 'बाजार',
      'updates_tab_weather': 'हवामान',
      'updates_pest_alert_title': 'कीड सूचना: मावा आढळला',
      'updates_pest_alert_desc':
      'तुमच्या परिसरात माव्याचा प्रादुर्भाव वाढला आहे. तुमच्या पिकांची तपासणी करा आणि गरज भासल्यास कडुलिंबाच्या तेलाची फवारणी करा.',
      'updates_task_fertilizer_title': 'आजचे काम: खत घालणे',
      'updates_task_fertilizer_desc':
      'तुमच्या गव्हाच्या पिकाला NPK खत देण्याची वेळ झाली आहे. हवामान अनुकूल आहे.',
      'updates_market_price_title': 'बाजार भाव अद्यतन',
      'updates_market_price_desc':
      'या आठवड्यात टोमॅटोच्या दरात २०% वाढ झाली आहे. तुमचे पीक विकण्याची ही चांगली वेळ आहे.',
      'updates_load_more': 'अधिक अद्यतने लोड करा',
      'priority_high': 'उच्च',
      'priority_medium': 'मध्यम',
      'priority_low': 'कमी',

      // Diary Screen
      'diary_my_crop_plans': 'माझ्या पीक योजना',
      'diary_day_of_plan': 'योजनेचा दिवस {days}',
      'diary_progress': 'प्रगती',
      'diary_view_full_calendar': 'संपूर्ण कॅलेंडर पहा →',
      'diary_no_tasks_today': 'आजसाठी कोणतेही काम नियोजित नाही. आराम करा!',
      'diary_no_activities': 'या दिवशी कोणतीही क्रिया नाही.',
      'diary_no_specific_steps': 'या कामासाठी कोणतेही विशिष्ट चरण प्रदान केलेले नाहीत.',
      'diary_steps': 'चरण:',
      'diary_add_details': 'तपशील जोडा',
      'diary_view_edit_details': 'तपशील पहा/संपादित करा',
      'diary_details_for': 'साठी तपशील: {activity}',
      'diary_expenses': 'खर्च (उदा., 500)',
      'diary_add_notes': 'नोट्स जोडा',
      'diary_save_details': 'तपशील जतन करा',
      'diary_no_plans': 'कोणतीही पीक योजना सापडली नाही.',

      // Profile Screen
      'profile_title': 'प्रोफाइल',
      'profile_farm_info': 'शेतीची माहिती',
      'profile_farm_size': 'शेतीचा आकार',
      'profile_experience': 'अनुभव',
      'profile_primary_language': 'प्राथमिक भाषा',
      'profile_member_since': 'सदस्य झाल्यापासून',
      'profile_offline_capability': 'ऑफलाइन क्षमता',
      'profile_offline_desc':
      'तुमचा आवश्यक शेती डेटा ऑफलाइन उपलब्ध आहे. शेवटचे सिंक: 2 तासांपूर्वी',
      'profile_offline_cta':
      'हवामान डेटा, पीक माहिती, आणि उपचार मार्गदर्शक ऑफलाइन उपलब्ध आहेत',
      'profile_settings': 'सेटिंग्ज',
      'profile_settings_desc': 'अ‍ॅप प्राधान्ये, सूचना',
      'profile_offline_data': 'ऑफलाइन डेटा',
      'profile_offline_data_desc': 'ऑफलाइन वापरासाठी डेटा डाउनलोड करा',
      'profile_help_support': 'मदत आणि समर्थन',
      'profile_help_support_desc': 'मदत मिळवा, समर्थनाशी संपर्क साधा',
      'profile_contact_info': 'संपर्क माहिती',
      'profile_primary_contact': 'प्राथमिक संपर्क क्रमांक',
      'profile_emergency_contacts': 'आणीबाणी संपर्क',
      'profile_sign_out': 'साइन आउट',

      // Crop Advisory Flow
      'crop_advisory_title': 'पीक सल्ला',
      'crop_advisory_subtitle': 'वैयक्तिकृत शेती मार्गदर्शनासाठी आपले पीक निवडा',
      'crop_advisory_customize': 'पीक सानुकूलित करा',
      'crop_advisory_rice': 'भात',
      'crop_advisory_wheat': 'गहू',
      'crop_advisory_cotton': 'कापूस',
      'crop_advisory_maize': 'मका',
      'crop_advisor_form_title': 'पीक सल्लागार',
      'crop_advisor_form_land_details': 'जमिनीचा तपशील',
      'crop_advisor_form_land_area': 'जमीन क्षेत्र (एकर)',
      'crop_advisor_form_soil_type': 'जमिनीचा प्रकार',
      'crop_advisor_form_irrigation_type': 'सिंचनाचा प्रकार',
      'crop_advisor_form_get_recommendation': 'शिफारस मिळवा',
      'crop_advisor_form_get_plan': 'योजना मिळवा',
      'personalized_plan_title': 'तुमची वैयक्तिकृत योजना',
      'personalized_plan_summary_title': 'शिफारस सारांश',
      'personalized_plan_summary_desc':
      'तुमच्या चिकणमाती आणि ठिबक सिंचनाच्या माहितीनुसार, गहू हे शिफारस केलेले पीक आहे.',
      'personalized_plan_step1_title': 'पायरी 1: जमिनीची तयारी',
      'personalized_plan_step2_title': 'पायरी 2: पेरणी आणि लागवड',
      'personalized_plan_step3_title': 'पायरी 3: खत व्यवस्थापन',
      'crop_advisor_form_hint_area': 'उदा., 5.0',
      'crop_advisor_form_hint_soil': 'उदा., चिकणमाती, वालुकामय',
      'crop_advisor_form_hint_irrigation': 'सिंचन पद्धत निवडा',
      'irrigation_drip': 'ठिबक सिंचन',
      'irrigation_sprinkler': 'तुषार सिंचन',
      'irrigation_canal': 'कालवा',

      // Market Insights
      'market_prices_title': 'बाजार अंतर्दृष्टी',
      'market_prices_live': 'थेट',
      'market_prices_per_quintal': 'प्रति क्विंटल',
      'market_prices_vs_yesterday': 'कालच्या तुलनेत',
      'market_search_hint': 'पीक किंवा मंडी नुसार शोधा...',
      'market_all_markets': 'सर्व बाजार',
      'market_mandi': 'मंडी',
      'market_market_yard': 'मार्केट यार्ड',
      'market_bazaar': 'बाजार',
      'market_forecast_button': '1-महिन्याचा अंदाज',
      'market_prediction_title': '{crop} साठी अंदाज',
      'market_predicted_price': 'अंदाजित किंमत (30 दिवस):',
      'market_prediction_note': 'हा एक नमुना AI अंदाज आहे. बाजारातील परिस्थिती बदलू शकते.',
      'market_close': 'बंद करा',

      // Community Forum
      'community_title': 'शेतकरी समुदाय',
      'community_share_experience': 'तुमचा अनुभव सांगा',
      'community_share_experience_subtitle':
      'समुदायासाठी 30-सेकंदांचा व्हॉइस संदेश रेकॉर्ड करा',
      'community_record_button': '30 सेकंदांचा प्रश्न रेकॉर्ड करा',
      'community_tag_crops': 'पिके',
      'community_tag_tips': 'टिपा',
      'community_tag_govt': 'सरकारी योजना',
      'community_post_1_text':
      'माझ्या गव्हाच्या पिकाला पिवळी पाने येत आहेत. मी काय करावे?',
      'community_post_2_text':
      'मी कीड नियंत्रणासाठी कडुलिंबाचे तेल साबणाच्या पाण्यात मिसळून वापरतो. खूप प्रभावी आणि सेंद्रिय!',
      'community_post_3_text':
      'पीएम-किसानचा हप्ता आज मिळाला. खात्यात ₹2000 जमा झाले. तुमची स्थिती तपासा!',

      // Pest Detection
      'pest_detection_title': 'कीड ओळख',
      'pest_detection_subtitle':
      'रोगांची ओळख आणि उपचार सल्ल्यासाठी तुमची रोपे स्कॅन करा',
      'pest_detection_viewfinder_title': 'कॅमेरा व्ह्यूफाइंडर',
      'pest_detection_viewfinder_subtitle':
      'प्रभावित वनस्पती क्षेत्रावर कॅमेरा निर्देशित करा',
      'pest_detection_instructions_title': 'प्रभावीपणे कसे स्कॅन करावे:',
      'pest_detection_instruction_1':
      'फोन स्थिर धरा आणि वनस्पतीच्या जवळ ठेवा',
      'pest_detection_instruction_2': 'चांगली प्रकाश व्यवस्था असल्याची खात्री करा',
      'pest_detection_instruction_3':
      'प्रभावित भागावर लक्ष केंद्रित करा (पाने, देठ, फळे)',
      'pest_detection_instruction_4':
      'पार्श्वभूमी साधी आणि गोंधळविरहित ठेवा',
      'pest_detection_capture_button': 'फोटो काढा',
      'pest_detection_upload_button': 'प्रतिमा अपलोड करा',

      // New translations for crop advisory
      'validation_land_area_required': 'कृपया जमीन क्षेत्र प्रविष्ट करा',
      'validation_land_area_number': 'कृपया एक वैध संख्या प्रविष्ट करा',
      'validation_land_area_positive': 'जमीन क्षेत्र 0 पेक्षा जास्त असणे आवश्यक आहे',
      'validation_soil_type_required': 'कृपया मातीचा प्रकार प्रविष्ट करा',
      'validation_soil_type_valid': 'कृपया एक वैध माती प्रकार प्रविष्ट करा',
      'validation_irrigation_required': 'कृपया सिंचन पद्धत निवडा',
      'recommendation_success': 'शिफारस यशस्वीरित्या तयार झाली!',
      'reset_form_tooltip': 'फॉर्म रीसेट करा',
      'reset_form_button': 'फॉर्म रीसेट करा',
      'not_selected': 'निवडलेले नाही',
      'acres_unit': 'एकर',
      'form_summary': 'फॉर्म सारांश:',
      'Step': 'पायरी',

      // Crop recommendation texts
      'recommendation_based_on': 'तुमच्या माहितीच्या आधारे',
      'recommendation_land_area': 'एकर सह',
      'recommendation_soil': 'माती आणि',
      'recommendation_irrigation': 'सिंचन, शिफारस केलेले पीक आहे',
      'recommendation_crop_loamy': 'गहू',
      'recommendation_crop_sandy': 'भुईमूग',
      'recommendation_crop_clay': 'भात',
      'recommendation_crop_default': 'मका',

      // Plan step tasks
      'plan_task_plow': 'चांगली भुसभुशीत जमीन मिळवण्यासाठी शेताची २-३ वेळा नांगरणी करा.',
      'plan_task_manure': 'प्रति एकर १०-१५ टन शेणखत टाका.',
      'plan_task_seeds': 'उत्तम परिणामांसाठी प्रमाणित बियाणे वापरा.',
      'plan_task_spacing': 'दोन ओळींमध्ये ३० सें.मी. अंतर ठेवा.',
      'plan_task_npk1': '२५ दिवसांनी एनपीके खताचा पहिला डोस द्या.',
      'plan_task_npk2': 'दुसरा डोस फुलोऱ्याच्या अवस्थेत द्यावा.',


      // Marathi translations
      'location_permission_title': 'स्थान प्रवेश',
      'location_permission_message': 'कृषी रथला स्थानिक हवामान माहिती दर्शविण्यासाठी आणि अचूक शेती शिफारसी प्रदान करण्यासाठी आपल्या स्थानावर प्रवेश आवश्यक आहे.',
      'location_permission_allow': 'परवानगी द्या',
      'location_permission_deny': 'नकार द्या',
      'weather_title': 'हवामान',
      'weather_loading': 'हवामान डेटा लोड होत आहे...',
      'weather_refresh': 'हवामान रीफ्रेश करा',
      'weather_humidity': 'आर्द्रता',
      'weather_wind': 'वारा वेग',
      'weather_using_default_location': 'डीफॉल्ट लोकेशन वापरत आहे',
      'home_chatbot': 'कृत्रिम बुद्धिमत्ता सहाय्यक',
      'home_weather': 'हवामान',
      'feature_coming_soon': 'लवकरच येणार आहे!',

// Chatbot translations
      'chatbot_title': 'कृषी रथ कृत्रिम बुद्धिमत्ता सहाय्यक',
      'chatbot_welcome_message': 'नमस्कार! मी तुमचा शेती सहाय्यक आहे. मला पिके, हवामान, रोग, किंमती याबद्दल विचारा किंवा विश्लेषणासाठी प्रतिमा अपलोड करा.',
      'chatbot_type_message': 'तुमचा प्रश्न टाइप करा...',
      'chatbot_send_message': 'संदेश पाठवा',
      'chatbot_upload_image': 'प्रतिमा अपलोड करा',
      'chatbot_voice_input': 'व्हॉइस इनपुट',
      'chatbot_voice_coming_soon': 'व्हॉइस इनपुट लवकरच येणार आहे!',
      'chatbot_image_uploaded': 'विश्लेषणासाठी प्रतिमा अपलोड केली',
      'chatbot_image_analysis': 'अपलोड केलेल्या प्रतिमेचे विश्लेषण करत आहे',

// Bot responses
      'chatbot_response_greeting': 'नमस्कार! मी आज तुम्हाला तुमच्या शेतीत कशी मदत करू शकतो?',
      'chatbot_response_weather': 'अचूक हवामान माहितीसाठी होम स्क्रीनवरील वेदर कार्ड तपासा. नाशिक प्रदेशासाठी, शक्यतेसह मध्यम तापमानाची अपेक्षा आहे.',
      'chatbot_response_crop': 'तुमच्या मातीच्या प्रकार आणि हंगामावर आधारित, मी गहू, तांदूळ किंवा भाज्या यासारख्या पिकांची शिफारस करतो. वैयक्तिकृत शिफारसींसाठी क्रॉप अ‍ॅडवायझरी वर जा.',
      'chatbot_response_disease': 'कीटक आणि रोग ओळखण्यासाठी, रोपांच्या प्रतिमा स्कॅन करण्यासाठी पेस्ट डिटेक्शन फीचर वापरा. बुरशीजन्य संसर्ग आणि कीटकांचे नुकसान यासारख्या सामान्य समस्या आहेत.',
      'chatbot_response_price': 'चालू दरांसाठी मार्केट प्राइस तपासा. नाशिक मार्केटमध्ये गहू २,१००-२,३०० रुपये प्रति क्विंटल या दराने आहे.',
      'chatbot_response_soil': 'बहुतेक पिकांसाठी चिकणमाती सर्वोत्तम असते. चांगल्या उत्पादनासाठी मातीची चाचणी करा आणि कंपोस्ट खत वापरा.',
      'chatbot_response_fertilizer': 'संतुलित एनपीके खते वापरा. गव्हासाठी: एन:पी:के १२०:६०:४० किलो/हेक्टर. वापरापूर्वी नेहमी मातीची चाचणी करा.',
      'chatbot_response_irrigation': 'ड्रिप सिंचनाने ३०-५०% पाणी वाचते. पाण्याची आवश्यकता पिकाच्या टप्प्यानुसार आणि हंगामानुसार बदलते.',
      'chatbot_response_default': 'मला समजले आहे की आपण शेतीबद्दल विचारत आहात. तपशीलवार मदतीसाठी, आमची विशेष फीचर्स वापरा: क्रॉप अ‍ॅडवायझरी, पेस्ट डिटेक्शन, किंवा मार्केट प्राइस.',
    },
  };

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  String translate(String key) {
    // Falls back to the key itself if a translation is not found
    return _translations[_locale.languageCode]?[key] ?? key;
  }
}

// Global instance of the service
final localizationService = LocalizationService();