import java.util.Arrays;

public final class MilitaryUnit {
    
    private final PlayerIdentity playerIdentity;
    private final int id;
    private final Direction direction;
    private final int numberOfSoldiers, morale, leadership;
    
    MilitaryUnit(String line) {
        String[] words = line.split(" ");
        // MIL_UNIT %s %d %d %d %d %d
        playerIdentity = PlayerIdentity.valueOf(words[1]);
        id = Integer.parseInt(words[2]);
        switch (Integer.parseInt(words[3])) {
            case 0: direction = Direction.EAST; break;
            case 1: direction = Direction.NORTH; break;
            case 2: direction = Direction.WEST; break;
            case 3: direction = Direction.SOUTH; break;
            default: throw new Error("Bad Output!");
        }
        numberOfSoldiers = Integer.parseInt(words[4]);
        morale = Integer.parseInt(words[5]);
        leadership = Integer.parseInt(words[6]);
    }
    
    public PlayerIdentity getPlayerIdentity() {
        return playerIdentity;
    }
    
    public int getId() {
        return id;
    }
    
    public Direction getDirection() {
        return direction;
    }
    
    public int getNumberOfSoldiers() {
        return numberOfSoldiers;
    }
    
    public int getMorale() {
        return morale;
    }
    
    public int getLeadership() {
        return leadership;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (obj instanceof MilitaryUnit) {
            MilitaryUnit m = (MilitaryUnit) obj;
            return m.playerIdentity == playerIdentity && m.id == id
                    && m.direction == direction
                    && m.numberOfSoldiers == numberOfSoldiers
                    && m.leadership == leadership
                    && m.morale == morale;
        }
        return false;
    }
    
    @Override
    public int hashCode() {
        return Arrays.hashCode(new int[]{
                playerIdentity.hashCode(), id, direction.hashCode(),
                numberOfSoldiers, morale, leadership
        });
    }
}
