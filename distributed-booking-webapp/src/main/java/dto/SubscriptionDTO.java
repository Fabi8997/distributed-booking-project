package dto;

import com.ericsson.otp.erlang.OtpErlangTuple;

public class SubscriptionDTO{

    int idSubscription;
    String username;
    int idBeach;
    String type;
    String status;
    String endDate;

    int duration;

    public SubscriptionDTO( int idSubscription, String username, int idBeach, String type, String status, String endDate, int duration){
        this.idSubscription = idSubscription;
        this.username = username;
        this.idBeach = idBeach;
        this.type = type;
        this.status = status;
        this.endDate = endDate;
        this.duration = duration;
    }

    public SubscriptionDTO(OtpErlangTuple subscriptionInfo) {
        idSubscription = Integer.parseInt(subscriptionInfo.elementAt(1).toString());
        username = subscriptionInfo.elementAt(2).toString();
        idBeach = Integer.parseInt(subscriptionInfo.elementAt(3).toString());
        type = subscriptionInfo.elementAt(4).toString();
        status = subscriptionInfo.elementAt(5).toString();
        endDate = subscriptionInfo.elementAt(6).toString();
        duration = Integer.parseInt(subscriptionInfo.elementAt((7)).toString());
    }

    public int getIdSubscription() {
        return idSubscription;
    }

    public String getUsername() {
        return username;
    }

    public int getIdBeach() {
        return idBeach;
    }

    public String getType() {
        return type;
    }

    public String getStatus() {
        return status;
    }

    public String getEndDate() {
        return endDate;
    }

    public int getDuration() {
        return duration;
    }

    @Override
    public String toString() {
        return "SubscriptionDTO{" +
                "idSubscription='" + idSubscription + '\'' +
                ", username='" + username + '\'' +
                ", idBeach='" + idBeach + '\'' +
                ", type='" + type + '\'' +
                ", status='" + status + '\'' +
                ", endDate='" + endDate + '\'' +
                ", duration='" + duration + '\'' +
                '}';
    }
}
