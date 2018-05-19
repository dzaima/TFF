void save(String name) {
  byte[] bytes = new byte[map.length*map[0].length+2];
  bytes[0] = (byte)map.length;
  bytes[1] = (byte)map[0].length;
  int i = 2;
  for (Cell[] ln : map) for (Cell c : ln) {
    bytes[i] = (byte)c.type;
    i++;
  }
  saveBytes(dataPath(name), bytes);
}

void load(String name) {
  byte[] bytes = loadBytes(dataPath(name));
  map = new Cell[bytes[0]&0xff][bytes[1]&0xff];
  int i = 2;
  for (int x = 0; x < map.length; x++) {
    for (int y = 0; y < map[0].length; y++) {
      map[x][y] = new Cell(x, y, constrain(bytes[i], 0, 18));
      i++;
    }
  }
}
