package dto;

import com.ericsson.otp.erlang.OtpErlangTuple;

public class SubscriptionDTO{

    String idSubscription;
    String username;
    String idBeach;
    String type;
    String status;
    String endDate;

    public SubscriptionDTO( String idSubscription, String username, String idBeach, String type, String status, String endDate){
        this.idSubscription = idSubscription;
        this.username = username;
        this.idBeach = idBeach;
        this.type = type;
        this.status = status;
        this.endDate = endDate;
    }

    public SubscriptionDTO(OtpErlangTuple subscriptionInfo) {
<<<<<<< Updated upstream
        idSubscription = subscriptionInfo.elementAt(0).toString();
        username = subscriptionInfo.elementAt(1).toString();
        idBeach = subscriptionInfo.elementAt(2).toString();
        type = subscriptionInfo.elementAt(3).toString();
        status = subscriptionInfo.elementAt(4).toString();
        endDate = subscriptionInfo.elementAt(5).toString();
=======
        idSubscription = Integer.parseInt(subscriptionInfo.elementAt(1).toString());
        username = subscriptionInfo.elementAt(2).toString();
        idBeach = Integer.parseInt(subscriptionInfo.elementAt(3).toString());
        type = subscriptionInfo.elementAt(4).toString();
        status = subscriptionInfo.elementAt(5).toString();
        endDate = subscriptionInfo.elementAt(6).toString();
>>>>>>> Stashed changes
    }

    public String getIdSubscription() {
        return idSubscription;
    }

    public String getUsername() {
        return username;
    }

    public String getIdBeach() {
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

    @Override
    public String toString() {
        return "SubscriptionDTO{" +
                "idSubscription='" + idSubscription + '\'' +
                ", username='" + username + '\'' +
                ", idBeach='" + idBeach + '\'' +
                ", type='" + type + '\'' +
                ", status='" + status + '\'' +
                ", endDate='" + endDate + '\'' +
                '}';
    }
}
