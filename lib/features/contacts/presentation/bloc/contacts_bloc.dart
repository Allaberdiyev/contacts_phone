import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/contacts_model.dart';
import '../../data/repositories/contacts_repositorie.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactsRepositorie repository;

  ContactBloc(this.repository) : super(ContactInitial()) {
    on<SaveContactEvent>(_onSaveContact);
  }

  Future<void> _onSaveContact(
    SaveContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    emit(ContactLoading());

    try {
      final isEdit = event.oldContact != null;

      final contact = ContactsModel(
        id: isEdit
            ? event.oldContact!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phone,
        imageUrl: isEdit ? event.oldContact!.imageUrl : '',
      );

      if (isEdit) {
        await repository.updateContact(
          contact: contact,
          imageFile: event.imageFile,
        );
      } else {
        await repository.addContact(
          contact: contact,
          imageFile: event.imageFile,
        );
      }

      emit(ContactSuccess());
    } catch (e) {
      emit(ContactError('Error. Save contact'));
    }
  }
}
