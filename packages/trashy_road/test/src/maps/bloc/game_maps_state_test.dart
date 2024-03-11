import 'package:flutter_test/flutter_test.dart';
import 'package:trashy_road/src/maps/maps.dart';

void main() {
  group('$ScoreRating', () {
    group('fromSteps', () {
      test(
        'returns ScoreRating.gold when score is less than the first step',
        () {
          final rating = ScoreRating.fromSteps(score: 0, steps: (1, 2, 3));
          expect(rating, ScoreRating.gold);
        },
      );

      test(
        '''returns ScoreRating.silver when score is greater or equal than the first step '''
        'and less than the second step',
        () {
          final rating = ScoreRating.fromSteps(score: 2, steps: (1, 2, 3));
          expect(rating, ScoreRating.silver);
        },
      );

      test(
        '''returns ScoreRating.bronze when score is greater or equal than the second step '''
        'and less than the third step',
        () {
          final rating = ScoreRating.fromSteps(score: 3, steps: (1, 2, 3));
          expect(rating, ScoreRating.bronze);
        },
      );

      test(
        '''returns ScoreRating.none when score is greater or equal than the third step''',
        () {
          final rating = ScoreRating.fromSteps(score: 4, steps: (1, 2, 3));
          expect(rating, ScoreRating.none);
        },
      );

      test(
        '''returns ScoreRating.none when score is less than 0''',
        () {
          final rating = ScoreRating.fromSteps(score: -1, steps: (1, 2, 3));
          expect(rating, ScoreRating.none);
        },
      );

      test(
        '''returns ScoreRating.none when score is null''',
        () {
          final rating = ScoreRating.fromSteps(score: null, steps: (1, 2, 3));
          expect(rating, ScoreRating.none);
        },
      );
    });
  });
}
