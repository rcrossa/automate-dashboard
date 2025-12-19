import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:msasb_app/data/repositories/supabase_auth_repository.dart';
import 'package:msasb_app/core/error/failure.dart';

// Generate mocks
@GenerateMocks([SupabaseClient, GoTrueClient, User, Session, AuthResponse])
import 'auth_repository_test.mocks.dart';

void main() {
  late SupabaseAuthRepository repository;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    
    // Mock the auth property of SupabaseClient
    when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
    
    repository = SupabaseAuthRepository(mockSupabaseClient);
  });

  group('AuthRepository', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('signInWithEmailAndPassword should call supabase.auth.signInWithPassword', () async {
      // Arrange
      when(mockGoTrueClient.signInWithPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => MockAuthResponse());

      // Act
      await repository.signInWithEmailAndPassword(tEmail, tPassword);

      // Assert
      verify(mockGoTrueClient.signInWithPassword(email: tEmail, password: tPassword));
    });

    test('signInWithEmailAndPassword should throw ServerFailure on AuthException', () async {
      // Arrange
      when(mockGoTrueClient.signInWithPassword(email: tEmail, password: tPassword))
          .thenThrow(const AuthException('Invalid credentials'));

      // Act & Assert
      expect(
        () => repository.signInWithEmailAndPassword(tEmail, tPassword),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('signOut should call supabase.auth.signOut', () async {
      // Arrange
      when(mockGoTrueClient.signOut()).thenAnswer((_) async {});

      // Act
      await repository.signOut();

      // Assert
      verify(mockGoTrueClient.signOut());
    });
  });
}
