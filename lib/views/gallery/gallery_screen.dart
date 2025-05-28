import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../const/colors/colors.dart';
import '../../controllers/gallery/gallery_controller.dart';
import '../../widgets/common/custom_app_bar.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GalleryController controller = Get.find<GalleryController>();
    return Container(
      color: kColorWhite,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              CustomAppBar(
                title: 'Gallery'.tr,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 24.w, right: 24.w, top: 24.h, bottom: 40.h),
                    child: StaggeredGrid.count(
                      axisDirection: AxisDirection.down,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                      children: controller.galleryImages
                          .map((e) => FutureBuilder(
                              future: controller.isLandscape(Image.network(
                                e!,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      "assets/icons/default.png");
                                },
                              )),
                              builder: (context, snapshot) {
                                return StaggeredGridTile.count(
                                  // mainAxisExtent: 1,
                                  // mainAxisCellCount: 1,
                                  crossAxisCellCount: snapshot.hasData
                                      ? snapshot.data!
                                          ? 2
                                          : 1
                                      : 1,
                                  mainAxisCellCount: 1,
                                  child: Container(
                                    // width: snapshot.hasData
                                    //     ? snapshot.data!
                                    //         ? width
                                    //         : width / 2
                                    //     : width / 2,
                                    margin: EdgeInsets.zero,
                                    // width: snapshot.hasData
                                    //     ? snapshot.data!
                                    //         ? width
                                    //         : width / 2
                                    //     : width / 2,
                                    child: FadeInImage(
                                      image: NetworkImage(e),
                                      fit: BoxFit.fill,
                                      placeholderFit: BoxFit.scaleDown,
                                      placeholder: const AssetImage(
                                          "assets/icons/default.png"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            "assets/icons/default.png");
                                      },
                                    ),
                                    // child: Image.asset(
                                    //   e,
                                    //   // width: snapshot.hasData
                                    //   //     ? snapshot.data!
                                    //   //         ? width / 2
                                    //   //         : width
                                    //   //     : width / 2,
                                    //   fit: BoxFit.fill,
                                    // ),
                                  ),
                                );
                              }))
                          .toList(),
                    ),
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
