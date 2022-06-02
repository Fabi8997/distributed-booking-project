package dto;

import com.ericsson.otp.erlang.OtpErlangTuple;

public class BookingDTO {

    String idBooking;
    String username;
    int idBeach;
    String type;
    String status;
    String date;

    public BookingDTO( String idBooking, String username, int idBeach, String type, String date){
        this.idBooking = idBooking;
        this.username = username;
        this.idBeach = idBeach;
        this.type = type;
        this.date = date;
    }

    public BookingDTO(OtpErlangTuple bookingInfo) {
        idBooking = bookingInfo.elementAt(0).toString();
        username = bookingInfo.elementAt(1).toString();
        idBeach = Integer.parseInt(bookingInfo.elementAt(2).toString());
        type = bookingInfo.elementAt(3).toString();
        status = bookingInfo.elementAt(4).toString();
        date = bookingInfo.elementAt(5).toString();
    }

    public String getIdBooking() {
        return idBooking;
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

    public String getDate() {
        return date;
    }

    @Override
    public String toString() {
        return "BookingDTO{" +
                "idBooking='" + idBooking + '\'' +
                ", username='" + username + '\'' +
                ", idBeach='" + idBeach + '\'' +
                ", type='" + type + '\'' +
                ", date='" + date + '\'' +
                '}';
    }
}
