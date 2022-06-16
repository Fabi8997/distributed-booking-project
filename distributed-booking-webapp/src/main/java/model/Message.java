package model;

public class Message {
    private String from;
    private String idBeach;
    private String morningSlots;
    private String afternoonSlots;
    private String content;

    public String getFrom() {
        return from;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getIdBeach() {
        return idBeach;
    }

    public void setIdBeach(String idBeach) {
        this.idBeach = idBeach;
    }

    public String getMorningSlots() {
        return morningSlots;
    }

    public void setMorningSlots(String morningSlots) {
        this.morningSlots = morningSlots;
    }

    public String getAfternoonSlots() {
        return afternoonSlots;
    }

    public void setAfternoonSlots(String afternoonSlots) {
        this.afternoonSlots = afternoonSlots;
    }

    @Override
    public String toString() {
        return "Message{" +
                "from='" + from + '\'' +
                ", idBeach='" + idBeach + '\'' +
                ", morningSlots='" + morningSlots + '\'' +
                ", afternoonSlots='" + afternoonSlots + '\'' +
                ", content='" + content + '\'' +
                '}';
    }
}

