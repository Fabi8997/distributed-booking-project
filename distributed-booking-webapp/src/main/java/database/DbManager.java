package database;

import com.ericsson.otp.erlang.*;
import dto.*;
import utility.Utils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class DbManager {

    private static final String cookie = "abcde";
    private static final String remoteNodeId ="server@localhost";
    private static final String registeredServer ="mnesia_manager";

    public static void main(String[] args) {

        System.out.println(DbManager.getAvailableSlots("Prova", 1));
    }

    //USERS

    public static boolean login(String user, String pass){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "login", new OtpErlangObject[]{new OtpErlangString(user), new OtpErlangString(pass)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();

                return Boolean.parseBoolean(reply.toString());
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

    public static boolean register(String user, String pass){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "register", new OtpErlangObject[]{new OtpErlangString(user), new OtpErlangString(pass)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();

                return Boolean.parseBoolean(reply.toString());
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

    public static boolean deleteUser(String admin, String user){
        List<SubscriptionDTO> userSubscriptions = getAllSubscriptions(user);
        List<BookingDTO> userBookings = getAllBookings(user);
        for(SubscriptionDTO s: userSubscriptions){
            deleteSubscription(user, s.getIdSubscription());
        }
        for(BookingDTO b: userBookings){
            deleteBooking(user, b.getIdBooking());
        }
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(admin);
            if(conn != null) {
                conn.sendRPC(registeredServer, "delete_user", new OtpErlangObject[]{new OtpErlangString(user)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();

                return Boolean.parseBoolean(reply.toString());
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

    public static ArrayList<UserDTO> getUsers(String user){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {
                conn.sendRPC(registeredServer, "all_user", new OtpErlangObject[]{});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangList) {
                    return toUsersArray((OtpErlangList) reply);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    private static ArrayList<UserDTO> toUsersArray(OtpErlangList list){
        ArrayList<UserDTO> users = new ArrayList<>();

        for(int i = 0; i < list.arity(); i++){
            users.add(new UserDTO((OtpErlangTuple) list.elementAt(i)));
        }
        return users;
    }

    //BEACHES

    public static boolean addBeach(String user, String name, String description, int slots){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "add_beach", new OtpErlangObject[]{
                        new OtpErlangString(name), new OtpErlangString(description), new OtpErlangInt(slots)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();

                return reply.toString().equals("ok");
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


    public static BeachDTO getBeach(int beachId, String user){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {
                conn.sendRPC(registeredServer, "get_beach", new OtpErlangObject[]{new OtpErlangInt(beachId)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangTuple) {
                    return new BeachDTO((OtpErlangTuple) reply);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return null;
    }


    public static ArrayList<BeachDTO> getBeaches(String user){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {
                conn.sendRPC(registeredServer, "all_beaches", new OtpErlangObject[]{});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangList) {
                    return toBeachesArray((OtpErlangList) reply);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    private static ArrayList<BeachDTO> toBeachesArray(OtpErlangList list){
        ArrayList<BeachDTO> beaches = new ArrayList<>();

        for(int i = 0; i < list.arity(); i++){
            beaches.add(new BeachDTO((OtpErlangTuple) list.elementAt(i)));
        }
        return beaches;
    }

    public static boolean updateBeach(String user, int beachId, String desc){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "update_beach", new OtpErlangObject[]{
                        new OtpErlangInt(beachId), new OtpErlangString(desc)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();

                return reply.toString().equals("ok");
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


    //BOOKINGS

    public static boolean addBooking(String user, int beach, String type, String date){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "insert_booking", new OtpErlangObject[]{
                        new OtpErlangString(user), new OtpErlangInt(beach),
                        new OtpErlangString(type), new OtpErlangString(date)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();

                return reply.toString().equals("ok");
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


    public static BookingDTO getBooking(int bookingId, String user){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {
                conn.sendRPC(registeredServer, "get_booking", new OtpErlangObject[]{new OtpErlangInt(bookingId)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangTuple) {
                    return new BookingDTO((OtpErlangTuple) reply);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return null;
    }

    public static ArrayList<BookingDTO> getAllBookings(String user){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {
                conn.sendRPC(registeredServer, "all_bookings", new OtpErlangObject[]{new OtpErlangString(user)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangList) {
                    return toBookingsArray((OtpErlangList) reply, user);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    public static ArrayList<BookingDTO> getUserBookings(String user, String connectionUser){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(connectionUser);
            if(conn != null) {
                conn.sendRPC(registeredServer, "all_bookings", new OtpErlangObject[]{new OtpErlangString(user)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangList) {
                    return toBookingsArray((OtpErlangList) reply, user);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    private static ArrayList<BookingDTO> toBookingsArray(OtpErlangList list, String user){
        ArrayList<BookingDTO> bookings = new ArrayList<>();

        for(int i = 0; i < list.arity(); i++){
            //bookings.add(new BookingDTO((OtpErlangTuple) list.elementAt(i)));
            int idBooking = Integer.parseInt(String.valueOf(((OtpErlangTuple) list.elementAt(i)).elementAt(1)));
            bookings.add(getBooking(idBooking, user));
        }
        return bookings;
    }

    public static boolean deleteBooking(String user, int BookingId){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "delete_booking", new OtpErlangObject[]{new OtpErlangInt(BookingId)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();

                return Boolean.parseBoolean(reply.toString());
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

    //SUBSCRIPTION

    /*public static boolean insertSubscription(int beach, String user, String type, String endDate, String request){
        if(request.equals("add")){
            return addSubscription(beach, user, type, endDate);
        }
        else if(request.equals("update")){
            return updateSubscription(user, beach, type, "active", endDate);
        }
        else return false;
    }*/

    public static boolean addSubscription(int beach, String user, String type, String endDate){
        if(beach == 0 || endDate.equals("")){
            return false;
        }
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "add_subscription", new OtpErlangObject[]{
                        new OtpErlangInt(beach), new OtpErlangString(user),
                        new OtpErlangString(type), new OtpErlangString(endDate)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();

                return reply.toString().equals("ok");
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


    public static SubscriptionDTO getSubscription(int subscriptionId, String user){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {
                conn.sendRPC(registeredServer, "get_subscription", new OtpErlangObject[]{new OtpErlangInt(subscriptionId)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangTuple) {
                    return new SubscriptionDTO((OtpErlangTuple) reply);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return null;
    }

    //TODO 02/06/2022: is the update method ok???
    //we keep just one sub per user and update it each time
    public static boolean updateSubscription(String user, int subId, String type, String status, String endDate){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "update_subscription", new OtpErlangObject[]{
                        new OtpErlangInt(subId), new OtpErlangString(type),
                        new OtpErlangString(status), new OtpErlangString(endDate)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();

                return reply.toString().equals("ok");
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

    public static ArrayList<SubscriptionDTO> getSubscriptionFromUser(String user){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {
                conn.sendRPC(registeredServer, "all_subscriptions", new OtpErlangObject[]{new OtpErlangString(user)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangList) {
                    return toSubscriptionsArray((OtpErlangList) reply, user);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    public static ArrayList<SubscriptionDTO> getSubscriptionFromAnotherUser(String user, String connectionUser){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(connectionUser);
            if(conn != null) {
                conn.sendRPC(registeredServer, "get_user_subscription", new OtpErlangObject[]{new OtpErlangString(user)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangList) {
                    return toSubscriptionsArray((OtpErlangList) reply, user);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    public static ArrayList<SubscriptionDTO> getAllSubscriptions(String user){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {
                conn.sendRPC(registeredServer, "all_subscriptions", new OtpErlangObject[]{new OtpErlangString(user)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangList) {
                    return toSubscriptionsArray((OtpErlangList) reply, user);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    private static ArrayList<SubscriptionDTO> toSubscriptionsArray(OtpErlangList list, String user){
        ArrayList<SubscriptionDTO> subscriptions = new ArrayList<>();

        for(int i = 0; i < list.arity(); i++){
            int idSub = Integer.parseInt(String.valueOf(((OtpErlangTuple) list.elementAt(i)).elementAt(1)));
            subscriptions.add(getSubscription(idSub, user));
            //subscriptions.add(OtpErlangCommunication.get_info(idSub,user));
        }
        return subscriptions;
    }

    public static boolean deleteSubscription(String user, int SubscriptionId){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "delete_subscription", new OtpErlangObject[]{new OtpErlangInt(SubscriptionId)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();

                return Boolean.parseBoolean(reply.toString());
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

    public static OtpConnection getConnectionDB(String username) throws IOException {
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

    public static SlotsDTO getAvailableSlots(String user, int BeachId){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {
                String currentDate = Utils.getDateNow();
                conn.sendRPC(registeredServer, "get_available_slots", new OtpErlangObject[]{new OtpErlangInt(BeachId), new OtpErlangString(currentDate)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                if (reply instanceof OtpErlangTuple) {
                    return new SlotsDTO((OtpErlangTuple) reply);
                }
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return null;
    }
}
