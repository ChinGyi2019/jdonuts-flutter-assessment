// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_member.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeMember)
final activeMemberProvider = ActiveMemberProvider._();

final class ActiveMemberProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, Member?>>,
          Either<Failure, Member?>,
          Stream<Either<Failure, Member?>>
        >
    with
        $FutureModifier<Either<Failure, Member?>>,
        $StreamProvider<Either<Failure, Member?>> {
  ActiveMemberProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeMemberProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeMemberHash();

  @$internal
  @override
  $StreamProviderElement<Either<Failure, Member?>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Either<Failure, Member?>> create(Ref ref) {
    return activeMember(ref);
  }
}

String _$activeMemberHash() => r'ce47373a8eda667ace558cca3c2749ce299a515f';
