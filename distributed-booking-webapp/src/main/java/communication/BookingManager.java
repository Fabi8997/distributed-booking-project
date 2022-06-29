package communication;

import com.ericsson.otp.erlang.*;
import database.DbManager;
import dto.BookingDTO;
import dto.SubscriptionDTO;
import dto.SubscriptionType;
import utility.ResultMessage;
import utility.Utils;

import java.io.IOException;
import java.util.ArrayList;

public class BookingManager {

    private static final String cookie = "abcde";
    private static final String remoteNodeId = "server@localhost";
    private static final String registeredServer = "booking_manager";


    public static void main(String[] args) {
        System.out.println(BookingManager.newSubscription("Prova4", 1, "morning", "2022-06-28",2));
    }

    public static ResultMessage newBooking(String user, int BeachId, String Type, String Date) {
        OtpConnection conn = null;
        try {
            conn = getConnection(user);
            if (conn != null) {

                conn.sendRPC(registeredServer, "new_booking", new OtpErlangObject[]{new OtpErlangString(user), new OtpErlangInt(BeachId), new OtpErlangAtom(Type), new OtpErlangString(Date)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangTuple) {
                    boolean result = Boolean.parseBoolean(((OtpErlangTuple) reply).elementAt(0).toString());
                    String message = ((OtpErlangTuple) reply).elementAt(1).toString();
                    return new ResultMessage(result, message);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if (conn != null) {
                conn.close();
            }
            e.printStackTrace();
            return new ResultMessage(false, "Something has gone wrong!");
        }
        return new ResultMessage(false, "Something has gone wrong!");

    }

    public static ArrayList<BookingDTO> getBookings(String username) {
        return DbManager.getAllBookings(username);
    }

    public static OtpConnection getConnection(String username) throws IOException {

        String nodeId = username + "_client@localhost";
        OtpSelf self = new OtpSelf(nodeId, cookie);
        OtpPeer auctionServerNode = new OtpPeer(remoteNodeId);
        try {
            return self.connect(auctionServerNode);
        } catch (OtpAuthException | IOException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }
        return null;
    }

    public static ResultMessage newSubscription(String user, int BeachId, String Type, String StartingDate, int Duration) {
        OtpConnection conn = null;
        try {
            conn = getConnection(user);
            if (conn != null) {

                conn.sendRPC(registeredServer, "new_subscription", new OtpErlangObject[]{
                        new OtpErlangString(user),
                        new OtpErlangInt(BeachId),
                        new OtpErlangAtom(Type),
                        Utils.fromDateToTuple(StartingDate),
                        new OtpErlangInt(Duration)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangTuple) {
                    boolean result = Boolean.parseBoolean(((OtpErlangTuple) reply).elementAt(0).toString());
                    String message = ((OtpErlangTuple) reply).elementAt(1).toString();
                    return new ResultMessage(result, message);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if (conn != null) {
                conn.close();
            }
            e.printStackTrace();
            return new ResultMessage(false, "Something has gone wrong!");
        }
        return new ResultMessage(false, "Something has gone wrong!");
    }

    public static ResultMessage removeSubscription(String connUser, int subId) {
        SubscriptionDTO subscription = DbManager.getSubscription(subId, connUser);
        String subUser = subscription.getUsername();
        int beachId = subscription.getIdBeach();
        String type = subscription.getType();
        String date = subscription.getEndDate();
        int duration = SubscriptionType.parseInt(SubscriptionType.valueOf(type));
        OtpConnection conn = null;
        try {
            conn = getConnection(connUser);
            if (conn != null) {

                conn.sendRPC(registeredServer, "remove_subscription", new OtpErlangObject[]{
                        new OtpErlangString(subUser),
                        new OtpErlangInt(beachId),
                        new OtpErlangAtom(type),
                        Utils.fromDateToTuple(date),
                        new OtpErlangInt(duration)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangTuple) {
                    boolean result = Boolean.parseBoolean(((OtpErlangTuple) reply).elementAt(0).toString());
                    String message = ((OtpErlangTuple) reply).elementAt(1).toString();
                    return new ResultMessage(result, message);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if (conn != null) {
                conn.close();
            }
            e.printStackTrace();
            return new ResultMessage(false, "Something has gone wrong!");
        }
        return new ResultMessage(false, "Something has gone wrong!");
    }
}
