extension ListExtensions on List {
  dynamic takeFirstOrNull (){
    if(this.isEmpty){
      return null;
    } else {
      return this.first;
    }
  }
}