// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_preference.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LanguagePreference)
final languagePreferenceProvider = LanguagePreferenceProvider._();

final class LanguagePreferenceProvider
    extends $AsyncNotifierProvider<LanguagePreference, Locale?> {
  LanguagePreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languagePreferenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languagePreferenceHash();

  @$internal
  @override
  LanguagePreference create() => LanguagePreference();
}

String _$languagePreferenceHash() =>
    r'eed707dbef21186beb6c648a110b4dabbfe3c802';

abstract class _$LanguagePreference extends $AsyncNotifier<Locale?> {
  FutureOr<Locale?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Locale?>, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Locale?>, Locale?>,
              AsyncValue<Locale?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
