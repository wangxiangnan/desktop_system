// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthLoginRequested value)?  loginRequested,TResult Function( AuthLogoutRequested value)?  logoutRequested,TResult Function( AuthCheckRequested value)?  checkRequested,TResult Function( AuthCaptchaRequested value)?  captchaRequested,TResult Function( AuthCopyrightRequested value)?  copyrightRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthLoginRequested() when loginRequested != null:
return loginRequested(_that);case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case AuthCheckRequested() when checkRequested != null:
return checkRequested(_that);case AuthCaptchaRequested() when captchaRequested != null:
return captchaRequested(_that);case AuthCopyrightRequested() when copyrightRequested != null:
return copyrightRequested(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthLoginRequested value)  loginRequested,required TResult Function( AuthLogoutRequested value)  logoutRequested,required TResult Function( AuthCheckRequested value)  checkRequested,required TResult Function( AuthCaptchaRequested value)  captchaRequested,required TResult Function( AuthCopyrightRequested value)  copyrightRequested,}){
final _that = this;
switch (_that) {
case AuthLoginRequested():
return loginRequested(_that);case AuthLogoutRequested():
return logoutRequested(_that);case AuthCheckRequested():
return checkRequested(_that);case AuthCaptchaRequested():
return captchaRequested(_that);case AuthCopyrightRequested():
return copyrightRequested(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthLoginRequested value)?  loginRequested,TResult? Function( AuthLogoutRequested value)?  logoutRequested,TResult? Function( AuthCheckRequested value)?  checkRequested,TResult? Function( AuthCaptchaRequested value)?  captchaRequested,TResult? Function( AuthCopyrightRequested value)?  copyrightRequested,}){
final _that = this;
switch (_that) {
case AuthLoginRequested() when loginRequested != null:
return loginRequested(_that);case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case AuthCheckRequested() when checkRequested != null:
return checkRequested(_that);case AuthCaptchaRequested() when captchaRequested != null:
return captchaRequested(_that);case AuthCopyrightRequested() when copyrightRequested != null:
return copyrightRequested(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String username,  String password,  String code,  String uuid)?  loginRequested,TResult Function()?  logoutRequested,TResult Function()?  checkRequested,TResult Function()?  captchaRequested,TResult Function()?  copyrightRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthLoginRequested() when loginRequested != null:
return loginRequested(_that.username,_that.password,_that.code,_that.uuid);case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested();case AuthCheckRequested() when checkRequested != null:
return checkRequested();case AuthCaptchaRequested() when captchaRequested != null:
return captchaRequested();case AuthCopyrightRequested() when copyrightRequested != null:
return copyrightRequested();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String username,  String password,  String code,  String uuid)  loginRequested,required TResult Function()  logoutRequested,required TResult Function()  checkRequested,required TResult Function()  captchaRequested,required TResult Function()  copyrightRequested,}) {final _that = this;
switch (_that) {
case AuthLoginRequested():
return loginRequested(_that.username,_that.password,_that.code,_that.uuid);case AuthLogoutRequested():
return logoutRequested();case AuthCheckRequested():
return checkRequested();case AuthCaptchaRequested():
return captchaRequested();case AuthCopyrightRequested():
return copyrightRequested();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String username,  String password,  String code,  String uuid)?  loginRequested,TResult? Function()?  logoutRequested,TResult? Function()?  checkRequested,TResult? Function()?  captchaRequested,TResult? Function()?  copyrightRequested,}) {final _that = this;
switch (_that) {
case AuthLoginRequested() when loginRequested != null:
return loginRequested(_that.username,_that.password,_that.code,_that.uuid);case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested();case AuthCheckRequested() when checkRequested != null:
return checkRequested();case AuthCaptchaRequested() when captchaRequested != null:
return captchaRequested();case AuthCopyrightRequested() when copyrightRequested != null:
return copyrightRequested();case _:
  return null;

}
}

}

/// @nodoc


class AuthLoginRequested implements AuthEvent {
  const AuthLoginRequested({required this.username, required this.password, required this.code, required this.uuid});
  

 final  String username;
 final  String password;
 final  String code;
 final  String uuid;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthLoginRequestedCopyWith<AuthLoginRequested> get copyWith => _$AuthLoginRequestedCopyWithImpl<AuthLoginRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLoginRequested&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.code, code) || other.code == code)&&(identical(other.uuid, uuid) || other.uuid == uuid));
}


@override
int get hashCode => Object.hash(runtimeType,username,password,code,uuid);

@override
String toString() {
  return 'AuthEvent.loginRequested(username: $username, password: $password, code: $code, uuid: $uuid)';
}


}

/// @nodoc
abstract mixin class $AuthLoginRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthLoginRequestedCopyWith(AuthLoginRequested value, $Res Function(AuthLoginRequested) _then) = _$AuthLoginRequestedCopyWithImpl;
@useResult
$Res call({
 String username, String password, String code, String uuid
});




}
/// @nodoc
class _$AuthLoginRequestedCopyWithImpl<$Res>
    implements $AuthLoginRequestedCopyWith<$Res> {
  _$AuthLoginRequestedCopyWithImpl(this._self, this._then);

  final AuthLoginRequested _self;
  final $Res Function(AuthLoginRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = null,Object? code = null,Object? uuid = null,}) {
  return _then(AuthLoginRequested(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthLogoutRequested implements AuthEvent {
  const AuthLogoutRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLogoutRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logoutRequested()';
}


}




/// @nodoc


class AuthCheckRequested implements AuthEvent {
  const AuthCheckRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthCheckRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.checkRequested()';
}


}




/// @nodoc


class AuthCaptchaRequested implements AuthEvent {
  const AuthCaptchaRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthCaptchaRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.captchaRequested()';
}


}




/// @nodoc


class AuthCopyrightRequested implements AuthEvent {
  const AuthCopyrightRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthCopyrightRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.copyrightRequested()';
}


}




// dart format on
