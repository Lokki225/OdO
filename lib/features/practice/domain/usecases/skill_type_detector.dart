import 'package:odo/features/practice/domain/entities/skill_type.dart';

abstract final class SkillTypeDetector {
  static SkillType detect(String name) {
    final lower = name.toLowerCase();
    if (_languageKeywords.any(lower.contains)) return SkillType.language;
    if (_strategyKeywords.any(lower.contains)) return SkillType.strategy;
    if (_physicalKeywords.any(lower.contains)) return SkillType.physical;
    if (_technicalKeywords.any(lower.contains)) return SkillType.technical;
    if (_creativeKeywords.any(lower.contains)) return SkillType.creative;
    return SkillType.personal;
  }

  static const _languageKeywords = [
    'japanese', 'japonais', 'français', 'french', 'english', 'anglais',
    'spanish', 'espagnol', 'chinese', 'chinois', 'korean', 'coréen',
    'arabic', 'arabe', 'german', 'allemand', 'italian', 'italien',
    'portuguese', 'portugais', 'language', 'langue', 'vocab', 'vocabulaire',
    'grammar', 'grammaire', 'mandarin', 'hindi', 'russian', 'russe',
    'hébreu', 'hebrew', 'dutch', 'néerlandais', 'swedish', 'suédois',
  ];

  static const _strategyKeywords = [
    'chess', 'échecs', 'go ', 'poker', 'strateg', 'stratégi', 'competitive',
    'compétit', 'rating', 'elo', 'puzzle', 'puzzle', 'shogi', 'checkers',
    'dames', 'backgammon', 'jeu de go',
  ];

  static const _physicalKeywords = [
    'running', 'course', 'gym', 'football', 'soccer', 'tennis', 'yoga',
    'swimming', 'natation', 'basketball', 'sport', 'musculation', 'boxe',
    'boxing', 'cycling', 'vélo', 'hiking', 'randonnée', 'climbing',
    'escalade', 'crossfit', 'pilates', 'stretching', 'fitness', 'rugby',
    'volleyball', 'badminton', 'golf', 'ski', 'surf', 'martial',
  ];

  static const _technicalKeywords = [
    'coding', 'programming', 'programmation', 'flutter', 'python',
    'javascript', 'typescript', 'react', 'vue', 'angular', 'swift',
    'kotlin', 'java', 'dev', 'développement', 'development', 'code',
    'software', 'logiciel', 'data science', 'machine learning',
    'artificial intelligence', 'intelligence artificielle',
    'sql', 'database', 'base de données', 'algorithm', 'algorithme',
    'backend', 'frontend', 'fullstack', 'devops', 'cloud', 'linux',
    'arduino', 'raspberry', 'électronique', 'electronics',
  ];

  static const _creativeKeywords = [
    'writing', 'écriture', 'drawing', 'dessin', 'painting', 'peinture',
    'guitar', 'guitare', 'piano', 'ukulele', 'drums', 'batterie',
    'music', 'musique', 'design', 'art', 'photography', 'photographie',
    'sculpt', 'sculpture', 'ceramics', 'céramique', 'illustration',
    'calligraph', 'calligraphie', 'violin', 'violon', 'sing', 'chant',
    'dance', 'danse', 'acting', 'théâtre', 'podcast', 'film', 'video',
    'novel', 'roman', 'poém', 'poem', 'blog', 'content',
  ];
}
