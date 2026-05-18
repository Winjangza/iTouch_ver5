import QtQuick 2.12
import QtQuick.Window 2.12
//import QtQuick.VirtualKeyboard 2.4
import QtQuick.Controls 2.12
import QtQuick3D.Effects 1.15
import QtQuick.Layouts 1.15
import QtWebSockets 1.0
import QtGraphicalEffects 1.0
import QtQuick.VirtualKeyboard 2.15
import QtQuick.VirtualKeyboard.Styles 2.15
import QtQuick.VirtualKeyboard.Settings 2.15
import QtQuick.Extras 1.4
import QtCharts 2.2
import Qt.labs.settings 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 600
    property int userLevel: 0
    signal getScreenshot()
    property string serverAddress: "127.0.0.1"
    property var socketPort: 0
    property string socketUrl: "ws://"+ serverAddress + ":" + socketPort.toString()
    property bool sockStart: false
    property var objectName: []
    property string userTypeMaster: "MASTER"
    property string userTypeSlave: "SLAVE"
    property var keyboardLayout: inputPanel.keyboard.layout
    property string mainBarMasterSelect
    property string mainBarSlaveSelect
    property string usertypeMaster:""
    property string usertypeSlave:""
    property bool usertypeSelect
    property bool usertypeSelectMaster: true
    property bool usertypeSelectSlave: false
    property string currentUserType: userTypeMaster
    signal qmlCommand(string msg)
    property string currentField: ""
    property bool userEditing: false
    property string amontOfMarginA: ""
    property string amontOfMarginB: ""
    property string amontOfMarginC: ""
    signal updateField(string fieldName, string value)
    property string datetime: ""
    property string textforInformation: textInformation.text
    property int dacLevel:1
    property int patternLevel: 1  // ค่าเริ่มต้น
    property int displayLight: 1
    property bool statusA
    property int numberA: 0
    property int num_listA: 0
    property double distanceA: 0
    property string detailA: ""
    property string phaseA: ""
    property bool statusB
    property int numberB: 0
    property int num_listB: 0
    property double distanceB: 0
    property string detailB: ""
    property string phaseB: ""
    property bool statusC
    property int numberC: 0
    property int num_listC: 0
    property double distanceC: 0
    property string detailC: ""
    property string phaseC: ""
    property bool checkedStates: false
    property var listdatatebleA : []
    property var listdatatebleB : []
    property var listdatatebleC : []
    property bool isTableCleared: false;
    property double editDistanceA: 0
    property string editDetailA: ""
    property int listMarginA: 0
    property string marginA: ""
    property int valueMarginA: 0
    property string unitMaginA: ""
    property bool statusMaginA
    property int maxMarginA: 0
    property int autoValueVoltageA: 0

    property int listMarginB: 0
    property string marginB: ""
    property int valueMarginB: 0
    property string unitMaginB: ""
    property bool statusMaginB
    property int maxMarginB: 0
    property int autoValueVoltageB: 0

    property int listMarginC: 0
    property string marginC: ""
    property int valueMarginC: 0
    property string unitMaginC: ""
    property bool statusMaginC
    property int maxMarginC: 0
    property int autoValueVoltageC: 0

    property string updateTimePeriodic: ""
    property string loadfilename: ""

    property int expectedDataCount: 0
    property int receivedDataCount: 0
    property bool newListDataTaggingTables: false
    property bool interlockXY: false

    property var storageA:[]
    property var storageB : []

    property double valueThresholdA: 0.0
    property double valueThresholdB: 0.0
    property double valueThresholdC: 0.0

    property double distanceCursor: 0.0
    property string distanceCursorStr: ""

    property string voltageInfo: ""
    property string substationInfo: ""
    property string directionInfo: ""
    property string linenoInfo: ""


    property bool updataStatusOfButtonA : true
    property bool updataStatusOfButtonB : true
    property bool updataStatusOfButtonC : true
    property bool updataStatusOfPatternA : true
    property bool updataStatusOfPatternB : true
    property bool updataStatusOfPatternC : true
    property string time: ""
    property bool updateMonday
    property bool updateTuesday
    property bool updateWednesday
    property bool updateThursday
    property bool updateFriday
    property bool updateSaturday
    property bool updateSunday
    property bool plottingGraph:false
    property double minAxisX:0.0
    property double maxAxisX:0.0
    property double minAxisY:0.0
    property double maxAxisY:0.0
    property var voltageRawA: []
    property var distanceRawA: []
    property var distanceRawB: []
    property var voltageRawB: []
    property var distanceRawC: []
    property var voltageRawC: []
    property var distancePatternA: []
    property var voltagePatternA: []
    property var distancePatternB: []
    property var voltagePatternB: []
    property var distancePatternC: []
    property var voltagePatternC: []
    property var minDataSizeArray: []
    property var minDataSizeArrayPattern: []
    property string fileNamePattern: ""
    property string fileNameData: ""

    property bool hasDataA: false
    property bool hasDataB: false
    property bool hasDataC: false

    property var arr: []
    property string cursorposition: ""
    property double cursorleft: 0.0
    property double cursorright: 0.0
    property double updateNewDistance: 0.0
    property int taggingpointData: 0
    property string globalPhase: ""
    property bool globalStatus
    property int globalTempNum: 0
    property double globalDistance: 0.0
    property string globalDetail: ""
    property double positionX:0.0
    property double positionY:0.0
    property bool statusSystem
    property var dataPoinDatatA: []
    property var dataPointA: []  //var arrRawA
    property var arrRawA: []
    property var arrRawB: []
    property var arrRawC: []
    property var sagfactor
    property var sampling
    property var displayStart
    property var displayShow
    property double endOFDistance
    property var fulldistances

    property var plotDataAX: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,963,964,965,966,967,968,969,970,971,972,973,974,975,976,977,978,979,980,981,982,983,984,985,986,987,988,989,990,991,992,993,994,995,996,997,998,999,1000]
    property var plotDataAY: [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.10,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.20,0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.30,0.31,0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.40,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.50,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.60,0.61,0.62,0.63,0.64,0.65,0.66,0.67,0.68,0.69,0.70,0.71,0.72,0.73,0.74,0.75,0.76,0.77,0.78,0.79,0.80,0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,0.100,0.101,0.102,0.103,0.104,0.105,0.106,0.107,0.108,0.109,0.110,0.111,0.112,0.113,0.114,0.115,0.116,0.117,0.118,0.119,0.120,0.121,0.122,0.123,0.124,0.125,0.126,0.127,0.128,0.129,0.130,0.131,0.132,0.133,0.134,0.135,0.136,0.137,0.138,0.139,0.140,0.141,0.142,0.143,0.144,0.145,0.146,0.147,0.148,0.149,0.150,0.151,0.152,0.153,0.154,0.155,0.156,0.157,0.158,0.159,0.160,0.161,0.162,0.163,0.164,0.165,0.166,0.167,0.168,0.169,0.170,0.171,0.172,0.173,0.174,0.175,0.176,0.177,0.178,0.179,0.180,0.181,0.182,0.183,0.184,0.185,0.186,0.187,0.188,0.189,0.190,0.191,0.192,0.193,0.194,0.195,0.196,0.197,0.198,0.199,0.200,0.201,0.202,0.203,0.204,0.205,0.206,0.207,0.208,0.209,0.210,0.211,0.212,0.213,0.214,0.215,0.216,0.217,0.218,0.219,0.220,0.221,0.222,0.223,0.224,0.225,0.226,0.227,0.228,0.229,0.230,0.231,0.232,0.233,0.234,0.235,0.236,0.237,0.238,0.239,0.240,0.241,0.242,0.243,0.244,0.245,0.246,0.247,0.248,0.249,0.250,0.251,0.252,0.253,0.254,0.255,0.256,0.257,0.258,0.259,0.260,0.261,0.262,0.263,0.264,0.265,0.266,0.267,0.268,0.269,0.270,0.271,0.272,0.273,0.274,0.275,0.276,0.277,0.278,0.279,0.280,0.281,0.282,0.283,0.284,0.285,0.286,0.287,0.288,0.289,0.290,0.291,0.292,0.293,0.294,0.295,0.296,0.297,0.298,0.299,0.300,0.301,0.302,0.303,0.304,0.305,0.306,0.307,0.308,0.309,0.310,0.311,0.312,0.313,0.314,0.315,0.316,0.317,0.318,0.319,0.320,0.321,0.322,0.323,0.324,0.325,0.326,0.327,0.328,0.329,0.330,0.331,0.332,0.333,0.334,0.335,0.336,0.337,0.338,0.339,0.340,0.341,0.342,0.343,0.344,0.345,0.346,0.347,0.348,0.349,0.350,0.351,0.352,0.353,0.354,0.355,0.356,0.357,0.358,0.359,0.360,0.361,0.362,0.363,0.364,0.365,0.366,0.367,0.368,0.369,0.370,0.371,0.372,0.373,0.374,0.375,0.376,0.377,0.378,0.379,0.380,0.381,0.382,0.383,0.384,0.385,0.386,0.387,0.388,0.389,0.390,0.391,0.392,0.393,0.394,0.395,0.396,0.397,0.398,0.399,0.400,0.401,0.402,0.403,0.404,0.405,0.406,0.407,0.408,0.409,0.410,0.411,0.412,0.413,0.414,0.415,0.416,0.417,0.418,0.419,0.420,0.421,0.422,0.423,0.424,0.425,0.426,0.427,0.428,0.429,0.430,0.431,0.432,0.433,0.434,0.435,0.436,0.437,0.438,0.439,0.440,0.441,0.442,0.443,0.444,0.445,0.446,0.447,0.448,0.449,0.450,0.451,0.452,0.453,0.454,0.455,0.456,0.457,0.458,0.459,0.460,0.461,0.462,0.463,0.464,0.465,0.466,0.467,0.468,0.469,0.470,0.471,0.472,0.473,0.474,0.475,0.476,0.477,0.478,0.479,0.480,0.481,0.482,0.483,0.484,0.485,0.486,0.487,0.488,0.489,0.490,0.491,0.492,0.493,0.494,0.495,0.496,0.497,0.498,0.499,0.500,0.002,0.004,0.006,0.008,0.01,0.012,0.014,0.016,0.018,0.02,0.022,0.024,0.026,0.028,0.03,0.032,0.034,0.036,0.038,0.04,0.042,0.044,0.046,0.048,0.05,0.052,0.054,0.056,0.058,0.06,0.062,0.064,0.066,0.068,0.07,0.072,0.074,0.076,0.078,0.08,0.082,0.084,0.086,0.088,0.09,0.092,0.094,0.096,0.098,0.1,0.102,0.104,0.106,0.108,0.11,0.112,0.114,0.116,0.118,0.12,0.122,0.124,0.126,0.128,0.13,0.132,0.134,0.136,0.138,0.14,0.142,0.144,0.146,0.148,0.15,0.152,0.154,0.156,0.158,0.16,0.162,0.164,0.166,0.168,0.17,0.172,0.174,0.176,0.178,0.18,0.182,0.184,0.186,0.188,0.19,0.192,0.194,0.196,0.198,0.2,0.202,0.204,0.206,0.208,0.21,0.212,0.214,0.216,0.218,0.22,0.222,0.224,0.226,0.228,0.23,0.232,0.234,0.236,0.238,0.24,0.242,0.244,0.246,0.248,0.25,0.252,0.254,0.256,0.258,0.26,0.262,0.264,0.266,0.268,0.27,0.272,0.274,0.276,0.278,0.28,0.282,0.284,0.286,0.288,0.29,0.292,0.294,0.296,0.298,0.3,0.302,0.304,0.306,0.308,0.31,0.312,0.314,0.316,0.318,0.32,0.322,0.324,0.326,0.328,0.33,0.332,0.334,0.336,0.338,0.34,0.342,0.344,0.346,0.348,0.35,0.352,0.354,0.356,0.358,0.36,0.362,0.364,0.366,0.368,0.37,0.372,0.374,0.376,0.378,0.38,0.382,0.384,0.386,0.388,0.39,0.392,0.394,0.396,0.398,0.4,0.402,0.404,0.406,0.408,0.41,0.412,0.414,0.416,0.418,0.42,0.422,0.424,0.426,0.428,0.43,0.432,0.434,0.436,0.438,0.44,0.442,0.444,0.446,0.448,0.45,0.452,0.454,0.456,0.458,0.46,0.462,0.464,0.466,0.468,0.47,0.472,0.474,0.476,0.478,0.48,0.482,0.484,0.486,0.488,0.49,0.492,0.494,0.496,0.498,0.5,0.502,0.504,0.506,0.508,0.51,0.512,0.514,0.516,0.518,0.52,0.522,0.524,0.526,0.528,0.53,0.532,0.534,0.536,0.538,0.54,0.542,0.544,0.546,0.548,0.55,0.552,0.554,0.556,0.558,0.56,0.562,0.564,0.566,0.568,0.57,0.572,0.574,0.576,0.578,0.58,0.582,0.584,0.586,0.588,0.59,0.592,0.594,0.596,0.598,0.6,0.602,0.604,0.606,0.608,0.61,0.612,0.614,0.616,0.618,0.62,0.622,0.624,0.626,0.628,0.63,0.632,0.634,0.636,0.638,0.64,0.642,0.644,0.646,0.648,0.65,0.652,0.654,0.656,0.658,0.66,0.662,0.664,0.666,0.668,0.67,0.672,0.674,0.676,0.678,0.68,0.682,0.684,0.686,0.688,0.69,0.692,0.694,0.696,0.698,0.7,0.702,0.704,0.706,0.708,0.71,0.712,0.714,0.716,0.718,0.72,0.722,0.724,0.726,0.728,0.73,0.732,0.734,0.736,0.738,0.74,0.742,0.744,0.746,0.748,0.75,0.752,0.754,0.756,0.758,0.76,0.762,0.764,0.766,0.768,0.77,0.772,0.774,0.776,0.778,0.78,0.782,0.784,0.786,0.788,0.79,0.792,0.794,0.796,0.798,0.8,0.802,0.804,0.806,0.808,0.81,0.812,0.814,0.816,0.818,0.82,0.822,0.824,0.826,0.828,0.83,0.832,0.834,0.836,0.838,0.84,0.842,0.844,0.846,0.848,0.85,0.852,0.854,0.856,0.858,0.86,0.862,0.864,0.866,0.868,0.87,0.872,0.874,0.876,0.878,0.88,0.882,0.884,0.886,0.888,0.89,0.892,0.894,0.896,0.898,0.9,0.902,0.904,0.906,0.908,0.91,0.912,0.914,0.916,0.918,0.92,0.922,0.924,0.926,0.928,0.93,0.932,0.934,0.936,0.938,0.94,0.942,0.944,0.946,0.948,0.95,0.952,0.954,0.956,0.958,0.96,0.962,0.964,0.966,0.968,0.97,0.972,0.974,0.976,0.978,0.98,0.982,0.984,0.986,0.988,0.99,0.992,0.994,0.996,0.998,1.0]
    property var plotDataBX: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500]
    property var plotDataBY: [0.002,0.004,0.006,0.008,0.01,0.012,0.014,0.016,0.018,0.02,0.022,0.024,0.026,0.028,0.03,0.032,0.034,0.036,0.038,0.04,0.042,0.044,0.046,0.048,0.05,0.052,0.054,0.056,0.058,0.06,0.062,0.064,0.066,0.068,0.07,0.072,0.074,0.076,0.078,0.08,0.082,0.084,0.086,0.088,0.09,0.092,0.094,0.096,0.098,0.1,0.102,0.104,0.106,0.108,0.11,0.112,0.114,0.116,0.118,0.12,0.122,0.124,0.126,0.128,0.13,0.132,0.134,0.136,0.138,0.14,0.142,0.144,0.146,0.148,0.15,0.152,0.154,0.156,0.158,0.16,0.162,0.164,0.166,0.168,0.17,0.172,0.174,0.176,0.178,0.18,0.182,0.184,0.186,0.188,0.19,0.192,0.194,0.196,0.198,0.2,0.202,0.204,0.206,0.208,0.21,0.212,0.214,0.216,0.218,0.22,0.222,0.224,0.226,0.228,0.23,0.232,0.234,0.236,0.238,0.24,0.242,0.244,0.246,0.248,0.25,0.252,0.254,0.256,0.258,0.26,0.262,0.264,0.266,0.268,0.27,0.272,0.274,0.276,0.278,0.28,0.282,0.284,0.286,0.288,0.29,0.292,0.294,0.296,0.298,0.3,0.302,0.304,0.306,0.308,0.31,0.312,0.314,0.316,0.318,0.32,0.322,0.324,0.326,0.328,0.33,0.332,0.334,0.336,0.338,0.34,0.342,0.344,0.346,0.348,0.35,0.352,0.354,0.356,0.358,0.36,0.362,0.364,0.366,0.368,0.37,0.372,0.374,0.376,0.378,0.38,0.382,0.384,0.386,0.388,0.39,0.392,0.394,0.396,0.398,0.4,0.402,0.404,0.406,0.408,0.41,0.412,0.414,0.416,0.418,0.42,0.422,0.424,0.426,0.428,0.43,0.432,0.434,0.436,0.438,0.44,0.442,0.444,0.446,0.448,0.45,0.452,0.454,0.456,0.458,0.46,0.462,0.464,0.466,0.468,0.47,0.472,0.474,0.476,0.478,0.48,0.482,0.484,0.486,0.488,0.49,0.492,0.494,0.496,0.498,0.5,0.502,0.504,0.506,0.508,0.51,0.512,0.514,0.516,0.518,0.52,0.522,0.524,0.526,0.528,0.53,0.532,0.534,0.536,0.538,0.54,0.542,0.544,0.546,0.548,0.55,0.552,0.554,0.556,0.558,0.56,0.562,0.564,0.566,0.568,0.57,0.572,0.574,0.576,0.578,0.58,0.582,0.584,0.586,0.588,0.59,0.592,0.594,0.596,0.598,0.6,0.602,0.604,0.606,0.608,0.61,0.612,0.614,0.616,0.618,0.62,0.622,0.624,0.626,0.628,0.63,0.632,0.634,0.636,0.638,0.64,0.642,0.644,0.646,0.648,0.65,0.652,0.654,0.656,0.658,0.66,0.662,0.664,0.666,0.668,0.67,0.672,0.674,0.676,0.678,0.68,0.682,0.684,0.686,0.688,0.69,0.692,0.694,0.696,0.698,0.7,0.702,0.704,0.706,0.708,0.71,0.712,0.714,0.716,0.718,0.72,0.722,0.724,0.726,0.728,0.73,0.732,0.734,0.736,0.738,0.74,0.742,0.744,0.746,0.748,0.75,0.752,0.754,0.756,0.758,0.76,0.762,0.764,0.766,0.768,0.77,0.772,0.774,0.776,0.778,0.78,0.782,0.784,0.786,0.788,0.79,0.792,0.794,0.796,0.798,0.8,0.802,0.804,0.806,0.808,0.81,0.812,0.814,0.816,0.818,0.82,0.822,0.824,0.826,0.828,0.83,0.832,0.834,0.836,0.838,0.84,0.842,0.844,0.846,0.848,0.85,0.852,0.854,0.856,0.858,0.86,0.862,0.864,0.866,0.868,0.87,0.872,0.874,0.876,0.878,0.88,0.882,0.884,0.886,0.888,0.89,0.892,0.894,0.896,0.898,0.9,0.902,0.904,0.906,0.908,0.91,0.912,0.914,0.916,0.918,0.92,0.922,0.924,0.926,0.928,0.93,0.932,0.934,0.936,0.938,0.94,0.942,0.944,0.946,0.948,0.95,0.952,0.954,0.956,0.958,0.96,0.962,0.964,0.966,0.968,0.97,0.972,0.974,0.976,0.978,0.98,0.982,0.984,0.986,0.988,0.99,0.992,0.994,0.996,0.998,1.0]
    property var plotDataAX1: [1,2,3,4,5]
    property var plotDataAY1: [100,200,300,400,500]
    property var currentMarginCountA:0
    property int focusIndex : -1
    property bool communication_error
    property bool gps_module_fail
    property bool internal_phase_A_error
    property bool internal_phase_B_error
    property bool internal_phase_C_error
    property bool lfl_operate
    property bool lfl_fail
    property bool manual_test_event
    property bool module_hi_speed_phase_A_error
    property bool module_hi_speed_phase_B_error
    property bool module_hi_speed_phase_C_error
    property bool periodic_test_event
    property bool plc_di_error
    property bool plc_do_error
    property bool relay_start_event
    property bool surage_start_event
    property bool system_initial
    property string deviceMode: ""
    property string ip_address: ""
    property string ip_gateway: ""
    property string ip_snmp: ""
    property string ip_timeserver: ""
    property string userMode: ""
    property string remoteMonitor: ""
    property var updateMarginA
    property var updateMarginB
    property var updateMarginC
    property string detailwireInformation: ""
    property var propertyLength : 0
    property bool alarm_plc_do_error
    property bool alarm_plc_di_error
    property bool alarm_communication_error
    property bool alarm_gps_module_fail
    property bool alarm_internal_phase_A_error
    property bool alarm_internal_phase_B_error
    property bool alarm_internal_phase_C_error
    property bool alarm_lfl_operate
    property bool alarm_lfl_fail
    property bool alarm_module_hi_speed_phase_A_error
    property bool alarm_module_hi_speed_phase_B_error
    property bool alarm_module_hi_speed_phase_C_error
    property bool alarm_system_initial
    property bool alarm_manual_test_event
    property bool alarm_periodic_test_event
    property bool alarm_relay_start_event
    property bool alarm_surage_start_event
    property string timeEventAlarm: ""
    signal sendEventToTable(string date, string time, string message, string priority)
    property var eventListeners:[];
    property var fullEventDataRelayStart: []
    property var hiddenEventDataRelayStart: []

    property var fullEventDataPeriodicStart: []
    property var hiddenEventDataPeriodicStart: []

    property var fullEventDataManualStart: []
    property var hiddenEventDataManualStart: []

    property var fullEventDataSurgeStart: []
    property var hiddenEventDataSurgeStart: []
    property var fullEventData: []
    property var modelInited: false

    property var __relayBackupHistory : null;
    property var __relayBackupLog     : null;

    property var __manualBackupHistory   : null;
    property var __manualBackupLog       : null;

    property var __periodicBackupHistory : null;
    property var __periodicBackupLog     : null;

    property var __surgeBackupHistory    : null;
    property var __surgeBackupLog        : null;

    property var __historyBackup : null;
    property var hiddenEventData: []
    property var filteredData: []
    property int maxHistoryItems: 100
    property int maxEventItems: 100
    property var eventShadow: []
    property var historyShadow: []
    property bool eventFilterEnabled: false
    property bool eventFilterRelayActive: false
    property bool eventFilterPeriodicActive: false
    property bool eventFilterManualActive: false
    property bool eventFilterSurgeActive: false

    property bool showRelayStart: true
    property bool showPeriodicStart: true
    property bool showManualStart: true
    property bool showSurgeStart: true

    property double realDistanceA: 0.0
    property double realDistanceB: 0.0
    property double realDistanceC: 0.0
    property bool statusLFLFails
    property bool statusLFLOperates
    property var distancePointA:0
    property var distancePointB:0
    property var distancePointC:0

    property bool isDataAReady : false;
    property bool isDataBReady : false;
    property bool isDataCReady : false;

    property var numOfTagging:0
    property string remoteMode: ""
    property var getDeviceIndex
    property bool refresh: false
    property bool refreshPattern: false
    property bool checkGraphDone:false
    property var trapsAlertEvent
    property string currentPage: "MainPage"
    property int contorlAndMonitorPercentPlot: contorlAndMonitor.percentPlot
    property int currentUserLevel: 0
    property var transmissionLineA: ""
    property double fullDistanceA: 0.0
    property var transmissionLineB: ""
    property double fullDistanceB: 0.0
    property var transmissionLineC: ""
    property double fullDistanceC: 0.0
    property double fullDistance3Phase: 0.0
    property string openFilePattern: ""

    property string fullnameCSV: ""

    property var phaseTower: ""
    property var socketConnectToCpp:""
    property bool screenshotSent: false  // ✅ เพิ่มตัวแปรกันซ้ำ
    property var numPointOfLFL:0
    property double distanceInfoSetting:0.0
    property string detailInfoSetting:""
    property var incomingFullBatch: [];
    property var refreshPatternTimerInterval:5000;
    property bool isBackToMainPage: false
    property bool interlogLogOut: false
    property string userleveltype: ""
    property string userloginby: ""
    property string ipAddressOfiTouch: ""
    property string ipGatewatOfiTouch: ""
    property bool showPatternPlot : false;
    property double zoomValueRecord:0.0
    property int lastZoomVoltage: 0

    property double backupLastZoom: 0.0
    property real yGraphOffset: 200
    property bool unscreenshotTimer : true;
    property bool vncModeDisplay : false;
