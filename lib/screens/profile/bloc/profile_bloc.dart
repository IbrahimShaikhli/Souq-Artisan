import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

// Events
abstract class ProfileEvent {}

class ImageSelectedEvent extends ProfileEvent {
  final XFile selectedImage;

  ImageSelectedEvent(this.selectedImage);
}

// States
abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ImageUploadSuccessState extends ProfileState {
  final String downloadURL;

  ImageUploadSuccessState(this.downloadURL);
}

class ImageUploadErrorState extends ProfileState {
  final String error;

  ImageUploadErrorState(this.error);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProfileBloc() : super(ProfileLoading()) {
    on<ImageSelectedEvent>(_onImageSelected);
  }

  void _onImageSelected(ImageSelectedEvent event, Emitter<ProfileState> emit) async {
    try {
      final user = _auth.currentUser;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users/${user!.uid}/profile_picture/image.jpg');

      final uploadTask = storageRef.putFile(File(event.selectedImage.path));
      final snapshot = await uploadTask.whenComplete(() {});

      if (snapshot.state == TaskState.success) {
        final downloadURL = await snapshot.ref.getDownloadURL();
        emit(ImageUploadSuccessState(downloadURL));
      } else {
        emit(ImageUploadErrorState("Image upload failed."));
      }
    } catch (e) {
      emit(ImageUploadErrorState(e.toString()));
    }
  }
}
