import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.VirtualKeyboard 2.4
import QtQuick.Controls 2.15
import QtQuick3D.Effects 1.15
import QtQuick.Layouts 1.0
import QtWebSockets 1.0

Window {
    id: window
    visible: true
    width: 1024
    height: 600
    property int userLevel: 0
    signal getScreenshot()
    property string serverAddress: "127.0.0.1"
    property var socketPort: 1234
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

    property int listMarginB: 0
    property string marginB: ""
    property int valueMarginB: 0
    property string unitMaginB: ""
    property bool statusMaginB

    property int listMarginC: 0
    property string marginC: ""
    property int valueMarginC: 0
    property string unitMaginC: ""
    property bool statusMaginC


    property double valueThresholdA: 0.0
    property double valueThresholdB: 0.0
    property double valueThresholdC: 0.0

    property double voltageInfo: 0.0
    property string substationInfo: ""
    property string directionInfo: ""
    property int linenoInfo: 0

    property double time: 0.0
    property bool updateMonday
    property bool updateTuesday
    property bool updateWednesday
    property bool updateThursday
    property bool updateFriday
    property bool updateSaturday
    property bool updateSunday
    property double minAxisY
    property double maxAxisY
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
    property var fulldistances
    property var plotDataAX: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,963,964,965,966,967,968,969,970,971,972,973,974,975,976,977,978,979,980,981,982,983,984,985,986,987,988,989,990,991,992,993,994,995,996,997,998,999,1000]
    property var plotDataAY: [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.10,0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.20,0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.30,0.31,0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.40,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.50,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.60,0.61,0.62,0.63,0.64,0.65,0.66,0.67,0.68,0.69,0.70,0.71,0.72,0.73,0.74,0.75,0.76,0.77,0.78,0.79,0.80,0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,0.100,0.101,0.102,0.103,0.104,0.105,0.106,0.107,0.108,0.109,0.110,0.111,0.112,0.113,0.114,0.115,0.116,0.117,0.118,0.119,0.120,0.121,0.122,0.123,0.124,0.125,0.126,0.127,0.128,0.129,0.130,0.131,0.132,0.133,0.134,0.135,0.136,0.137,0.138,0.139,0.140,0.141,0.142,0.143,0.144,0.145,0.146,0.147,0.148,0.149,0.150,0.151,0.152,0.153,0.154,0.155,0.156,0.157,0.158,0.159,0.160,0.161,0.162,0.163,0.164,0.165,0.166,0.167,0.168,0.169,0.170,0.171,0.172,0.173,0.174,0.175,0.176,0.177,0.178,0.179,0.180,0.181,0.182,0.183,0.184,0.185,0.186,0.187,0.188,0.189,0.190,0.191,0.192,0.193,0.194,0.195,0.196,0.197,0.198,0.199,0.200,0.201,0.202,0.203,0.204,0.205,0.206,0.207,0.208,0.209,0.210,0.211,0.212,0.213,0.214,0.215,0.216,0.217,0.218,0.219,0.220,0.221,0.222,0.223,0.224,0.225,0.226,0.227,0.228,0.229,0.230,0.231,0.232,0.233,0.234,0.235,0.236,0.237,0.238,0.239,0.240,0.241,0.242,0.243,0.244,0.245,0.246,0.247,0.248,0.249,0.250,0.251,0.252,0.253,0.254,0.255,0.256,0.257,0.258,0.259,0.260,0.261,0.262,0.263,0.264,0.265,0.266,0.267,0.268,0.269,0.270,0.271,0.272,0.273,0.274,0.275,0.276,0.277,0.278,0.279,0.280,0.281,0.282,0.283,0.284,0.285,0.286,0.287,0.288,0.289,0.290,0.291,0.292,0.293,0.294,0.295,0.296,0.297,0.298,0.299,0.300,0.301,0.302,0.303,0.304,0.305,0.306,0.307,0.308,0.309,0.310,0.311,0.312,0.313,0.314,0.315,0.316,0.317,0.318,0.319,0.320,0.321,0.322,0.323,0.324,0.325,0.326,0.327,0.328,0.329,0.330,0.331,0.332,0.333,0.334,0.335,0.336,0.337,0.338,0.339,0.340,0.341,0.342,0.343,0.344,0.345,0.346,0.347,0.348,0.349,0.350,0.351,0.352,0.353,0.354,0.355,0.356,0.357,0.358,0.359,0.360,0.361,0.362,0.363,0.364,0.365,0.366,0.367,0.368,0.369,0.370,0.371,0.372,0.373,0.374,0.375,0.376,0.377,0.378,0.379,0.380,0.381,0.382,0.383,0.384,0.385,0.386,0.387,0.388,0.389,0.390,0.391,0.392,0.393,0.394,0.395,0.396,0.397,0.398,0.399,0.400,0.401,0.402,0.403,0.404,0.405,0.406,0.407,0.408,0.409,0.410,0.411,0.412,0.413,0.414,0.415,0.416,0.417,0.418,0.419,0.420,0.421,0.422,0.423,0.424,0.425,0.426,0.427,0.428,0.429,0.430,0.431,0.432,0.433,0.434,0.435,0.436,0.437,0.438,0.439,0.440,0.441,0.442,0.443,0.444,0.445,0.446,0.447,0.448,0.449,0.450,0.451,0.452,0.453,0.454,0.455,0.456,0.457,0.458,0.459,0.460,0.461,0.462,0.463,0.464,0.465,0.466,0.467,0.468,0.469,0.470,0.471,0.472,0.473,0.474,0.475,0.476,0.477,0.478,0.479,0.480,0.481,0.482,0.483,0.484,0.485,0.486,0.487,0.488,0.489,0.490,0.491,0.492,0.493,0.494,0.495,0.496,0.497,0.498,0.499,0.500,0.002,0.004,0.006,0.008,0.01,0.012,0.014,0.016,0.018,0.02,0.022,0.024,0.026,0.028,0.03,0.032,0.034,0.036,0.038,0.04,0.042,0.044,0.046,0.048,0.05,0.052,0.054,0.056,0.058,0.06,0.062,0.064,0.066,0.068,0.07,0.072,0.074,0.076,0.078,0.08,0.082,0.084,0.086,0.088,0.09,0.092,0.094,0.096,0.098,0.1,0.102,0.104,0.106,0.108,0.11,0.112,0.114,0.116,0.118,0.12,0.122,0.124,0.126,0.128,0.13,0.132,0.134,0.136,0.138,0.14,0.142,0.144,0.146,0.148,0.15,0.152,0.154,0.156,0.158,0.16,0.162,0.164,0.166,0.168,0.17,0.172,0.174,0.176,0.178,0.18,0.182,0.184,0.186,0.188,0.19,0.192,0.194,0.196,0.198,0.2,0.202,0.204,0.206,0.208,0.21,0.212,0.214,0.216,0.218,0.22,0.222,0.224,0.226,0.228,0.23,0.232,0.234,0.236,0.238,0.24,0.242,0.244,0.246,0.248,0.25,0.252,0.254,0.256,0.258,0.26,0.262,0.264,0.266,0.268,0.27,0.272,0.274,0.276,0.278,0.28,0.282,0.284,0.286,0.288,0.29,0.292,0.294,0.296,0.298,0.3,0.302,0.304,0.306,0.308,0.31,0.312,0.314,0.316,0.318,0.32,0.322,0.324,0.326,0.328,0.33,0.332,0.334,0.336,0.338,0.34,0.342,0.344,0.346,0.348,0.35,0.352,0.354,0.356,0.358,0.36,0.362,0.364,0.366,0.368,0.37,0.372,0.374,0.376,0.378,0.38,0.382,0.384,0.386,0.388,0.39,0.392,0.394,0.396,0.398,0.4,0.402,0.404,0.406,0.408,0.41,0.412,0.414,0.416,0.418,0.42,0.422,0.424,0.426,0.428,0.43,0.432,0.434,0.436,0.438,0.44,0.442,0.444,0.446,0.448,0.45,0.452,0.454,0.456,0.458,0.46,0.462,0.464,0.466,0.468,0.47,0.472,0.474,0.476,0.478,0.48,0.482,0.484,0.486,0.488,0.49,0.492,0.494,0.496,0.498,0.5,0.502,0.504,0.506,0.508,0.51,0.512,0.514,0.516,0.518,0.52,0.522,0.524,0.526,0.528,0.53,0.532,0.534,0.536,0.538,0.54,0.542,0.544,0.546,0.548,0.55,0.552,0.554,0.556,0.558,0.56,0.562,0.564,0.566,0.568,0.57,0.572,0.574,0.576,0.578,0.58,0.582,0.584,0.586,0.588,0.59,0.592,0.594,0.596,0.598,0.6,0.602,0.604,0.606,0.608,0.61,0.612,0.614,0.616,0.618,0.62,0.622,0.624,0.626,0.628,0.63,0.632,0.634,0.636,0.638,0.64,0.642,0.644,0.646,0.648,0.65,0.652,0.654,0.656,0.658,0.66,0.662,0.664,0.666,0.668,0.67,0.672,0.674,0.676,0.678,0.68,0.682,0.684,0.686,0.688,0.69,0.692,0.694,0.696,0.698,0.7,0.702,0.704,0.706,0.708,0.71,0.712,0.714,0.716,0.718,0.72,0.722,0.724,0.726,0.728,0.73,0.732,0.734,0.736,0.738,0.74,0.742,0.744,0.746,0.748,0.75,0.752,0.754,0.756,0.758,0.76,0.762,0.764,0.766,0.768,0.77,0.772,0.774,0.776,0.778,0.78,0.782,0.784,0.786,0.788,0.79,0.792,0.794,0.796,0.798,0.8,0.802,0.804,0.806,0.808,0.81,0.812,0.814,0.816,0.818,0.82,0.822,0.824,0.826,0.828,0.83,0.832,0.834,0.836,0.838,0.84,0.842,0.844,0.846,0.848,0.85,0.852,0.854,0.856,0.858,0.86,0.862,0.864,0.866,0.868,0.87,0.872,0.874,0.876,0.878,0.88,0.882,0.884,0.886,0.888,0.89,0.892,0.894,0.896,0.898,0.9,0.902,0.904,0.906,0.908,0.91,0.912,0.914,0.916,0.918,0.92,0.922,0.924,0.926,0.928,0.93,0.932,0.934,0.936,0.938,0.94,0.942,0.944,0.946,0.948,0.95,0.952,0.954,0.956,0.958,0.96,0.962,0.964,0.966,0.968,0.97,0.972,0.974,0.976,0.978,0.98,0.982,0.984,0.986,0.988,0.99,0.992,0.994,0.996,0.998,1.0]
    property var plotDataBX: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500]
    property var plotDataBY: [0.002,0.004,0.006,0.008,0.01,0.012,0.014,0.016,0.018,0.02,0.022,0.024,0.026,0.028,0.03,0.032,0.034,0.036,0.038,0.04,0.042,0.044,0.046,0.048,0.05,0.052,0.054,0.056,0.058,0.06,0.062,0.064,0.066,0.068,0.07,0.072,0.074,0.076,0.078,0.08,0.082,0.084,0.086,0.088,0.09,0.092,0.094,0.096,0.098,0.1,0.102,0.104,0.106,0.108,0.11,0.112,0.114,0.116,0.118,0.12,0.122,0.124,0.126,0.128,0.13,0.132,0.134,0.136,0.138,0.14,0.142,0.144,0.146,0.148,0.15,0.152,0.154,0.156,0.158,0.16,0.162,0.164,0.166,0.168,0.17,0.172,0.174,0.176,0.178,0.18,0.182,0.184,0.186,0.188,0.19,0.192,0.194,0.196,0.198,0.2,0.202,0.204,0.206,0.208,0.21,0.212,0.214,0.216,0.218,0.22,0.222,0.224,0.226,0.228,0.23,0.232,0.234,0.236,0.238,0.24,0.242,0.244,0.246,0.248,0.25,0.252,0.254,0.256,0.258,0.26,0.262,0.264,0.266,0.268,0.27,0.272,0.274,0.276,0.278,0.28,0.282,0.284,0.286,0.288,0.29,0.292,0.294,0.296,0.298,0.3,0.302,0.304,0.306,0.308,0.31,0.312,0.314,0.316,0.318,0.32,0.322,0.324,0.326,0.328,0.33,0.332,0.334,0.336,0.338,0.34,0.342,0.344,0.346,0.348,0.35,0.352,0.354,0.356,0.358,0.36,0.362,0.364,0.366,0.368,0.37,0.372,0.374,0.376,0.378,0.38,0.382,0.384,0.386,0.388,0.39,0.392,0.394,0.396,0.398,0.4,0.402,0.404,0.406,0.408,0.41,0.412,0.414,0.416,0.418,0.42,0.422,0.424,0.426,0.428,0.43,0.432,0.434,0.436,0.438,0.44,0.442,0.444,0.446,0.448,0.45,0.452,0.454,0.456,0.458,0.46,0.462,0.464,0.466,0.468,0.47,0.472,0.474,0.476,0.478,0.48,0.482,0.484,0.486,0.488,0.49,0.492,0.494,0.496,0.498,0.5,0.502,0.504,0.506,0.508,0.51,0.512,0.514,0.516,0.518,0.52,0.522,0.524,0.526,0.528,0.53,0.532,0.534,0.536,0.538,0.54,0.542,0.544,0.546,0.548,0.55,0.552,0.554,0.556,0.558,0.56,0.562,0.564,0.566,0.568,0.57,0.572,0.574,0.576,0.578,0.58,0.582,0.584,0.586,0.588,0.59,0.592,0.594,0.596,0.598,0.6,0.602,0.604,0.606,0.608,0.61,0.612,0.614,0.616,0.618,0.62,0.622,0.624,0.626,0.628,0.63,0.632,0.634,0.636,0.638,0.64,0.642,0.644,0.646,0.648,0.65,0.652,0.654,0.656,0.658,0.66,0.662,0.664,0.666,0.668,0.67,0.672,0.674,0.676,0.678,0.68,0.682,0.684,0.686,0.688,0.69,0.692,0.694,0.696,0.698,0.7,0.702,0.704,0.706,0.708,0.71,0.712,0.714,0.716,0.718,0.72,0.722,0.724,0.726,0.728,0.73,0.732,0.734,0.736,0.738,0.74,0.742,0.744,0.746,0.748,0.75,0.752,0.754,0.756,0.758,0.76,0.762,0.764,0.766,0.768,0.77,0.772,0.774,0.776,0.778,0.78,0.782,0.784,0.786,0.788,0.79,0.792,0.794,0.796,0.798,0.8,0.802,0.804,0.806,0.808,0.81,0.812,0.814,0.816,0.818,0.82,0.822,0.824,0.826,0.828,0.83,0.832,0.834,0.836,0.838,0.84,0.842,0.844,0.846,0.848,0.85,0.852,0.854,0.856,0.858,0.86,0.862,0.864,0.866,0.868,0.87,0.872,0.874,0.876,0.878,0.88,0.882,0.884,0.886,0.888,0.89,0.892,0.894,0.896,0.898,0.9,0.902,0.904,0.906,0.908,0.91,0.912,0.914,0.916,0.918,0.92,0.922,0.924,0.926,0.928,0.93,0.932,0.934,0.936,0.938,0.94,0.942,0.944,0.946,0.948,0.95,0.952,0.954,0.956,0.958,0.96,0.962,0.964,0.966,0.968,0.97,0.972,0.974,0.976,0.978,0.98,0.982,0.984,0.986,0.988,0.99,0.992,0.994,0.996,0.998,1.0]
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
    property string ip_address: ""
    property string ip_gateway: ""
    property string ip_snmp: ""
    property string ip_timeserver: ""

    property var updateMarginA
    property var updateMarginB
    property var updateMarginC
    property string detailwireInformation: ""

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
    property var fullEventData:[];
    property var hiddenEventData:[];


    property double realDistanceA: 0.0
    property double realDistanceB: 0.0
    property double realDistanceC: 0.0
    ListModel {
        id: testGraph
        property var nameX: plotDataAX
        property var nameY: plotDataAY
    }

    ListModel {
        id:newlistdatatebleA
        property bool list_statusA: false
        property int list_numberA: 0
        property int num_listA: 0
        property double list_distanceA: 0.0
        property string list_detailA: ""
        property string list_phaseA: ""
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
        property int userLevel: 0
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

    function getTaggingData(positionX, positionY, globalTempNum) {
        var pointerX = positionX;
        var pointerY = positionY;
        var globalNum = globalTempNum;

        // Append data into the listofTagging property of taggingA
        taggingA.append({
            "globalTempNumA": globalNum,
            "globalPositionX": pointerX,
            "globalPositionY": pointerY
        });

        console.log("Tagging data sent:", positionX, positionY, globalTempNum);
    }


    color: "#f2f2f2"
    title: qsTr("Hello World")
    StackView {
        id: stackView
        anchors.fill: parent
        anchors.topMargin: 0
        anchors.rightMargin: 0
        initialItem: "qrc:/LoginPage.qml"
        onCurrentItemChanged: {
            mainBar.visible = stackView.currentItem.objectName !== "LoginPage"
        }
    }

    MainBar {
        id: mainBar
        x: 0
        y: 0
        width: 1024
        height: 52
    }

    function qmlSubmitTextFiled(message){
        var JsonObject = JSON.parse(message);
        var objectName = JsonObject.objectName;
        var TrapsAlert = JsonObject.TrapsAlert;
        var menuID = JsonObject.objectName;
//        console.log("receviceSocket:", message ,JsonObject,objectName,TrapsAlert,menuID,JSON.parse(message),JsonObject.objectName);

        if(message === true){
            statusSystem = message
//            console.log("receviceSocket:", message, statusSystem);
        }

        if (objectName === "UserSelectM") {
            mainBarMasterSelect = userTypeMaster;
            usertypeSelect = JsonObject.userStatusMaster
        }
        else if (objectName ==="userlavel")
        {
            console.log("iuhododjoewjoidje", message);
            userlavel(message);
        }

        else if  (objectName === "PatternData"){
            console.log("PatternDataQML:", message);
            // const { filename, event_datetime } = JsonObject;
            // var category = JsonObject.category_name;
            // console.log("📌 Adding to patternDataStorage:",category_name, filename, event_datetime);
            // patternDataStorage.append({
            //     "filename": filename,
            //     "event_datetime": event_datetime
            // });

            // appendPattern(message)
            appendDatStorage(message)
            }
        else if (objectName === "UserSelectS") {
            mainBarSlaveSelect = userTypeSlave;
            usertypeSelect = !JsonObject.userStatusSlave
        }else if (objectName === "DateTime") {
            datetime = JsonObject.formattedDateTime
            console.log("check Date and Time:", message,datetime);
        }else if (objectName === "getMySqlPhaseA") {
            statusA = JsonObject.status;
            numberA = JsonObject.temp_no;
            num_listA = JsonObject.num_list;
            distanceA = JsonObject.Distance;
            detailA = JsonObject.Detail;
            phaseA = JsonObject.Phase;
            console.log("getMySqlPhaseA:", message);

            appendNewDataTableA(message)
        }else if (objectName === "getMySqlPhaseB") {
            statusB = JsonObject.status; // แปลงเป็น bool
            numberB = JsonObject.temp_no;
            num_listB = JsonObject.num_list;
            distanceB = JsonObject.Distance;
            detailB = JsonObject.Detail;
            phaseB = JsonObject.Phase;
            console.log("getMySqlPhaseB:", message);

            appendNewDataTableB(message)
        }else if (objectName === "getMySqlPhaseC") {
            statusC = JsonObject.status;
            numberC = JsonObject.temp_no;
            num_listC = JsonObject.num_list;
            distanceC = JsonObject.Distance;
            detailC = JsonObject.Detail;
            phaseC = JsonObject.Phase;
            console.log("getMySqlPhaseC:", message);

            appendNewDataTableC(message)
        }else if (objectName === "updatedataTableA") {

            statusA = JsonObject.status;
            numberA = JsonObject.temp_no || 0;
            num_listA = JsonObject.num_list || 0;
            distanceA = JsonObject.Distance || 0.0;
            detailA = JsonObject.Detail || "";
            phaseA = JsonObject.Phase || "";
            console.log("refreshTableDataA:", message);

            refreshTableDataA(message);
        }else if (objectName === "updatedataTableB") {
            statusA = JsonObject.status !== undefined ? JsonObject.status : false;
            numberA = JsonObject.temp_no || 0;
            num_listA = JsonObject.num_list || 0;
            distanceA = JsonObject.Distance || 0.0;
            detailA = JsonObject.Detail || "";
            phaseA = JsonObject.Phase || "";

            console.log("updatedataTableB:", message);

            refreshTableDataB(message);
        }else if (objectName === "updatedataTableC") {
            statusC = JsonObject.status !== undefined ? JsonObject.status : false;
            numberC = JsonObject.temp_no || 0;
            num_listC = JsonObject.num_list || 0;
            distanceC = JsonObject.Distance || 0.0;
            detailC = JsonObject.Detail || "";
            phaseC = JsonObject.Phase || "";

            console.log("updatedataTableC:", message);

            refreshTableDataC(message);
        }else if(objectName === 'deletedcommand'){
            commandID = JsonObject.list_deviceID
            console.log("command from monitor",message , commandID)
            deletedCommand(message)
        }else if (objectName === 'editDataPhaseA') {
            console.log("editDataPhaseA", message);
            num_listA = JsonObject.IndexNum || 0;
            distanceA = JsonObject.Distance || 0.0;
            detailA = JsonObject.Detail || "";
            phaseA = JsonObject.Phase || "";
        }else if (objectName === 'marginlistCountA') {
            console.log("QMLmarginCountA:", message);
            listMarginA = JsonObject.no || 0;
            marginA = JsonObject.marginNo || "";
            valueMarginA = JsonObject.valueOfMargin || 0.0;
            unitMaginA = JsonObject.unit || "";
            appendNewMarginlistA(message);
        }else if (objectName === 'marginlistCountB') {
            console.log("QMLmarginCountB:", message);
            listMarginB = JsonObject.no || 0;
            marginB = JsonObject.marginNo || "";
            valueMarginB = JsonObject.valueOfMargin || 0.0;
            unitMaginB = JsonObject.unit || "";
            appendNewMarginlistB(message);
        }else if (objectName === 'marginlistCountC') {
            console.log("QMLmarginCountC:", message);
            listMarginC = JsonObject.no || 0;
            marginC = JsonObject.marginNo || "";
            valueMarginC = JsonObject.valueOfMargin || 0.0;
            unitMaginC = JsonObject.unit || "";
            appendNewMarginlistC(message);
        }else if (objectName === 'getThreshold') {
            console.log("getUpdateThreshold:", message);
            valueThresholdA = JsonObject.thresholdInitA || 0.0;
            valueThresholdB = JsonObject.thresholdInitB || 0.0;
            valueThresholdC = JsonObject.thresholdInitC || 0.0;
        }else if (objectName === 'getSettingInfo') {
            console.log("getSettingInfo:", message);
            voltageInfo = JsonObject.voltage || 0.0;
            substationInfo = JsonObject.substation || 0.0;
            directionInfo = JsonObject.direction || 0.0;
            linenoInfo = JsonObject.line_no || 0.0;
        }else if (objectName === 'getPeriodicInfo') {
            time = JsonObject.Time || 0.0;
            updateMonday = JsonObject.Monday;
            updateTuesday = JsonObject.Tuesday;
            updateWednesday = JsonObject.Wednesday;
            updateThursday = JsonObject.Thursday;
            updateFriday = JsonObject.Friday;
            updateSaturday = JsonObject.Saturday;
            updateSunday = JsonObject.Sunday;
            console.log("getPeriodicInfo:", message,updateMonday, updateTuesday, updateWednesday, JsonObject.Monday);
        }else if((objectName === 'dataPlotingA')) {
            arrRawA = []
            distanceRawA = []
            voltageRawA = []
            arrRawA = JsonObject.dataPlotingA || [];
            distanceRawA = JsonObject.distance;
            voltageRawA = JsonObject.voltage;
            console.log("Debug_RawdataA_dataPlotingA:", message , arrRawA, distanceRawA, voltageRawA);
        } else if (objectName === 'dataPlotingB') {
            arrRawB = []
            distanceRawB = []
            voltageRawB = []
            arrRawB = JsonObject.dataPlotingB || [];
            distanceRawB = JsonObject.distance;
            voltageRawB = JsonObject.voltage;
            console.log("Debug_RawdataA_dataPlotingB:", message , arrRawB, distanceRawB, voltageRawB);
        } else if (objectName === 'dataPlotingC') {
            arrRawC = []
            distanceRawC = []
            voltageRawC = []
            arrRawC = JsonObject.dataPlotingC || [];
            distanceRawC = JsonObject.distance;
            voltageRawC = JsonObject.voltage;
            console.log("Debug_RawdataA_dataPlotingC:", message , arrRawC, distanceRawC, voltageRawC);
        }else if (objectName === 'patternA') {
            console.log("patthernA_check_debug:", message);
            var arrA = JsonObject.data || [];
            distancePatternA = JsonObject.distance;
            voltagePatternA= JsonObject.voltage;
        }else if (objectName === 'patternB') {
            console.log("patthernB_check_debug:", message);
            distancePatternB = JsonObject.distance;
            voltagePatternB = JsonObject.voltage;
        } else if (objectName === 'patternC') {
            console.log("patthernC_check_debug:", message);
            distancePatternC = JsonObject.distance;
            voltagePatternC = JsonObject.voltage;
        }else if (objectName === 'positonCursor') {
            console.log("positonCursor:", message, JsonObject.distance);
            cursorposition = parseFloat(JsonObject.distance).toFixed(2);
            console.log("Formatted position:", cursorposition);
        }else if (objectName === 'decreaseValue') {
            console.log("decreaseValue:", message, JsonObject.decreaseValue);
            cursorleft =  JsonObject.decreaseValue;
        }else if (objectName === 'increaseValue') {
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
        }else if (objectName === 'GetSettingDisplay') {
                sagfactor       = JsonObject.sagFactorInit;
                sampling        = JsonObject.samplingRateInit;
                displayStart    = JsonObject.distanceToStartInit;
                displayShow     = JsonObject.distanceToShowInit;
                fulldistances    = JsonObject.fulldistancesInit;
            console.log("displaySetting:", message, sagfactor, sampling, displayStart, displayShow, fulldistances);
        }else if (objectName === 'TrapsEnabling') {
                communication_error             = JsonObject.COMMUNICATION_ERROR;
                gps_module_fail                 = JsonObject.GPS_MODULE_FAIL;
                internal_phase_A_error          = JsonObject.INTERNAL_PHASE_A_ERROR;
                internal_phase_B_error          = JsonObject.INTERNAL_PHASE_B_ERROR;
                internal_phase_C_error          = JsonObject.INTERNAL_PHASE_C_ERROR;
                lfl_operate                     = JsonObject.LEL_OPERATE;
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

//                ip_address                      = JsonObject.ipaddress? JsonObject.ip_address: "";
//                ip_gateway                      = JsonObject.ip_gateway;
//                ip_snmp                         = JsonObject.ip_snmp;
//                ip_timeserver                   = JsonObject.ip_timeserver;
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
            addEvent(message);
//            console.log("TrapsAlert PLC_DO_ERROR:", message,alarm_plc_do_error,timeEventAlarm);
        }else if ((TrapsAlert === 'PLC_DI_ERROR')) {
            addEvent(message);
//            console.log("TrapsAlert PLC_DI_ERROR:", message,alarm_plc_di_error,timeEventAlarm);
        }else if ((TrapsAlert === 'INTERNAL_PHASE_A_ERROR')) {
            addEvent(message);
//            console.log("TrapsAlert INTERNAL_PHASE_A_ERROR:", message,alarm_internal_phase_A_error,timeEventAlarm);
        }else if ((TrapsAlert === 'INTERNAL_PHASE_B_ERROR')) {
            addEvent(message);
//            console.log("TrapsAlert INTERNAL_PHASE_B_ERROR:", message,alarm_internal_phase_B_error,timeEventAlarm);
        }else if ((TrapsAlert === 'INTERNAL_PHASE_C_ERROR')) {
            addEvent(message);
//            console.log("TrapsAlert INTERNAL_PHASE_C_ERROR:", message,alarm_internal_phase_C_error,timeEventAlarm);

        }else if ((TrapsAlert === 'MODULE_HI_SPEED_PHASE_A_ERROR')) {
            addEvent(message);
//            console.log("TrapsAlert MODULE_HI_SPEED_PHASE_A_ERROR:", message,alarm_module_hi_speed_phase_A_error,timeEventAlarm);

        }else if ((TrapsAlert === 'MODULE_HI_SPEED_PHASE_B_ERROR')) {
            addEvent(message);
//            console.log("TrapsAlert MODULE_HI_SPEED_PHASE_B_ERROR:", message,alarm_module_hi_speed_phase_B_error,timeEventAlarm);

        }else if ((TrapsAlert === 'MODULE_HI_SPEED_PHASE_C_ERROR')) {
            addEvent(message);
//            console.log("TrapsAlert MODULE_HI_SPEED_PHASE_C_ERROR:", message,alarm_module_hi_speed_phase_C_error,timeEventAlarm);

        }else if ((TrapsAlert === 'GPS_MODULE_FAIL')) {
            addEvent(message);
//            console.log("TrapsAlert GPS_MODULE_FAIL:", message,alarm_gps_module_fail,timeEventAlarm);

        }else if ((TrapsAlert === 'SYSTEM_INITIAL')) {
            addEvent(message);
//            console.log("TrapsAlert SYSTEM_INITIAL:", message,alarm_system_initial,timeEventAlarm);

        }else if ((TrapsAlert === 'COMMUNICATION_ERROR')) {
            addEvent(message);
//            console.log("TrapsAlert COMMUNICATION_ERROR:", message,alarm_communication_error,timeEventAlarm);

        }else if ((TrapsAlert === 'RELAY_START_EVENT')) {
            addEvent(message);
//            console.log("TrapsAlert RELAY_START_EVENT:", message,alarm_relay_start_event,timeEventAlarm);

        }else if ((TrapsAlert === 'SURGE_START_EVENT')) {
            addEvent(message);
//            console.log("TrapsAlert SURGE_START_EVENT:", message,alarm_surage_start_event,timeEventAlarm);

        }else if ((TrapsAlert === 'PERIODIC_TEST_EVENT')) {
            addEvent(message);
//            console.log("TrapsAlert PERIODIC_TEST_EVENT:", message,alarm_periodic_test_event,timeEventAlarm);

        }else if ((TrapsAlert === 'MANUAL_TEST_EVENT')) {
            addEvent(message);
           console.log("TrapsAlert MANUAL_TEST_EVENT:", message,alarm_manual_test_event,timeEventAlarm);

        }else if ((TrapsAlert === 'LFL_FAIL')) {
            addEvent(message);
//            console.log("TrapsAlert LFL_FAIL:", message,alarm_lfl_fail,timeEventAlarm);

        }else if (TrapsAlert === "LEL_OPERATE") {
            message = message.replace("LEL_OPERATE", "LFL_OPERATE");
            addEvent(message);
            console.log("TrapsAlert changed to LFL_OPERATE:", message);
        }else if ((objectName === 'CLEAR_ALARM')) {
//            console.log("CLEAR_ALARM:", message);
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

        }
    }

    function userlavel(message){
        var JsonObject = JSON.parse(message);
        var filename = JsonObject.filename;
        var userLevel = JsonObject.level;
        userLevelGlobalVars.append({
                                "userLevel": userLevel,
                                });
    }
    function appendDatStorage(message){
        console.log("debug_pattern_SQL");
        var JsonObject = JSON.parse(message);
        var filename = JsonObject.filename;
        var event_datetime = JsonObject.event_datetime;
        var category_name = JsonObject.category_name;
        if (category_name === "Pattern"){ //Pattern
            console.log("datastorage Pattern");
            patternDataStorage.append({
                                    "filename": filename,
                                    "event_datetime": event_datetime
                                    });
        }
        else if (category_name === "Periodic" ){
            console.log("datastorage Periodic");
            periodicDataStorage.append({
                                        "filename": filename,
                                        "event_datetime": event_datetime
                                    });

        }
        else if (category_name === "Relay"){
            console.log("datastorage Relay");
            relayDataStorage.append({
                                    "filename": filename,
                                    "event_datetime": event_datetime
                                    });
        }
        else if (category_name === "Surge"){
            console.log("datastorage Surge");
            surgeDataStorage.append({
                                    "filename": filename,
                                    "event_datetime": event_datetime
                                    });
        }

        // console.log("datastorage JsonObject:", filename,event_datetime);

        // patternDataStorage.append({
        //                         "filename": filename,
        //                         "event_datetime": event_datetime
        //                         });
    }

    function setpropertyIDTableA(checkIDtable) {
        console.log("setpropertyCheckTable:", checkIDtable);

        clearAllProperties();

        if (checkIDtable !== 0) {
            newlistdatatebleA.num_listA = checkIDtable;
            console.log("setpropertyCheckTableA:", checkIDtable, newlistdatatebleA.num_listA);
        }
    }

    function taggingpoint(checklist,statuslist){
        console.log("taggingpoint",checklist, statuslist)
        var tagging = '{"objectName":"taggingdata", "checklist":'+checklist+', "statuslist":'+statuslist+'}';
        qmlCommand(tagging);
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
//        newlistdatatebleB.num_listB = 0;
//        console.log("Cleared num_listB:", newlistdatatebleB.num_listB);
//        newlistdatatebleC.num_listC = 0;
//        console.log("Cleared num_listC:", newlistdatatebleC.num_listC);
    }

    function refreshTableDataA(message) {
        console.log("debug_refresh_data_A", message);

        var JsonObject = JSON.parse(message);
        var commandName = JsonObject.objectName;
        var selectStatus = JsonObject.status;
        var numberPhase = JsonObject.temp_no;
        var distancePhase = JsonObject.Distance;
        var detailPhase = JsonObject.Detail;
        var tablePhase = JsonObject.Phase;
        var numberoflist = JsonObject.num_list;

        console.log("Type of distancePhase:", typeof distancePhase, "Value:", distancePhase);

        if (commandName === "updatedataTableA") {
            if (!isTableCleared) {
                newlistdatatebleA.clear();
                isTableCleared = true;
            }

            newlistdatatebleA.append({
                "list_statusA": selectStatus,
                "list_numberA": numberPhase,
                "num_listA": numberoflist,
                "list_distanceA": String(distancePhase), // Convert to string
                "list_detailA": detailPhase,
                "list_phaseA": tablePhase,
            });

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
        // try {
            var JsonObject = JSON.parse(message);
//            console.log("[addEvent] Received:", JsonObject);
            console.log("addEvent:",message)

            if (!JsonObject.TrapsAlert || !JsonObject.time) {
//                console.warn("[addEvent] Missing required fields:", JsonObject);
                return;
            }

            var fullTime = JsonObject.time;
            var datePart = fullTime.split(" ")[0] || "N/A";
            var timePart = fullTime.split(" ")[1] || "N/A";

            var newEvent = {
                datetEventandAlram: datePart,
                timeEventandAlram: timePart,
                logDetail: JsonObject.TrapsAlert,
                statusEventandAlram: JsonObject.state ? "ACTIVE" : "DEACTIVE"
            };

            eventAlarmLog.insert(0, newEvent);
            eventAlarmHistoryLog.insert(0, newEvent);
//            console.log(`[addEvent] Inserted Event: ${JSON.stringify(newEvent)}`);

        // } catch (error) {
//            console.error("[addEvent] JSON Parse Error:", error);
        // }
    }


//    function addEvent(message) {
//        try {
//            var JsonObject = JSON.parse(message);
//            console.log("[addEvent] Received:", JsonObject);

//            if (!JsonObject.TrapsAlert || !JsonObject.time) {
//                console.warn("[addEvent] Missing required fields.");
//                return;
//            }

//            var fullTime = JsonObject.time;
//            var datePart = fullTime.split(" ")[0] || "N/A";
//            var timePart = fullTime.split(" ")[1] || "N/A";

//            var newEvent = {
//                datetEventandAlram: datePart,
//                timeEventandAlram: timePart,
//                logDetail: JsonObject.TrapsAlert,
//                statusEventandAlram: JsonObject.state ? "ACTIVE" : "DEACTIVE"
//            };

//            eventAlarmLog.insert(0, newEvent); // ✅ Insert at the top
//            eventAlarmHistoryLog.insert(0, newEvent);
//            console.log(`[addEvent] Appended: ${JSON.stringify(newEvent)}`);
//        } catch (error) {
//            console.error("[addEvent] JSON Parse Error:", error);
//        }
//    }


//    function processIncomingMessage(message) {
//        try {
//            var JsonObject = JSON.parse(message);
//            if (JsonObject.objectName === "CLEAR_ALARM") {
//                clearAlarmLog();
//            } else {
//                addEvent(message);
//            }
//        } catch (error) {
//            console.error("JSON Parse Error:", error);
//        }
//    }
//    function fliterRelayStart(checkfliter) {
//        console.error("fliterRelayStart:", checkfliter);
//        if (checkfliter) {
//            fullEventData = [];
//            for (var i = 0; i < eventAlarmLog.count; i++) {
//                var item = eventAlarmLog.get(i);
//                if (item.logDetail === "RELAY_START_EVENT") {
//                    fullEventData.push(item);
//                }
//            }
//            eventAlarmLog.clear();
//            fullEventData.forEach(function(item) {
//                eventAlarmLog.append(item);
//            });
//        } else {
//            fullEventData.forEach(function(item) {
//                eventAlarmLog.append(item);
//            });
//        }
//    }

    function clearAlarmLog() {
        if (eventAlarmLog.count > 0 || fullEventData.length > 0) {
            console.log(`[clearAlarmLog] Found ${eventAlarmLog.count} items and ${fullEventData.length} cached items. Clearing...`);
            eventAlarmLog.clear();
            fullEventData = Array.from([]);  // Ensures no lingering references
            console.log("✅ Event Alarm Log and cached data cleared!", fullEventData);
        } else {
            console.log("⚠️ No items to clear.");
        }
    }

    function fliterRelayStart(checkfliter) {
            console.error("fliterRelayStart:", checkfliter);
            if (fullEventData.length === 0) {
                console.warn(" fullEventData is empty, initializing with eventAlarmLog.");
                for (var i = 0; i < eventAlarmLog.count; i++) {
                    let item = eventAlarmLog.get(i);
                    fullEventData.push(JSON.parse(JSON.stringify(item))); // ✅ แปลงให้เป็น JSON Object
                }
            }

            if (checkfliter) {
                hiddenEventData = [];
                var filteredData = [];
                for (var i = 0; i < fullEventData.length; i++) {
                    if (fullEventData[i].logDetail === "RELAY_START_EVENT") {
                        filteredData.push(fullEventData[i]);
                    } else {
                        hiddenEventData.push(fullEventData[i]);
                    }
                }
                console.log("Filtered Data:", filteredData);
                console.log("Hidden Data (ซ่อนอยู่):", hiddenEventData);
                eventAlarmLog.clear();
                for (var j = 0; j < filteredData.length; j++) {
                    eventAlarmLog.append(filteredData[j]);
                }
            } else {
                console.log("Restoring hidden data:", hiddenEventData);
                for (var k = 0; k < hiddenEventData.length; k++) {
                    var item = hiddenEventData[k];

                    if (item.logDetail !== undefined && item.datetEventandAlram !== undefined
                        && item.timeEventandAlram !== undefined && item.statusEventandAlram !== undefined) {
                        eventAlarmLog.append(item);
                    } else {
                        console.warn("⚠️ Skipping invalid data:", item);
                    }
                }
                hiddenEventData = [];
            }
        }
        function fliterPeriodicStart(checkfliter) {
            console.error("fliterPeriodicStart:", checkfliter);

            if (fullEventData.length === 0) {
                console.warn("fullEventData is empty, initializing with eventAlarmLog.");
                for (var i = 0; i < eventAlarmLog.count; i++) {
                    fullEventData.push(JSON.parse(JSON.stringify(eventAlarmLog.get(i))));
                }
            }

            if (checkfliter) {
                hiddenEventData = [];
                var filteredData = [];

                for (var i = 0; i < fullEventData.length; i++) {
                    if (fullEventData[i].logDetail === "PERIODIC_TEST_EVENT") {
                        filteredData.push(fullEventData[i]);
                    } else {
                        hiddenEventData.push(fullEventData[i]);
                    }
                }

                console.log("Filtered Data:", filteredData);
                console.log("Hidden Data:", hiddenEventData);

                eventAlarmLog.clear();
                for (var j = 0; j < filteredData.length; j++) {
                    eventAlarmLog.append(filteredData[j]);
                }
            } else {
                console.log("Restoring hidden data:", hiddenEventData);

                for (var k = 0; k < hiddenEventData.length; k++) {
                    var item = hiddenEventData[k];

                    if (item.logDetail !== undefined) {
                        eventAlarmLog.append(item);
                    } else {
                        console.warn("Skipping invalid data:", item);
                    }
                }

                hiddenEventData = [];
            }
        }

        function fliterManualStart(checkfliter) {
            console.error("fliterManualStart:", checkfliter);

            if (fullEventData.length === 0) {
                console.warn("fullEventData is empty, initializing with eventAlarmLog.");
                for (var i = 0; i < eventAlarmLog.count; i++) {
                    fullEventData.push(JSON.parse(JSON.stringify(eventAlarmLog.get(i))));
                }
            }

            if (checkfliter) {
                hiddenEventData = [];
                var filteredData = [];

                for (var i = 0; i < fullEventData.length; i++) {
                    if (fullEventData[i].logDetail === "MANUAL_TEST_EVENT") {
                        filteredData.push(fullEventData[i]);
                    } else {
                        hiddenEventData.push(fullEventData[i]);
                    }
                }

                console.log("Filtered Data:", filteredData);
                console.log("Hidden Data (ซ่อนอยู่):", hiddenEventData);

                eventAlarmLog.clear();
                for (var j = 0; j < filteredData.length; j++) {
                    eventAlarmLog.append(filteredData[j]);
                }
            } else {
                console.log("Restoring hidden data:", hiddenEventData);

                for (var k = 0; k < hiddenEventData.length; k++) {
                    var item = hiddenEventData[k];

                    if (item.logDetail !== undefined) {
                        eventAlarmLog.append(item);
                    } else {
                        console.warn("Skipping invalid data:", item);
                    }
                }

                hiddenEventData = [];
            }
        }

        function fliterSurageStart(checkfliter) {
            console.error("fliterSurageStart:", checkfliter);

            if (fullEventData.length === 0) {
                console.warn("fullEventData is empty, initializing with eventAlarmLog.");
                for (var i = 0; i < eventAlarmLog.count; i++) {
                    fullEventData.push(JSON.parse(JSON.stringify(eventAlarmLog.get(i))));
                }
            }

            if (checkfliter) {
                hiddenEventData = [];
                var filteredData = [];

                for (var i = 0; i < fullEventData.length; i++) {
                    if (fullEventData[i].logDetail === "SURGE_START_EVENT") {
                        filteredData.push(fullEventData[i]);
                    } else {
                        hiddenEventData.push(fullEventData[i]);
                    }
                }

                console.log("Filtered Data:", filteredData);
                console.log("Hidden Data:", hiddenEventData);

                eventAlarmLog.clear();
                for (var j = 0; j < filteredData.length; j++) {
                    eventAlarmLog.append(filteredData[j]);
                }
            } else {
                console.log("Restoring hidden data:", hiddenEventData);

                for (var k = 0; k < hiddenEventData.length; k++) {
                    var item = hiddenEventData[k];

                    if (item.logDetail !== undefined) {
                        eventAlarmLog.append(item);
                    } else {
                        console.warn("Skipping invalid data:", item);
                    }
                }

                hiddenEventData = [];
            }
        }

    function appendNewDataTableA(message) {
        console.log("debug_for_mysqlTable_A", message);

        var JsonObject = JSON.parse(message);
        var commandName = JsonObject.objectName;
        var selectStatus = JsonObject.status;
        var numberPhase = JsonObject.temp_no;
        var distancePhase = JsonObject.Distance;
        var detailPhase = JsonObject.Detail;
        var tablePhase = JsonObject.Phase;
        var numberoflist = JsonObject.num_list;

        console.log("Parsed JsonObject:", JsonObject,numberoflist);

        var getdeviceIndexA = getDeviceIndexA(numberoflist);

        if (getdeviceIndexA === -1) {
            console.log("Item not found, adding new item:", numberoflist,getdeviceIndexA);
            newlistdatatebleA.append({
                "list_statusA": selectStatus,
                "list_numberA": numberPhase,
                "num_listA": numberoflist,
                "list_distanceA": distancePhase,
                "list_detailA": detailPhase,
                "list_phaseA": tablePhase,
            });
        } else {
            console.log("Item found at index:", getdeviceIndexA);
            var existingIndexNum = newlistdatatebleA.get(getdeviceIndexA).num_listA;
            if (String(existingIndexNum) !== String(numberoflist)) {
                console.log("Updating item:", numberoflist);
                newlistdatatebleA.append({
                    "list_statusA": selectStatus,
                    "list_numberA": numberPhase,
                    "num_listA": numberoflist,
                    "list_distanceA": distancePhase,
                    "list_detailA": detailPhase,
                    "list_phaseA": tablePhase,
                });
            }
        }
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

    function getDeviceIndexA(num_listA) {
        for (var i = 0; i < newlistdatatebleA.count; i++) {
            var currentItem = newlistdatatebleA.get(i);
            if (!currentItem) {
                console.warn("Item at index", i, "is undefined");
                continue;
            }

            var currentDeviceId = currentItem.num_listA;
            if (String(currentDeviceId) === String(num_listA)) {
                return i;
            }
        }
        console.log("getDeviceIndex_A - num_listA not found:", num_listA);
        return -1;
    }
    function getDeviceIndexB(num_listB) {
        for (var i = 0; i < newlistdatatebleB.count; i++) {
            var currentDeviceId = newlistdatatebleB.get(i).num_listB;
            if (currentDeviceId === num_listB || currentDeviceId === parseInt(num_listB)) {
                return i;
            }
        }
        console.log("getDeviceIndex_B", num_listB,currentDeviceId);
        return -1;
    }
    function getDeviceIndexC(num_listC) {
        for (var i = 0; i < newlistdatatebleC.count; i++) {
            var currentDeviceId = newlistdatatebleC.get(i).num_listC;
            if (currentDeviceId === num_listC || currentDeviceId === parseInt(num_listC)) {
                return i;
            }
        }
        console.log("getDeviceIndex_C", num_listC,currentDeviceId);
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
        var valueMarginA = JsonObject.valueOfMargin; // 300
        var unitMaginA = JsonObject.unit; // mV

        console.log("Appending to newlistMarginA: Count", listMarginCount, "Value:", valueMarginA, "Unit:", unitMaginA);

        // ✅ Remove extra entries if the new count is smaller
        while (newlistMarginA.count > listMarginCount) {
            console.log("Removing excess entry:", newlistMarginA.count);
            newlistMarginA.remove(newlistMarginA.count - 1);
        }

        // ✅ Check and update existing entries
        var found = false;
        for (var i = 0; i < newlistMarginA.count; i++) {
            if (newlistMarginA.get(i).list_marginA === JsonObject.marginNo) {
                found = true;
                newlistMarginA.set(i, {
                    "voltageIndex": i,
                    "list_marginA": JsonObject.marginNo,
                    "valueMarginA": valueMarginA,
                    "unitMaginA": unitMaginA
                });
                console.log("Updated existing entry:", JsonObject.marginNo);
                break;
            }
        }

        // ✅ Append if not found
        if (!found && newlistMarginA.count < listMarginCount) {
            newlistMarginA.append({
                "voltageIndex": newlistMarginA.count,
                "list_marginA": JsonObject.marginNo,
                "valueMarginA": valueMarginA,
                "unitMaginA": unitMaginA
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
    function clearAlarmLogIncrementally() {
        console.log("[clearAlarmLogIncrementally] Starting incremental clear...");

        let itemCount = eventAlarmLog.count;

        // ลบจากท้ายขึ้นไป
        for (let i = itemCount - 1; i >= 0; i--) {
            eventAlarmLog.remove(i);
        }

        console.log("[clearAlarmLogIncrementally] Log cleared successfully!");
    }

//    function appendNewMarginlistA(message) {
//        var JsonObject = JSON.parse(message);
//        var listMarginCount = parseInt(JsonObject.marginNo.replace("Margin", ""));
//        var valueMarginA = JsonObject.valueOfMargin; // 300
//        var unitMaginA = JsonObject.unit; // mV

//        console.log("Appending to newlistMarginA: Count", listMarginCount, "Value:", valueMarginA, "Unit:", unitMaginA);

//        if (newlistMarginA.count === 0 || newlistMarginA.count < listMarginCount) {
//            console.log("Updating list: Adding Margin", listMarginCount);
//            var found = false;
//            for (var i = 0; i < newlistMarginA.count; i++) {
//                if (newlistMarginA.get(i).list_marginA === JsonObject.marginNo) {
//                    found = true;
//                    newlistMarginA.set(i, {
//                        "voltageIndex": i,
//                        "list_marginA": JsonObject.marginNo,
//                        "valueMarginA": valueMarginA,
//                        "unitMaginA": unitMaginA
//                    });
//                    console.log("Updated existing entry:", JsonObject.marginNo);
//                    break;
//                }
//            }

//            if (!found) {
//                newlistMarginA.append({
//                    "voltageIndex": newlistMarginA.count,
//                    "list_marginA": JsonObject.marginNo,
//                    "valueMarginA": valueMarginA,
//                    "unitMaginA": unitMaginA
//                });
//                console.log("Added new entry:", JsonObject.marginNo);
//            }
//        } else {
//            console.log("No updates needed.");
//        }
//    }

//    function appendNewMarginlistA(message) {
//        var JsonObject = JSON.parse(message);
//        var listMarginCount = parseInt(JsonObject.marginNo.replace("Margin", ""));
//        var valueMarginA = JsonObject.valueOfMargin; // 300
//        var unitMaginA = JsonObject.unit; // mV

//        console.log("Appending to newlistMarginA: Count", listMarginCount, "Value:", valueMarginA, "Unit:", unitMaginA);

//        if (newlistMarginA.count !== listMarginCount) {
//            console.log("Mismatch detected. Clearing old list.");
//            newlistMarginA.clear(); // ล้างรายการเก่า

//            for (var i = 1; i <= listMarginCount; i++) {
//                newlistMarginA.append({
//                    "voltageIndex": i-1,
//                    "list_marginA": "Margin" + i,
//                    "valueMarginA": valueMarginA,
//                    "unitMaginA": unitMaginA
//                });
//            }
//        } else {
//            console.log("No changes detected. Keeping current list.");
//        }
//    }

//    function appendNewMarginlistA(message) {
//        var JsonObject = JSON.parse(message);
//        var listMarginA = JsonObject.marginNo; // MarginX
//        var valueMarginA = JsonObject.valueOfMargin; // 300
//        var unitMaginA = JsonObject.unit; // mV

//        console.log("Appending to newlistMarginA:", listMarginA, valueMarginA, unitMaginA);

//        newlistMarginA.append({
//            "list_marginA": listMarginA,
//            "valueMarginA": valueMarginA,
//            "unitMaginA": unitMaginA
//        });
//    }

//    function appendNewMarginlistA(message) {
//          console.log("debug_for_MarginA", message);
//          var JsonObject = JSON.parse(message);
//          var commandName = JsonObject.objectName;
//          var listMarginA = JsonObject.no;
//          var numMarginA = JsonObject.marginNo;
//          var valueMarginA = JsonObject.valueOfMargin;
//          var unitMaginA = JsonObject.unit;

//          console.log("Parsed JsonObject:", JsonObject,listMarginA);

//          var getdeviceIndexA = getDeviceIndexA(listMarginA);

//        if (getdeviceIndexA !== -1) { // ต้องเป็นค่าที่ถูกต้อง
//            var existingItem = newlistMarginA.get(getdeviceIndexA);
//            if (existingItem) { // ตรวจสอบว่ามีค่าอยู่จริง
//                var existingIndexNum = existingItem.list_marginA; // เปลี่ยนจาก listMarginA เป็น list_marginA
//                if (String(existingIndexNum) !== String(listMarginA)) {
//                    console.log("Updating item:", listMarginA);
//                    newlistMarginA.set(getdeviceIndexA, {
//                        "list_marginA": listMarginA,
//                        "valueMarginA": numMarginA,
//                        "unitMaginA": valueMarginA,
//                        "statusMaginA": unitMaginA
//                    });
//                }
//            }
//        } else {
//            console.log("Item not found, adding new item:", listMarginA);
//            newlistMarginA.append({
//                "list_marginA": listMarginA,
//                "valueMarginA": numMarginA,
//                "unitMaginA": valueMarginA,
//                "statusMaginA": unitMaginA
//            });
//        }

//      }


    WebSocket {
        id: socketCPP
        url: "ws://127.0.0.1:1234"
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
                             var selectUserType = '{"objectName":"UserSelectM","userType": "Master" ,"userStatusMaster": '+usertypeSelectMaster+'}'
                             qmlCommand(selectUserType);
                             if (socketCPP.status == WebSocket.Open && !hasSentTaggingCommands) {

                                 var tableTaggingPhaseA = '{"objectName":"TaggingPhaseA", "tableTaggingPhaseA": "TaggingPhaseA"}';
                                 qmlCommand(tableTaggingPhaseA);
                                 var tableTaggingPhaseB = '{"objectName":"TaggingPhaseB", "tableTaggingPhaseB": "TaggingPhaseB"}';
                                 qmlCommand(tableTaggingPhaseB);
                                 var tableTaggingPhaseC = '{"objectName":"TaggingPhaseC", "tableTaggingPhaseC": "TaggingPhaseC"}';
                                 qmlCommand(tableTaggingPhaseC);
                                 hasSentTaggingCommands = true;
                                 var threshold = "getCurrentThreshold";
                                 qmlCommand(threshold);
                                 var settingInfo = "SettingGeneral";
                                 qmlCommand(settingInfo);
                                 var getpreiodicInfo = "getpreiodicInfo";
                                 qmlCommand(getpreiodicInfo);
                                 var startPloting = '{"objectName":"startPlotingDataPhaseA", "threshold": 1500, "sagFactor": 0.983, "samplingRate": 10, "distanceToStart": 0, "distanceToShow": 8500}';
                                 qmlCommand(startPloting);
                                 var updateValueMargin = "updateValueMargin";
                                 qmlCommand(updateValueMargin);
//                                 var getRawData=  "testRawData";
//                                 qmlCommand(getRawData);
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
            sockStart=true
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
    onSockStartChanged: {
        sockStart.active = !sockStart.active
        console.log("socket.active",socket.active)
    }
    Component.onCompleted: {
        console.log("Testing WebSocket connection...");
        socketCPP.active = true;
        console.log("status of socket",socketCPP.active);
        if (socketCPP.active === true){
            if (socketCPP.status === WebSocket.Open) {
                socketCPP.sendTextMessage("Test message from QML!");
            }
        }
    }

    InputPanel {
        id: inputPanel
        y: 369
        height: 231
        visible: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        Component.onCompleted: {
            visible = false;
            textInformation.visible = false;
            textInformation.focus = false;
        }

        onVisibleChanged: {
            if (inputPanel.visible && !textInformation.focus) {
                textInformation.focus = true;
            }else{
                focusIndex = -1;
            }
        }

        Connections {
            target: Qt.inputMethod
            function onVisibleChanged() {
                if (Qt.inputMethod.visible) {
                    console.log("Keyboard shown");
                    inputPanel.visible = true;
                    textInformation.visible = true;
                    if (!textInformation.focus) {
                        textInformation.focus = true;
                    }
                } else {
                    console.log("Keyboard hidden");
                    inputPanel.visible = false;
                    textInformation.visible = false;
                    textInformation.focus = false;
                }
            }
        }

        // TextField สำหรับพิมพ์ข้อความ
        TextField {
            id: textInformation
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.bottomMargin: 320
            anchors.leftMargin: 0
            anchors.topMargin: -130
            placeholderText: qsTr("Text Field")
            visible: false  // กำหนดให้เริ่มต้นซ่อน
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            font.pointSize: 12

            Keys.onReturnPressed: {
                if (text.trim() !== "") {
                    console.log("Enter key pressed! Value:", currentField);
                    if (currentField === "valueVoltage") {
                        textInformation.text = text;
                        var Voltage = '{"objectName":"VoltageInfo","Voltage": '+textInformation.text+'}'
                        qmlCommand(Voltage);
                        console.log("Voltage Entered:", text, Voltage);
                    } else if (currentField === "valueSubstation") {
                        textInformation.text = text;
                        var Substation = '{"objectName":"Substations","Substation": "'+textInformation.text+'"}'
                        qmlCommand(Substation);
                        console.log("Substation Entered:", text,Substation);
                    } else if (currentField === "valueDirection") {
                        textInformation.text = text;
                        var Direction = '{"objectName":"Direction","Direction": "'+textInformation.text+'"}'
                        qmlCommand(Direction);
                        console.log("Direction Entered:", text,Direction);
                    } else if (currentField === "valueLineNo") {
                        textInformation.text = text;
                        var LineNo = '{"objectName":"LineNo","LineNo": '+textInformation.text+'}'
                        qmlCommand(LineNo);
                        console.log("Line No Entered:", text,LineNo);
                    } else if (currentField === "textTime") {
                        textInformation.text = text;
                        var Time = '{"objectName":"updatetextTime","Time": '+textInformation.text+'}'
                        qmlCommand(Time);
                        console.log("Time Entered:", text,Time);
                    } else if (currentField === "distanceField") {
                        textInformation.text = text;
                        var Distance = '{"objectName":"distanceField","distanceField": '+textInformation.text+'}'
                        qmlCommand(Distance);
                        console.log("Distance Entered:", text, Distance);
                    } else if (currentField === "detailField") {
                        textInformation.text = text;
                        var Detail = '{"objectName":"detailField","detailField": '+textInformation.text+'}'
                        qmlCommand(Detail);
                        console.log("Detail Entered:", text,Detail);
                    } else if (currentField === "sagText") {
                        textInformation.text = text;
                        var Sag = '{"objectName":"sagText","sagText": '+textInformation.text+'}'
                        qmlCommand(Sag);
                        console.log("Sag Entered:", text, Sag);
                    } else if (currentField === "samplingText") {
                        textInformation.text = text;
                        var Sampling = '{"objectName":"samplingText","samplingText": '+textInformation.text+'}'
                        qmlCommand(Sampling);
                        console.log("Sampling Entered:", text,Sampling);
                    } else if (currentField === "distancetostartText") {
                        textInformation.text = text;
                        var distancetostart = '{"objectName":"distancetostartText","distancetostartText": '+textInformation.text+'}'
                        qmlCommand(distancetostart);
                        console.log("Dist. Start Entered:", text,distancetostart);
                    } else if (currentField === "distancetoshowText") {
                        textInformation.text = text;
                        var distancetoshow = '{"objectName":"distancetoshowText","distancetoshowText": '+textInformation.text+'}'
                        qmlCommand(distancetoshow);
                        console.log("Dist. Show Entered:", text,distancetoshow);
                    } else if (currentField === "fulldistanceText") {
                        textInformation.text = text;
                        var fulldistance = '{"objectName":"fulldistanceText","fulldistanceText": '+textInformation.text+'}'
                        qmlCommand(fulldistance);
                        console.log("Full Dist. Entered:", text,fulldistance);
                    } else if (currentField === "settingIPaddress") {
                        textInformation.text = text;
                        var IpAddress = '{"objectName":"settingIPaddress","settingIPaddress": '+textInformation.text+'}'
//                        qmlCommand(IpAddress);
                        console.log("IpAddress Entered:", text, IpAddress);
                    } else if (currentField === "settinggateway") {
                        textInformation.text = text;
                        var GateWays = '{"objectName":"settinggateway","settinggateway": '+textInformation.text+'}'
//                        qmlCommand(GateWays);
                        console.log("IpAddress Entered:", text, IpAddress);
                    }else if (currentField === "detailField") {
                        textInformation.text = text;
//                        var Detail = '{"objectName":"detailField","detailField": ' + JSON.stringify(textInformation.text) + '}';
                        var Detail = '{"objectName":"detailField","detailField": ' + textInformation.text + '}';
//                        qmlCommand(Detail);
                        console.log("Detail Entered:", text, Detail);
                    }else if (currentField === "marginNumberA") {
                        textInformation.text = text;
                        var marginA = '{"objectName":"marginCountA", "valueMarginA":'+textInformation.text +', "PHASE": "A"}';
                        qmlCommand(marginA);
                        console.log("MarginNumberA Entered:", text, marginA);
                    }else if (currentField === "marginNumberB") {
                        textInformation.text = text;
                        var marginB = '{"objectName":"marginCountB", "valueMarginB":'+textInformation.text +', "PHASE": "B"}';
                        qmlCommand(marginB);
                        console.log("MarginNumberB Entered:", text, marginB);
                    }else if (currentField === "marginNumberC") {
                        textInformation.text = text;
                        var marginC = '{"objectName":"marginCountC", "valueMarginC":'+textInformation.text +', "PHASE": "C"}';
                        qmlCommand(marginC);
                        console.log("MarginNumberC Entered:", text, marginC);
                    }else if (currentField === "textPhaseA") {
                        textInformation.text = text;
                        var thresholdA = '{"objectName":"textPhaseA", "thresholdA":'+textInformation.text +', "PHASE": "A"}';
                        qmlCommand(thresholdA);
                        console.log("thresholdA Entered:", text, thresholdA);
                    }else if (currentField === "textPhaseB") {
                        textInformation.text = text;
                        var thresholdB = '{"objectName":"textPhaseB", "thresholdB":'+textInformation.text +', "PHASE": "B"}';
                        qmlCommand(thresholdB);
                        console.log("thresholdB Entered:", text, thresholdB);
                    }else if (currentField === "textPhaseC") {
                        textInformation.text = text;
                        var thresholdC = '{"objectName":"textPhaseC", "thresholdC":'+textInformation.text +', "PHASE": "C"}';
                        qmlCommand(thresholdC);
                        console.log("thresholdC Entered:", text, thresholdC);
                    }else if (currentField === "rangedistance") {
                        textInformation.text = text;
                        var range = '{"objectName":"rangedistance", "rangedistance":'+textInformation.text +'}';
                        qmlCommand(range);
                        console.log("range Entered:", text, range);
                    }else if (currentField === "textUserName") {
                        textInformation.text = text;
                        var User = '{"objectName":"UserName", "textUserName":'+textInformation.text +'}';
                        qmlCommand(User);
                        console.log("range Entered:", text, User);
                    }else if (currentField === "textPassword") {
                        textInformation.text = text;
                        var Password = '{"objectName":"Password", "textPassword":'+textInformation.text +'}';
                        qmlCommand(Password);
                        console.log("range Entered:", text, Password);
                    }else if (currentField === "valueVoltageA") {
                        textInformation.text = text;
                        var marginVoltageA = '{"objectName":"valueMarginVoltageA", "valueVoltageA":'+textInformation.text +'}';
//                        qmlCommand(marginVoltageA);
//                        console.log("marginVoltageA Entered:", text, marginVoltageA);
                    }else if (currentField === "changeValueofVoltageA") {
                        textInformation.text = text;
                        var valueVoltageA = '{"objectName":"valueMarginVoltageA", "valueVoltageA":'+textInformation.text +',"focusIndex":'+focusIndex+',"listMarginA":'+listMarginA+',"PHASE": "A"}';
                        console.log("marginVoltageA Entered:", text, valueVoltageA, focusIndex,listMarginA);
                        qmlCommand(valueVoltageA);
                    }else if (currentField === "cheangeValueofVoltageB") {
                        textInformation.text = text;
                        var valueVoltageB = '{"objectName":"valueMarginVoltageB", "valueVoltageB":'+textInformation.text +',"focusIndex":'+focusIndex+',"listMarginB":'+listMarginB+',"PHASE": "B"}';
                        console.log("marginVoltageB Entered:", text, valueVoltageB, focusIndex,listMarginB);
                        qmlCommand(valueVoltageB);
                    }else if (currentField === "cheangeValueofVoltageC") {
                        textInformation.text = text;
                        var valueVoltageC = '{"objectName":"valueMarginVoltageC", "valueVoltageC":'+textInformation.text +',"focusIndex":'+focusIndex+',"listMarginC":'+listMarginC+',"PHASE": "C"}';
                        console.log("marginVoltageC Entered:", text, valueVoltageC, focusIndex,listMarginC);
                        qmlCommand(valueVoltageC);
                    }
                }
                inputPanel.visible = false;
                visible = false;
            }
        }
    }
    Drawer {
        id: drawer_audio
        width: parent.width / 2 // 1/4 ของหน้าจอในแนวนอน
        height: parent.height / 2 // 1/4 ของหน้าจอในแนวตั้ง
        x: 0 // ตำแหน่งที่มุมซ้ายบน
        y: -height // ซ่อน Drawer ไว้ที่ด้านบนก่อน
        modal: true
        dragMargin: 50
        interactive: true
        clip: true

        background: Rectangle {
            color: "#2c2c2c" // สีพื้นหลัง
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
        }
    }

}




/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