//    property var linesDrawn: 0;

    property bool connectForunlockCapture : false;

    property bool lockPageWhileTagging: false
    property var requestedDistancesA: []
    property var closestDistancesA: []
    property var taggingVoltagesA: []

    property var requestedDistancesB: []
    property var closestDistancesB: []
    property var taggingVoltagesB: []

    property var requestedDistancesC: []
    property var closestDistancesC: []
    property var taggingVoltagesC: []

    property int activeTaggingNumberA: 0
    property int activeTaggingNumberB: 0
    property int activeTaggingNumberC: 0

    property string activeTaggingDetailA: ""
    property string activeTaggingDetailB: ""
    property string activeTaggingDetailC: ""

    property double activeTaggingDistanceA: 0
    property double activeTaggingDistanceB: 0
    property double activeTaggingDistanceC: 0

    property bool refreshDataStorage:false

    property real minDistance: 0.0
    property real maxDistance: 0.0
    property real minVoltage:  0.0
    property real maxVoltage:  0.0
    property real voltageOffset:  0.0
    property real maxVoltageWithOffset:  0.0


    property string userTypeMode: ""
    property string ip_PLC: ""
    property string swversionupdate: ""

    property string remoteMessageReset: ""
    property bool timeoutTriggered: false

    property bool buttonNoCap: true
    property bool interlockPeriodic: true
    property string periodicwarning: ""
    property string localT: ""
    property string diffMin: ""
    property string diffText: ""

    // ===== periodic popup remind state =====
    property bool periodicRemindActive: false
    property string periodicAcceptedLocalSnapshot: ""   // local time ณ ตอนกด OK
    property string periodicLastRemote: ""
    property string periodicLastLocal: ""
    property int periodicLastDiffMin: 0
    property string guiPeriodicTime: ""
    property string periodicLastIssueKey: ""

//patternLevel
    onCheckGraphDoneChanged: {
//        if (!fileNamePattern && !fileNameData && !screenshotSent) {
//            screenshotSent = true;
//            screenshotTimer.start();
//        }
    }
    Timer {
        id: periodicRemindTimer
        interval: 10 * 60 * 1000   // 10 minutes
        repeat: true
        running: false

        onTriggered: {
            if (!periodicRemindActive) {
                stop()
                return
            }

            if ((periodicLastLocal || "") === (periodicAcceptedLocalSnapshot || "")) {
                console.log("⏰ Periodicwarning REMIND: local time not updated yet -> reopen popup",
                            "snapshot=", periodicAcceptedLocalSnapshot,
                            "currentLocal=", periodicLastLocal)

                popupWarningPeriodic.modeLocal = deviceMode || ""
                popupWarningPeriodic.recordPeriodicRaw = periodicLastRemote
                popupWarningPeriodic.localPeriodicRaw = periodicLastLocal
                popupWarningPeriodic.diffMin = periodicLastDiffMin
                popupWarningPeriodic.popupinterlockPeriodic = true
            } else {
                console.log("✅ Periodicwarning REMIND: local time updated -> stop remind",
                            "snapshot=", periodicAcceptedLocalSnapshot,
                            "currentLocal=", periodicLastLocal)
                periodicRemindActive = false
                stop()
            }
        }
    }
    Timer {
        id: timerInterlogPopup
        interval: 1000
        repeat: false
        onTriggered: {
            remotePopup.close();
        }
    }

//    Timer {
//        id: screenshotTimer
//        interval: 1000 //5000
//        repeat: false
//        onTriggered: {
//            console.log("Timer triggered");

//            currentPage = "MainPage";
//            mainBar.mainListView.currentIndex = -1;
//            returntoMainPage.start();
//        }
//    }
    Timer {
        id: screenshotTimer
        interval: 1000
        repeat: false
        onTriggered: {
            console.log("Timer triggered, currentPage =", currentPage,
                        "lockPageWhileTagging =", lockPageWhileTagging)

            if (lockPageWhileTagging ||
                currentPage === "DataTaggingPage" ||
                currentPage === "DataTaggingPhaseA" ||
                currentPage === "DataTaggingPhaseB" ||
                currentPage === "DataTaggingPhaseC") {
                console.log("screenshotTimer ignored because tagging page is active")
                stop()
                return
            }

            currentPage = "MainPage"
            mainBar.mainListView.currentIndex = -1
            returntoMainPage.start()
        }
    }
    Timer {
        id: returntoMainPage
        interval: 1000
        repeat: true
        onTriggered: {
            console.log("Checking if back to MainPage...");
            if (currentPage === "MainPage" && mainBar.mainListView.currentIndex === -1) {
                isBackToMainPage = true;
                returntoMainPage.stop();

                var Screenshot = JSON.stringify({
                    "objectName": "Screenshot",
                    "onClicked": "true"
                });
                console.log("ScreenShotStart:", Screenshot);
                qmlCommand(Screenshot);
                screenshotTimer.stop()
            }
        }
    }
//    Timer {
//        id: screenshotTimer
//        interval: 5000
//        repeat: false
//        onTriggered: {
//            currentPage = "MainPage";
//            mainBar.mainListView.currentIndex = -1;
//            var Screenshot = JSON.stringify({
//                "objectName": "Screenshot",
//                "onClicked": "true"
//            });
//            console.log("ScreenShotStart:", Screenshot);
//            qmlCommand(Screenshot);
//            screenshotTimer.running = false
//        }
//    }


    Timer {
        id: refreshTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            console.log("refresh_before:",refresh)
            refresh = !refresh;
            console.log("refresh_after:",refresh)
        }
    }

    Timer {
        id: refreshPatternTimer
        interval: refreshPatternTimerInterval
        running: false
        repeat: false
        onTriggered: {
            console.log("refreshPatternTimer triggered",refreshPatternTimerInterval);
            refreshPattern = !refreshPattern;
            refreshPatternTimerInterval= 1000
        }
    }

    Timer {
        id: timerConnectSocket
        interval: 5000
        running: false
        repeat: false
        onTriggered: {
                qmlCommand(socketConnectToCpp)
                console.log("connect_to_cpp:");

        }
    }
    QtObject {
        id: remotepopUp
        property string remoteMessage: "REMOTE FROM VNC"
    }

