package rmuti.runnerapp.config;

public class Config {

    public static final int DASHBOARD_MOREDATA_SIZE = 10;

    public static final double STORE_DISTANCE = 10.0;

    public static final String MEDIATYPE_UTF8_JSON = "application/json;charset=UTF-8";

    public static final String[] ALLOW_API_PATH = new String[]{
            "/token_check",
            "/user_profile/save",
            "/notificationscreen/list"
    };

    public static final String[] ALLOW_URL = new String[]{
            "http://localhost:3000"};
}