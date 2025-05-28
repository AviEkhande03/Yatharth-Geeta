import 'package:get/get.dart';

mixin ValidationsMixin {
  String? validatedEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the email address'.tr;
    } else if (!GetUtils.isEmail(value)) {
      return 'Please enter valid email address'.tr;
    } else {
      return null;
    }
  }

  String? validateUserOrEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter valid email or username'.tr;
    } else {
      return null;
    }
  }

  String? validatedOtp(String? value) {
    if (value == null || value.isEmpty || value.length != 6) {
      return 'Please enter the proper OTP code'.tr;
    } else {
      return null;
    }
  }

  String? validatedPassword(String? value) {
    if (value == null || value.isEmpty || value.contains(' ')) {
      return 'Please enter your password'.tr;
    } else {
      return null;
    }
  }

  String? validatedCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password'.tr;
    } else {
      return null;
    }
  }

  String? validatedRepeatPassword({
    required String currentPassword,
    required String? repeatPassword,
  }) {
    if (repeatPassword == null || repeatPassword.isEmpty) {
      return 'Please enter repeat password'.tr;
    } else if (currentPassword != repeatPassword) {
      return 'The confirm password should be same as password'.tr;
    } else {
      return null;
    }
  }

  String? validatedName(String? value) {
    RegExp pattern = RegExp(r'^[A-Za-z\s]+$');
    if (value == null ||
        value.trim() == '' ||
        value.trim().isEmpty ||
        !pattern.hasMatch(value)) {
      return 'Please enter proper name'.tr;
    } else {
      return null;
    }
  }

  String? validatedPhoneNumber(String? value, int length) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    if (value == null ||
        value.trim().length > length ||
        value.trim().isEmpty ||
        value.length < length ||
        !_numeric.hasMatch(value)) {
      return 'Please enter valid phone number'.tr;
    } else {
      return null;
    }
  }

  String? validatedDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    } else if (value.length < 3) {
      return 'Display name must be greater than 3';
    } else if (value.trim().isEmpty) {
      return 'Display name should not have spaces';
    } else {
      return null;
    }
  }

  String? validatedData(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter valid data'.tr;
    } else {
      return null;
    }
  }

  String? validatedSubject(String? value) {
    if (value == null || value.isEmpty || value.trim().length < 5) {
      return 'Subject too short'.tr;
    } else {
      return null;
    }
  }

  String? validatedDesc(String? value) {
    if (value == null || value.isEmpty || value.trim().length < 10) {
      return 'Message too short'.tr;
    } else {
      return null;
    }
  }

  String? validatedCityName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter city name'.tr;
    } else {
      return null;
    }
  }

  String? validatedPinCode(String? value) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    if (value == null ||
        value.trim().isEmpty ||
        value.length > 6 ||
        value.length < 6 ||
        !_numeric.hasMatch(value)) {
      return 'Please enter valid pincode'.tr;
    } else {
      return null;
    }
  }

  String? validatedStateName(String? value) {
    print("inside validatedStateName");
    ;
    RegExp pattern = RegExp(r'^[A-Za-z\s]+$');
    if (value == null || value.trim().isEmpty || !pattern.hasMatch(value)) {
      return 'Please enter valid State name'.tr;
    } else {
      return null;
    }
  }

  String? validatedCountryName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter country name'.tr;
    } else {
      return null;
    }
  }

  String? validatePasswordCondition(String? value) {
    const String pattern = r"^[a-zA-Z._0-9]+$";
    final bool passValid = RegExp(pattern).hasMatch(value!);
    if (value.isEmpty) {
      return 'Please set a password';
    } else if (!passValid) {
      return 'Password should not contain special characters';
    }
    return null;
  }

  String? validateTimeOfMin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    } else {
      return null;
    }
  }
}
