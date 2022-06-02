package database;

import com.ericsson.otp.erlang.*;

import java.io.IOException;
import java.util.ArrayList;

public class DbManager {

    private static final String cookie = "abcde";
    private static final String remoteNodeId ="server@localhost";
    private static final String registeredServer ="mnesia_manager";

    public static void main(String[] args) {

        //System.out.println(DbManager.getAllAuctions("Provaj"));
    }

    //Tested --> OK!
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

    //Tested --> OK!
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
/*
    //Tested --> OK!
    public static Double getCredit(String user){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {
                conn.sendRPC(registeredServer, "get_credit", new OtpErlangObject[]{new OtpErlangString(user)});
                OtpErlangObject reply = conn.receiveRPC();
                System.out.println("Received " + reply);
                conn.close();
                return Double.parseDouble(reply.toString());
            }
        } catch (IOException | OtpErlangExit | OtpAuthException e) {
            if(conn!= null){
                conn.close();
            }
            e.printStackTrace();
        }
        return 0.00;
    }

    //Tested --> OK!
    public static boolean addCredit(String user, double credit){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "add_credit", new OtpErlangObject[]{new OtpErlangString(user), new OtpErlangDouble(credit)});
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
*/

    public static boolean addBeach(String user, String description, int slots){
        OtpConnection conn = null;
        try {
            conn = getConnectionDB(user);
            if(conn != null) {

                conn.sendRPC(registeredServer, "add_good", new OtpErlangObject[]{new OtpErlangString(description), new OtpErlangInt(slots)});
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

}
