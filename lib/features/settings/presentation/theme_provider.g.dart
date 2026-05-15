// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveTheme)
final activeThemeProvider = ActiveThemeProvider._();

final class ActiveThemeProvider
    extends $NotifierProvider<ActiveTheme, OdoTheme> {
  ActiveThemeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'activeThemeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activeThemeHash();

  @$internal
  @override
  ActiveTheme create() => ActiveTheme();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OdoTheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OdoTheme>(value),
    );
  }
}

String _$activeThemeHash() => r'0f5dbd7fef00822848284888ba47c11686ca15b1';

abstract class _$ActiveTheme extends $Notifier<OdoTheme> {
  OdoTheme build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<OdoTheme, OdoTheme>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<OdoTheme, OdoTheme>, OdoTheme, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
