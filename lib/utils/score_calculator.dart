String calculateFeedback(int score, int totalQuestions) {
  double percentage = (score / totalQuestions) * 100;

  if (percentage <= 50) {
    return 'Você pode melhorar! Continue aprendendo sobre mediação de conflitos.';
  } else if (percentage <= 70) {
    return 'Bom trabalho! Você está no caminho certo para mediar conflitos com sucesso.';
  } else {
    return 'Excelente! Você é um mestre em mediação de conflitos!';
  }
}
