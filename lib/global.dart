const bool isInDebug = true;

const String DEWARP_IMAGE = "Dewarp.bmp";
const String ID_BMP_0 = "projector.png";
const String ID_BMP_1 = "BMP_ID1_ON.bmp";
const String ID_BMP_2 = "BMP_ID2_ON.bmp";
const String ID_BMP_3 = "BMP_ID3_ON.bmp";

const String APPBARID0_PNG = "pj.png";
const String APPBARID1_PNG = "BMP_ID1.png";
const String APPBARID2_PNG = "BMP_ID2.png";
const String APPBARID3_PNG = "BMP_ID3.png";

const String PRO_MODEL_LIST1 = "7M2P051";
const String PRO_MODEL_LIST2 = "7M4P051";

const String STATUS_ON = "ON";
const String STATUS_OFF = "OFF";
const String COMPANY_NAME = "Elite Screens Visual & Sound Co.,Ltd";
const String MOSICGO_NAME = "Movies Music Power GO ™";
const String COMPANY_URL = "https://www.eliteprojector.com";
const String COPYRIGHT = "Copyright © 2022";
const String DEWARPING_NAME = "Aflex™ DeWarping Version:";
const String TITLE_NAME = "MOSICGO\u24C7 Projector";
const String MSG_WAIT_DEVICE_READY = "Wainting for Projector Ready";
const String MSG_GET_DEVICEID = "Request ID";
const String MSG_WAIT_BT_READY = "Wainting for Bluetooth Ready";
const String MSG_UPDATE = "Please go to Store to check it out!";
const String MSG_WRONG_USER = "Wrong User !!";
const String MSG_WRONG_PASSWORD = "Wrong Password !!";
const String DEFAULT_USERNAME = "admin";
const String DEFAULT_PASSWORD = "admin";
const String MSG_BTAUDIO_ON = 'BT Audio ON';
const String MSG_BTAUDIO_OFF = 'BT Audio OFF';

const int CONNECT_TIMEOUT = 40;
const int BT_TIMEOUT = 5;
const int SCAN_TIMEOUT = 4;
const int GETID_TIMEOUT = 10;
const int IDLE_TIMEOUT = 7200; //60*60*2= 2 hour,
const int BTSWITCHING_TIMEOUT = 15;
bool BT_connected = false;
var ports = <String>[];
var selectedPort = '';
String statusText = "Port Not Open";
String MCU_ver = "";
