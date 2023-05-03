// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:uscheduler/repositories/events_repository.dart' as _i3;
import 'package:uscheduler/repositories/secured_shared_preferences.dart' as _i4;
import 'package:uscheduler/repositories/shared_preferences.dart' as _i5;
import 'package:uscheduler/repositories/user_repository.dart' as _i6;
import 'package:uscheduler/view_models/home_viewmodel.dart' as _i7;
import 'package:uscheduler/view_models/login_viewmodel.dart' as _i8;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.EventsRepository>(_i3.EventsRepository());
    gh.singleton<_i4.SecuredSharedPreferencesRepo>(
        _i4.SecuredSharedPreferencesRepo());
    gh.singleton<_i5.SharedPreferencesRepo>(_i5.SharedPreferencesRepo());
    gh.singleton<_i6.UserRepository>(_i6.UserRepository());
    gh.singleton<_i7.HomeViewModel>(_i7.HomeViewModel(
      gh<_i3.EventsRepository>(),
      gh<_i4.SecuredSharedPreferencesRepo>(),
    ));
    gh.singleton<_i8.LoginViewModel>(_i8.LoginViewModel(
      gh<_i4.SecuredSharedPreferencesRepo>(),
      gh<_i6.UserRepository>(),
    ));
    return this;
  }
}
