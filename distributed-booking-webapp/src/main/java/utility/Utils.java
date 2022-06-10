package utility;
import java.time.LocalDateTime;
import java.time.Instant;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;
public class Utils {

    //gets the endDate of a subscription based on the type of the subscription
    public static String getEndDate(String type){
        Instant instant = Instant.now();
        LocalDateTime localDateTime = LocalDateTime.ofInstant(instant, ZoneOffset.of("+02:00"));
        if(type.equals("weekly")){
            localDateTime = LocalDateTime.ofInstant(instant, ZoneOffset.of("+02:00")
            ).plus(7, ChronoUnit.DAYS).truncatedTo(ChronoUnit.SECONDS);
        }
        else if(type.equals("monthly")){
            localDateTime = LocalDateTime.ofInstant(instant, ZoneOffset.of("+02:00")
            ).plus(1, ChronoUnit.MONTHS).truncatedTo(ChronoUnit.SECONDS);
        }

        System.out.println(localDateTime);
        return localDateTime.toString();
    }

    public static boolean isAdmin(String user){
        if(user.equals("admin")){
            return true;
        }
        else{
            return false;
        }
    }

    public static void main(String args[]){
        System.out.println(getEndDate("weekly"));
    }

}