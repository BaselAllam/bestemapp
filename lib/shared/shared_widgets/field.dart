import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



Container authField({
  required String title, required String inputTitle, required TextStyle inputStyle, required Color fillColor, bool enabled = true, required TextInputAction textInputAction, required TextInputType keyBoardType, required List<TextInputFormatter> formaters, bool obsecure = false,
  required TextEditingController controller, Widget suffix = const SizedBox(), bool border = true, Function? validatorMethod
  }) {
  return Container(
    margin: EdgeInsets.only(top: 15.0),
    child: ListTile(
      title: Text(title, style: AppFonts.subFontBlackColor),
      subtitle: Container(
        padding: EdgeInsets.only(top: 10.0),
        child: customField(inputTitle: inputTitle, inputStyle: inputStyle, fillColor: fillColor, textInputAction: textInputAction, keyBoardType: keyBoardType, formaters: formaters, controller: controller, suffix: suffix, enabled: enabled, border: border, validatorMethod: validatorMethod, obsecure: obsecure),
      ),
    ),
  );
}


Container otherField({
  required String inputTitle, required TextStyle inputStyle, required Color fillColor, bool enabled = true, required TextInputAction textInputAction, required TextInputType keyBoardType, required List<TextInputFormatter> formaters, bool obsecure = false,
  required TextEditingController controller, Widget suffix = const SizedBox(), required Size size, EdgeInsets margin = const EdgeInsets.all(10.0), Function? validatorMethod, bool border = true,
  }) {
  return Container(
    height: size.height,
    width: size.width,
    margin: margin,
    child: customField(inputTitle: inputTitle, inputStyle: inputStyle, fillColor: fillColor, textInputAction: textInputAction, keyBoardType: keyBoardType, formaters: formaters, controller: controller, suffix: suffix, enabled: enabled, border: border, validatorMethod: validatorMethod),
  );
}


DecoratedBox customField({required String inputTitle, required TextStyle inputStyle, required Color fillColor, bool enabled = true, required TextInputAction textInputAction, required TextInputType keyBoardType,
required List<TextInputFormatter> formaters, bool obsecure = false, required TextEditingController controller, Widget suffix = const SizedBox(), bool border = true, Function? validatorMethod, bool isExpanded = false,
Function(String)? onFieldSubmitted}) {
  bool showBorder = true;
  int? maxLine = null;
  if (obsecure) {
    maxLine = 1;
  }
  if (!enabled || !border) {
    showBorder = false;
  }
  return DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: AppColors.whiteColor
    ),
    child: TextFormField(
      decoration: InputDecoration(
        border: showBorder ? inputBorder(AppColors.whiteColor) : InputBorder.none,
        enabledBorder: showBorder ? inputBorder(AppColors.whiteColor) : InputBorder.none,
        disabledBorder: showBorder ? inputBorder(AppColors.whiteColor) : InputBorder.none,
        focusedBorder: showBorder ? inputBorder(AppColors.whiteColor) : InputBorder.none,
        focusedErrorBorder: showBorder ? inputBorder(AppColors.redColor) : InputBorder.none,
        errorBorder: showBorder ? inputBorder(AppColors.redColor) : InputBorder.none,
        hintText: inputTitle,
        hintStyle: inputStyle,
        fillColor: fillColor,
        enabled: enabled,
        suffixIcon: suffix,
      ),
      expands: isExpanded,
      minLines: null,
      maxLines: maxLine,
      textInputAction: textInputAction,
      keyboardType: keyBoardType,
      enabled: enabled,
      controller: controller,
      inputFormatters: formaters,
      obscureText: obsecure,
      onFieldSubmitted: onFieldSubmitted,
    ),
  );
}


OutlineInputBorder inputBorder(Color color) {
  return OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: color, width: 0.5));
}



dynamic bottomSheet({required BuildContext context, required Widget child, required double minHeight, required double maxHeight}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).viewInsets.bottom > 0 ? maxHeight : minHeight,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
        ),
        child: child
      );
    }
  );
}