import 'package:flutter/foundation.dart';
import '../models/user_address_model.dart';
import '../services/user_address_service.dart';

class UserAddressProvider extends ChangeNotifier {
  final UserAddressService _addressService = UserAddressService();
  bool _isLoading = false;
  List<UserAddress> _addresses = [];
  UserAddress? _selectedAddress;

  bool get isLoading => _isLoading;
  List<UserAddress> get addresses => _addresses;
  UserAddress? get selectedAddress => _selectedAddress;

  Future<void> loadUserAddresses(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _addresses = await _addressService.getUserAddresses(userId);

      // Set selected address to default if available
      if (_addresses.isNotEmpty) {
        _selectedAddress = _addresses.firstWhere(
          (address) => address.isDefault,
          orElse: () => _addresses.first,
        );
      } else {
        _selectedAddress = null;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<String> addAddress(UserAddress address) async {
    try {
      _isLoading = true;
      notifyListeners();

      final addressId = await _addressService.addUserAddress(address);
      final newAddress = UserAddress(
        id: addressId,
        userId: address.userId,
        address: address.address,
        additionalInfo: address.additionalInfo,
        latitude: address.latitude,
        longitude: address.longitude,
        isDefault: address.isDefault,
      );

      if (address.isDefault) {
        // Update all other addresses to not be default
        _addresses =
            _addresses.map((a) => a.copyWith(isDefault: false)).toList();
      }

      _addresses.add(newAddress);

      if (newAddress.isDefault || _selectedAddress == null) {
        _selectedAddress = newAddress;
      }

      _isLoading = false;
      notifyListeners();

      return addressId;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateAddress(UserAddress address) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _addressService.updateUserAddress(address);

      final index = _addresses.indexWhere((a) => a.id == address.id);
      if (index != -1) {
        if (address.isDefault) {
          // Update all addresses to not be default
          _addresses =
              _addresses.map((a) => a.copyWith(isDefault: false)).toList();
        }

        _addresses[index] = address;

        if (address.isDefault || _selectedAddress?.id == address.id) {
          _selectedAddress = address;
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _addressService.deleteUserAddress(userId, addressId);

      final index = _addresses.indexWhere((a) => a.id == addressId);
      if (index != -1) {
        final wasDefault = _addresses[index].isDefault;
        _addresses.removeAt(index);

        // If we removed the default/selected address, select a new one
        if (wasDefault || _selectedAddress?.id == addressId) {
          _selectedAddress = _addresses.isNotEmpty ? _addresses.first : null;

          // If we have addresses and removed the default, make the first one default
          if (wasDefault && _addresses.isNotEmpty) {
            final newDefault = _addresses.first.copyWith(isDefault: true);
            await _addressService.updateUserAddress(newDefault);

            final newDefaultIndex =
                _addresses.indexWhere((a) => a.id == newDefault.id);
            if (newDefaultIndex != -1) {
              _addresses[newDefaultIndex] = newDefault;
              _selectedAddress = newDefault;
            }
          }
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void selectAddress(UserAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }
}
