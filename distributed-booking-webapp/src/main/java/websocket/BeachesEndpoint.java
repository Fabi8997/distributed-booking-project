package websocket;

import database.DbManager;
import dto.BeachDTO;
import dto.SlotsDTO;
import model.Message;

import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.HashMap;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint(value = "/BeachesServlet", decoders = MessageDecoder.class, encoders = MessageEncoder.class)
public class BeachesEndpoint {
    private Session session;
    private static final Set<BeachesEndpoint> chatEndpoints = new CopyOnWriteArraySet<BeachesEndpoint>();

    @OnOpen
    public void onOpen(Session session) throws IOException, EncodeException {

        this.session = session;
        chatEndpoints.add(this);

    }

    @OnMessage
    public void onMessage(Session session, Message message) throws IOException, EncodeException {
        String RELOAD_MESSAGE = "reload_slots";
        System.out.println("Received msg" + message);
        System.out.println(message.getContent().equals(RELOAD_MESSAGE));
        if(message.getContent().equals(RELOAD_MESSAGE)) {
            System.out.println("Sono dentro");
            SlotsDTO slots = DbManager.getAvailableSlots("ws", Integer.parseInt(message.getIdBeach()));
            assert slots != null;
            message.setMorningSlots(Integer.toString(slots.getMorningSlots()));
            message.setAfternoonSlots(Integer.toString(slots.getAfternoonSlots()));
            System.out.println(message);
            broadcast(message);
        }
    }

    @OnClose
    public void onClose(Session session) throws IOException, EncodeException {
        chatEndpoints.remove(this);
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        // Do error handling here
    }

    private static void broadcast(Message message) throws IOException, EncodeException {
        for (BeachesEndpoint endpoint : chatEndpoints) {
            synchronized (endpoint) {
                try {
                    endpoint.session.getBasicRemote()
                            .sendObject(message);

                } catch (IOException | EncodeException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
