package utility;
import com.ericsson.otp.erlang.OtpErlangInt;
import com.ericsson.otp.erlang.OtpErlangObject;
import com.ericsson.otp.erlang.OtpErlangTuple;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Instant;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
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
        else if(type.equals("biweekly")){
            localDateTime = LocalDateTime.ofInstant(instant, ZoneOffset.of("+02:00")
            ).plus(14, ChronoUnit.DAYS).truncatedTo(ChronoUnit.SECONDS);
        }
        else{
            return "";
        }

        System.out.println(localDateTime);
        return localDateTime.toLocalDate().toString();
    }

    public static String getDateNow(){
        Instant instant = Instant.now();
        LocalDateTime localDateTime = LocalDateTime.ofInstant(instant, ZoneOffset.of("+02:00")).truncatedTo(ChronoUnit.DAYS);
        return  localDateTime.toLocalDate().toString();
    }

    public static String getDateNext(int days){
        Instant instant = Instant.now();
        LocalDateTime localDateTime = LocalDateTime.ofInstant(instant, ZoneOffset.of("+02:00")
        ).plus(days, ChronoUnit.DAYS).truncatedTo(ChronoUnit.DAYS);
        return  localDateTime.toLocalDate().toString();
    }

    public static OtpErlangTuple fromDateToTuple(String date){
        DateTimeFormatter DATEFORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate ld = LocalDate.parse(date, DATEFORMATTER);
        int year = ld.getYear();
        int month = ld.getMonthValue();
        int day = ld.getDayOfMonth();

        return new OtpErlangTuple(new OtpErlangObject []{
            new OtpErlangInt(year), new OtpErlangInt(month), new OtpErlangInt(day)
        });
    }

    public static boolean isAdmin(String user){
        return user.equals("admin");
    }

    public static void main(String[] args){

        System.out.println(getDateNow());
    }

}