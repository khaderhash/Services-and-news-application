import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app11/core/services/api_service.dart';

import '../../../core/data/models/apis/beneficiary_model.dart';

class BeneficiaryController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = true.obs;
  var isUpdateMode = false.obs;
  var existingBeneficiary = Rxn<BeneficiaryModel>();

  var dropdownValues = <String, String?>{
    'gender': null,
    'livingStatus': null,
    'residenceType': null,
    'maritalStatus': null,
    'weaknesses_disabilities': null,
    'education': null,
  }.obs;
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final prevAddressCtrl = TextEditingController();
  final currentAddressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final birthDateCtrl = TextEditingController();
  final jobCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final familyMembersCtrl = TextEditingController();

  final livingStatusList = [
    "نازح داخلي",
    "عائد",
    "لاجئ",
    "أفراد مجتمع متضررين",
    "مستضاف",
    "غير ذلك",
  ];
  final residenceTypeList = [
    "ملك",
    "استئجار",
    "استضافة",
    "مركز إيواء اجتماعي",
    "مخيم",
    "غير ذلك",
  ];
  final genderList = ["ذكر", "أنثى"];
  final maritalStatusList = ["أعزب", "متزوج", "مطلق", "أرمل", "الزوج مفقود"];
  final disabilityList = ["سليم", "ذو أعاقة", "مرض مزمن"];
  final educationList = ["ابتدائية", "اعدادية", "ثانوية", "جامعية", "غير ذلك"];

  @override
  void onInit() {
    super.onInit();
    checkUserBeneficiaryStatus();
  }

  Future<void> checkUserBeneficiaryStatus() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getBeneficiary();
      isUpdateMode.value = true;
      populateForm(BeneficiaryModel.fromJson(response.data));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        isUpdateMode.value = false;
        setInitialFormValues();
        print("User has no beneficiary data. Entering create mode.");
      } else {
        Get.snackbar('خطأ', 'فشل في جلب البيانات');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void setInitialFormValues() {
    dropdownValues['gender'] = genderList.first;
    dropdownValues['livingStatus'] = livingStatusList.first;
    dropdownValues['residenceType'] = residenceTypeList.first;
    dropdownValues['maritalStatus'] = maritalStatusList.first;
    dropdownValues['weaknesses_disabilities'] = disabilityList.first;
    dropdownValues['education'] = educationList.first;
    dropdownValues.refresh();
  }

  void populateForm(BeneficiaryModel data) {
    nameCtrl.text = data.fullName;
    emailCtrl.text = data.email;
    prevAddressCtrl.text = data.previousAddress;
    currentAddressCtrl.text = data.currentAddress;
    phoneCtrl.text = data.phoneNumber;
    birthDateCtrl.text = data.birthDate;
    jobCtrl.text = data.job;
    notesCtrl.text = data.notes ?? '';
    familyMembersCtrl.text = data.familyMembers.toString();

    dropdownValues['gender'] =
        _mapApiToApp('gender', data.gender) ?? genderList.first;
    dropdownValues['livingStatus'] =
        _mapApiToApp('living_status', data.livingStatus) ??
        livingStatusList.first;
    dropdownValues['maritalStatus'] =
        _mapApiToApp('marital_status', data.maritalStatus) ??
        maritalStatusList.first;
    dropdownValues['weaknesses_disabilities'] =
        _mapApiToApp('weaknesses_disabilities', data.weaknessesDisabilities) ??
        disabilityList.first;
    dropdownValues['residenceType'] =
        _mapApiToApp('residence_type', data.residenceType) ??
        residenceTypeList.first;
    dropdownValues['education'] =
        _mapApiToApp('education', data.education) ?? educationList.first;
    dropdownValues.refresh();
  }

  void updateDropdownValue(String key, String? value) {
    dropdownValues[key] = value;
  }

  void pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      birthDateCtrl.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  void submitForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Map<String, dynamic> formData = {
      "full_name": nameCtrl.text,
      "email": emailCtrl.text,
      "previous_address": prevAddressCtrl.text,
      "current_address": currentAddressCtrl.text,
      "phone_number": phoneCtrl.text,
      "birth_date": birthDateCtrl.text,
      "job": jobCtrl.text,
      "notes": notesCtrl.text,
      "family_members": int.tryParse(familyMembersCtrl.text) ?? 0,

      "gender": _mapAppToApi('gender', dropdownValues['gender']),
      "living_status": _mapAppToApi(
        'living_status',
        dropdownValues['livingStatus'],
      ),
      "marital_status": _mapAppToApi(
        'marital_status',
        dropdownValues['maritalStatus'],
      ),
      "weaknesses_disabilities": _mapAppToApi(
        'weaknesses_disabilities',
        dropdownValues['weaknesses_disabilities'],
      ),
      "residence_type": _mapAppToApi(
        'residence_type',
        dropdownValues['residenceType'],
      ),
      "education": _mapAppToApi('education', dropdownValues['education']),
    };

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      if (isUpdateMode.value) {
        await _apiService.updateBeneficiary(formData);
      } else {
        await _apiService.createBeneficiary(formData);
      }
      Get.back();
      Get.snackbar(
        'نجاح',
        isUpdateMode.value ? 'تم تحديث البيانات' : 'تم إرسال البيانات',
      );
      checkUserBeneficiaryStatus();
    } on DioException catch (e) {
      Get.back();
      Get.snackbar('خطأ', 'فشلت العملية');
    }
  }

  String? _mapAppToApi(String field, String? value) {
    if (value == null) return null;
    const Map<String, Map<String, String>> mapping = {
      'gender': {"ذكر": "male", "أنثى": "female"},
      'living_status': {
        "نازح داخلي": "idp",
        "عائد": "returnee",
        "لاجئ": "refugee",
        "أفراد مجتمع متضررين": "affected_community",
        "مستضاف": "hosted",
        "غير ذلك": "other",
      },
      'residence_type': {
        "ملك": "owned",
        "استئجار": "rented",
        "استضافة": "hosted",
        "مركز إيواء اجتماعي": "shelter_center",
        "مخيم": "camp",
        "غير ذلك": "other",
      },
      'marital_status': {
        "أعزب": "single",
        "متزوج": "married",
        "مطلق": "divorced",
        "أرمل": "widowed",
        "الزوج مفقود": "husband_missing",
      },
      'weaknesses_disabilities': {
        "سليم": "none",
        "ذو أعاقة": "disabled",
        "مرض مزمن": "chronic_illness",
      },
      'education': {
        "ابتدائية": "primary",
        "اعدادية": "middle_school",
        "ثانوية": "high_school",
        "جامعية": "university",
        "غير ذلك": "other",
      },
    };
    return mapping[field]?[value] ?? value;
  }

  String? _mapApiToApp(String field, String? value) {
    if (value == null) return null;
    const Map<String, Map<String, String>> mapping = {
      'gender': {"male": "ذكر", "female": "أنثى"},
      'living_status': {
        "idp": "نازح داخلي",
        "returnee": "عائد",
        "refugee": "لاجئ",
        "affected_community": "أفراد مجتمع متضررين",
        "hosted": "مستضاف",
        "other": "غير ذلك",
      },
      'residence_type': {
        "owned": "ملك",
        "rented": "استئجار",
        "hosted": "استضافة",
        "shelter_center": "مركز إيواء اجتماعي",
        "camp": "مخيم",
        "other": "غير ذلك",
      },
      'marital_status': {
        "single": "أعزب",
        "married": "متزوج",
        "divorced": "مطلق",
        "widowed": "أرمل",
        "husband_missing": "الزوج مفقود",
      },
      'weaknesses_disabilities': {
        "none": "سليم",
        "disabled": "ذو أعاقة",
        "chronic_illness": "مرض مزمن",
      },
      'education': {
        "primary": "ابتدائية",
        "middle_school": "اعدادية",
        "high_school": "ثانوية",
        "university": "جامعية",
        "other": "غير ذلك",
      },
    };
    return mapping[field]?[value] ?? value;
  }
}
