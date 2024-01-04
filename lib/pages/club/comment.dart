import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';

import '../../models/club/newfeed.dart';
import '../../models/data/menu_item.dart';
import '../../models/data/menu_items.dart';
import '../../utils/api_url.dart';
import '../../utils/colors.dart';

class CommentsWidget extends StatefulWidget {
  const CommentsWidget({
    super.key,
    required this.comments,
    required this.userId,
    required this.postId,
  });

  final List<Comment> comments;
  final String postId;
  final String userId;

  @override
  State<CommentsWidget> createState() => _CommentsState();
}

class _CommentsState extends State<CommentsWidget> {
  TextEditingController? userCommentController;

  final ScrollController _controller = ScrollController();
  final GlobalKey<FormState> _userCommentKey = GlobalKey<FormState>();

  @override
  void dispose() {
    userCommentController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userCommentController = TextEditingController();
  }

  Future<bool> userComment(
      String postId, String userId, String userComment) async {
    final response = await http.post(
      Uri.parse("$currentApi/comment/store"),
      body: {
        'post_id': postId,
        'user_id': userId,
        'comment': userComment,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.60,
                child: ListView.builder(
                  itemCount: widget.comments.length,
                  physics: const BouncingScrollPhysics(),
                  controller: _controller,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return StatefulBuilder(
                      builder: (context, setState) => CommentTile(
                        commentsModel: widget.comments,
                        userId: widget.userId,
                        postId: widget.postId,
                        index: index,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Form(
                      key: _userCommentKey,
                      child: TextFormField(
                        controller: userCommentController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'แสดงความคิดเห็น',
                          labelStyle: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3F3F3),
                          suffixIcon: const Icon(
                            Icons.keyboard,
                            color: Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                        style: GoogleFonts.sarabun(),
                        validator: MultiValidator([
                          RequiredValidator(
                            errorText: "ไม่สามารถค่าว่างได้",
                          ),
                        ]),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_userCommentKey.currentState?.validate() ?? false) {
                        userComment(
                          widget.postId,
                          widget.userId,
                          userCommentController!.text,
                        ).then((value) {
                          if (value == false) {
                            Fluttertoast.showToast(
                              msg:
                                  "ดูเหมือนมีอะไรผิดพลาด กรุณาลองอีกครั้งในภายหลัง",
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.black,
                            );
                          } else {
                            Get.offAllNamed('/home')!
                                .then((value) => setState(() {}));
                          }
                        });
                        // print(userCommentController);
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: darkGray,
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
}

class CommentTile extends StatefulWidget {
  const CommentTile({
    super.key,
    required this.commentsModel,
    required this.userId,
    required this.postId,
    required this.index,
  });

  final List<Comment> commentsModel;
  final int index;
  final String postId;
  final String userId;

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool isReadMore = false;
  var maxLine = 2;
  TextEditingController editCommentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    editCommentController = TextEditingController();
  }

  @override
  void dispose() {
    editCommentController.dispose();
    super.dispose();
  }

  PopupMenuItem<CustomMenuItem> buildItem(CustomMenuItem item) =>
      PopupMenuItem<CustomMenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(
              item.icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              item.text,
              style: GoogleFonts.sarabun(),
            ),
          ],
        ),
      );

  void onSelected(
    BuildContext context,
    CustomMenuItem item,
    String userId,
    String ownerId,
    String commentId,
    String postId,
    String? comment,
  ) {
    if (userId == ownerId) {
      switch (item) {
        case CommentMenuItems.itemEdit:
          showFormDialog(comment, postId, commentId, ownerId);
          // print('tapped edit comment!!');
          // print('edit comment : $comment');
          // print('userId is : $userId\ncomment ownerId is : $ownerId');
          break;
        case CommentMenuItems.itemDelete:
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("ต้องการลบคอมเม้นนี้หรือไม่?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (userId == ownerId) {
                      deleteComment(commentId);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('ลบคอมเม้น'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ยกเลิก'),
                ),
              ],
              elevation: 24,
            ),
          );
          break;
      }
    }
  }

  void deleteComment(String commentId) async {
    var url = Uri.parse('$currentApi/comment/destroy/$commentId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      Get.offAllNamed('/home')!.then((value) => setState(() {}));

      Fluttertoast.showToast(
        msg: "คุณได้ลบคอมเม้นนี้แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void editComment(
    String commentId,
    String postId,
    String ownerId,
    String comment,
  ) async {
    var url = Uri.parse('$currentApi/comment/update/$commentId');

    final response = await http.post(
      url,
      body: {
        'post_id': postId,
        'user_id': ownerId,
        'comment': comment,
      },
    );

    if (response.statusCode == 200) {
      Get.offAllNamed('/home')!.then((value) => setState(() {}));

      Fluttertoast.showToast(
        msg: "คุณได้แก้ไขโพสต์แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void showFormDialog(
    String? comment,
    String postId,
    String commentId,
    String ownerId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text(
                'แก้ไขคอมเม้น',
                textAlign: TextAlign.center,
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: editCommentController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          validator: MultiValidator([
                            RequiredValidator(
                              errorText: "กรุณาใส่ข้อความด้วย",
                            ),
                          ]),
                          decoration: const InputDecoration(
                            label: Text('พูดคุยว่าอะไรดีนะ?'),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Color(0xffffffff),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: mainGreen,
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: whiteGreen, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffEF4444), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainGreen, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: lightGrey,
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width / 3.5,
                                  40,
                                ),
                              ),
                              child: Text(
                                'ยกเลิก',
                                style: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  // next

                                  editComment(
                                    commentId,
                                    postId,
                                    ownerId,
                                    editCommentController.text,
                                  );

                                  Get.back();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainGreen,
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width / 3.5,
                                  40,
                                ),
                              ),
                              child: Text(
                                'แก้ไข',
                                style: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        dense: true,
        titleAlignment: ListTileTitleAlignment.center,
        contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
        leading: Container(
          width: 50,
          height: 50,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CachedNetworkImage(
            imageUrl: widget
                .commentsModel[(widget.commentsModel.length - 1) - widget.index]
                .ownerAvatar,
          ),
        ),
        title: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget
                        .commentsModel[
                            (widget.commentsModel.length - 1) - widget.index]
                        .owner,
                    style: GoogleFonts.sarabun(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PopupMenuButton<CustomMenuItem>(
                onSelected: (item) => onSelected(
                  context,
                  item,
                  widget.userId,
                  widget
                      .commentsModel[
                          (widget.commentsModel.length - 1) - widget.index]
                      .userId,
                  widget
                      .commentsModel[
                          (widget.commentsModel.length - 1) - widget.index]
                      .id,
                  widget.postId,
                  widget
                      .commentsModel[
                          (widget.commentsModel.length - 1) - widget.index]
                      .comment!,
                ),
                enabled: widget.userId ==
                    widget
                        .commentsModel[
                            (widget.commentsModel.length - 1) - widget.index]
                        .userId,
                itemBuilder: (context) => [
                  ...CommentMenuItems.itemsFirst.map(buildItem).toList(),
                  const PopupMenuDivider(),
                  ...CommentMenuItems.itemsSecond.map(buildItem).toList(),
                ],
                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        subtitle: ReadMoreText(
          widget.commentsModel[(widget.commentsModel.length - 1) - widget.index]
              .comment!,
          trimLines: 3,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' ดูเพิ่มเติม',
          trimExpandedText: ' ย่อลง',
          style: GoogleFonts.sarabun(
            fontSize: 15,
            color: Colors.black,
            // fontWeight: FontWeight.bold,
          ),
          moreStyle:
              GoogleFonts.sarabun(fontSize: 14, fontWeight: FontWeight.bold),
          lessStyle:
              GoogleFonts.sarabun(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
