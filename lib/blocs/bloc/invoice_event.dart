part of 'invoice_bloc.dart';

abstract class InvoiceEvent extends Equatable {}

class NewInvoice extends InvoiceEvent {
  final String invoiceId;
  final String userId;
  final String storeId;
  final List<Invoice> invoice;
  final UserInfo userInfo;
  final Service problem;
  final List<Service> listServiceSelected;
  final total;

  NewInvoice({
    this.invoiceId,
    this.userId,
    this.storeId,
    this.invoice,
    this.problem,
    this.userInfo,
    this.listServiceSelected,
    this.total,
  });

  @override
  List<Object> get props => [invoice, invoiceId];

  Invoice toInvoice() {
    return Invoice.newInvoice(
      invoiceId: invoiceId,
      userInfo: userInfo,
      userId: userId,
      storeId: storeId,
      problem: problem,
      total: getTotalPrice(listServiceSelected).toStringAsFixed(0),
    );
  }
}
