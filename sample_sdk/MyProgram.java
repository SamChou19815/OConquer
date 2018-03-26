public class MyProgram {

    class Decider {
        static int randomNumber() {
            return 0;
        }
    }

    public Action chooseAction() {
        int[] a = new int[]{1, 3, 3, 4, 1}; // Create array literal
        int[] b = new int[]{a[2], a[0] - a[2] * a[3]}; // array read
        int c = nearby(new int[]{a[2], b[1]});
        // call built in function to know nearby info,
        c = c + 2;
        int i = 0;
        while (i < 5) {
            if (i >= 4) {
                return Action.DO_NOTHING; // early return
            }
            i = i + 1;
            break;
        }
        return ATTACK; // return value always has type Action
    }

}
