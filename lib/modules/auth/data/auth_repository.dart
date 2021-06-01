import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/constants/enums/payment_account_type.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/crypto/password_hasher.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/auth/data/util/userDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationRepository {
  final CollectionReference _userCredentialClient;
  final CollectionReference _paymentCredentialClient;

  AuthenticationRepository(this._userCredentialClient, this._paymentCredentialClient);

  Future<DMTaskState> login(String username, String password, UserType userType) async {
    try {
      return await _userCredentialClient
          .where('type', isEqualTo: userType.toStringValue())
          .where('username', isEqualTo: username.trim())
          .limit(1)
          .get()
          .then((value) async {
        final userData = value.docs;
        final List<User> userList = userData.map((e) => User.fromDocument(e)).toList();
        print(userList);
        if (userList == null || userList.isEmpty) {
          return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: "User with $username does not exist"));
        } else if (PasswordHashManager.verifyPassword(hashedPasswordFromServer: userList.first.hashedPassword, unHashedPassword: password)) {
          if (userList.first.isEnrolled) {
            await SharedPrefRepository.setUserType(userList.first.accountType);
            await SharedPrefRepository.setUsername(username.trim());
            await SharedPrefRepository.setTheUserId(userList.first.userId);
            return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
          } else {
            return DMTaskState(
                isTaskSuccess: false,
                taskResultData: null,
                error: DMError(message: "Your account has been disabled by the admin ☹...Please contact mess coordinator"));
          }
        } else {
          return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: "Incorrect password for $username"));
        }
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> register(UserDetails userCredentials) async {
    try {
      final String hashedPassword = PasswordHashManager.hashPassword(userCredentials.unhashedPassword);
      return await _userCredentialClient
          .add(User(
                  username: userCredentials.username,
                  hashedPassword: hashedPassword,
                  accountType: userCredentials.accountType,
                  isEnrolled: userCredentials.isEnrolled,
                  cautionDepositAmount: userCredentials.cautionDepositAmount,
                  name: userCredentials.name,
                  yearOfAdmission: userCredentials.yearOfAdmission,
                  yearOfCompletion: userCredentials.yearOfCompletion,
                  branch: userCredentials.branch,
                  dob: userCredentials.dob,
                  phoneNumber: userCredentials.phoneNumber,
                  email: userCredentials.email,
                  isVeg: userCredentials.isVeg)
              .toMap())
          .then((userRef) async {
        final Payment paymentWithUserRef = Payment(
            description: "Caution Deposit",
            user: userRef,
            paymentDate: DateTime.now(),
            paymentId: "",
            paymentAccountType: PaymentAccountType.CARD,
            paymentAmount: DMDetails.constantMessCaution);
        return await _paymentCredentialClient.add(paymentWithUserRef.toMap()).then((value) async {
          await SharedPrefRepository.setUserType(UserType.STUDENT);
          await SharedPrefRepository.setUsername(userCredentials.username.trim());
          await SharedPrefRepository.setTheUserId(userRef.id);
          return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
        }).onError((error, stackTrace) {
          print(stackTrace.toString());
          return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
        });
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> usernameAvailableCheck(username) async {
    try {
      return await _userCredentialClient
          .where('type', isEqualTo: UserType.STUDENT.toStringValue())
          .where('username', isEqualTo: username.trim())
          .get()
          .then((value) async {
        final userData = value.docs;
        if (userData == null || userData.isEmpty) {
          return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
        } else {
          return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: "User with $username already exist"));
        }
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
