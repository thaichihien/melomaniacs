import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:melomaniacs/components/button.dart';
import 'package:melomaniacs/utils/utils.dart';
import 'package:melomaniacs/viewmodels/main_viewmodel.dart';
import 'package:melomaniacs/viewmodels/post_view_model.dart';
import 'package:melomaniacs/views/search_song_screen.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';

class PostScreen extends StatefulWidget {
  final Uint8List? createdLyricsCard;
  const PostScreen({super.key, this.createdLyricsCard});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Uint8List> images = [];
  late final TextEditingController _captionController;
  late final PostViewModel _postViewModel;

  

  selectImage() async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Select Image"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(16),
                child: const Text("Take a Photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var file = await pickImage(ImageSource.camera);
                  if (file != null) {
                    setState(() {
                      images.add(file);
                    });
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(16),
                child: const Text("Select from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var file = await pickImage(ImageSource.gallery);
                  if (file != null) {
                    setState(() {
                      images.add(file);
                    });
                  }
                },
              )
            ],
          );
        });
  }

  void post({required String avatar, required String username}) async {
    var (success, message) = await _postViewModel.createPost(
        avatar: avatar,
        username: username,
        caption: _captionController.text,
        images: images);

    if (context.mounted) {
      if (success) {
        showSnakeBar(context, message);
        Navigator.of(context).pop();
      } else {
        showSnakeBar(context, message);
      }
    }
  }

  @override
  void initState() {
    _captionController = TextEditingController();
    _postViewModel = Provider.of<PostViewModel>(context, listen: false);
    if(widget.createdLyricsCard != null){
      images.add(widget.createdLyricsCard!);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MainViewModel>(context).currentUser;
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SmallButton(
                    buttonText: "POST",
                    onClick: () {
                      post(avatar: user.avatar, username: user.username);
                    }))
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _postViewModel.loading
                  ? const LinearProgressIndicator()
                  : const SizedBox(),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    user.username,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _captionController,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w100, color: primaryColor),
                    hintText: "Write your thoughts about music...",
                    border: InputBorder.none),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  itemCount: images.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(image: MemoryImage(images.elementAt(index))),
                  ),
                ),
              )
            ]),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: selectImage,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Add Images',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SearchSongScreen(),
                          ));
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.music_note),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Create Lyrics\nCard',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
        ));
  }
}
