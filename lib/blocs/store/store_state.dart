part of 'store_bloc.dart';

// ignore: must_be_immutable
class StoreState extends Equatable {
  final bool storeLoading;
  final bool storeSuccess;
  final String storeError;
  final Store store;
  List<Store> listStore = [];
  List<Service> listService;

  StoreState(
      {this.storeLoading,
      this.storeSuccess,
      this.storeError,
      this.listStore,
      this.listService,
      this.store});

  factory StoreState.empty() {
    return StoreState(
      storeLoading: false,
      storeSuccess: false,
      storeError: '',
      listStore: [],
      listService: [],
      store: null,
    );
  }
  StoreState copyWith({
    bool storeLoading,
    bool storeSuccess,
    String storeError,
    List<Store> listStore,
    Store store,
  }) {
    return StoreState(
      storeLoading: storeLoading ?? this.storeLoading,
      storeSuccess: storeSuccess ?? this.storeSuccess,
      storeError: storeError ?? this.storeError,
      listStore: listStore ?? this.listStore,
      store: store ?? this.store,
    );
  }

  StoreState copyWithService(List<Service> service) {
    return StoreState(listService: listService ?? this.listService);
  }

  @override
  List<Object> get props => [
        this.storeLoading,
        this.storeSuccess,
        this.storeError,
        this.listStore,
        this.listService
      ];
}