//    ListModel {
//        id: remotepopUp
//        property string remoteMessage: "REMOTE FROM VNC"
//    }
    ListModel {
        id: disconnectpopup
        property string remoteMessageReset: "DISCONNECTED FROM SERVER"
    }

    ListModel {
        id: testGraph
        property var nameX: plotDataAX
        property var nameY: plotDataAY
    }

    ListModel {
         id: scatterModel
     }

    ListModel {
        id: newlistdatatebleA
        property bool list_statusA: false
        property int list_numberA: 0
        property int num_listA: 0
        property double list_distanceA: 0.0
        property string list_detailA: ""
        property string list_phaseA: ""
        property double ampiltudeVol: 0.00

    }

    ListModel {
        id:newlistdatatebleB
        property bool list_statusB: false
        property int list_numberB: 0
        property int num_listB: 0
        property double list_distanceB: 0.0
        property string list_detailB: ""
        property string list_phaseB: ""
    }
    ListModel {
        id:newlistdatatebleC
        property bool list_statusC: false
        property int list_numberC: 0
        property int num_listC: 0
        property double list_distanceC: 0.0
        property string list_detailC: ""
        property string list_phaseC: ""
    }

    ListModel {
        id: newlistMarginA
        property int voltageIndex:-1 // เปลี่ยนชื่อให้ตรงกัน
        property int list_marginA: 0  // เปลี่ยนชื่อให้ตรงกัน
        property string marginA: ""
        property int valueMarginA: 0
        property string unitMaginA: ""
        property bool statusMaginA: false
    }
    ListModel {
        id: newlistMarginB
        property int voltageIndex:-1 // เปลี่ยนชื่อให้ตรงกัน
        property int list_marginB: 0  // เปลี่ยนชื่อให้ตรงกัน
        property string marginB: ""
        property int valueMarginB: 0
        property string unitMaginB: ""
        property bool statusMaginB: false
    }
    ListModel {
        id: newlistMarginC
        property int voltageIndex:-1 // เปลี่ยนชื่อให้ตรงกัน
        property int list_marginC: 0  // เปลี่ยนชื่อให้ตรงกัน
        property string marginC: ""
        property int valueMarginC: 0
        property string unitMaginC: ""
        property bool statusMaginC: false
    }
    ListModel {
        id: eventAlarmLog
        property string datetimeEventandAlram: ""
        property string logDetailHistory: ""
        property bool statusEventandAlram
    }

    ListModel {
        id: eventAlarmHistoryLog
        property string datetimeEventandAlram: ""
        property string logDetailHistory: ""
        property bool statusEventandAlram
    }

    ListModel {
        id: patternDataStorage
        property string  event_datetime: ""
        property string  filename: ""
    }
    ListModel {
        id : periodicDataStorage
        property string  event_datetime: ""
        property string  filename: ""
    }
    ListModel {
        id : relayDataStorage
        property  string  event_datatime: ""
        property  string  filename: ""
    }
    ListModel {
        id : surgeDataStorage
        property  string event_dtaatime : ""
        property  string filename: ""
    }
    ListModel {
        id: userLevelGlobalVars
        property int userLevel: 3
    }
    ListModel {
        id: taggingModel
    }

    //         property string globalPhaseA: ""
    //         property bool globalStatusA: false
    //         property int globalTempNumA: 0
    //         property double globalDistanceA: 0.0
    //         property string globalDetailA: ""
    //         property int globalPositionX: 0 // Add X
    //         property int globalPositionY: 0 // Add Y

    //    function getTaggingData(positionX,positiony,globalTempNum) {
    //        var JsonObject = JSON.parse(data);
    //        var commandName = JsonObject.objectName;
    //        var pointerX = positionX;
    //        var pointerY = positiony;
    //        var globalNum = globalTempNum;
    //    }
        // Instance of ControlAndMonitor

    ListModel {
         id: taggingA
         property var listofTagging: []
         property int globalTempNumA: 0
         property int globalPositionX: 0 // Add X
         property int globalPositionY: 0 // Add Y
     }
    function returnToMainPageAndFreeRam() {
        console.log("[MainPage] returnToMainPageAndFreeRam");

        // ล้าง cache/page state ของหน้าปัจจุบันก่อน
        if (stackView.currentItem && stackView.currentItem.clearPageRam) {
            stackView.currentItem.clearPageRam();
        }

        // ล้าง temporary arrays ของ main ที่ rebuild ได้
        requestedDistancesA = []
        closestDistancesA = []
        taggingVoltagesA = []

        requestedDistancesB = []
        closestDistancesB = []
        taggingVoltagesB = []

        requestedDistancesC = []
        closestDistancesC = []
        taggingVoltagesC = []

        Qt.inputMethod.hide()
        inputPanel.visible = false
        textInformation.visible = false
        textInformation.focus = false

        // กลับไป root ของ stack จริง ๆ
        while (stackView.depth > 1) {
            stackView.pop();
        }
        if (lockPageWhileTagging ||
            currentPage === "DataTaggingPage" ||
            currentPage === "DataTaggingPhaseA" ||
            currentPage === "DataTaggingPhaseB" ||
            currentPage === "DataTaggingPhaseC") {
            console.log("[MainPage] skip returnToMainPageAndFreeRam because tagging page is active")
            return
        }

        currentPage = "MainPage"
        mainBar.mainListView.currentIndex = -1

        // reload เฉพาะหน้าหลัก
        contorlAndMonitor.reloadTaggingData()

        // ให้ QML เก็บกวาด object ที่ถูก pop ออก
        gc()
        Qt.callLater(function() {
            gc()
            console.log("[MainPage] RAM cleanup done");
        })
    }
    function getTaggingData(positionX, positionY, globalTempNum) {
        var pointerX = positionX;
        var pointerY = positionY;
        var globalNum = globalTempNum;

        // กันข้อมูลซ้ำ
        for (var i = 0; i < taggingA.count; ++i) {
            var item = taggingA.get(i);
            if (item.globalTempNumA === globalNum &&
                item.globalPositionX === pointerX &&
                item.globalPositionY === pointerY) {
                console.log("Tagging already exists, skip:", positionX, positionY, globalTempNum);
                return;
            }
        }

        taggingA.append({
            "globalTempNumA": globalNum,
            "globalPositionX": pointerX,
            "globalPositionY": pointerY
        });

        // คุมขนาดใน RAM
        while (taggingA.count > maxTaggingItems) {
            taggingA.remove(0);
        }

        console.log("Tagging data sent:", positionX, positionY, globalTempNum,
                    "count =", taggingA.count);
    }

    color: "#f2f2f2"
    title: qsTr("Hello World")


    StackView {
        id: stackView
        anchors.fill: parent
        anchors.topMargin: 0
        anchors.rightMargin: 0
        initialItem: Qt.resolvedUrl("qrc:/Mainpage.qml")
    }

    MainBar {
        id: mainBar
        x: 0
        y: 0
        width: 1024
        height: 52
    }
    ContorlAndMonitor {
        id: contorlAndMonitor
        x: 0
        y: 0
        visible: currentPage == "MainPage"
        plotminAxisX: minAxisX
        plotmaxAxisX: maxAxisX
        plotminAxisY: minAxisY
        plotmaxAxisY: maxAxisY
    }

    function goToLoginPage() {
        var loginPage = stackView.push("qrc:/LoginPage.qml");
        loginPage.userLoggedOut.connect(function() {
            mainBar.mainText3.text = "VIEWER";
            mainBar.mainText4.text = "LOCKED\nBY VIEWER";
            currentPage = "MainPage";
            stackView.pop();
        });
    }

    Popup {
        id: patternPopup
        x: 0
        y: 200
        width: 1024
        height: 200
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        z: 9999

        // 🔧 Custom properties
        property string remoteMessage: ""
        property bool state: false
    //        property bool touchToCloseEnabled: false

        // ✅ Background
        background: Rectangle {
            color: "#808080C0"
            radius: 10
        }

        // ✅ MouseArea to handle both mouse and touch
        MouseArea {
            id: closeAreaPattern
            anchors.fill: parent
            enabled: true
            visible: true
            z: 10000
            hoverEnabled: true
            preventStealing: false
            propagateComposedEvents: false
            acceptedButtons: Qt.AllButtons
            focus: true

            onPressed: {
                console.log("🟡 MouseArea PRESSED");
                qmlCommand('{"objectName":"canclePattern"}');
                patternPopup.close();
            }
        }

        Text {
            id: animatedTextPatternPopup
            anchors.centerIn: parent
            font.pixelSize: 50
            color: "white"
            property int state: 0

            text: state === 0 ? ">> " + patternPopup.remoteMessage + " <<" :
                  state === 1 ? "> " + patternPopup.remoteMessage + " <" :
                  patternPopup.remoteMessage

            // ปิดแอนิเมชัน
            SequentialAnimation on state {
                loops: Animation.Infinite
                running: false   // ⛔ stop animation
                PropertyAnimation { to: 1; duration: 300 }
                PropertyAnimation { to: 2; duration: 300 }
                PropertyAnimation { to: 0; duration: 300 }
            }

            // ปิดแอนิเมชันสี
            ColorAnimation on color {
                from: "white"
                to: "yellow"
                duration: 500
                loops: Animation.Infinite
                running: false   // ⛔ stop animation
            }
        }
        Timer {
            id: autoCloseTimerPattern
            interval: 10000
            running: false
            repeat: false
            onTriggered: {
                console.log("⏲️ patternPopup auto-closed by timer");
                patternPopup.close();
            }
        }
        onOpened: {
            console.log("patternPopup opened — enabling MouseArea");
            state = true;
        }

        onClosed: {
            console.log("patternPopup closed — disabling MouseArea");
            state = false;
        }
    }

    Popup {
        id: remotePopup
        x: 0
        y: 200
        width: 1024
        height: 200
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        z: 9999

        // 🔧 Custom properties
        property string remoteMessage: ""
        property bool state: false
    //        property bool touchToCloseEnabled: false

        // ✅ Background
        background: Rectangle {
            color: "#808080C0"
            radius: 10
        }

        // ✅ MouseArea to handle both mouse and touch
        MouseArea {
            id: closeArea
            anchors.fill: parent
            enabled: true
            visible: true
            z: 10000
            hoverEnabled: true
            preventStealing: false
            propagateComposedEvents: false
            acceptedButtons: Qt.AllButtons
            focus: true

            onPressed: {
                console.log("MouseArea PRESSED");
                    qmlCommand('{"objectName":"alive"}');
                remotePopup.close();
            }
        }

        Text {
            id: animatedText
            anchors.centerIn: parent
            font.pixelSize: 50
            color: "white"
            property int state: 0

            text: state === 0 ? ">> " + remotePopup.remoteMessage + " <<" :
                  state === 1 ? "> " + remotePopup.remoteMessage + " <" :
                  remotePopup.remoteMessage

            // ปิดแอนิเมชัน
            SequentialAnimation on state {
                loops: Animation.Infinite
                running: false   // ⛔ stop animation
                PropertyAnimation { to: 1; duration: 300 }
                PropertyAnimation { to: 2; duration: 300 }
                PropertyAnimation { to: 0; duration: 300 }
            }

            // ปิดแอนิเมชันสี
            ColorAnimation on color {
                from: "white"
                to: "yellow"
                duration: 500
                loops: Animation.Infinite
                running: false   // ⛔ stop animation
            }
        }
        Timer {
            id: autoCloseTimer
            interval: 10000
            running: false
            repeat: false
            onTriggered: {
                console.log("⏲️ remotePopup auto-closed by timer");
                remotePopup.close();
            }
        }
        onOpened: {
            console.log("remotePopup opened — enabling MouseArea");
            state = true;
        }

        onClosed: {
            console.log("remotePopup closed — disabling MouseArea");
            state = false;
        }
    }

    Popup {
        id: vncPopup

        width: parent ? parent.width : 1024
        height: parent ? parent.height : 768

        modal: true
        focus: true
        dim: true

        // ใช้ NoAutoClose เพื่อไม่ให้ popup ปิดเองก่อน MouseArea ส่ง command
        closePolicy: Popup.NoAutoClose

        z: 10050

        property string message: ""
        property bool state: false
        property bool clickLocked: false

        background: Rectangle {
            color: "#808080C0"
            border.color: "#ffaa00"
            border.width: 2
        }

        MouseArea {
            id: vncClickArea
            anchors.fill: parent
            z: 10000
            enabled: vncPopup.opened
            visible: true

            acceptedButtons: Qt.AllButtons
            preventStealing: true
            propagateComposedEvents: false

            // ใช้ onPressed แทน onClicked เพื่อให้ touch/mouse ส่งแน่นอนกว่า
            onPressed: {
                if (vncPopup.clickLocked) {
                    console.log("[vncPopup] click locked, skip")
                    return
                }

                vncPopup.clickLocked = true

                // กรณี REMOTE FROM VNC แล้วกด popup เพื่อ logout
                sendVncCommandOnce("VNClogout", vncPopup)
            }
        }

        Text {
            anchors.centerIn: parent
            text: vncPopup.message
            font.pixelSize: 48
            color: "orange"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        onOpened: {
            console.log("vncPopup opened — message:", message)
            state = true
            clickLocked = false
            forceActiveFocus()
        }

        onClosed: {
            console.log("vncPopup closed")
            state = false
            clickLocked = false
        }
    }

    Popup {
        id: loggingOutPopup

        x: 0
        y: 200
        width: 1024
        height: 200

        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose

        z: 10060

        property bool state: false
        property bool clickLocked: false

        background: Rectangle {
            color: "#800000C0"
            radius: 10
        }

        MouseArea {
            id: loggingOutClickArea
            anchors.fill: parent
            z: 10000
            enabled: loggingOutPopup.opened
            visible: true

            acceptedButtons: Qt.AllButtons
            preventStealing: true
            propagateComposedEvents: false

            // ใช้ onPressed แทน onClicked
            onPressed: {
                if (loggingOutPopup.clickLocked) {
                    console.log("[loggingOutPopup] click locked, skip")
                    return
                }

                loggingOutPopup.clickLocked = true

                // กดระหว่าง logging out เพื่อ login/alive กลับ
                sendVncCommandOnce("VNClogin", loggingOutPopup)
            }
        }

        Text {
            anchors.centerIn: parent
            font.pixelSize: 50
            color: "yellow"
            text: ">> Logging out <<"

            SequentialAnimation on color {
                loops: Animation.Infinite
                running: false
                ColorAnimation { from: "yellow"; to: "white"; duration: 500 }
                ColorAnimation { from: "white"; to: "yellow"; duration: 500 }
            }
        }

        onOpened: {
            console.log("loggingOutPopup opened")
            state = true
            clickLocked = false
            forceActiveFocus()
        }

        onClosed: {
            console.log("loggingOutPopup closed")
            state = false
            clickLocked = false
        }
    }
    Popup {
        id: disconnectPopup
        x: 0
        y: 0
        width: 1024
        height: 600
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        property string targetIP: ""
        property string monitortIP: ""
        property string remoteMessageReset: "Disconnected"
        property bool state: false

        background: Rectangle {
            color: "#808080C0"
            radius: 10
        }

        Timer {
            id: timeoutTimer
            interval: 20000
            repeat: false
            running: false

            onTriggered: {
                console.log("🔔 Timer triggered after 20s")
                if (!timeoutTriggered) {
                    timeoutTriggered = true
                    console.log("📢 Showing Return to Host DelayButton")
                    returnToHostButton.visible = true
                }
            }
        }

        onVisibleChanged: {
            console.log("📌 Popup visibility:", visible)
            if (visible) {
                timeoutTriggered = false
                timeoutTimer.start()
                returnToHostButton.visible = false
            } else {
                timeoutTimer.stop()
            }
        }

        Component.onCompleted: {
            if (disconnectPopup.visible) {
                timeoutTimer.start()
            }
        }

        // ✅ ข้อความหลักที่กระพริบ
        Text {
            id: animatedTextSetIP
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 50
            color: "white"

            property int state: 0

            text: state === 0 ? ">> " + disconnectPopup.remoteMessageReset + " <<" :
                  state === 1 ? "> " + disconnectPopup.remoteMessageReset + " <" :
                  disconnectPopup.remoteMessageReset

            // ปิดแอนิเมชัน
            SequentialAnimation on state {
                loops: Animation.Infinite
                running: false   // ⛔ stop animation
                PropertyAnimation { to: 1; duration: 300; easing.type: Easing.InOutQuad }
                PropertyAnimation { to: 2; duration: 300; easing.type: Easing.InOutQuad }
                PropertyAnimation { to: 0; duration: 300; easing.type: Easing.InOutQuad }
            }

            // ปิดแอนิเมชันสี
            ColorAnimation on color {
                from: "white"
                to: "yellow"
                duration: 500
                loops: Animation.Infinite
                easing.type: Easing.InOutQuad
                running: false   // ⛔ stop animation
            }
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: animatedTextSetIP.bottom
            anchors.topMargin: 20

            spacing: 10

            Text {
                text: "Target IP: " + disconnectPopup.targetIP
                font.pixelSize: 28
                color: "yellow"
                x: -80
                y: 120
            }

            Text {
                text: "Monitor IP: " + disconnectPopup.monitortIP
                font.pixelSize: 28
                color: "yellow"
                x: -80
                y: 160
            }

        }

        // ✅ ปุ่ม Hold to Reset IP
        DelayButton {
            id: delayButton
            x: 800
            y: 380
            height: 200
            width: 200
            text: "Hold to Reset IP"
            delay: 2000
            visible: true
            onActivated: {
                var resetIP = '{"objectName":"resetDefalutIP","defalutip": "192.168.1.4","defalutgateways": "192.168.1.254","defalutnetmask": "255.255.255.0"}'
                qmlCommand(resetIP);
                disconnectPopup.close();
                console.log("Reset IP triggered!");
            }
        }

        DelayButton {
            id: returnToHostButton
            x: 580
            y: 380
            height: 200
            width: 200
            text: "Can't Remote\nReturn to Host"
            delay: 1500
            visible: false
            onActivated: {
                qmlCommand('{"objectName":"ReturnToHost"}')
                console.log("Return to Host activated!")
            }
        }

        onOpened: {
            console.log("remotePopup opened — enabling MouseArea");
            state = true;
        }

        onClosed: {
            console.log("remotePopup closed — disabling MouseArea");
            state = false;
        }
    }




    ValueAxis {
        id: axisY
        min: 0
        max: 4095
        titleText: "<font color='#ffffff'>Voltage (mV)</font>"
        labelsVisible: true
        gridVisible: false
        color: "#ffffff"
        labelsColor: "#ffffff"
    }

    function qmlSubmitTextFiled(message){
//        var JsonObject = JSON.parse(message);
//        var objectName = JsonObject.objectName;
//        var TrapsAlert = JsonObject.TrapsAlert;
//        var menuID = JsonObject.objectName;
//        var eventRecord = JsonObject.eventRecord;
        console.log("qmlSubmitTextFiled raw message =", message)
        console.log("qmlSubmitTextFiled typeof =", typeof message)

        var JsonObject = null

        if (typeof message === "string") {
            try {
                JsonObject = JSON.parse(message)
            } catch (e) {
                console.log("JSON.parse error:", e)
                console.log("Invalid message was:", message)
                return
            }
        } else if (message && typeof message === "object") {
            JsonObject = message
        } else {
            console.log("qmlSubmitTextFiled: unsupported message =", message)
            return
        }

        var objectName = JsonObject.objectName !== undefined ? JsonObject.objectName : ""
        var TrapsAlert = JsonObject.TrapsAlert
        var menuID = JsonObject.menuID !== undefined ? JsonObject.menuID : objectName
        var eventRecord = JsonObject.eventRecord

        console.log("objectName =", objectName)
        console.log("menuID =", menuID)
//        console.log("receviceSocket:", message ,JsonObject,objectName,TrapsAlert,menuID,JSON.parse(message),JsonObject.objectName);

        if(message === true){
            statusSystem = message
//            console.log("receviceSocket:", message, statusSystem);
        }
        if (objectName === "UserSelectM") {
            console.log("UserSelectM:", message);
            mainBarMasterSelect = userTypeMaster;
            usertypeSelect = JsonObject.userStatusMaster
        }else if(menuID === 'system' || objectName === 'system'){
            console.log("system_qml:", message ,JsonObject.SwVersion,JsonObject.swversion)
//            swversionupdate = JsonObject.swversion
//            swversionupdate = JsonObject.SwVersion
            if(JsonObject.SwVersion){
                swversionupdate = JsonObject.SwVersion
            }else{
                swversionupdate = JsonObject.swversion
            }

            console.log("swversionupdate:", swversionupdate,JsonObject.swversion);

        }else if (objectName === 'GetSettingDisplay') {
            sagfactor       = JsonObject.sagFactorInit;
            sampling        = JsonObject.samplingRateInit;
            displayStart    = JsonObject.distanceToStartInit;
            displayShow     = JsonObject.distanceToShowInit;
            fulldistances    = JsonObject.fulldistancesInit;
            endOFDistance   = JsonObject.distanceToShowInit;
            console.log("displaySetting:", message, sagfactor, sampling, displayStart, displayShow, fulldistances);
        }else if (objectName === "userlavel"){
            console.log("userlavel:", message);
            userlavel(message);
        }else if (objectName === 'dataPloting') {
            // console.log("Debug_All_Phase_Rawdata_dataPloting:", message);
            showPatternPlot = false;
            buttonNoCap = false
            contorlAndMonitor.linesDrawn = 0;
            distanceRawA.splice(0, distanceRawA.length);
            voltageRawA.splice(0, voltageRawA.length);
            distanceRawB.splice(0, distanceRawB.length);
            voltageRawB.splice(0, voltageRawB.length);
            distanceRawC.splice(0, distanceRawC.length);
            voltageRawC.splice(0, voltageRawC.length);

            distanceRawA.splice(0, distanceRawA.length, ...(JsonObject.distanceA ?? []));
            voltageRawA.splice(0, voltageRawA.length, ...(JsonObject.voltageA ?? []));

            distanceRawB.splice(0, distanceRawB.length, ...(JsonObject.distanceB ?? []));
            voltageRawB.splice(0, voltageRawB.length, ...(JsonObject.voltageB ?? []));

            distanceRawC.splice(0, distanceRawC.length, ...(JsonObject.distanceC ?? []));
            voltageRawC.splice(0, voltageRawC.length, ...(JsonObject.voltageC ?? []));
            minDataSizeArray = JsonObject.baselineSize
            console.log("After setting: distanceRawA:", distanceRawA.length, "distanceRawB:", distanceRawB.length, "distanceRawC:", distanceRawC.length, minDataSizeArray);
            fileNameData = JsonObject.fileName;
            contorlAndMonitor.updateRawPlotFromWebSocket(JsonObject);
            if (fileNameData) {
                let parts = fileNameData.split("_");
                if (parts.length >= 2) {
                    fileNameData = parts[0] + "_" + parts[1];
                }
            }

            console.log("fileNameData (trimmed):", fileNameData);
            minAxisY = JsonObject.minVoltage
            maxAxisY = JsonObject.maxVoltage
            minAxisX = JsonObject.minDistance
            maxAxisX = JsonObject.maxDistance
            // console.log("After setting raw Data | A:", distancePatternA.length, "B:", distancePatternB.length, "C:", distancePatternC.length);
            // console.log("minAxisY:", minAxisY, "maxAxisY:", maxAxisY, "minAxisX:", minAxisX, "maxAxisX:", maxAxisX);
            // console.log("JsonObject.maxDistance:", JsonObject.maxDistance, "JsonObject.minDistance:", JsonObject.minDistance);
            connectForunlockCapture = true;
            buttonNoCap = false
//            if (refreshTimer.running)
//                refreshTimer.restart()
//            else
//                refreshTimer.running = true;

        }else if (objectName === 'dataSurge') {
//            console.log("Debug_All_Phase_dataSurge_dataSurge:", message);
            showPatternPlot = false;
            buttonNoCap = false
            console.log("Debug_All_Phase_dataSurge_dataSurge:"/*message*/,buttonNoCap);

//            contorlAndMonitor.linesDrawn = 0;
            isDataAReady = JsonObject.isDataAReady
            isDataBReady = JsonObject.isDataBReady
            isDataCReady = JsonObject.isDataCReady

            distanceRawA.splice(0, distanceRawA.length);
            voltageRawA.splice(0, voltageRawA.length);
            distanceRawB.splice(0, distanceRawB.length);
            voltageRawB.splice(0, voltageRawB.length);
            distanceRawC.splice(0, distanceRawC.length);
            voltageRawC.splice(0, voltageRawC.length);

            distanceRawA.splice(0, distanceRawA.length, ...(JsonObject.distanceA ?? []));
            voltageRawA.splice(0, voltageRawA.length, ...(JsonObject.voltageA ?? []));

            distanceRawB.splice(0, distanceRawB.length, ...(JsonObject.distanceB ?? []));
            voltageRawB.splice(0, voltageRawB.length, ...(JsonObject.voltageB ?? []));

            distanceRawC.splice(0, distanceRawC.length, ...(JsonObject.distanceC ?? []));
            voltageRawC.splice(0, voltageRawC.length, ...(JsonObject.voltageC ?? []));
            minDataSizeArray = JsonObject.baselineSize
            // console.log("After setting: distanceRawA:", distanceRawA.length, "distanceRawB:", distanceRawB.length, "distanceRawC:", distanceRawC.length, minDataSizeArray);
            fileNameData = JsonObject.fileName;
            contorlAndMonitor.updateRawPlotFromWebSocket(JsonObject);
            if (fileNameData) {
                let parts = fileNameData.split("_");
                if (parts.length >= 2) {
                    fileNameData = parts[0] + "_" + parts[1];
                }
            }
            console.log("fileNameData (trimmed):", fileNameData);
            minAxisY = JsonObject.minVoltage
            maxAxisY = JsonObject.maxVoltage
            minAxisX = JsonObject.minDistance
            maxAxisX = JsonObject.maxDistance
            // console.log("After setting raw Data | A:", distancePatternA.length, "B:", distancePatternB.length, "C:", distancePatternC.length);
            // console.log("minAxisY:", minAxisY, "maxAxisY:", maxAxisY, "minAxisX:", minAxisX, "maxAxisX:", maxAxisX);
            // console.log("JsonObject.maxDistance:", JsonObject.maxDistance, "JsonObject.minDistance:", JsonObject.minDistance);
            buttonNoCap = false
            if (refreshTimer.running)
                refreshTimer.restart()
            else
                refreshTimer.running = true;

        }else if  (objectName === "PatternData"){
             console.log("flie_record_PatternData:", JsonObject.filename,JsonObject.filename)
            appendDatStorage(message)
        }else if (objectName === "UserSelectS") {
            console.log("UserSelectS:", message)
            mainBarSlaveSelect = userTypeSlave;
            usertypeSelect = !JsonObject.userStatusSlave
        }else if (objectName === "DateTime") {
            datetime = JsonObject.formattedDateTime
            console.log("check Date and Time:", message,datetime);
        }else if (objectName === "positionDistance") {
            console.log("positionDistance:", message);
            distanceCursor = JsonObject.distance
            contorlAndMonitor.updateCursorFromExternal(distanceCursor)
        }else if (objectName ==="userlevel"){
            console.log("userlevel:", message);
            userlavel(message);
        }else if (objectName ==="updateTimeRemote"){
            updateTimePeriodic = JsonObject.Time
        }else if (objectName === "getDataTaggingPhaseA") {
            statusA = JsonObject.status ?? 0;
            numberA = JsonObject.temp_no ?? -1;
            num_listA = JsonObject.No ?? -1;
            distanceA = JsonObject.Distance ?? 0.0;
            detailA = JsonObject.Detail ?? "";
            phaseA = JsonObject.Phase ?? "";
            console.log("qmlTaggingPhaseA:", message);
            appendNewDataTableA(message);
        }else if (objectName === "TaggingPhaseA") {
            statusA = JsonObject.status ?? 0;
            numberA = JsonObject.temp_no ?? -1;
            num_listA = JsonObject.No ?? -1;
            distanceA = JsonObject.Distance
            detailA = JsonObject.Detail ?? "";
            phaseA = JsonObject.Phase ?? "";
            console.log("qmlupadataTaggingPhaseA:", message);
            appendNewDataTableA(message);
        }else if (objectName === "getDataTaggingPhaseB") {
            statusA = JsonObject.status ?? 0;
            numberA = JsonObject.temp_no ?? -1;
            num_listA = JsonObject.No ?? -1;
            distanceA = JsonObject.Distance
            detailA = JsonObject.Detail ?? "";
            phaseA = JsonObject.Phase ?? "";
            console.log("getDataTaggingPhaseB:", message);
            appendNewDataTableA(message)
        }else if (objectName === "TaggingPhaseB") {
            statusA = JsonObject.status ?? 0;
            numberA = JsonObject.temp_no ?? -1;
            num_listA = JsonObject.No ?? -1;
            distanceA = JsonObject.Distance
            detailA = JsonObject.Detail ?? "";
            phaseA = JsonObject.Phase ?? "";
            console.log("TaggingPhaseB:", message);
            appendNewDataTableA(message)
        }else if (objectName === "getDataTaggingPhaseC") {
            statusA = JsonObject.status ?? 0;
            numberA = JsonObject.temp_no ?? -1;
            num_listA = JsonObject.No ?? -1;
            distanceA = JsonObject.Distance
            detailA = JsonObject.Detail ?? "";
            phaseA = JsonObject.Phase ?? "";
            console.log("getDataTaggingPhaseC:", message);
            appendNewDataTableA(message)
        }else if (objectName === "TaggingPhaseC") {
            statusA = JsonObject.status ?? 0;
            numberA = JsonObject.temp_no ?? -1;
            num_listA = JsonObject.No ?? -1;
            distanceA = JsonObject.Distance
            detailA = JsonObject.Detail ?? "";
            phaseA = JsonObject.Phase ?? "";
            console.log("TaggingPhaseC:", message);
            appendNewDataTableA(message)
        }else if (objectName === "updatedataTableA") {
            statusA = JsonObject.status;
            numberA = JsonObject.temp_no || 0;
            num_listA = JsonObject.num_list || 0;
            distanceA = JsonObject.Distance || 0.0;
            detailA = JsonObject.Detail || "";
            phaseA = JsonObject.Phase || "";
            console.log("refreshTableDataA:", message);
            appendNewDataTableA(message);
        }else if (objectName === "updatedataTableB") {
            statusA = JsonObject.status !== undefined ? JsonObject.status : false;
            numberA = JsonObject.temp_no || 0;
            num_listA = JsonObject.num_list || 0;
            distanceA = JsonObject.Distance || 0.0;
            detailA = JsonObject.Detail || "";
            phaseA = JsonObject.Phase || "";
            console.log("updatedataTableB:", message);
            appendNewDataTableA(message);
        }else if (objectName === "updatedataTableC") {
            statusC = JsonObject.status !== undefined ? JsonObject.status : false;
            numberC = JsonObject.temp_no || 0;
            num_listC = JsonObject.num_list || 0;
            distanceC = JsonObject.Distance || 0.0;
            detailC = JsonObject.Detail || "";
            phaseC = JsonObject.Phase || "";
            console.log("updatedataTableC:", message);
            appendNewDataTableA(message);
        }else if(objectName === 'deletedcommand'){
            commandID = JsonObject.list_deviceID
            console.log("command from monitor",message , commandID)
            deletedCommand(message)
        }else if (objectName === 'editDataTaggingPhaseA') {
            console.log("editDataPhaseA", message);
            num_listA = JsonObject.IndexNum || 0;
            distanceA = JsonObject.Distance || 0.0;
            detailA = JsonObject.Detail || "";
            phaseA = JsonObject.Phase || "";
        }else if (objectName === 'editDataTaggingPhaseB') {
            console.log("editDataPhaseA", message);
            num_listB = JsonObject.IndexNum || 0;
            distanceB = JsonObject.Distance || 0.0;
            detailB = JsonObject.Detail || "";
            phaseB = JsonObject.Phase || "";
        }else if (objectName === 'editDataTaggingPhaseC') {
            console.log("editDataPhaseA", message);
            num_listC = JsonObject.IndexNum || 0;
            distanceC = JsonObject.Distance || 0.0;
            detailC = JsonObject.Detail || "";
            phaseC = JsonObject.Phase || "";
        }else if (objectName === 'marginlistCountA') {
            listMarginA = JsonObject.no || 0;
            marginA = JsonObject.marginNo || "";
            valueMarginA = JsonObject.valueOfMargin || 0.0;
            unitMaginA = JsonObject.unit || "";
            maxMarginA = JsonObject.maxmargin;
            console.log("QMLmarginCountA:",message,listMarginA,JsonObject.no,maxMarginA,JsonObject.maxmargin );
            appendNewMarginlistA(message);
        }else if (objectName === 'marginlistCountB') {
            listMarginB = JsonObject.no || 0;
            marginB = JsonObject.marginNo || "";
            valueMarginB = JsonObject.valueOfMargin || 0.0;
            unitMaginB = JsonObject.unit || "";
            maxMarginB = JsonObject.maxmargin;
            console.log("QMLmarginCountB:", message,listMarginB,JsonObject.no,maxMarginB,JsonObject.maxmargin );
            appendNewMarginlistB(message);
        }else if (objectName === 'marginlistCountC') {
            listMarginC = JsonObject.no || 0;
            marginC = JsonObject.marginNo || "";
            valueMarginC = JsonObject.valueOfMargin || 0.0;
            unitMaginC = JsonObject.unit || "";
            maxMarginC = JsonObject.maxmargin;
            console.log("QMLmarginCountC:", message,listMarginC,JsonObject.no,maxMarginC,JsonObject.maxmargin );
            appendNewMarginlistC(message);
        }else if (objectName === 'getThreshold') {
            console.log("getUpdateThreshold:", message);
            valueThresholdA = JsonObject.thresholdInitA || 0.0;
            valueThresholdB = JsonObject.thresholdInitB || 0.0;
            valueThresholdC = JsonObject.thresholdInitC || 0.0;
        }else if (objectName === 'getSettingInfo') {
            console.log("getSettingInfo:", message);

            voltageInfo = String(JsonObject.voltage || "");
            substationInfo = String(JsonObject.substation || "");
            directionInfo = String(JsonObject.direction || "");
            linenoInfo = String(JsonObject.line_no || "");

            if (typeof valueVoltage !== "undefined" && !valueVoltage.activeFocus)
                valueVoltage.text = voltageInfoSetting;

            if (typeof valueSubstation !== "undefined" && !valueSubstation.activeFocus)
                valueSubstation.text = substationInfoSetting;

            if (typeof valueDirection !== "undefined" && !valueDirection.activeFocus)
                valueDirection.text = directionInfoSetting;

            if (typeof valueLineNo !== "undefined" && !valueLineNo.activeFocus)
                valueLineNo.text = linenoInfoSetting;
        }else if (objectName === 'getPeriodicInfo') {
            time = JsonObject.Time || "";
            updateMonday = JsonObject.Monday;
            updateTuesday = JsonObject.Tuesday;
            updateWednesday = JsonObject.Wednesday;
            updateThursday = JsonObject.Thursday;
            updateFriday = JsonObject.Friday;
            updateSaturday = JsonObject.Saturday;
            updateSunday = JsonObject.Sunday;
            console.log("getPeriodicInfo:", message,updateMonday, updateTuesday, updateWednesday, JsonObject.Monday);
        }else if (objectName === 'getButtonStatus') {
            console.log("Received Button Status:", message);
            updataStatusOfButtonA = JsonObject.buttonA;
            updataStatusOfButtonB = JsonObject.buttonB;
            updataStatusOfButtonC = JsonObject.buttonC;
            updataStatusOfPatternA = JsonObject.buttonPatternA;
            updataStatusOfPatternB = JsonObject.buttonPatternB;
            updataStatusOfPatternC = JsonObject.buttonPatternC;
            // console.log("updataStatusOfButtonA:", updataStatusOfButtonA);
            // console.log("updataStatusOfButtonB:", updataStatusOfButtonB);
            // console.log("updataStatusOfButtonC:", updataStatusOfButtonC);
//            contorlAndMonitor.canvasPlot.requestPaint();
        }else if (objectName === 'ButtonPattern') {
            console.log("QML_receive_ButtonPattern:", message);

            var buttonAction = ""
            if (JsonObject && JsonObject.Onclicked !== undefined && JsonObject.Onclicked !== null)
                buttonAction = String(JsonObject.Onclicked).trim().toUpperCase()

            // NEW เท่านั้นที่เพิ่มเข้า list
            if (buttonAction === "NEW") {
                appendDatStorage(message)
            }

            // SAVE ให้แสดง popup แจ้งผู้ใช้
            else if (buttonAction === "SAVE") {
                var filename = ""
                if (JsonObject && JsonObject.filename !== undefined && JsonObject.filename !== null)
                    filename = String(JsonObject.filename).trim()

                if (filename !== "")
                    savePopUp.show("SAVE COMPLETE : " + filename)
                else
                    savePopUp.show("SAVE COMPLETE")
            }
        }else if (objectName === "patternData") {
            if (!JsonObject || typeof JsonObject !== "object") {
                console.log("patternData: JsonObject invalid =", JsonObject)
                return
            }

            function toSafeArray(v) {
                if (Array.isArray(v))
                    return v
                if (v === undefined || v === null)
                    return []
                if (typeof v.length === "number") {
                    var arr = []
                    for (var i = 0; i < v.length; ++i)
                        arr.push(v[i])
                    return arr
                }
                return []
            }

            const safeDistancePatternA = toSafeArray(JsonObject.distancePatternA)
            const safeVoltagePatternA  = toSafeArray(JsonObject.voltagePatternA)

            const safeDistancePatternB = toSafeArray(JsonObject.distancePatternB)
            const safeVoltagePatternB  = toSafeArray(JsonObject.voltagePatternB)

            const safeDistancePatternC = toSafeArray(JsonObject.distancePatternC)
            const safeVoltagePatternC  = toSafeArray(JsonObject.voltagePatternC)

            distancePatternA.splice(0, distancePatternA.length)
            voltagePatternA.splice(0, voltagePatternA.length)
            distancePatternB.splice(0, distancePatternB.length)
            voltagePatternB.splice(0, voltagePatternB.length)
            distancePatternC.splice(0, distancePatternC.length)
            voltagePatternC.splice(0, voltagePatternC.length)

            for (var i = 0; i < safeDistancePatternA.length; ++i)
                distancePatternA.push(safeDistancePatternA[i])
            for (var j = 0; j < safeVoltagePatternA.length; ++j)
                voltagePatternA.push(safeVoltagePatternA[j])

            for (var k = 0; k < safeDistancePatternB.length; ++k)
                distancePatternB.push(safeDistancePatternB[k])
            for (var l = 0; l < safeVoltagePatternB.length; ++l)
                voltagePatternB.push(safeVoltagePatternB[l])

            for (var m = 0; m < safeDistancePatternC.length; ++m)
                distancePatternC.push(safeDistancePatternC[m])
            for (var n = 0; n < safeVoltagePatternC.length; ++n)
                voltagePatternC.push(safeVoltagePatternC[n])

            minDataSizeArrayPattern =
                    (JsonObject.baselineSize !== undefined && JsonObject.baselineSize !== null)
                    ? JsonObject.baselineSize : 0

            console.log("After setting Pattern Data | A:", distancePatternA.length,
                        "B:", distancePatternB.length,
                        "C:", distancePatternC.length)

            console.log("Pattern Data raw | distancePatternA:", safeDistancePatternA.length,
                        "voltagePatternA:", safeVoltagePatternA.length,
                        "distancePatternB:", safeDistancePatternB.length,
                        "voltagePatternB:", safeVoltagePatternB.length,
                        "distancePatternC:", safeDistancePatternC.length,
                        "voltagePatternC:", safeVoltagePatternC.length)

            var incomingFileName = ""
            if (JsonObject.fileName !== undefined && JsonObject.fileName !== null) {
                incomingFileName = String(JsonObject.fileName).trim()
            } else if (JsonObject.fileNamesPattern !== undefined && JsonObject.fileNamesPattern !== null) {
                incomingFileName = String(JsonObject.fileNamesPattern).trim()
            }

            if (incomingFileName !== "") {
                if (incomingFileName.toLowerCase() === "noname") {
                    openFilePattern = ""
                } else {
                    openFilePattern = incomingFileName
                }
            }

            if (contorlAndMonitor &&
                    typeof contorlAndMonitor.updatePatternPlotFromWebSocket === "function") {
                contorlAndMonitor.updatePatternPlotFromWebSocket(JsonObject)
            } else {
                console.log("patternData: contorlAndMonitor or updatePatternPlotFromWebSocket not ready")
            }

            console.log("openFilePattern:", openFilePattern)

            if (openFilePattern) {
                var parts = openFilePattern.split("_")
//                if (parts.length >= 2) {
//                    openFilePattern = parts[0] + "_" + parts[1]
//                }
            }

            console.log("openFilePattern (trimmed):", openFilePattern)

            if (distancePatternA.length || distancePatternB.length || distancePatternC.length) {
                if (JsonObject.minVoltage !== undefined && JsonObject.minVoltage !== null)
                    minAxisY = JsonObject.minVoltage

                if (JsonObject.maxVoltage !== undefined && JsonObject.maxVoltage !== null)
                    maxAxisY = JsonObject.maxVoltage

                if (JsonObject.minDistance !== undefined && JsonObject.minDistance !== null)
                    minAxisX = JsonObject.minDistance

                if (JsonObject.maxDistance !== undefined && JsonObject.maxDistance !== null)
                    maxAxisX = JsonObject.maxDistance
            }

            if (refreshPatternTimer.running)
                refreshPatternTimer.restart()
            else
                refreshPatternTimer.running = true
        }else if (objectName === 'getMaxMinValue') {
            console.log("QMLgetMaxMinValue:", message,minDistance,maxDistance,minVoltage,maxVoltage);
            minDistance = JsonObject.minDistance;
            maxDistance = JsonObject.maxDistance;
            minVoltage = JsonObject.minVoltage;
            maxVoltage = JsonObject.maxVoltage;
            voltageOffset = JsonObject.voltageOffset;
            maxVoltageWithOffset = JsonObject.maxVoltagePlusOffset;
        }else if (objectName === 'positonCursor') {
            console.log("QMLpositonCursor:", message, JsonObject.distance);
            cursorposition = parseFloat(JsonObject.distance).toFixed(2);
            console.log("Formatted position:", cursorposition);
        }else if (objectName === 'updatedecreaseValue') {
            console.log("decreaseValue:", message, JsonObject.decreaseValue);
            cursorleft =  JsonObject.decreaseValue;
        }else if (objectName === 'updateincreaseValue') {
            console.log("increaseValue:", message, JsonObject.increaseValue);
            cursorright =  JsonObject.increaseValue;
        }else if (objectName === 'updateCursor') {
            console.log("updateCursor:", message, JsonObject.distance);
            updateNewDistance =  JsonObject.distance;
        }else if (objectName === 'taggingdata') {
            console.log("taggingdata:", message, JsonObject.Distance, JsonObject.status, JsonObject.temp_no,JsonObject.Phase);
            globalPhase =  JsonObject.Phase;
            if(globalPhase = "A"){
                globalDistance = JsonObject.Distance;
                globalStatus = JsonObject.status;
                globalTempNum = JsonObject.temp_no;
                positionX = JsonObject.Distance;
                positionY = 150.00;
                getTaggingData(positionX,positionY,globalTempNum)
            }
        }else if (objectName === 'TrapsEnabling') {
                communication_error             = JsonObject.COMMUNICATION_ERROR;
                gps_module_fail                 = JsonObject.GPS_MODULE_FAIL;
                internal_phase_A_error          = JsonObject.INTERNAL_PHASE_A_ERROR;
                internal_phase_B_error          = JsonObject.INTERNAL_PHASE_B_ERROR;
                internal_phase_C_error          = JsonObject.INTERNAL_PHASE_C_ERROR;
                lfl_operate                     = JsonObject.LFL_OPERATE;
                lfl_fail                        = JsonObject.LFL_FAIL;
                manual_test_event               = JsonObject.MANUAL_TEST_EVENT;
                module_hi_speed_phase_A_error   = JsonObject.MODULE_HI_SPEED_PHASE_A_ERROR;
                module_hi_speed_phase_B_error   = JsonObject.MODULE_HI_SPEED_PHASE_B_ERROR;
                module_hi_speed_phase_C_error   = JsonObject.MODULE_HI_SPEED_PHASE_C_ERROR;
                periodic_test_event             = JsonObject.PERIODIC_TEST_EVENT ;
                plc_di_error                    = JsonObject.PLC_DI_ERROR;
                plc_do_error                    = JsonObject.PLC_DO_ERROR;
                relay_start_event               = JsonObject.RELAY_START_EVENT;
                surage_start_event              = JsonObject.SURGE_START_EVENT;
                system_initial                  = JsonObject.SYSTEM_INITIAL;

//                ip_address                      = JsonObject.ipaddress? JsonObject.ipaddress: "";
//                ip_gateway                      = JsonObject.gateway? JsonObject.gateway: "";
//                ip_snmp                         = JsonObject.ip_snmp? JsonObject.ip_snmp: "";
//                ip_timeserver                   = JsonObject.ntpServer? JsonObject.ntpServer: "";
            console.log("TrapsEnabling:", message,JsonObject.SYSTEM_INITIAL,JsonObject.ip_address,JsonObject.COMMUNICATION_ERROR,JsonObject.GPS_MODULE_FAIL,JsonObject.INTERNAL_PHASE_A_ERROR, JsonObject.INTERNAL_PHASE_B_ERROR);
        }else if (objectName === 'updateParameterMargin') {
            if(JsonObject.PHASE === "A"){
                updateMarginA       = JsonObject.margin;
                console.log("updateMarginA:", updateMarginA);
            }
            if(JsonObject.PHASE === "B"){
                updateMarginB       = JsonObject.margin;
                console.log("updateMarginB:", updateMarginB);
            }
            if(JsonObject.PHASE === "C"){
                updateMarginC       = JsonObject.margin;
                console.log("updateMarginB:", updateMarginC);
            }
            console.log("update Margin from database:", message,JsonObject.margin,updateMarginA,updateMarginB,updateMarginC);

        }else if (objectName === 'detailInfoSetting') {
            detailwireInformation       = JsonObject.data;
            console.log("update detailInfoSetting:", message, detailwireInformation, JsonObject.data);
        }else if (objectName === 'MarginTableUpdated') {
            console.log("update MarginTableUpdated:", message);

        }else if ((TrapsAlert === 'PLC_DO_ERROR')) {
            message = message.replace("PLC_DO_ERROR", "PLC_DO_ACTIVE");
            addEvent(message);
        }else if ((TrapsAlert === 'PLC_DI_ERROR')) {
            message = message.replace("PLC_DI_ERROR", "PLC_DI_ACTIVE");
            addEvent(message);
        }else if (TrapsAlert === 'INTERNAL_PHASE_A_ERROR') {
            addEvent(message);
        } else if (TrapsAlert === 'INTERNAL_PHASE_B_ERROR') {
            addEvent(message);
        } else if (TrapsAlert === 'INTERNAL_PHASE_C_ERROR') {
            addEvent(message);
        } else if (TrapsAlert === 'MODULE_HI_SPEED_PHASE_A_ERROR') {
            addEvent(message);
        } else if (TrapsAlert === 'MODULE_HI_SPEED_PHASE_B_ERROR') {
            addEvent(message);
        } else if (TrapsAlert === 'MODULE_HI_SPEED_PHASE_C_ERROR') {
            addEvent(message);
        } else if (TrapsAlert === 'GPS_MODULE_FAIL') {
            addEvent(message);
        } else if (TrapsAlert === 'SYSTEM_INITIAL') {
            addEvent(message);
        } else if (TrapsAlert === 'COMMUNICATION_ERROR') {
            addEvent(message);
        }else if ((TrapsAlert === 'RELAY_START_EVENT')) {
            addEvent(message);
        }else if ((TrapsAlert === 'SURGE_START_EVENT_A') || (TrapsAlert === 'SURGE_START_EVENT_B') || (TrapsAlert === 'SURGE_START_EVENT_C')) {
            addEvent(message);
            trapsAlertEvent = TrapsAlert
            console.log("TrapsAlert:",TrapsAlert,trapsAlertEvent);
        }else if ((TrapsAlert === 'Send Master Start') || (TrapsAlert === 'Receive Master Start')) {
            addEvent(message);
        }else if ((TrapsAlert === 'PERIODIC_TEST_EVENT')) {
            console.log("PERIODIC_TEST_EVENT:",message);
            addEvent(message);
        }else if ((TrapsAlert === 'MANUAL_TEST_EVENT')) {
            addEvent(message);
            console.log("MANUAL_TEST_EVENT:",message);
        }else if (TrapsAlert === 'LFL_FAIL') {
            addEvent(message);
        } else if (TrapsAlert === 'LFL_OPERATE') {
            addEvent(message);
        }else if ((objectName === 'CLEAR_ALARM')) {
        }else if ((objectName === 'realDistanceA')) {
            console.log("realDistanceA:", message);
            realDistanceA = JsonObject.valueDistanceA;
            realDistanceA = realDistanceA/1000;
        }else if ((objectName === 'realDistanceB')) {
            console.log("realDistanceB:", message);
            realDistanceB = JsonObject.valueDistanceB;
            realDistanceB = realDistanceB/1000;
        }else if ((objectName === 'realDistanceC')) {
            console.log("realDistanceC:", message);
            realDistanceC = JsonObject.valueDistanceC;
            realDistanceC = realDistanceC/1000;
        }else if ((objectName === 'Network')) {

            console.log("QML display Network:", message,JsonObject.ip_address,JsonObject.ip_gateway);
            ip_address                      = JsonObject.ip_address;
            ip_gateway                      = JsonObject.ip_gateway;
            ip_snmp                         = JsonObject.ip_snmp;
            ip_timeserver                   = JsonObject.ip_timeserver;

        }else if ((objectName === 'selectUsers') || (objectName === 'selectUser')) {
            console.log("selectUser:", message);

            if (JsonObject.hasOwnProperty("RemoteTOMonitor") && JsonObject.RemoteTOMonitor) {
                remoteMonitor = JsonObject.RemoteTOMonitor;
            }

            if (JsonObject.userType === "STANDALONE") {
                ip_address = JsonObject.ip_master;
                userMode = "STANDALONE";
            } else if (JsonObject.userType === "MASTER") {
                ip_address = JsonObject.ip_master;
                userMode = JsonObject.userType;
            } else {
                ip_address = JsonObject.ip_slave;
                userMode = JsonObject.userType;
            }

            console.log("selectUser recheck:", JsonObject.userType , userMode);
        }/*else if ((objectName === 'selectUser')) {
            console.log("selectUser:", message);

            remoteMonitor = JsonObject.RemoteTOMonitor;
            if(JsonObject.userType === "STANDALONE"){
                ip_address   = JsonObject.ip_master;
                userMode = "STANDALONE";
            }else if(JsonObject.userType === "MASTER"){
                ip_address   = JsonObject.ip_master;
                userMode = JsonObject.userType
            }else{
                ip_address   = JsonObject.ip_slave;
                userMode = JsonObject.userType
            }
            console.log("selectUser:", JsonObject.userType);

        }*/else if ((objectName === 'dateRemote')) {
            updateMonday = JsonObject.Monday;
            updateTuesday = JsonObject.Tuesday;
            updateWednesday = JsonObject.Wednesday;
            updateThursday = JsonObject.Thursday;
            updateFriday = JsonObject.Friday;
            updateSaturday = JsonObject.Saturday;
            updateSunday = JsonObject.Sunday;
//            console.log("dateRemote_qml:", message,JsonObject.Monday,JsonObject.Tuesday,JsonObject.Wednesday,JsonObject.Thursday,JsonObject.Friday,JsonObject.Saturday,JsonObject.Sunday);
        }else if ((objectName === 'statusFails')) {
           console.log("status_LFL:", message);
            statusLFLFails = JsonObject.LFLFAIL;
        }else if ((objectName === 'statusOperates')) {
           console.log("status_LFL:", message);
            statusLFLOperates = JsonObject.LFLOPERATE;
        }else if (objectName === "updateTaggingData") {
            console.log("update_Tagging_Data_point:", message)

            // 1) update model ก่อน
            appendNewDataTableA(message)

            // 2) หลัง model update แล้ว ค่อย update active detail
            if (JsonObject.data && Array.isArray(JsonObject.data)) {
                applyActiveTaggingFromData(JsonObject.data)
            }

            // 3) redraw graph หลังจาก active/detail/model พร้อมแล้ว
            Qt.callLater(function() {
                if (contorlAndMonitor && contorlAndMonitor.reloadTaggingData) {
                    contorlAndMonitor.reloadTaggingData()
                }
            })
        }else if (JsonObject.objectName === "Pop-up") {
            console.log("Pop-up:", message);
            if (JsonObject.state === true) {
                console.log("Pop-up_remoteMessage:", JsonObject.msg);
//                remotePopup.remoteMessage = JsonObject.msg;
//                remotePopup.open();
                if(JsonObject.msg === "Logging out"){
                    console.log("Logging out popup shown");
//                    contorlAndMonitor.linesDrawn=-1;
                    loggingOutPopup.open();
                    remotePopup.remoteMessage = JsonObject.msg;
                    inputPanel.visible = false;
                    returntoMainPage.stop()
                    screenshotTimer.stop()
                    console.log("Logging out popup shown");
                // }else if (JsonObject.msg === "Disconnected"){
                }else if (JsonObject.msg === "Connected"){
                    console.log("Connected:",JsonObject.msg);
                    // if (String(JsonObject.msg || "").toUpperCase().includes("REMOTE")) {
                    // }else{
                    // }
                    disconnectPopup.close();
                }else if(JsonObject.msg === "REMOTE FROM VNC"){
                        console.log("REMOTE FROM VNC popup open:", JsonObject.msg)

                        // ปิด popup ที่อาจบังอยู่ก่อน
                        disconnectPopup.close()
                        remotePopup.close()
                        loggingOutPopup.close()

                        // ถ้า vncPopup ใช้ property ชื่อ message
                        vncPopup.message = JsonObject.msg

                        // ถ้า vncPopup ของคุณใช้ property ชื่อ remoteMessage แทน
                        // ให้ใช้บรรทัดนี้แทนบรรทัด vncPopup.message ด้านบน:
                        // vncPopup.remoteMessage = JsonObject.msg

                        vncPopup.z = 10050
                        vncPopup.open()
                        vncPopup.forceActiveFocus()

                        returntoMainPage.stop()
                        screenshotTimer.stop()

                        console.log("vncPopup opened:",
                                    "opened=", vncPopup.opened,
                                    "visible=", vncPopup.visible,
                                    "z=", vncPopup.z)

                        return
                    }else if (JsonObject.msg === "REMOTE FROM MASTER" || JsonObject.msg === "Logging out" || JsonObject.msg === "REMOTE FROM SLAVE"){
                        console.log("--------------check_who_remote--------------");
                        if(JsonObject.msg === "REMOTE FROM SLAVE"){
                            console.log("------------MAKE SURE WE ARE REMOTE-----------",JsonObject.msg);
                            remotePopup.remoteMessage = JsonObject.msg;
                            remotePopup.open();
                            closeArea.enabled = true;
                            closeArea.visible = true;

//                            contorlAndMonitor.linesDrawn=-1;
                        }else if(JsonObject.msg === "REMOTE FROM MASTER"){
                            console.log("------------MAKE SURE WE ARE REMOTE-----------",JsonObject.msg);
                            remotePopup.remoteMessage = JsonObject.msg;
                            remotePopup.open();
                            closeArea.enabled = true;
                            closeArea.visible = true;
//                            contorlAndMonitor.linesDrawn=-1;
                        }
                    }else{
                        console.log("unknown",JsonObject.msg)
                        // remotePopup.close();
                        // vncPopup.close();
                        // disconnectPopup.close();
                        console.log("unknown_after",JsonObject.msg)
                    }
            }else if (JsonObject.msg === "REMOTE FROM MASTER" || JsonObject.msg === "REMOTE FROM SLAVE"){
                console.log("check_who_remote:");
                remotePopup.remoteMessage = JsonObject.msg;
                remotePopup.open();
//                contorlAndMonitor.linesDrawn=-1;
            }else if (JsonObject.msg === 'ALREADY CAPTURESCREEN') {
                closeArea.enabled =false;
                remotePopup.remoteMessage = JsonObject.msg;
                remotePopup.open();
                console.log("Popup opened with message:", JsonObject.msg);
            }else if (JsonObject.msg === 'DONE') {
                remotePopup.remoteMessage = JsonObject.msg;
                closeArea.enabled = true;
                autoCloseTimer.interval = 3000;
                autoCloseTimer.restart();
                console.log("Popup opened with message:", JsonObject.msg);
            }else{
                console.log("VNC msg:", JsonObject.msg);
                if (JsonObject.msg === "Disconnected" || JsonObject.msg === "Local LAN Disconnected"){
                    console.log("disconnectPopup", JsonObject.targetIP, JsonObject.monitortIP)

                    disconnectPopup.remoteMessageReset = "DISCONNECTED FROM SERVER"
                    disconnectPopup.targetIP = JsonObject.targetIP
                    disconnectPopup.monitortIP = JsonObject.monitortIP
                    disconnectPopup.open()

                    contorlAndMonitor.distanceA = []
                    contorlAndMonitor.distanceB = []
                    contorlAndMonitor.distanceC = []

                    contorlAndMonitor.plotdataA = []
                    contorlAndMonitor.plotdataB = []
                    contorlAndMonitor.plotdataC = []

                    contorlAndMonitor.distancepatternA = []
                    contorlAndMonitor.distancepatternB = []
                    contorlAndMonitor.distancepatternC = []

                    contorlAndMonitor.plotdatapatternA = []
                    contorlAndMonitor.plotdatapatternB = []
                    contorlAndMonitor.plotdatapatternC = []

                    // ✅ เพิ่มตรงนี้
                    clearEventLogsOnDisconnect()

                    console.log("Popup opened: DISCONNECTED FROM SERVER")

                    remotePopup.close()
                    vncPopup.close()
                }else if(JsonObject.msg === "disable"){
                    console.log("disable",JsonObject.msg)
                    remotePopup.close();
                    vncPopup.close();
                    disconnectPopup.close();
                    remotePopup.closed();
                    console.log("disable_check_after",JsonObject.msg)
                }else{
                    console.log("unknown",JsonObject.msg)
                    // remotePopup.close();
                    // disconnectPopup.close();
                    console.log("unknown_after",JsonObject.msg)
                }
            }
        }else if (objectName === 'PatternCount') {
            if(JsonObject.msg !== ""){
                closeArea.enabled =false;
                remotePopup.remoteMessage = JsonObject.msg;
                remotePopup.open();
                console.log("Popup opened with message:", JsonObject.msg);

                if (JsonObject.msg === "PATTERN COUNT SUCCESS") {
                    closeArea.enabled = true;
                    autoCloseTimer.interval = 3000;
                    autoCloseTimer.restart();

                    console.log("Success received: Timer restarted to auto-close",JsonObject.msg);
                }else{
                    console.log("else message:", JsonObject.msg);

                }
            }

        }else if ((objectName === 'TOWER_NO')) {
            console.log("TOWER_NO", message);
            phaseTower = JsonObject.phase;
//            fullDistance3Phase = JsonObject.FullDistance;
                if(phaseTower === "A"){
                    transmissionLineA = JsonObject.TransmissionLine;
                     fullDistanceA = JsonObject.FullDistance;
                }
                if(phaseTower === "B"){
                    transmissionLineB = JsonObject.TransmissionLine;
                     fullDistanceB = JsonObject.FullDistance;
                }
                if(phaseTower === "C"){
                    transmissionLineC = JsonObject.TransmissionLine;
                     fullDistanceC = JsonObject.FullDistance;
                }

        }else if ((objectName === 'TOWER_NO_INIT')) {
            console.log("TOWER_NO_INIT:", message)

            var phaseValue = ""
            var fullDistanceValue = ""
            var patternNameValue = ""

            if (JsonObject.phase !== undefined && JsonObject.phase !== null) {
                phaseValue = String(JsonObject.phase)
            }

            if (JsonObject.FullDistance !== undefined && JsonObject.FullDistance !== null) {
                fullDistanceValue = String(JsonObject.FullDistance)
            }

            // รองรับทั้งชื่อเก่าที่สะกดผิด และชื่อใหม่ที่ควรถูกต้อง
            if (JsonObject.selectPatterName !== undefined && JsonObject.selectPatterName !== null) {
                patternNameValue = String(JsonObject.selectPatterName)
            } else if (JsonObject.selectPatternName !== undefined && JsonObject.selectPatternName !== null) {
                patternNameValue = String(JsonObject.selectPatternName)
            } else if (JsonObject.patternName !== undefined && JsonObject.patternName !== null) {
                patternNameValue = String(JsonObject.patternName)
            }

            phaseTower = phaseValue
            fullDistance3Phase = fullDistanceValue
            openFilePattern = patternNameValue

            console.log("TOWER_NO_INIT parsed:",
                        "phaseTower=", phaseTower,
                        "fullDistance3Phase=", fullDistance3Phase,
                        "openFilePattern=", openFilePattern)
        }else if ((objectName === 'sendMail')) {
            console.log("sendMail:", message,JsonObject.CSVname, fileNameData);
            fullnameCSV = JsonObject.CSVname;

        }else if ((objectName === 'socketPort')) {
            socketPort = JsonObject.port;
            console.log("socketPort:", socketPort);
        }else if ((objectName === 'LineFails')) {
            console.log("LineFails:", JsonObject.rangeoflfl);
            numPointOfLFL = JsonObject.rangeoflfl;
        }else if ((objectName === 'distanceField')) {
            console.log("distanceField:", JsonObject.distanceInfoSetting);
            distanceInfoSetting = JsonObject.distanceInfoSetting;
        }else if ((objectName === 'detailField')) {
            console.log("detailField:", JsonObject.detailInfoSetting);
            detailInfoSetting = JsonObject.detailInfoSetting;
        }else if ((objectName === 'logouts')) {
            console.log("logouts:", message);

//            userLevelGlobalVars.clear();
            loggingOutPopup.close();
            vncPopup.close();
        }else if (objectName === "DefaultUserLevel") {
            console.log("DefaultUserLevel:", JsonObject.usertype, JsonObject.loginby, message)

            userleveltype = JsonObject.usertype || ""
            userloginby = JsonObject.loginby || ""

            if (userleveltype === "ADMIN") {
                currentUserLevel = 1
            } else if (userleveltype === "SUPERVISOR") {
                currentUserLevel = 2
            } else if (userleveltype === "VIEWER") {
                currentUserLevel = 3
            } else {
                currentUserLevel = 0
            }
            userlavel(message)
            console.log("userleveltype:", userleveltype,
                        "userloginby:", userloginby,
                        "currentUserLevel:", currentUserLevel)
        }else if ((objectName === 'iTouchOwnIP')) {
            console.log("iTouchOwnIP:",JsonObject.iTouchIPAddress,message);
            if(JsonObject.iTouchIPGateway !== "" && JsonObject.iTouchIPAddress !== ""){
                ipGatewatOfiTouch = JsonObject.iTouchIPGateway;
                ipAddressOfiTouch = JsonObject.iTouchIPAddress;
            }
            console.log("ipGatewatOfiTouch:",ipGatewatOfiTouch,"ipAddressOfiTouch:",ipAddressOfiTouch);

        }else if ((objectName === 'valueMarginVoltageAauto')) {
            console.log("valueMarginVoltageAauto:",message);
            autoValueVoltageA = JsonObject.valueVoltageA;
        }else if ((objectName === 'valueMarginVoltageBauto')) {
            console.log("valueMarginVoltageBauto:",message);
            autoValueVoltageB = JsonObject.valueVoltageB;
        }else if ((objectName === 'valueMarginVoltageCauto')) {
            console.log("valueMarginVoltageCauto:",message);
            autoValueVoltageC = JsonObject.valueVoltageC;
        }else if ((objectName === 'getZoomValueRecord')) {
            console.log("getZoomValueRecord:", message, JsonObject.valueOfZoom);
            zoomValueRecord = JsonObject.valueOfZoom;
            lastZoomVoltage = JsonObject.lastZoomVoltage;
            console.log("zoomValueRecord:", zoomValueRecord,lastZoomVoltage);
            contorlAndMonitor.adjustZoom(zoomValueRecord);
        }else if ((objectName === 'updateyZoomFactor')) {
            console.log("updateyZoomFactor:", message);
            backupLastZoom = JsonObject.backupyZoomFactor;
        }else if ((objectName === 'updateIP')) {
            console.log("updateIP:", message);
            deviceMode          = JsonObject.USERMODE;
            if(JsonObject.USERMODE === "STANDALONE"){
                ip_address          = JsonObject.ip_Master_PCL;
            }else if(JsonObject.USERMODE === "MASTER"){
                ip_address          = JsonObject.ip_Master_PCL;
            }else{
               ip_address          = JsonObject.ip_SLAVE_PCL;
            }
            ip_gateway          = JsonObject.gateway;
            ip_snmp             = JsonObject.IP_SNMP;
            ip_timeserver       = JsonObject.IP_TIMERSERVER;
            ipAddressOfiTouch   = JsonObject.ipaddressMonitor;
            ipGatewatOfiTouch   = JsonObject.gateway;
        }else if ((objectName === "selectVNCHW")) {
            unscreenshotTimer = JsonObject.selectVNCHW;
//            vncModeDisplay = JsonObject.selectVNCHW;
            console.log("unscreenshotTimer_selectVNCHW:", message,JsonObject.selectVNCHW,unscreenshotTimer);
        } else if ((objectName === "voltageTaggingResults")) {
            console.log("voltageTaggingResults:", JsonObject)

            if (!JsonObject.results || !Array.isArray(JsonObject.results)) {
                console.warn("voltageTaggingResults missing .results[]:", JsonObject)
                return
            }

            applyVoltageTaggingResults(JsonObject.results)
        }else if ((objectName === "ScreenPicture")) {
            console.log("String_ScreenPicture",String(JsonObject.msg || "").toUpperCase().includes("REMOTE"))
            if (String(JsonObject.msg || "").toUpperCase().includes("REMOTE")) {
//                unscreenshotTimer = false;
                connectForunlockCapture = false;
                screenshotTimer.stop();
                console.log("connectForunlockCapture_FALSE:",connectForunlockCapture,unscreenshotTimer)
            }else{
//                unscreenshotTimer = true;
                connectForunlockCapture = true;
//                screenshotTimer.start();
                console.log("connectForunlockCapture_TRUE:",connectForunlockCapture,unscreenshotTimer)
            }
        }else if (objectName === "Periodicwarning") {
            const modeLocal = (JsonObject.mode || "").toUpperCase()
            const localT    = JsonObject.PeriodicTime || ""
            const remoteT   = JsonObject.recordPeriodic || ""
            const diffMin   = (JsonObject.timeDiffMin !== undefined) ? Number(JsonObject.timeDiffMin) : NaN

            let isOk = false

            if (isFinite(diffMin)) {
                if (modeLocal === "MASTER") {
                    isOk = (diffMin > 0)
                } else if (modeLocal === "SLAVE") {
                    isOk = (diffMin < 0)
                }
            }

            const issueKey = modeLocal + "|" + localT + "|" + remoteT + "|" + String(diffMin)

            periodicLastLocal = localT
            periodicLastRemote = remoteT
            periodicLastDiffMin = isFinite(diffMin) ? diffMin : 0

            if (isOk) {
                popupWarningPeriodic.popupinterlockPeriodic = false
                periodicRemindActive = false
                periodicAcceptedLocalSnapshot = ""
                periodicLastIssueKey = ""
                periodicRemindTimer.stop()
                console.log("✅ Periodicwarning OK -> close popup and stop remind")
                return
            }

            popupWarningPeriodic.modeLocal = modeLocal
            popupWarningPeriodic.recordPeriodicRaw = remoteT
            popupWarningPeriodic.localPeriodicRaw  = localT
            popupWarningPeriodic.diffMin = diffMin
            popupWarningPeriodic.expectedDiffMin = (modeLocal === "MASTER") ? 5 : -5

            // ถ้าเป็น issue เดิม และระบบกำลังรอ timer อยู่ -> อย่าเปิด popup ซ้ำทันที
            if (periodicRemindActive && periodicLastIssueKey === issueKey) {
                console.log("⏳ Same periodic issue still active -> wait for timer, skip immediate reopen")
                return
            }

            // เปิด popup ครั้งแรก
            popupWarningPeriodic.popupinterlockPeriodic = true
            periodicRemindActive = true
            periodicAcceptedLocalSnapshot = localT
            periodicLastIssueKey = issueKey

            if (!periodicRemindTimer.running)
                periodicRemindTimer.start()

            console.log("⚠️ Periodicwarning NOT OK -> open popup once, timer started")
        }else if(objectName === "updateRemotePeriodic"){
            console.log("updateRemotePeriodic BEFORE >>>>>", time, "incoming =", JsonObject.Time)
            time = JsonObject.Time || ""
            console.log("updateRemotePeriodic AFTER  >>>>>", time)
        }else if(objectName === "loadfilename"){ //loadfilename
            console.log("loadfilename",loadfilename,JsonObject.loadnewfilename)
            openFilePattern = JsonObject.loadnewfilename
         }else if(objectName === "CLEAR_NAME"){ //loadfilename
            console.log("CLEAR_NAME",message)
            openFilePattern = ""
            console.log("CLEAR_NAME>>>",message, openFilePattern)

         }
    }

    function applyVoltageTaggingResults(results) {
        if (!results || !Array.isArray(results))
            return

        // reset รอบล่าสุด
        requestedDistancesA = []
        closestDistancesA = []
        taggingVoltagesA = []

        requestedDistancesB = []
        closestDistancesB = []
        taggingVoltagesB = []

        requestedDistancesC = []
        closestDistancesC = []
        taggingVoltagesC = []

        for (var i = 0; i < results.length; ++i) {
            var row = results[i]

            var phase = row.Phase !== undefined ? String(row.Phase).trim() : ""
            var dbNo = row.num_list !== undefined ? parseInt(row.num_list) : -1
            var tempNo = row.temp_no !== undefined ? parseInt(row.temp_no) : -1
            var requestedDistance = row.requestedDistance !== undefined ? Number(row.requestedDistance) : 0
            var closestDist = row.closestDist !== undefined ? Number(row.closestDist) : 0
            var voltage = row.voltage !== undefined ? Number(row.voltage) : 0
            var detail = row.Detail !== undefined ? String(row.Detail) : ""

            switch (phase) {
            case "A":
                requestedDistancesA.push(requestedDistance)
                closestDistancesA.push(closestDist)
                taggingVoltagesA.push(voltage)
                break
            case "B":
                requestedDistancesB.push(requestedDistance)
                closestDistancesB.push(closestDist)
                taggingVoltagesB.push(voltage)
                break
            case "C":
                requestedDistancesC.push(requestedDistance)
                closestDistancesC.push(closestDist)
                taggingVoltagesC.push(voltage)
                break
            default:
                console.warn("Unknown Phase in voltageTaggingResults:", phase)
                continue
            }

            // อัปเดต model ที่ใช้แสดง detail/pointer
            var idx = getDeviceIndexByPhase(dbNo, phase)
            if (idx !== -1) {
                var existing = newlistdatatebleA.get(idx)

                newlistdatatebleA.set(idx, {
                    "list_statusA": existing.list_statusA,
                    "list_numberA": tempNo !== -1 ? tempNo : existing.list_numberA,
                    "num_listA": dbNo,
                    "list_distanceA": existing.list_distanceA,
                    "list_detailA": detail !== "" ? detail : existing.list_detailA,
                    "list_phaseA": phase,
                    "ampiltudeVol": voltage,
                    "checked": existing.checked
                })
            }
        }

        console.log("✅ Phase A:", requestedDistancesA.length, requestedDistancesA,
                    closestDistancesA, taggingVoltagesA)
        console.log("✅ Phase B:", requestedDistancesB.length, requestedDistancesB,
                    closestDistancesB, taggingVoltagesB)
        console.log("✅ Phase C:", requestedDistancesC.length, requestedDistancesC,
                    closestDistancesC, taggingVoltagesC)

        newListDataTaggingTables = !newListDataTaggingTables

    }
    function userlavel(message){
        var JsonObject = JSON.parse(message);
        var filename = JsonObject.filename;
        var userLevel = JsonObject.level;

        userLevelGlobalVars.clear();
        userLevelGlobalVars.append({ "userLevel": userLevel });

        currentUserLevel = userLevel;
        console.log("userLevelGlobalVars:", filename, userLevel);
    }

    function _safeStorageString(value) {
        if (value === undefined || value === null)
            return ""
        return String(value).trim()
    }

    function _findStorageRow(model, filename) {
        var name = _safeStorageString(filename)

        for (var i = 0; i < model.count; ++i) {
            var item = model.get(i)
            var itemName = _safeStorageString(item.filename)

            // สำคัญ:
            // ให้ถือว่า filename เดียวกัน = record เดียวกัน
            // ไม่ต้องเอา event_datetime มาเทียบ เพราะ backend อาจส่งเวลาตามมาทีหลัง
            if (itemName === name)
                return i
        }

        return -1
    }
    function updateOrAppend(model, filename, newData, makeNewestOnTop) {
        var name = ""
        if (filename !== undefined && filename !== null)
            name = String(filename).trim()

        for (var i = 0; i < model.count; ++i) {
            var item = model.get(i)
            var itemName = ""

            if (item.filename !== undefined && item.filename !== null)
                itemName = String(item.filename).trim()

            // ใช้ filename กันซ้ำเป็นหลัก
            // ไม่เอา event_datetime มาเทียบ เพราะเวลามันอาจมาทีหลัง
            if (itemName === name) {
                model.set(i, newData)

                if (makeNewestOnTop === true && i > 0) {
                    model.move(i, 0, 1)
                    return 0
                }

                return i
            }
        }

        if (makeNewestOnTop === true) {
            model.insert(0, newData)
            return 0
        }

        model.append(newData)
        return model.count - 1
    }
    function appendDatStorage(message) {
        var JsonObject = JSON.parse(message)

        var filename = JsonObject.filename || ""
        var event_datetime = JsonObject.event_datetime || ""

        // รับได้ทั้ง category_name และ category
        // เพราะปุ่ม NEW ส่ง category: "Pattern"
        var category_name = JsonObject.category_name || JsonObject.category || ""

        var newData = {
            filename: filename,
            event_datetime: event_datetime
        }

        console.log("appendDatStorage:", category_name, filename, event_datetime)

        if (filename === "") {
            console.warn("appendDatStorage skip: empty filename")
            return
        }

        if (category_name === "Pattern") {
            console.log("receiveNewPattern:", category_name)
            updateOrAppend(patternDataStorage, filename, newData, true)

        } else if (category_name === "Periodic") {
            console.log("Periodic:", category_name)
            updateOrAppend(periodicDataStorage, filename, newData, true)

        } else if (category_name === "Relay") {
            updateOrAppend(relayDataStorage, filename, newData, true)

        } else if (category_name === "Surge") {
            updateOrAppend(surgeDataStorage, filename, newData, true)
        }
    }
    function setpropertyIDTableA(checkIDtable) {
        console.log("setpropertyCheckTable:", checkIDtable);

        clearAllProperties();

        if (checkIDtable !== 0) {
            newlistdatatebleA.num_listA = checkIDtable;
            console.log("setpropertyCheckTableA:", checkIDtable, newlistdatatebleA.num_listA);
        }
    }

    function taggingpointA(taggingPointID, distancePoint) {
        console.log("taggingpointA:", taggingPointID, distancePoint);
        if (taggingPointID !== 0) {
            distancePointA = distancePoint;
            numOfTagging = taggingPointID;
            console.log("Updated tagging number:", numOfTagging);
        } else {
            console.warn("Skipping tagging update because taggingPointID is 0");
        }
    }


    function setpropertyCheckA(check){
        console.log("setpropertyCheck",check)
        if(check === true){
            checkedStates = check
        }else if(check === false){
            checkedStates = check
        }
    }
    function setpropertyIDTableB(checkIDtable) {
        console.log("setpropertyCheckTable", checkIDtable);

        clearAllProperties();

        if (checkIDtable !== 0) {
            newlistdatatebleB.num_listB = checkIDtable;
            console.log("setpropertyCheckTableA:", checkIDtable, newlistdatatebleB.num_listB);
        }
    }

    function setpropertyCheckB(check){
        console.log("setpropertyCheck",check)
        if(check === true){
            checkedStates = check
        }else if(check === false){
            checkedStates = check
        }
    }


    function clearAllProperties() {
        console.log("Clearing all properties...");
        newlistdatatebleA.num_listA = 0;
        console.log("Cleared num_listA:", newlistdatatebleA.num_listA);
    }

    function refreshTableDataA(message) {
        console.log("debug_refresh_data_A", message)
        var JsonObject;
        try {
            JsonObject = typeof message === "string" ? JSON.parse(message) : message;
        } catch (e) {
            console.error("Error parsing JSON:", e, "Raw message:", message);
            return;
        }

        var commandName = JsonObject.objectName || "";
        var selectStatus = (JsonObject.status === 0&&JsonObject.status !== undefined) ? true : false ;
        var numberPhase = JsonObject.temp_no !== undefined ? JsonObject.temp_no : null;
        var distancePhase = JsonObject.Distance !== undefined ? JsonObject.Distance : null;
        var detailPhase = JsonObject.Detail !== undefined ? JsonObject.Detail : "";
        var tablePhase = JsonObject.Phase !== undefined ? JsonObject.Phase : "";
        var numberoflist = JsonObject.num_list !== undefined ? JsonObject.num_list : 0;
        var vuleOFAmp = 0.0;

        console.log("Processed refreshTableDataA:", selectStatus, numberPhase, distancePhase, detailPhase, tablePhase, numberoflist, vuleOFAmp);

        if (!commandName || numberPhase === null || distancePhase === null) {
            console.warn("Invalid or missing data in JSON, skipping update.");
            return;
        }

        if(commandName.includes("TaggingPhase") || commandName.includes("updatedataTable") || commandName.includes("getDataTaggingPhase")){
            let foundIndex = -1;
            for (var i = 0; i < newlistdatatebleA.count; i++) {
                if (newlistdatatebleA.get(i).list_numberA === numberPhase) {
                    foundIndex = i;
                    break;
                }
            }

            if (foundIndex !== -1) {
                newlistdatatebleA.setProperty(foundIndex, "list_statusA", selectStatus)
                newlistdatatebleA.setProperty(foundIndex, "num_listA", numberoflist)
                newlistdatatebleA.setProperty(foundIndex, "list_distanceA", distancePhase)
                newlistdatatebleA.setProperty(foundIndex, "list_detailA", detailPhase)
                newlistdatatebleA.setProperty(foundIndex, "list_phaseA", tablePhase)
                newlistdatatebleA.setProperty(foundIndex, "ampiltudeVol", vuleOFAmp)
                newlistdatatebleA.setProperty(foundIndex, "checked", selectStatus)
                console.log("Updated existing row at index:", foundIndex);
            } else {
                newlistdatatebleA.append({
                    "list_statusA": selectStatus,
                    "list_numberA": numberPhase,
                    "num_listA": numberoflist,
                    "list_distanceA": distancePhase,
                    "list_detailA": detailPhase,
                    "list_phaseA": tablePhase,
                    "ampiltudeVol": vuleOFAmp,
                });
                console.log("Appended new row to newlistdatatebleA");
            }

//            newlistdatatebleA.sync();
        } else {
            console.warn("Invalid or unexpected `objectName` in JSON for Table A.");
        }
    }



    function refreshTableDataB(message) {
        console.log("debug_refresh_data_B", message);
        newlistdatatebleB.clear();

        var JsonObject = JSON.parse(message);
        var commandName = JsonObject.objectName;

        if (commandName === "updatedataTableB" && Array.isArray(JsonObject.data)) {
            for (var i = 0; i < JsonObject.data.length; i++) {
                var item = JsonObject.data[i];
                newlistdatatebleB.append({
                    "list_statusB": item.statusB || false,
                    "list_numberB": item.temp_noB || 0,
                    "list_distanceB": item.DistanceB || 0.0,
                    "list_detailB": item.DetailB || "",
                    "num_listB": item.num_listB || 0,
                });
            }
        } else {
            console.warn("Invalid or missing `data` property in JSON for Table B.");
        }
    }

    function refreshTableDataC(message) {
        console.log("debug_refresh_data_C", message);

        newlistdatatebleC.clear();

        var JsonObject = JSON.parse(message);
        var commandName = JsonObject.objectName;

        // Check if the command is to update Table C
        if (commandName === "updatedataTableC" && Array.isArray(JsonObject.data)) {
            for (var i = 0; i < JsonObject.data.length; i++) {
                var item = JsonObject.data[i];
                newlistdatatebleC.append({
                    "list_statusC": item.statusC || false,   // Fallback to false if undefined
                    "list_numberC": item.temp_noC || 0,      // Fallback to 0
                    "list_distanceC": item.DistanceC || 0.0, // Fallback to 0.0
                    "list_detailC": item.DetailC || "",      // Fallback to empty string
                    "num_listC": item.num_listC || 0,        // Fallback to 0
                });
            }
        } else {
            console.warn("Invalid or missing `data` property in JSON for Table C.");
        }
    }

    function addEvent(message) {
        var JsonObject = JSON.parse(message)
        console.log("addEvent:", message)

        if (!JsonObject.TrapsAlert || !JsonObject.time)
            return

        var eventStatus = JsonObject.state ? "ACTIVE" : "DEACTIVE"

        // รองรับทั้ง chanel ที่ backend ส่งมา และ channel เผื่อแก้ชื่อในอนาคต
        var eventChannel = ""
        if (JsonObject.chanel !== undefined && JsonObject.chanel !== null)
            eventChannel = String(JsonObject.chanel).trim().toUpperCase()
        else if (JsonObject.channel !== undefined && JsonObject.channel !== null)
            eventChannel = String(JsonObject.channel).trim().toUpperCase()

        var isOldEvent = (eventChannel === "OLD")

        // OLD เป็น history เก่า ห้ามเอาไปเปลี่ยน statusSystem ปัจจุบัน
        if (!isOldEvent) {
            statusSystem = (eventStatus === "DEACTIVE")
        }

        var fullTime = String(JsonObject.time)
        var datePart = fullTime.split(" ")[0] || "N/A"
        var timePart = fullTime.split(" ")[1] || "N/A"

        var row = {
            datetEventandAlram: datePart,
            timeEventandAlram: timePart,
            logDetail: JsonObject.TrapsAlert,
            statusEventandAlram: eventStatus
        }

        // init shadow จาก model เดิมก่อน ถ้ายังไม่มี
        ensureEventShadowsReady()

        // ------------------------------------------------------------
        // OLD: เพิ่มเฉพาะ History เท่านั้น
        // ไม่เพิ่มเข้า eventShadow / eventAlarmLog
        // ------------------------------------------------------------
        if (isOldEvent) {
            if (historyShadow.length > 0) {
                var latestOld = historyShadow[0]
                if (latestOld.datetEventandAlram === row.datetEventandAlram &&
                    latestOld.timeEventandAlram === row.timeEventandAlram &&
                    latestOld.logDetail === row.logDetail &&
                    latestOld.statusEventandAlram === row.statusEventandAlram) {
                    console.log("[addEvent] duplicate OLD latest history event, skip")
                    return
                }
            }

            historyShadow.unshift(cloneEventRow(row))
            capShadow(historyShadow, maxHistoryItems)

            rebuildEventModelsFromShadow()

            console.log("[addEvent] OLD -> history only",
                        "eventShadow =", eventShadow.length,
                        "historyShadow =", historyShadow.length,
                        "eventModel =", eventAlarmLog.count,
                        "historyModel =", eventAlarmHistoryLog.count)

            return
        }

        // ------------------------------------------------------------
        // ปกติ: เพิ่มทั้ง event ปัจจุบัน และ history
        // ------------------------------------------------------------
        if (historyShadow.length > 0) {
            var latest = historyShadow[0]
            if (latest.datetEventandAlram === row.datetEventandAlram &&
                latest.timeEventandAlram === row.timeEventandAlram &&
                latest.logDetail === row.logDetail &&
                latest.statusEventandAlram === row.statusEventandAlram) {
                console.log("[addEvent] duplicate latest event, skip")
                return
            }
        }

        // ใหม่อยู่บนสุด
        eventShadow.unshift(cloneEventRow(row))
        historyShadow.unshift(cloneEventRow(row))

        // จำกัดจำนวน
        capShadow(eventShadow, maxEventItems)
        capShadow(historyShadow, maxHistoryItems)

        // rebuild model ตาม filter ปัจจุบัน
        rebuildEventModelsFromShadow()

        console.log("[addEvent] NORMAL -> event + history",
                    "eventShadow =", eventShadow.length,
                    "historyShadow =", historyShadow.length,
                    "eventModel =", eventAlarmLog.count,
                    "historyModel =", eventAlarmHistoryLog.count)
    }
    function clearEventLogsOnDisconnect() {
        console.log("[clearEventLogsOnDisconnect] clear eventAlarmLog + eventAlarmHistoryLog")

        // สำคัญ: ล้าง shadow ก่อน ไม่งั้น rebuild แล้วข้อมูลเก่าจะกลับมา
        eventShadow = []
        historyShadow = []

        if (eventAlarmLog)
            eventAlarmLog.clear()

        if (eventAlarmHistoryLog)
            eventAlarmHistoryLog.clear()

        console.log("[clearEventLogsOnDisconnect] after clear:",
                    "eventShadow=", eventShadow.length,
                    "historyShadow=", historyShadow.length,
                    "eventAlarmLog=", eventAlarmLog.count,
                    "eventAlarmHistoryLog=", eventAlarmHistoryLog.count)
    }
    function rebuildEventModelFromShadow() {
        eventAlarmLog.clear()

        var startIndex = Math.max(0, eventShadow.length - maxEventItems)
        for (var i = startIndex; i < eventShadow.length; ++i) {
            eventAlarmLog.append(eventShadow[i])
        }

        console.log("[rebuildEventModelFromShadow] model =", eventAlarmLog.count,
                    "shadow =", eventShadow.length)
    }

    function rebuildHistoryModelFromShadow() {
        eventAlarmHistoryLog.clear()

        var startIndex = Math.max(0, historyShadow.length - maxHistoryItems)
        for (var i = startIndex; i < historyShadow.length; ++i) {
            eventAlarmHistoryLog.append(historyShadow[i])
        }

        console.log("[rebuildHistoryModelFromShadow] model =", eventAlarmHistoryLog.count,
                    "shadow =", historyShadow.length)
    }
    function cloneEventRow(row) {
        return JSON.parse(JSON.stringify(row))
    }

    function capShadow(arr, maxItems) {
        while (arr.length > maxItems)
            arr.pop()
    }

    function ensureEventShadowsReady() {
        // eventShadow
        if (eventShadow.length === 0 && eventAlarmLog.count > 0) {
            for (var i = 0; i < eventAlarmLog.count && i < maxEventItems; ++i) {
                eventShadow.push(cloneEventRow(eventAlarmLog.get(i)))
            }
            console.log("[ensureEventShadowsReady] init eventShadow from eventAlarmLog =", eventShadow.length)
        }

        // historyShadow
        if (historyShadow.length === 0 && eventAlarmHistoryLog.count > 0) {
            for (var j = 0; j < eventAlarmHistoryLog.count && j < maxHistoryItems; ++j) {
                historyShadow.push(cloneEventRow(eventAlarmHistoryLog.get(j)))
            }
            console.log("[ensureEventShadowsReady] init historyShadow from eventAlarmHistoryLog =", historyShadow.length)
        }
    }

    function clearEventPageModelsOnly() {
        eventAlarmLog.clear()
        eventAlarmHistoryLog.clear()
        console.log("[clearEventPageModelsOnly] clear only view models")
    }
    function eventMatchesActiveFilters(row) {
        var detail = row && row.logDetail !== undefined ? String(row.logDetail).trim() : ""

        if (!eventFilterEnabled)
            return true

        var relayOn = eventFilterRelayActive
        var periodicOn = eventFilterPeriodicActive
        var manualOn = eventFilterManualActive
        var surgeOn = eventFilterSurgeActive

        if (!relayOn && !periodicOn && !manualOn && !surgeOn)
            return true

        if (relayOn && detail === "RELAY_START_EVENT")
            return true

        if (periodicOn && detail === "PERIODIC_TEST_EVENT")
            return true

        if (manualOn && detail === "MANUAL_TEST_EVENT")
            return true

        if (surgeOn && detail.indexOf("SURGE_START") === 0)
            return true

        return false
    }
    function rebuildEventModelsFromShadow() {
        ensureEventShadowsReady()

        eventAlarmLog.clear()
        eventAlarmHistoryLog.clear()

        var eventAdded = 0
        for (var i = 0; i < eventShadow.length && eventAdded < maxEventItems; ++i) {
            if (eventMatchesActiveFilters(eventShadow[i])) {
                eventAlarmLog.append(cloneEventRow(eventShadow[i]))
                eventAdded++
            }
        }

        var historyAdded = 0
        for (var j = 0; j < historyShadow.length && historyAdded < maxHistoryItems; ++j) {
            if (eventMatchesActiveFilters(historyShadow[j])) {
                eventAlarmHistoryLog.append(cloneEventRow(historyShadow[j]))
                historyAdded++
            }
        }

        console.log("[rebuildEventModelsFromShadow] eventModel =", eventAlarmLog.count,
                    "historyModel =", eventAlarmHistoryLog.count,
                    "eventShadow =", eventShadow.length,
                    "historyShadow =", historyShadow.length,
                    "filterEnabled =", eventFilterEnabled,
                    "relay =", eventFilterRelayActive,
                    "periodic =", eventFilterPeriodicActive,
                    "manual =", eventFilterManualActive,
                    "surge =", eventFilterSurgeActive)
    }
    function applyEventFilters() {
        rebuildEventModelsFromShadow()
    }

    function initHistoryShadowIfNeeded() {
        ensureEventShadowsReady()
    }

    function restoreHistoryFromShadowIfEmpty() {
        if (eventAlarmHistoryLog.count === 0 && historyShadow.length > 0) {
            console.warn("[shadow] history empty; restoring from shadow:", historyShadow.length);

            var maxRestore = Math.min(historyShadow.length, maxHistoryItems);
            for (var i = 0; i < maxRestore; i++) {
                eventAlarmHistoryLog.append(historyShadow[i]);
            }
        }
    }

    function fliterRelayStart(checkfliter) {
        console.log("[fliterRelayStart]", checkfliter)
        applyEventFilters()
    }

    function fliterPeriodicStart(checkfliter) {
        console.log("[fliterPeriodicStart]", checkfliter)
        applyEventFilters()
    }

    function fliterManualStart(checkfliter) {
        console.log("[fliterManualStart]", checkfliter)
        applyEventFilters()
    }

    function fliterSurageStart(checkfliter) {
        console.log("[fliterSurageStart]", checkfliter, "trapsAlertEvent =", trapsAlertEvent)
        applyEventFilters()
    }

    function getUpdateYAxis_A(modelDistance, modelNumber, phase) {
        console.log("getUpdateYAxis_A:", modelDistance, modelNumber, phase);

        var distanceRaw, voltageRaw;
        if (phase === "A") {
            distanceRaw = distanceRawA;
            voltageRaw = voltageRawA;
        } else if (phase === "B") {
            distanceRaw = distanceRawB;
            voltageRaw = voltageRawB;
        } else if (phase === "C") {
            distanceRaw = distanceRawC;
            voltageRaw = voltageRawC;
        } else {
            console.error("Invalid Phase:", phase);
            return 0;
        }

        if (distanceRaw.length === 0) {
            console.error("No data available for Phase:", phase);
            return 0;
        }

        console.log("Updating ListModel with Graph Data for Phase:", phase);

        var closestIndex = -1;
        var minDiff = Number.MAX_VALUE;

        for (var j = 0; j < distanceRaw.length; j++) {
            var diff = Math.abs(distanceRaw[j] - modelDistance);
            if (diff < minDiff) {
                minDiff = diff;
                closestIndex = j;
            }
        }
        console.log("closestIndex:",closestIndex);

        if (closestIndex !== -1) {
            var closestX = distanceRaw[closestIndex];
            var closestY = voltageRaw[closestIndex];
//            contorlAndMonitor.updateTagging(closestX, closestY, phase);
//            contorlAndMonitor.canvasPlot.updateTagging(closestX, closestY, phase, modelNumber);
            console.log(`Updating index modelNumber: modelNumber=${modelNumber}, Distance=${closestX}, Amplitude=${closestY} for Phase ${phase}`);
            return closestY;
        } else {
            return 0;
        }
    }
    function applyActiveTaggingFromData(dataArray) {
        activeTaggingNumberA = 0
        activeTaggingNumberB = 0
        activeTaggingNumberC = 0

        activeTaggingDetailA = ""
        activeTaggingDetailB = ""
        activeTaggingDetailC = ""

        activeTaggingDistanceA = 0
        activeTaggingDistanceB = 0
        activeTaggingDistanceC = 0

        if (!dataArray || !Array.isArray(dataArray))
            return

        for (var i = 0; i < dataArray.length; ++i) {
            var row = dataArray[i]

            var phase = row.Phase !== undefined ? String(row.Phase).trim() : ""
            var status = Number(row.status)
            var tempNo = Number(row.temp_no)
            var detail = row.Detail !== undefined ? String(row.Detail) : ""
            var dist = Number(row.Distance)

            if (status !== 1)
                continue

            if (phase === "A") {
                activeTaggingNumberA = tempNo
                activeTaggingDetailA = detail
                activeTaggingDistanceA = dist
            } else if (phase === "B") {
                activeTaggingNumberB = tempNo
                activeTaggingDetailB = detail
                activeTaggingDistanceB = dist
            } else if (phase === "C") {
                activeTaggingNumberC = tempNo
                activeTaggingDetailC = detail
                activeTaggingDistanceC = dist
            }
        }

        console.log("[applyActiveTaggingFromData] A =", activeTaggingNumberA, activeTaggingDetailA, activeTaggingDistanceA)
        console.log("[applyActiveTaggingFromData] B =", activeTaggingNumberB, activeTaggingDetailB, activeTaggingDistanceB)
        console.log("[applyActiveTaggingFromData] C =", activeTaggingNumberC, activeTaggingDetailC, activeTaggingDistanceC)
    }
    function appendNewDataTableA(message) {
        console.log("Received message for appendNewDataTableA:", message)
        var JsonObject = JSON.parse(message)
        console.log("Parsed JsonObject:", JsonObject)

        var dataList = Array.isArray(JsonObject.data) ? JsonObject.data : [JsonObject]
        var lastAddedOrUpdatedPhase = ""
        var lastAddedOrUpdatedTempNo = 0
        var lastAddedOrUpdatedDetail = ""
        var lastAddedOrUpdatedDistance = 0
        for (var i = 0; i < dataList.length; i++) {
            var item = dataList[i]

            var selectStatus = item.status === true || item.status === 1
            var tempNoPhase = parseInt(item.temp_no !== undefined ? item.temp_no : -1)
            var distancePhase = parseFloat(item.Distance !== undefined ? item.Distance : -1)
            var detailPhase = item.Detail !== undefined ? item.Detail : ""
            var tablePhase = item.Phase !== undefined ? item.Phase : ""
            lastAddedOrUpdatedPhase = tablePhase
            lastAddedOrUpdatedTempNo = tempNoPhase
            lastAddedOrUpdatedDetail = detailPhase
            lastAddedOrUpdatedDistance = distancePhase
            var dbNo = item.num_list !== undefined
                    ? parseInt(item.num_list)
                    : (item.No !== undefined ? parseInt(item.No) : -1)

            var valueOfAmp = getUpdateYAxis_A(distancePhase, tempNoPhase, tablePhase)

            console.log("Processed Values:", {
                dbNo: dbNo,
                selectStatus: selectStatus,
                tempNoPhase: tempNoPhase,
                distancePhase: distancePhase,
                detailPhase: detailPhase,
                tablePhase: tablePhase,
                valueOfAmp: valueOfAmp
            })

            if (tablePhase === "A" || tablePhase === "B" || tablePhase === "C") {
                console.log("Found Phase:", tablePhase)

                if (dbNo === -1 || isNaN(distancePhase) || isNaN(dbNo)) {
                    console.warn("Invalid Data: Missing required fields (No or Distance). Skipping entry.")
                    continue
                }

                var getDeviceIndex = getDeviceIndexByPhase(dbNo, tablePhase)
                console.log("getDeviceIndex for Phase " + tablePhase + ":", getDeviceIndex)

                if (getDeviceIndex === -1) {
                    console.log("Item not found for Phase " + tablePhase + ", adding new item:", dbNo)

                    newlistdatatebleA.append({
                        "list_statusA": selectStatus,
                        "list_numberA": tempNoPhase,    // ใช้ temp_no เป็นเลข tagging บนกราฟ
                        "num_listA": dbNo,              // ใช้ No เป็น id แถวใน DB
                        "list_distanceA": distancePhase,
                        "list_detailA": detailPhase,
                        "list_phaseA": tablePhase,
                        "ampiltudeVol": valueOfAmp,
                        "checked": selectStatus
                    })
                } else {
                    var existingItem = newlistdatatebleA.get(getDeviceIndex)

                    if (existingItem.list_statusA !== selectStatus ||
                        existingItem.list_numberA !== tempNoPhase ||
                        existingItem.num_listA !== dbNo ||
                        existingItem.list_distanceA !== distancePhase ||
                        existingItem.list_detailA !== detailPhase ||
                        existingItem.list_phaseA !== tablePhase ||
                        existingItem.ampiltudeVol !== valueOfAmp) {

                        console.log("Updating existing item at index " + getDeviceIndex + " for Phase " + tablePhase)

                        newlistdatatebleA.set(getDeviceIndex, {
                            "list_statusA": selectStatus,
                            "list_numberA": tempNoPhase,
                            "num_listA": dbNo,
                            "list_distanceA": distancePhase,
                            "list_detailA": detailPhase,
                            "list_phaseA": tablePhase,
                            "ampiltudeVol": valueOfAmp,
                            "checked": selectStatus
                        })
                    } else {
                        console.log("No changes detected for item at index " + getDeviceIndex + " for Phase " + tablePhase)
                    }
                }
            }
        }
        // ให้ tagging ที่เพิ่งสร้าง/อัปเดต กลายเป็น active ทันที
        // เพื่อให้ detail บนกราฟขึ้นตั้งแต่ครั้งแรก ไม่ต้องกดซ้ำ
        if (lastAddedOrUpdatedPhase === "A") {
            activeTaggingNumberA = lastAddedOrUpdatedTempNo
            activeTaggingDetailA = lastAddedOrUpdatedDetail
            activeTaggingDistanceA = lastAddedOrUpdatedDistance
        } else if (lastAddedOrUpdatedPhase === "B") {
            activeTaggingNumberB = lastAddedOrUpdatedTempNo
            activeTaggingDetailB = lastAddedOrUpdatedDetail
            activeTaggingDistanceB = lastAddedOrUpdatedDistance
        } else if (lastAddedOrUpdatedPhase === "C") {
            activeTaggingNumberC = lastAddedOrUpdatedTempNo
            activeTaggingDetailC = lastAddedOrUpdatedDetail
            activeTaggingDistanceC = lastAddedOrUpdatedDistance
        }

        console.log("[appendNewDataTableA] active updated:",
                    lastAddedOrUpdatedPhase,
                    lastAddedOrUpdatedTempNo,
                    lastAddedOrUpdatedDetail,
                    lastAddedOrUpdatedDistance)
        scatterModel.clear()
        newListDataTaggingTables = !newListDataTaggingTables
        console.log("newListDataTaggingTables:", newListDataTaggingTables)
    }

    function deletedMytaggingA(selectedDbNo) {
        var modelIndex = getDeviceIndexByPhase(selectedDbNo, "A")
        if (modelIndex === -1) {
            console.warn("deletedMytaggingA: item not found, dbNo =", selectedDbNo)
            return
        }

        var deleteData = JSON.stringify({
            objectName: "deleteMysql",
            num_listA: selectedDbNo,
            PHASE: "A"
        })

        console.log("DELETE Data A:", deleteData, "dbNo =", selectedDbNo, "modelIndex =", modelIndex)

        newlistdatatebleA.remove(modelIndex)
        qmlCommand(deleteData)
    }

    function deletedMytaggingB(selectedDbNo) {
        var modelIndex = getDeviceIndexByPhase(selectedDbNo, "B")
        if (modelIndex === -1) {
            console.warn("deletedMytaggingB: item not found, dbNo =", selectedDbNo)
            return
        }

        var deleteData = JSON.stringify({
            objectName: "deleteMysql",
            num_listA: selectedDbNo,
            PHASE: "B"
        })

        console.log("DELETE Data B:", deleteData, "dbNo =", selectedDbNo, "modelIndex =", modelIndex)

        newlistdatatebleA.remove(modelIndex)
        qmlCommand(deleteData)
    }

    function deletedMytaggingC(selectedDbNo) {
        var modelIndex = getDeviceIndexByPhase(selectedDbNo, "C")
        if (modelIndex === -1) {
            console.warn("deletedMytaggingC: item not found, dbNo =", selectedDbNo)
            return
        }

        var deleteData = JSON.stringify({
            objectName: "deleteMysql",
            num_listA: selectedDbNo,
            PHASE: "C"
        })

        console.log("DELETE Data C:", deleteData, "dbNo =", selectedDbNo, "modelIndex =", modelIndex)

        newlistdatatebleA.remove(modelIndex)
        qmlCommand(deleteData)
    }
    function getDeviceIndexByPhase(num_list, phase) {
         console.log("getDeviceIndexByPhase:", num_list, phase);
        for (var i = 0; i < newlistdatatebleA.count; i++) {
            var item = newlistdatatebleA.get(i);
            if (item.num_listA === num_list && item.list_phaseA === phase) {
                return i;
            }
        }
        return -1;
    }

    function updateListModelWithScatterData(distanceData, plotData) {
        if (!distanceData || !plotData || distanceData.length === 0 || plotData.length === 0) {
            console.error("updateListModelWithScatterData: distanceData or plotData is missing or empty!");
            return;
        }

        console.log("Updating ListModel with Graph Data");

        for (var i = 0; i < newlistdatatebleA.count; i++) {
            var modelDistance = newlistdatatebleA.get(i).list_distanceA;
            var modelNumber = newlistdatatebleA.get(i).list_numberA;
            var closestIndex = -1;
            var minDiff = Number.MAX_VALUE;

            for (var j = 0; j < distanceData.length; j++) {
                var diff = Math.abs(distanceData[j] - modelDistance);
                if (diff < minDiff) {
                    minDiff = diff;
                    closestIndex = j;
                }
            }

            if (closestIndex !== -1) {
                var closestX = distanceData[closestIndex];
                var closestY = plotData[closestIndex];

                console.log(`Updating index ${i}: Distance=${closestX}, Amplitude=${closestY}`);

                newlistdatatebleA.setProperty(i, "ampiltudeVol", closestY);
            }
        }

        console.log("Finished updating ListModel");
    }
    function hideKeyboard() {
        currentField = ""
        userEditing = false

        // ตัด focus จากทุกตัว
//        textPassword.focus = false
//        textUserName.focus = false
        textInformation.focus = false

        // ปิด input method จริง ๆ
        Qt.inputMethod.hide()

        // ซ่อน panel
        inputPanel.visible = false
    }
    function appendNewDataTableB(message) {
        console.log("debug_for_mysqlTable_B", message);

        var JsonObject = JSON.parse(message);
        var commandName = JsonObject.objectName;
        var selectStatus = JsonObject.status;
        var numberPhase = JsonObject.temp_no;
        var distancePhase = JsonObject.Distance;
        var detailPhase = JsonObject.Detail;
        var tablePhase = JsonObject.Phase;
        var numberoflist = JsonObject.num_list;

        if (commandName === "updateDataDisplay") {
            newlistdatatebleB.clear();
        } else {
            if (tablePhase === "B") {
                newlistdatatebleB.append({
                    "list_statusB": selectStatus,
                    "list_numberB": numberPhase,
                    "num_listB": numberoflist,
                    "list_distanceB": distancePhase,
                    "list_detailB": detailPhase,
                    "list_phaseB": tablePhase
                });
                console.log("debug_new_data_B", message, numberoflist);
            }
        }
    }

    function appendNewDataTableC(message) {
        console.log("debug_for_mysqlTable_C", message);

        var JsonObject = JSON.parse(message);
        var commandName = JsonObject.objectName;
        var selectStatus = JsonObject.status;
        var numberPhase = JsonObject.temp_no;
        var distancePhase = JsonObject.Distance;
        var detailPhase = JsonObject.Detail;
        var tablePhase = JsonObject.Phase;
        var numberoflist = JsonObject.num_list;

        if (commandName === "updateDataDisplay") {
            newlistdatatebleC.clear();
        } else {
            if (tablePhase === "C") {
                newlistdatatebleC.append({
                    "list_statusC": selectStatus,
                    "list_numberC": numberPhase,
                    "num_listC": numberoflist,
                    "list_distanceC": distancePhase,
                    "list_detailC": detailPhase,
                    "list_phaseC": tablePhase
                });
                console.log("debug_new_data_C", message, numberoflist);
            }
        }
    }

    function getDeviceIndexB(num_listB) {
        console.warn("getDeviceIndexB_test:", num_listB);

        if (num_listB === undefined || num_listB === null || num_listB === -1) {
            console.warn("Skipping getDeviceIndexB due to invalid num_listB:", num_listB);
            return -1;
        }

        for (var i = 0; i < newlistdatatebleA.count; i++) {
            var currentItem = newlistdatatebleA.get(i);
            if (!currentItem) {
                console.warn("Item at index", i, "is undefined");
                continue;
            }
            var currentDeviceId = currentItem.num_listB ?? -1;
            if (String(currentDeviceId) === String(num_listB)) {
                return i;
            }
        }
        console.log("getDeviceIndexB - num_listB not found:", num_listB);
        return -1;
    }

    function getDeviceIndexC(num_listC) {
        console.warn("getDeviceIndexC_test:", num_listC);

        if (num_listC === undefined || num_listC === null || num_listC === -1) {
            console.warn("Skipping getDeviceIndexC due to invalid num_listC:", num_listC);
            return -1;
        }

        for (var i = 0; i < newlistdatatebleA.count; i++) {
            var currentItem = newlistdatatebleA.get(i);
            if (!currentItem) {
                console.warn("Item at index", i, "is undefined");
                continue;
            }
            var currentDeviceId = currentItem.num_listC ?? -1;
            if (String(currentDeviceId) === String(num_listC)) {
                return i;
            }
        }
        console.log("getDeviceIndexC - num_listC not found:", num_listC);
        return -1;
    }

    function deletedCommand(message){
        var JsonObject = JSON.parse(message);
            var commandName = JsonObject.objectName;
            if (commandName === "deletedcommand") {
                var deviceIDToDelete = JsonObject.num_list;
                var deviceIndex = getDeviceIndexA(deviceIDToDelete);
                if (deviceIndex !== -1) {
                    newlistdatatebleA.remove(deviceIndex);
                    console.log("Row with device ID", deviceIDToDelete, "deleted");
                } else {
                    console.log("No row found with device ID", deviceIDToDelete);
                }
            }
    }

    function appendNewMarginlistA(message) {
        var JsonObject = JSON.parse(message);
        var listMarginCount = parseInt(JsonObject.marginNo.replace("Margin", ""));
        var valueMarginA = JsonObject.valueOfMargin;
        var unitMarginA = JsonObject.unit;

        console.log("Appending to newlistMarginA: Count", listMarginCount, "Value:", valueMarginA, "Unit:", unitMarginA);

        // Remove extra entries if the new count is smaller
        while (newlistMarginA.count > listMarginCount) {
            console.log("Removing excess entry:", newlistMarginA.count);
            newlistMarginA.remove(newlistMarginA.count - 1);
        }

        // Check and update existing entries
        var found = false;
        for (var i = 0; i < newlistMarginA.count; i++) {
            if (newlistMarginA.get(i).list_marginA === JsonObject.marginNo) {
                found = true;
                newlistMarginA.set(i, {
                    "voltageIndex": i,
                    "list_marginA": JsonObject.marginNo,
                    "valueMarginA": valueMarginA,
                    "unitMarginA": unitMarginA
                });
                console.log("Updated existing entry:", JsonObject.marginNo);
                break;
            }
        }

        // Append if not found
        if (!found && newlistMarginA.count < listMarginCount) {
            newlistMarginA.append({
                "voltageIndex": newlistMarginA.count,
                "list_marginA": JsonObject.marginNo,
                "valueMarginA": valueMarginA,
                "unitMarginA": unitMarginA
            });
            console.log("Added new entry:", JsonObject.marginNo);
        }
    }

    function appendNewMarginlistB(message) {
        var JsonObject = JSON.parse(message);
        var listMarginCount = parseInt(JsonObject.marginNo.replace("Margin", ""));
        var valueMarginB = JsonObject.valueOfMargin; // 300
        var unitMarginB = JsonObject.unit; // mV

        console.log("Appending to newlistMarginB: Count", listMarginCount, "Value:", valueMarginB, "Unit:", unitMarginB);

        // ✅ Remove extra entries if the new count is smaller
        while (newlistMarginB.count > listMarginCount) {
            console.log("Removing excess entry:", newlistMarginB.count);
            newlistMarginB.remove(newlistMarginB.count - 1);
        }

        // ✅ Check and update existing entries
        var found = false;
        for (var i = 0; i < newlistMarginB.count; i++) {
            if (newlistMarginB.get(i).list_marginB === JsonObject.marginNo) {
                found = true;
                newlistMarginB.set(i, {
                    "voltageIndex": i,
                    "list_marginB": JsonObject.marginNo,
                    "valueMarginB": valueMarginB,
                    "unitMarginB": unitMarginB
                });
                console.log("Updated existing entry:", JsonObject.marginNo);
                break;
            }
        }

        // ✅ Append if not found
        if (!found && newlistMarginB.count < listMarginCount) {
            newlistMarginB.append({
                "voltageIndex": newlistMarginB.count,
                "list_marginB": JsonObject.marginNo,
                "valueMarginB": valueMarginB,
                "unitMarginB": unitMarginB
            });
            console.log("Added new entry:", JsonObject.marginNo);
        }
    }

    function appendNewMarginlistC(message) {
        var JsonObject = JSON.parse(message);
        var listMarginCount = parseInt(JsonObject.marginNo.replace("Margin", ""));
        var valueMarginC = JsonObject.valueOfMargin; // 300
        var unitMarginC = JsonObject.unit; // mV

        console.log("Appending to newlistMarginC: Count", listMarginCount, "Value:", valueMarginC, "Unit:", unitMarginC);

        // ✅ Remove extra entries if the new count is smaller
        while (newlistMarginC.count > listMarginCount) {
            console.log("Removing excess entry:", newlistMarginC.count);
            newlistMarginC.remove(newlistMarginC.count - 1);
        }

        // ✅ Check and update existing entries
        var found = false;
        for (var i = 0; i < newlistMarginC.count; i++) {
            if (newlistMarginC.get(i).list_marginC === JsonObject.marginNo) {
                found = true;
                newlistMarginC.set(i, {
                    "voltageIndex": i,
                    "list_marginC": JsonObject.marginNo,
                    "valueMarginC": valueMarginC,
                    "unitMarginC": unitMarginC
                });
                console.log("Updated existing entry:", JsonObject.marginNo);
                break;
            }
        }

        // ✅ Append if not found
        if (!found && newlistMarginC.count < listMarginCount) {
            newlistMarginC.append({
                "voltageIndex": newlistMarginC.count,
                "list_marginC": JsonObject.marginNo,
                "valueMarginC": valueMarginC,
                "unitMarginC": unitMarginC
            });
            console.log("Added new entry:", JsonObject.marginNo);
        }
    }

//    function clearAlarmLogIncrementally() {
//        console.log("[clearAlarmLogIncrementally] Starting incremental clear...");

//        let itemCount = eventAlarmLog.count;

//        for (let i = itemCount - 1; i >= 0; i--) {
//            eventAlarmLog.remove(i);
//        }

//        console.log("[clearAlarmLogIncrementally] Log cleared successfully!");
//    }
    function clearAlarmLog() {
        console.log("[clearAlarmLog] clearing event page source only")

        eventShadow = []
        eventAlarmLog.clear()

        console.log("[clearAlarmLog] eventShadow =", eventShadow.length,
                    "eventModel =", eventAlarmLog.count,
                    "historyShadow =", historyShadow.length,
                    "historyModel =", eventAlarmHistoryLog.count)
    }

    WebSocket {
        id: socketCPP
        url: "ws://127.0.0.1:"+socketPort+""
        property bool checkuser: true

        onTextMessageReceived: {
            qmlSubmitTextFiled(message)
            if (message != ""){
//                console.log("onTextMessageReceived",message);
            }
        }
        onStatusChanged: if (socketCPP.status == WebSocket.Error) {
                             console.log("socketCPP Error: " + socketCPP.errorString)
                         }
                         else if (socketCPP.status == WebSocket.Open)
                         {
                             let hasSentTaggingCommands = false;
                             console.log("socketCPP Hello World")
//                             var selectUserType = '{"objectName":"UserSelectM","userType": "Master" ,"userStatusMaster": '+usertypeSelectMaster+'}'
//                             qmlCommand(selectUserType);
                             if (socketCPP.status == WebSocket.Open && !hasSentTaggingCommands) {

//                                 var tableTaggingPhaseA = '{"objectName":"TaggingPhaseA", "tableTaggingPhaseA": "TaggingPhaseA"}';
//                                 qmlCommand(tableTaggingPhaseA);
//                                 var tableTaggingPhaseB = '{"objectName":"TaggingPhaseB", "tableTaggingPhaseB": "TaggingPhaseB"}';
//                                 qmlCommand(tableTaggingPhaseB);
//                                 var tableTaggingPhaseC = '{"objectName":"TaggingPhaseC", "tableTaggingPhaseC": "TaggingPhaseC"}';
//                                 qmlCommand(tableTaggingPhaseC);
                                 hasSentTaggingCommands = true;
//                                 var threshold = "getCurrentThreshold";
//                                 qmlCommand(threshold);
//                                 var settingInfo = "SettingGeneral";
//                                 qmlCommand(settingInfo);
//                                 var getpreiodicInfo = "getpreiodicInfo";
//                                 qmlCommand(getpreiodicInfo);
//                                 var startPloting = '{"objectName":"startPlotingDataPhaseA", "threshold": 1500, "sagFactor": 0.983, "samplingRate": 10, "distanceToStart": 0, "distanceToShow": 8500}';
//                                 qmlCommand(startPloting);
//                                 var updateValueMargin = "updateValueMargin";
//                                 qmlCommand(updateValueMargin);
//                                 var getStatusOfButtonHidding= '{"objectName":"getStatusOfButtonHidding"}';
//                                 qmlCommand(getStatusOfButtonHidding);

//                                 var login = JSON.stringify({"objectName": "login","username": "admin","password": "password"});
//                                 qmlCommand(login);

                             }

                         }
                         else if (socketCPP.status == WebSocket.Closed)
                         {
                             console.log("Socket closed")
//                             connectToCPPServer.running = true
//                             connectToCPPServer.repeat = true
//                             connectToCPPServer.start()
//                             socketCPP.active = false
                         }
        active: false
    }





    function socketConnect() {
        if (socket.status === WebSocket.Open){
            connectToServer.running = false
            connectToServer.repeat = false
            connectToServer.stop()
        }else{
            if(socketPort == 0){
                sockStart=false
            }else{
                sockStart=true
                if (socketCPP.active === true){
                    if (socketCPP.status === WebSocket.Open) {
                        socketCPP.sendTextMessage("Test message from QML!");
                    }
                }
                console.log("Reconnecting....")
                if (socket.status === WebSocket.Error)
                {
                    console.log("Error: " + socket.errorString)
                }
                else if (socket.status === WebSocket.Open)
                {
                    console.log("Socket opened")
                }
                else if (socket.status === WebSocket.Closed)
                {
                    console.log("Socket closed")
                }
            }
        }
    }
    onSockStartChanged: {
        sockStart.active = !sockStart.active
        console.log("socket.active",socket.active)
    }
    Component.onCompleted: {
        console.log("Testing WebSocket connection...");
        socketCPP.active = true;
        console.log("status of socket",socketCPP.active);
        socketConnectToCpp =  '{"objectName":"socketConnect","socketCPP": "'+ socketCPP.active+'"}'
        console.log("socketConnect_onCompleted:",socketConnect);
        timerConnectSocket.start();
        Qt.inputMethod.hide()
        inputPanel.visible = false
        textInformation.visible = false
        textInformation.focus = false
//        disconnectPopup.open();
    }

    function startEdit(fieldName, hints) {
        currentField = fieldName
        if (hints !== undefined) {
            textInformation.inputMethodHints = hints
            textInformation.inputMethodHints = hints

        } else {
            textInformation.inputMethodHints = Qt.ImhNoPredictiveText
        }
        textInformation.visible = true
        textInformation.forceActiveFocus()   // ได้โฟกัส -> คีย์บอร์ดเด้งเอง (ดู onActiveFocusChanged ด้านล่าง)
    }
    // ฟังก์ชันหยุดแก้ไข + เคลียร์ state
    function stopEdit(commit) {
        if (commit && currentField === "namesearch") {
            namesearch.text = textInformation.text
        }
        userEditing = false
        currentField = ""
        Qt.inputMethod.hide()
        textInformation.visible = false
    }


    InputPanel {
        id: inputPanel
        y: 369
        height: 231
        visible: Qt.inputMethod.visible || userEditing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        Connections {
            target: Qt.inputMethod
            function onVisibleChanged() {
                if (!Qt.inputMethod.visible && userEditing)
                    stopEdit(true)
            }
        }

        onVisibleChanged: {
            if (inputPanel.visible && !textInformation.focus) {
                textInformation.visible = false
                textInformation.focus = false
            }else{
                focusIndex = -1;
                textInformation.visible = true
            }
        }
        Connections {
            target: Qt.inputMethod
            function onVisibleChanged() {
                if (!Qt.inputMethod.visible) {
                    if (userEditing) stopEdit()
                }
            }
        }

        // Connections {
        //     target: Qt.inputMethod
        //     function onVisibleChanged() {
        //         if (Qt.inputMethod.visible) {
        //             console.log("Keyboard shown");
        //             inputPanel.visible = true;
        //             textInformation.visible = true;
        //             if (!textInformation.focus) {
        //                 textInformation.focus = true;
        //             }
        //         } else {
        //             console.log("Keyboard hidden");
        //             inputPanel.visible = false;
        //             textInformation.visible = false;
        //             textInformation.focus = false;
        //         }
        //     }

        // }

//        Connections {
//            target: stackView.currentItem
//            onPlottingFinished: {
//                console.log("✅ Plotting finished received via StackView");
//                returntoMainPage.running = true;
//            }
//        }

//        Connections {
//            target: Qt.inputMethod
//            function onVisibleChanged() {
//                if (Qt.inputMethod.visible) {
//                    console.log("Keyboard shown");
//                    inputPanel.visible = true;
//                    textInformation.visible = true;
//                    if (!textInformation.focus) {
//                        textInformation.focus = true;
//                    }
//                } else {
//                    console.log("Keyboard hidden");
//                    inputPanel.visible = false;
//                    textInformation.visible = false;
//                    textInformation.focus = false;
//                }
//            }
//        }

        // TextField สำหรับพิมพ์ข้อความ
        TextField {
            id: textInformation
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.bottomMargin: 320
            anchors.leftMargin: 0
            anchors.topMargin: -130
            placeholderText: qsTr("Text Field")
            visible: false
//            inputMethodHints: Qt.ImhFormattedNumbersOnly
            font.pointSize: 12
            onActiveFocusChanged: {
                if (activeFocus && userEditing) Qt.inputMethod.show()
            }

            Keys.onReturnPressed: {
                if (text.trim() !== "" || currentField == "valueLineNo") {
                    console.log("Enter key pressed! Value:", currentField);
                    if (currentField === "valueVoltages") {
                        textInformation.text = text;
                        var Voltage = '{"objectName":"VoltageInfo","Voltage": '+textInformation.text+'}'
                        qmlCommand(Voltage);
                        console.log("Voltage Entered:", text, Voltage);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    } else if (currentField === "valueSubstation") {
                        textInformation.text = text;
                        var Substation = '{"objectName":"Substations","Substation": "'+textInformation.text+'"}'
                        qmlCommand(Substation);
                        console.log("Substation Entered:", text,Substation);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    } else if (currentField === "valueDirection") {
                        textInformation.text = text;
                        var Direction = '{"objectName":"Direction","Direction": "'+textInformation.text+'"}'
                        qmlCommand(Direction);
                        console.log("Direction Entered:", text,Direction);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                        });
                    } else if (currentField === "valueLineNo") {
                        var value = textInformation.text;  // อาจเป็น "" หรือมีค่า
                        var LineNo = `{"objectName":"LineNo", "LineNo":"${value}"}`;
                        qmlCommand(LineNo);
                        console.log("Line No Entered:", `"${value}"`, LineNo);
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
//                        textInformation.text = "";
                    }else if (currentField === "textTime") {
                        textInformation.text = text;
                        var Time = '{"objectName":"updatetextTime","Time": "'+textInformation.text+'"}'
                        qmlCommand(Time);
                        console.log("Time Entered:", text,Time);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    } else if (currentField === "distanceField") {
                        textInformation.text = text;
                        var Distance = '{"objectName":"distanceField","distanceField": '+textInformation.text+'}'
                        qmlCommand(Distance);
                        console.log("Distance Entered:", text, Distance);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    } else if (currentField === "detailField") {
                        textInformation.text = text;
                        var Detail = '{"objectName":"detailField","detailField": ' + textInformation.text + '}';
                        qmlCommand(Detail);
                        console.log("Detail Entered:", text,Detail);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    } else if (currentField === "sagText") {
                        textInformation.text = text;
                        var Sag = '{"objectName":"sagText","sagText": '+textInformation.text+'}'
                        qmlCommand(Sag);
                        console.log("Sag Entered:", text, Sag);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    } else if (currentField === "samplingText") {
                        textInformation.text = text;
                        if(textInformation.text < 60){
                            textInformation.text = 60
                            var Sampling = '{"objectName":"samplingText","samplingText": '+textInformation.text+'}'
                            qmlCommand(Sampling);
                            console.log("Sampling Entered 60:", text,Sampling);
//                            textInformation.text = "";
                            Qt.callLater(function() {
                                textInformation.text = "";
                                hideKeyboard()
                            });
                        }else if(textInformation.text > 480){
                            textInformation.text = 480
                            var Sampling = '{"objectName":"samplingText","samplingText": '+textInformation.text+'}'
                            qmlCommand(Sampling);
                            console.log("Sampling Entered 480:", text,Sampling);
//                            textInformation.text = "";
                            Qt.callLater(function() {
                                textInformation.text = "";
                                hideKeyboard()
                            });
                        }else{
                            var Sampling = '{"objectName":"samplingText","samplingText": '+textInformation.text+'}'
                            qmlCommand(Sampling);
                            console.log("Sampling Entered normal:", text,Sampling);
//                            textInformation.text = "";
                            Qt.callLater(function() {
                                textInformation.text = "";
                                hideKeyboard()
                            });
                        }

                    } else if (currentField === "distancetostartText") {
                        textInformation.text = text;
                        var distancetostart = '{"objectName":"distancetostartText","distancetostartText": '+textInformation.text+'}'
                        qmlCommand(distancetostart);
                        console.log("Dist. Start Entered:", text,distancetostart);
                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    } else if (currentField === "distancetoshowText") {
                        textInformation.text = text;
                        var distancetoshow = '{"objectName":"distancetoshowText","distancetoshowText": '+textInformation.text+'}'
                        qmlCommand(distancetoshow);
                        console.log("Dist. Show Entered:", text,distancetoshow);
                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    } else if (currentField === "fulldistanceText") {
                        textInformation.text = text;
                        var fulldistance = '{"objectName":"fulldistanceText","fulldistanceText": '+textInformation.text+'}'
                        qmlCommand(fulldistance);
                        console.log("Full Dist. Entered:", text,fulldistance);
                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    } else if (currentField === "settingIPaddress") {
                        textInformation.text = text;
                        var IpAddress = '{"objectName":"settingIPaddress","settingIPaddress": '+textInformation.text+'}'
//                        qmlCommand(IpAddress);
                        console.log("IpAddress Entered:", text, IpAddress);
                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    } else if (currentField === "settinggateway") {
                        textInformation.text = text;
                        var GateWays = '{"objectName":"settinggateway","settinggateway": '+textInformation.text+'}'
//                        qmlCommand(GateWays);
                        console.log("IpAddress Entered:", text, IpAddress);
                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "detailFieldTagging") {
                        textInformation.text = text;
                        var Detail = '{"objectName":"detailField","detailField": "' + textInformation.text + '"}';
                        console.log("Detail Entered:", text, Detail);
                        qmlCommand(Detail)
                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "distanceFieldTagging") {
                        textInformation.text = text;
                        var Distance = '{"objectName":"distanceField","distanceField": ' + textInformation.text + '}';
                        console.log("distanceField Entered:", text, Distance);
                        qmlCommand(Distance)
                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "marginNumberA") {
                        textInformation.text = text;
                        amontOfMarginA = textInformation.text
                        var marginA = '{"objectName":"marginCountA", "valueMarginA":'+textInformation.text +', "PHASE": "A"}';
                        qmlCommand(marginA);
                        console.log("MarginNumberA Entered:", text, marginA);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "marginNumberB") {
                        textInformation.text = text;
                        amontOfMarginB = textInformation.text
                        var marginB = '{"objectName":"marginCountB", "valueMarginB":'+textInformation.text +', "PHASE": "B"}';
                        qmlCommand(marginB);
                        console.log("MarginNumberB Entered:", text, marginB);
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "marginNumberC") {
                        textInformation.text = text;
                        amontOfMarginC = textInformation.text
                        var marginC = '{"objectName":"marginCountC", "valueMarginC":'+textInformation.text +', "PHASE": "C"}';
                        qmlCommand(marginC);
                        console.log("MarginNumberC Entered:", text, marginC);
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
//                        textInformation.text = "";
                    }else if (currentField === "textPhaseA") {
                        textInformation.text = text;
                        var thresholdA = '{"objectName":"textPhaseA", "thresholdA":'+textInformation.text +', "PHASE": "A"}';
                        qmlCommand(thresholdA);
                        console.log("thresholdA Entered:", text, thresholdA);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "textPhaseB") {
                        textInformation.text = text;
                        var thresholdB = '{"objectName":"textPhaseB", "thresholdB":'+textInformation.text +', "PHASE": "B"}';
                        qmlCommand(thresholdB);
                        console.log("thresholdB Entered:", text, thresholdB);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "textPhaseC") {
                        textInformation.text = text;
                        var thresholdC = '{"objectName":"textPhaseC", "thresholdC":'+textInformation.text +', "PHASE": "C"}';
                        qmlCommand(thresholdC);
                        console.log("thresholdC Entered:", text, thresholdC);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "rangedistance") {
                        textInformation.text = text;
                        let range = '{"objectName":"positionDistance", "distance": "'+textInformation.text +'"}';
                        qmlCommand(range);
                        console.log("range Entered:", range);
//                        textInformation.text = "";
//                        textInformation.focus = false;
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "textUserName") {
                        textInformation.text = text;
                        var User = '{"objectName":"UserName", "textUserName":'+textInformation.text +'}';
                        qmlCommand(User);
                        console.log("range Entered:", text, User);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "textPassword") {
                        textInformation.text = text;
                        var Password = '{"objectName":"Password", "textPassword":'+textInformation.text +'}';
                        qmlCommand(Password);
                        console.log("range Entered:", text, Password);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "valueVoltageA") {
                        textInformation.text = text;
                        var marginVoltageA = '{"objectName":"valueMarginVoltageAauto", "valueVoltageA":'+textInformation.text +'}';
                        qmlCommand(marginVoltageA);
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
//                        console.log("marginVoltageA Entered:", text, marginVoltageA);
                    }else if (currentField === "valueVoltageB") {
                        textInformation.text = text;
                        var marginVoltageB = '{"objectName":"valueMarginVoltageBauto", "valueVoltageB":'+textInformation.text +'}';
                        qmlCommand(marginVoltageB);
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
//                        console.log("marginVoltageA Entered:", text, marginVoltageA);
                    }else if (currentField === "valueVoltageC") {
                        textInformation.text = text;
                        var marginVoltageC = '{"objectName":"valueMarginVoltageCauto", "valueVoltageC":'+textInformation.text +'}';
                        qmlCommand(marginVoltageC);
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
//                        console.log("marginVoltageA Entered:", text, marginVoltageA);
                    }else if (currentField === "cheangeValueofVoltageA") {
                        textInformation.text = text;
                        var valueVoltageA = '{"objectName":"valueMarginVoltageA", "valueVoltageA":'+textInformation.text +',"focusIndex":'+focusIndex+',"listMarginA":'+listMarginA+',"PHASE": "A"}';
                        console.log("marginVoltageA Entered:", text, valueVoltageA, focusIndex,listMarginA);
                        qmlCommand(valueVoltageA);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "cheangeValueofVoltageB") {
                        textInformation.text = text;
                        var valueVoltageB = '{"objectName":"valueMarginVoltageB", "valueVoltageB":'+textInformation.text +',"focusIndex":'+focusIndex+',"listMarginB":'+listMarginB+',"PHASE": "B"}';
                        console.log("marginVoltageB Entered:", text, valueVoltageB, focusIndex,listMarginB);
                        qmlCommand(valueVoltageB);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "cheangeValueofVoltageC") {
                        textInformation.text = text;
                        var valueVoltageC = '{"objectName":"valueMarginVoltageC", "valueVoltageC":'+textInformation.text +',"focusIndex":'+focusIndex+',"listMarginC":'+listMarginC+',"PHASE": "C"}';
                        console.log("marginVoltageC Entered:", text, valueVoltageC, focusIndex,listMarginC);
                        qmlCommand(valueVoltageC);
//                        textInformation.text = "";
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "UserLevelName") {
                        textInformation.text = text;
                        console.log("UserLevelName Entered:", text,currentField);
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "PasswordLevelName") {
                        textInformation.text = text;
                        console.log("PasswordLevelName Entered:", text,currentField);

                        Qt.callLater(function() {
                            textInformation.text = ""
                            hideKeyboard()
                        })
                    }else if (currentField === "namesearch") {
                        textInformation.text = text;
                        console.log("namesearch:", text,currentField);
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }else if (currentField === "dataSearch") {
                        textInformation.text = text;
                        console.log("dataSearch:", text,currentField);
                        Qt.callLater(function() {
                            textInformation.text = "";
                            hideKeyboard()
                        });
                    }
                }
                inputPanel.visible = false;
                visible = false;
            }
        }
        Keys.onReturnPressed: stopEdit(true)   // commit แล้วปิด
        Keys.onEnterPressed:  stopEdit(true)
        Keys.onEscapePressed: stopEdit(false)
    }

    Drawer {
        id: drawer_audio
        width: parent.width / 2
        height: parent.height
        x: 0
        y: -height
        modal: true
        dragMargin: 8
        interactive: true
        clip: true
        background: Rectangle {
            color: "#2c2c2c"
            border.color: "#ffffff"
            border.width: 2
            radius: 10
        }
        onOpenedChanged: {
            if (drawer_audio.opened) {
                console.log("Drawer opened");
            } else {
                console.log("Drawer closed");
            }
        }
        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Adjust Brightness"
                font.pixelSize: 18
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Slider {
                id: spinBoxDisplay
                width: parent.width
                height: 30
                rotation: 180
                from: 10
                to: 1
                stepSize: 1
                value: 10
                onValueChanged: {
                    spinBoxDisplay.value = value.toFixed(0)
                    var levelOfLight = `{"objectName":"spinBoxDisplay", "displayLight": ${spinBoxDisplay.value}}`;
                    qmlCommand(levelOfLight);
                }
            }

            Text {
                text: "Brightness: " + spinBoxDisplay.value
                font.pixelSize: 16
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Button {
                text: "Reset Graph"
                width: parent.width
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    contorlAndMonitor.resetZoom()
                }
            }
            Button {
                text: "Restart App"
                width: parent.width
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var restartCommand = `{"objectName":"restart_system", "restart_system": "restartiTouch"}`;
                    qmlCommand(restartCommand);
                    console.log("Restart system command sent");
                }
            }

            Button {
                text: "Restart Sys."
                width: parent.width
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var restartCommand = `{"objectName":"restartSystemItouch", "restart_system": "restartSystemItouch"}`;
                    qmlCommand(restartCommand);
                    console.log("Restart system (SystemItouch) command sent");
                }
            }

            Button {
                text: "Shutdown"
                width: parent.width
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var restartCommand = `{"objectName":"ShutDownSystemItouch", "shutdown_system": "shutdownSystemItouch"}`;
                    qmlCommand(restartCommand);
                    console.log("shutdown system (SystemItouch) command sent");
                }
            }
        }
    }

