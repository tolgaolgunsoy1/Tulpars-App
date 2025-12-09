import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tulpars_app/presentation/bloc/app/app_bloc.dart';

// Mock classes
class MockBox extends Mock implements Box {}

void main() {
  late AppBloc appBloc;
  late MockBox mockSettingsBox;

  setUp(() {
    mockSettingsBox = MockBox();
    appBloc = AppBloc();
  });

  tearDown(() {
    appBloc.close();
  });

  group('AppBloc', () {
    blocTest<AppBloc, AppState>(
      'emits [AppLoading, OnboardingRequired] when AppStarted is added and onboarding not completed',
      build: () => appBloc,
      setUp: () {
        when(() => mockSettingsBox.get('onboarding_completed',
            defaultValue: false,),).thenReturn(false);
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [AppLoading(), OnboardingRequired()],
    );

    blocTest<AppBloc, AppState>(
      'emits [AppLoading, AuthenticationRequired] when AppStarted is added and onboarding completed',
      build: () => appBloc,
      setUp: () {
        when(() => mockSettingsBox.get('onboarding_completed',
            defaultValue: false,),).thenReturn(true);
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [AppLoading(), AuthenticationRequired()],
    );

    blocTest<AppBloc, AppState>(
      'emits [AppLoading, AppLoaded] when AppStarted is added and user is authenticated',
      build: () => appBloc,
      setUp: () {
        when(() => mockSettingsBox.get('onboarding_completed',
            defaultValue: false,),).thenReturn(true);
        // Mock authentication check - assume user is authenticated
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [AppLoading(), AppLoaded()],
    );
  });
}
