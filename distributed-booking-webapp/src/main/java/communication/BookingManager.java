package communication;

import com.ericsson.otp.erlang.*;
import database.DbManager;
import dto.BookingDTO;

import java.io.IOException;
import java.util.ArrayList;

public class BookingManager {

    private static final String cookie = "abcde";
    private static final String remoteNodeId ="server@localhost";
    private static final String registeredServer = "booking_manager";


    public  static  void main(String[] args){
        System.out.println(BookingManager.newBooking("Fabi",0,"morning", "2022-06-15"));
    }

    public static boolean newBooking(String user, int BeachId, String Type, String Date){
        OtpConnection conn = null;
        try {
            conn = getConnection(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "new_booking", new OtpErlangObject[]{new OtpErlangString(user), new OtpErlangInt(BeachId), new OtpErlangAtom(Type), new OtpErlangString(Date)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangTuple) {
                    return Boolean.parseBoolean(((OtpErlangTuple)reply).elementAt(0).toString());
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
            return false;
        }
        return false;
    }

    public static ArrayList<BookingDTO> getBookings(String username){
        return DbManager.getAllBookings(username);
    }

    public static OtpConnection getConnection(String username) throws IOException {

        String nodeId = username + "_client@localhost";
        OtpSelf self = new OtpSelf(nodeId,cookie);
        OtpPeer auctionServerNode = new OtpPeer(remoteNodeId);
        try {
            return self.connect(auctionServerNode);
        } catch (OtpAuthException | IOException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }
        return null;
    }
}