//    Drawer {
//        id: drawer_audio
//        width: parent.width / 2
//        height: parent.height / 2
//        x: 0
//        y: -height
//        modal: true
//        dragMargin: 8
//        interactive: true
//        clip: true

//        background: Rectangle {
//            color: "#2c2c2c" // สีพื้นหลัง
//            border.color: "#ffffff"
//            border.width: 2
//            radius: 10
//        }

//        onOpenedChanged: {
//            if (drawer_audio.opened) {
//                console.log("Drawer opened");
//            } else {
//                console.log("Drawer closed");
//            }
//        }

//        Column {
//            anchors.centerIn: parent
//            spacing: 20

//            Text {
//                text: "Adjust Brightness"
//                font.pixelSize: 18
//                color: "white"
//                anchors.horizontalCenter: parent.horizontalCenter
//            }

//            Slider {
//                id: spinBoxDisplay
//                width: parent.width
//                height: 30
//                rotation: 180
//                from: 10
//                to: 1
//                stepSize: 1
//                value: 10

//                onValueChanged: {
//                    spinBoxDisplay.value = value.toFixed(0)
//                    var levelOfLight = `{"objectName":"spinBoxDisplay", "displayLight": ${spinBoxDisplay.value}}`;
//                    qmlCommand(levelOfLight);
//                }
//            }

