/**
 * A simple data class for position.
 */
public final class Position {
    
    private final int x, y;
    
    public Position(int x, int y) {
        this.x = x; this.y = y;
    }
    
    public int getX() {
        return x;
    }
    
    public int getY() {
        return y;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (obj instanceof Position) {
            Position p = (Position) obj;
            return p.x == x && p.y == y;
        }
        return false;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(x) * 31 + Integer.hashCode(y);
    }
    
}
