package utility;

public class ResultMessage {
    private final boolean result;
    private final String message;

    public ResultMessage(boolean result, String message) {
        this.result = result;
        if(message.contains("noproc")){
            this.message = "Server offline, try later!";
        }else{
            this.message = message.replace("\"", "");
        }
    }

    public boolean isResult() {
        return result;
    }

    public String getMessage() {
        return message;
    }
}
