import 'package:bloc/bloc.dart';
import '../../../config/firebase_service.dart';
import '../../../models/cart.dart';

// Events
abstract class CartEvent {}

class FetchCartItems extends CartEvent {}

class RemoveCartItem extends CartEvent {
  final Cart cartItem;

  RemoveCartItem(this.cartItem);
}

// States
abstract class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Cart> cartItems;

  CartLoaded(this.cartItems);
}

class CartError extends CartState {}

class CartBloc extends Bloc<CartEvent, CartState> {
  // Initialize with loading state
  CartBloc() : super(CartLoading()) {
    on<FetchCartItems>(_onFetchCartItems);
    on<RemoveCartItem>(_onRemoveCartItem);
  }

  void _onFetchCartItems(FetchCartItems event, Emitter<CartState> emit) async {
    print("Fetching cart items..."); // Add this print statement
    try {
      List<Cart> cartItems = await FirebaseService.getCartItemsFromFirebase();
      emit(CartLoaded(cartItems));
    } catch (error) {
      emit(CartError());
      print(error.toString());
    }
  }

  void _onRemoveCartItem(RemoveCartItem event, Emitter<CartState> emit) async {
    try {
      await FirebaseService.removeCartItemFromFirebase(event.cartItem);

      // Fetch updated cart items after removing an item
      List<Cart> updatedCartItems = await FirebaseService.getCartItemsFromFirebase();

      emit(CartLoaded(updatedCartItems)); // Emit the updated state
    } catch (error) {
      emit(CartError());
    }
  }

}
