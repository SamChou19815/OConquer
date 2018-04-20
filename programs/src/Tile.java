/**
 * Tile is the data class for tile.
 */
public final class Tile {
    
    private final TileType tileType;
    
    private final int cityLevel;
    
    Tile(String line) {
        String[] words = line.split(" ");
        switch (words[1]) {
            case "EMPTY": tileType = TileType.EMPTY; break;
            case "MOUNTAIN": tileType = TileType.MOUNTAIN; break;
            case "FORT": tileType = TileType.FORT; break;
            case "CITY": tileType = TileType.CITY; break;
            default: throw new Error("Bad Output!");
        }
        if (tileType == TileType.CITY) {
            cityLevel = Integer.parseInt(words[2]);
        } else {
            cityLevel = -1;
        }
    }
    
    public TileType getTileType() {
        return tileType;
    }
    
    /**
     * Obtain the city level if it is a city, {@code null} if not.
     *
     * @return the city level if it is a city, {@code null} if not.
     */
    public Integer getCityLevel() {
        if (tileType == TileType.CITY) {
            return cityLevel;
        } else {
            return null;
        }
    }
    
    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (obj instanceof Tile) {
            Tile t = (Tile) obj;
            return t.tileType == tileType && t.cityLevel == cityLevel;
        }
        return false;
    }
    
    @Override
    public int hashCode() {
        return tileType.hashCode() * 31 + Integer.hashCode(cityLevel);
    }
    
}
