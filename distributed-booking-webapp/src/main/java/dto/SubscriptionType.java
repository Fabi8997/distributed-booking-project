package dto;

public enum SubscriptionType {
    none,
    weekly,
    biweekly;

    public static int parseInt(SubscriptionType type){

        if(type == weekly){
            return 7;
        }else if(type == biweekly){
            return 14;
        }
        return -1;
    }

}
