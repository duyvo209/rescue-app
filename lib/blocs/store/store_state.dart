part of 'store_bloc.dart';

// ignore: must_be_immutable
class StoreState extends Equatable {
  final bool storeLoading;
  final bool storeSuccess;
  final String storeError;
  List<Store> listStore = [];

  StoreState(
      {this.storeLoading, this.storeSuccess, this.storeError, this.listStore});

  factory StoreState.empty() {
    return StoreState(
      storeLoading: false,
      storeSuccess: false,
      storeError: '',
      listStore: [],
    );
  }
  StoreState copyWith({
    bool storeLoading,
    bool storeSuccess,
    String storeError,
    List<Store> listStore,
  }) {
    return StoreState(
      storeLoading: storeLoading ?? this.storeLoading,
      storeSuccess: storeSuccess ?? this.storeSuccess,
      storeError: storeError ?? this.storeError,
      listStore: listStore ?? this.listStore,
    );
  }

  @override
  List<Object> get props =>
      [this.storeLoading, this.storeSuccess, this.storeError, this.listStore];
}
