part of 'invoice_bloc.dart';

class InvoiceState extends Equatable {
  final bool invoiceLoading;
  final bool invoiceSuccess;
  final String invoiceError;
  final List<Invoice> invoice;
  const InvoiceState(
      {this.invoiceLoading,
      this.invoiceSuccess,
      this.invoiceError,
      this.invoice});

  factory InvoiceState.empty() {
    return InvoiceState(
      invoiceLoading: false,
      invoiceSuccess: false,
      invoiceError: '',
      invoice: [],
    );
  }

  InvoiceState copyWith({
    bool invoiceLoading,
    bool invoiceSuccess,
    String invoiceError,
    List<Invoice> invoice,
  }) {
    return InvoiceState(
      invoiceLoading: invoiceLoading ?? this.invoiceLoading,
      invoiceSuccess: invoiceSuccess ?? this.invoiceSuccess,
      invoiceError: invoiceError ?? this.invoiceError,
      invoice: invoice ?? this.invoice,
    );
  }

  @override
  List<Object> get props => [
        this.invoiceLoading,
        this.invoiceSuccess,
        this.invoiceError,
        this.invoice,
      ];
}

class InvoiceInitial extends InvoiceState {}
