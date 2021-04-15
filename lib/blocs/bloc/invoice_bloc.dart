import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rescue/models/Invoice.dart';
import 'package:rescue/models/Service.dart';
import 'package:rescue/models/UserInfo.dart';
import 'package:rescue/screens/store/ConfirmScreen.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(InvoiceState.empty());

  @override
  Stream<InvoiceState> mapEventToState(
    InvoiceEvent event,
  ) async* {
    if (event is NewInvoice) {
      try {
        yield state.copyWith(
          invoiceLoading: true,
          invoiceSuccess: true,
          invoiceError: '',
        );
        await FirebaseFirestore.instance
            .collection('invoice')
            .doc()
            .set(event.toInvoice().toMap());
        yield state.copyWith(invoiceLoading: false, invoiceSuccess: true);
      } catch (e) {
        yield state.copyWith(
          invoiceLoading: false,
          invoiceSuccess: false,
          invoiceError: e.toString(),
        );
      }
    }
  }
}
