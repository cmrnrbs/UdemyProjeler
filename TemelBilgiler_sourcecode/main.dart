void main() {
  int result = YasHesapla(1993);

  switch (result > 27) {
    case true:
      print('gayet büyüksün');
      break;
    default:
      print('küçüksün işte');
  }
}

int YasHesapla(int dogumYili) {
  int result;
  int guncelYil = DateTime.now().year;
  result = guncelYil - dogumYili;

  return result;
}
