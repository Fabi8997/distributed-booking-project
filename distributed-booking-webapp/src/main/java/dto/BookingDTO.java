package dto;

import com.ericsson.otp.erlang.OtpErlangTuple;

public class BookingDTO {

    int idBooking;
    String username;
    int idBeach;
    String type;
    String date;

    public BookingDTO( int idBooking, String username, int idBeach, String type, String date){
        this.idBooking = idBooking;
        this.username = username;
        this.idBeach = idBeach;
        this.type = type;
        this.date = date;
    }

    public BookingDTO(OtpErlangTuple bookingInfo) {
        idBooking = Integer.parseInt(bookingInfo.elementAt(1).toString());
        username = bookingInfo.elementAt(2).toString();
        idBeach = Integer.parseInt(bookingInfo.elementAt(3).toString());
        type = bookingInfo.elementAt(4).toString();
        date = bookingInfo.elementAt(5).toString();
    }

    public int getIdBooking() {
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

    public String getDate() {
        return date;
    }

    @Override
    public String toString() {
        return "BookingDTO{" +
                "idBooking=" + idBooking +
                ", username=" + username +
                ", idBeach=" + idBeach +
                ", type=" + type +
                ", date=" + date  +
                '}';
    }
}