//            Text {
//                text: "Brightness: " + spinBoxDisplay.value
//                font.pixelSize: 16
//                color: "white"
//                anchors.horizontalCenter: parent.horizontalCenter
//            }
//        }
//    }
    PopupWarningPeriodic {
        id: popupWarningPeriodic
        anchors.fill: parent

        onAccepted: function(modeLocal, recordPeriodicRaw) {
            console.log("Periodic popup accepted:", modeLocal, recordPeriodicRaw)
            // ถ้าจะส่ง confirm กลับ C++ ก็ทำตรงนี้ได้
            // qmlCommand('{"objectName":"PeriodicwarningAck","ok":true}')
        }
    }
    Connections {
        target: popupWarningPeriodic

        function onAccepted(modeLocal, recordPeriodicRaw, localPeriodicRaw, diffMin) {
            console.log("✅ Periodicwarning OK pressed:",
                        "modeLocal=", modeLocal,
                        "local=", localPeriodicRaw,
                        "remote=", recordPeriodicRaw,
                        "diffMin=", diffMin)

            // ✅ start reminder cycle
            periodicAcceptedLocalSnapshot = localPeriodicRaw || ""
            periodicRemindActive = true
            periodicRemindTimer.restart()
        }
    }
    SavePopUp {
        id: savePopUp
    }
}





/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:480;width:640}
}
##^##*/
