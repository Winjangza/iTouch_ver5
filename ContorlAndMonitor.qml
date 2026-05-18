import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.15
import QtQuick.Layouts 1.0

Item {
    id: controlAndMonitor
    width: 1024
    height: 600
    //─── global arrays for pin positions ─────────────────────────
    property var globalXA: []     // holds every tag’s computed x
    property var globalYA: []     // holds every tag’s computed y
    property var globalXB: []     // holds every tag’s computed x
    property var globalYB: []     // holds every tag’s computed y
    property var globalXC: []     // holds every tag’s computed x
    property var globalYC: []     // holds every tag’s computed y
    property var lastComputedPositions: []
    signal plottingFinished()
    // new per-phase pixel arrays:
    property var posXA: []
    property var posYA: []
    property var posXB: []
    property var posYB: []
    property var posXC: []
    property var posYC: []
    //tagging
    property bool newListDataTagging:newListDataTaggingTables
    property int activeTaggingNumberA: -1
    property int activeTaggingNumberB: -1
    property int activeTaggingNumberC: -1
    property var lastTaggingCount: -1;
    property bool isCursorActiveA: false
    property bool isCursorActiveB: false
    property bool isCursorActiveC: false
    property string activeTaggingDetailA: ""
    property string activeTaggingDetailB: ""
    property string activeTaggingDetailC: ""
    // stored tagging values
    property real currentDistance: -1
    property real currentVoltage:  -1
    property string currentPhase:  ""
    property int   currentNumber:   -1

    // Raw data arraysfillText
    property var distanceA: []
    property var plotdataA: []
    property var distanceB: []
    property var plotdataB: []
    property var distanceC: []
    property var plotdataC: []


    // Pattern data arrays separate from main
    property var distancepatternA: []
    property var plotdatapatternA: []
    property var distancepatternB: []
    property var plotdatapatternB: []
    property var distancepatternC: []
    property var plotdatapatternC: []

    // Cursor voltage tracking for pattern
    property var backupDistancePatternA: []
    property var backupPlotdataPatternA: []
    property var backupDistancePatternB: []
    property var backupPlotdataPatternB: []
    property var backupDistancePatternC: []
    property var backupPlotdataPatternC: []

    //plot and hide graph
    // property bool plotShowgraphA : updataStatusOfButtonA
    // property bool plotShowgraphB : updataStatusOfButtonB
    // property bool plotShowgraphC : updataStatusOfButtonC
    // property bool plotShowgraphPatternA : updataStatusOfPatternA
    // property bool plotShowgraphPatternB : updataStatusOfPatternB
    // property bool plotShowgraphPatternC : updataStatusOfPatternC

    // Cursor voltage position
    property string positionOfVoltageA: "0.00"
    property string positionOfVoltageB: "0.00"
    property string positionOfVoltageC: "0.00"

    // Toggle plot mode
    property bool showPatternPlot: false
    property int percentPlot: 0
    property real scaleOfZoomValue: zoomValueRecord
    property real lastZoomScale: 0.0
    property real filteredDy: 0
    property int plotIndexData: 0
    property var backupDistanceA: []
    property var backupPlotdataA: []
    property var backupDistanceB: []
    property var backupPlotdataB: []
    property var backupDistanceC: []
    property var backupPlotdataC: []
    //closeDistance and CloseVoltage
    property var closeDistance: []
    property var closeVoltage: []
    //canvas scale
    property var cL :canvasPlot.plotLeft
    property var cT  : canvasPlot.plotTop
    property var cW  : canvasPlot.plotWidth
    property var cH  : canvasPlot.plotHeight
    property real pendingCursorDistance: NaN
    property bool _applyingExternalCursor: false//    property var actualMaxY : canvasPlot.actualMaxY
    property bool zoomActive:     false
    property var linesDrawn: 0

    property int  minZoomMv: 50            // 0.001 V
    property int  maxZoomMv: 8192.00         // 20.000 V
    property int  defaultZoomMv: 1000
    property int  defaultZoomMvReset: 1000
    property real defaultScaleOfZoom: defaultZoomMv / 1000.0

    property int  pendingYZoomMv: defaultZoomMv   // ค่าใน SpinBox ที่ยังไม่คอมมิต
    property int  baselineZoomMv: defaultZoomMv   // ค่ากราฟ “ตั้งต้น” ใช้เป็นเส้นฐานเทียบ
    // Y-axis zoom factor
    property real yZoomFactor: pendingYZoomMv / baselineZoomMv
    // Axis limits
    property real plotminAxisX: minAxisX
    property real plotmaxAxisX: maxAxisX
    property real plotminAxisY: minAxisY
    property real plotmaxAxisY: maxAxisY
    property real actualMaxY: lastZoomVoltage

//    property real realMaxYTagging: (maxVoltage + yGraphOffset) / zoomValueRecord
    property real realMaxYTagging: Math.max(1, lastZoomVoltage)
    property bool alreadyCaptured: false
    property bool callLaterScheduled: false
    property bool suragePlot: false

    property bool ignoreAutoHide: false

    function getMax(arr) {
        if (!arr || arr.length === 0) return 0;
        return Math.max.apply(null, arr);
    }

    Component.onCompleted: {
        // บังคับให้กราฟเริ่มที่ default ด้วย (ถ้าต้องการ)
        if (yZoomPanel && (!yZoomPanel.scaleOfZoomValue || isNaN(yZoomPanel.scaleOfZoomValue)))
            yZoomPanel.scaleOfZoomValue = defaultZoomMv / 1000.0;
    }
    function commitSpinZoom() {
        var mv = Math.max(minZoomMv, Math.min(maxZoomMv, pendingYZoomMv));
        mv = Math.round(mv / 100) * 100;

        var z = mv / 1000.0;
        var stepSize = 0.01;
        z = Math.max(0.001, Math.min(20.0, z));
        z = Math.round(z / stepSize) * stepSize;

        yZoomPanel.scaleOfZoomValue = z;
        controlAndMonitor.yZoomFactor = z;
        controlAndMonitor.canvasPlot && controlAndMonitor.canvasPlot.requestPaint();

        qmlCommand(JSON.stringify({
            objectName: "zoomInOut",

            zoomValuerecord: z,
            lastZoomVoltage: Math.round(z * 1000)
        }));
        reloadTaggingData();
    }

    Timer {
        id: plotProgressTimer
        interval: 5
        repeat: true
        running: false
        onTriggered: {
            if (percentPlot < 100) {
                percentPlot += 2;
            } else {
                plotProgressTimer.stop();
                Qt.callLater(() => {
                                 plottingFinished();
                             });
            }
        }
    }

    function updatePatternPlotFromWebSocket(JsonObject) {
        distancepatternA = JsonObject.distancePatternA ?? [];
        plotdatapatternA = JsonObject.voltagePatternA ?? [];
        distancepatternB = JsonObject.distancePatternB ?? [];
        plotdatapatternB = JsonObject.voltagePatternB ?? [];
        distancepatternC = JsonObject.distancePatternC ?? [];
        plotdatapatternC = JsonObject.voltagePatternC ?? [];

        minAxisX = JsonObject.minDistance ?? 0;
        maxAxisX = JsonObject.maxDistance ?? displayShow;
        minAxisY = JsonObject.minVoltage ?? 0;
        maxAxisY = JsonObject.maxVoltage ?? 4096;
        canvasPlot.requestPaint();
    }

    function updateRawPlotFromWebSocket(JsonObject) {
        distanceA = JsonObject.distanceA ?? [];
        plotdataA = JsonObject.voltageA ?? [];
        distanceB = JsonObject.distanceB ?? [];
        plotdataB = JsonObject.voltageB ?? [];
        distanceC = JsonObject.distanceC ?? [];
        plotdataC = JsonObject.voltageC ?? [];

        minAxisX = JsonObject.minDistance ?? 0;
        maxAxisX = JsonObject.maxDistance ?? displayShow;
        minAxisY = JsonObject.minVoltage ?? 0;
        maxAxisY = JsonObject.maxVoltage ?? 4096;

        canvasPlot.requestPaint();
    }

    function updateCursorVoltage() {
        function findClosestVoltage(cursorArrayX, cursorArrayY, phase) {
            var closestIndex = -1;
            var minDiff = Infinity;
            for (var i = 0; i < cursorArrayX.length; i++) {
                let diff = Math.abs(cursorArrayX[i] - cursor.initdistance);
                if (diff < minDiff) {
                    minDiff = diff;
                    closestIndex = i;
                }
            }
            if (closestIndex !== -1) {
                let voltage = cursorArrayY[closestIndex].toFixed(2);
                console.log(`Voltage Updated for ${phase}:`, voltage, "at Distance:", cursor.initdistance.toFixed(2));
                return voltage;
            }
            return "0.00";
        }

        let srcA = showPatternPlot ? backupDistancePatternA : distanceA;
        let valA = showPatternPlot ? backupPlotdataPatternA : plotdataA;
        let srcB = showPatternPlot ? backupDistancePatternB : distanceB;
        let valB = showPatternPlot ? backupPlotdataPatternB : plotdataB;
        let srcC = showPatternPlot ? backupDistancePatternC : distanceC;
        let valC = showPatternPlot ? backupPlotdataPatternC : plotdataC;

        positionOfVoltageA = findClosestVoltage(srcA, valA, "Phase A");
        positionOfVoltageB = findClosestVoltage(srcB, valB, "Phase B");
        positionOfVoltageC = findClosestVoltage(srcC, valC, "Phase C");
    }

    function cleardisplay() {

        canvasPlot.hideAllPhases();
        buttonNoCap = true
        // canvasPlot.hideAllPatterns();

        // canvasPlot.hideAllPatterns();
        // updataStatusOfButtonA = false
        // updataStatusOfButtonB = false
        // updataStatusOfButtonC = false
        // updataStatusOfPatternA = false
        // updataStatusOfPatternB = false
        // updataStatusOfPatternC = false

        // canvasPlot.showA = false
        // canvasPlot.showB = false
        // canvasPlot.showC = false
        // canvasPlot.showPatternA = false
        // canvasPlot.showPatternB = false
        // canvasPlot.showPatternC = false

        // console.log("Clearing all graph and tagging data...");
    //     // — Clear your plot lines
    //     distanceA = []; plotdataA = [];
    //     distanceB = []; plotdataB = [];
    //     distanceC = []; plotdataC = [];
    //     distancepatternA = []; plotdatapatternA = [];
    //     distancepatternB = []; plotdatapatternB = [];
    //     distancepatternC = []; plotdatapatternC = [];
    //     backupDistancePatternA = []; backupPlotdataPatternA = [];
    //     backupDistancePatternB = []; backupPlotdataPatternB = [];
    //     backupDistancePatternC = []; backupPlotdataPatternC = [];
    //     positionOfVoltageA = "0.00";
    //     positionOfVoltageB = "0.00";
    //     positionOfVoltageC = "0.00";

    //     // — Clear all tagging pins
    //     scatterModel.clear();
    //     globalXA = []; globalYA = [];
    //     globalXB = []; globalYB = [];
    //     globalXC = []; globalYC = [];

    //     // — Also reset the source tagging table so nothing stays “checked”
    //     for (var i = 0; i < newlistdatatebleA.count; ++i) {
    //         newlistdatatebleA.setProperty(i, "list_statusA", false);
    //     }

    //     // — Finally, force a redraw
        // canvasPlot.requestPaint();
    // }
    }

    function clearpattern() {
        canvasPlot.hideAllPatterns();
        buttonNoCap = true
        // distancepatternA = [];
        // plotdatapatternA = [];
        // distancepatternB = [];
        // plotdatapatternB = [];
        // distancepatternC = [];
        // plotdatapatternC = [];

        // positionOfVoltageA = "0.00";
        // positionOfVoltageB = "0.00";
        // positionOfVoltageC = "0.00";

        // canvasPlot.requestPaint();
    }
    Rectangle {
        id: yZoomPanel
        width: 997
        anchors.top: canvasPlot.top
        anchors.bottom: canvasPlot.bottom
        anchors.bottomMargin: 42
        anchors.leftMargin: 14
        anchors.left: parent.left
        color: "#00333333"
        border.color: "#00000000"

        property real scaleOfZoomValue: 1.0
        property real zoomValueRecord:   1.0

        // our interlock flag:
        property bool zoomLocked:     false

        Text {
            text: "Zoom Y"
            color: "#00ffffff"
            font.pixelSize: 12
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 8
        }

        MouseArea {
//            id: yZoomMouseArea
//            anchors.fill: parent
//            drag.axis:  Drag.YAxis
//            drag.target: yZoomPanel

//            property real lastY:     0

//            onPressed: {
//                zoomActive = true
//                lastY = mouse.y
//            }
//            onPositionChanged: {
//                if (!zoomActive) return
//                var dy = lastY - mouse.y   // up→positive
//                lastY = mouse.y
//                adjustZoom(dy)
//            }
//            onReleased: {
//                zoomActive = false
//            }
        }

        // unlocks adjustZoom after 100 ms
        Timer {
            id: zoomUnlockTimer
            interval: 1
            repeat: false
            onTriggered: {
                yZoomPanel.zoomLocked = false
            }
        }
        Component.onCompleted: {
            if (typeof qmlCommand === "function") {
                qmlCommand(JSON.stringify({ objectName: "getZoomValueRecordReq" }))
            }
        }
    }
    // somewhere alongside adjustZoom in the same QML file:
    function resetZoom() {
        // restore your zoom factor to the identity
        yZoomPanel.scaleOfZoomValue = 1.0
        controlAndMonitor.yZoomFactor = 1.0

        // trigger a full repaint + re‐layout of your pins
        canvasPlot.requestPaint()
        contorlAndMonitor.updateAllTagPositions()
        contorlAndMonitor.reloadTaggingData()

        console.log("▶ resetZoom: scaleOfZoomValue, yZoomFactor → 1.0")
    }

    // ─────────── your function, with interlock ────────────
    function adjustZoom(dy) {
        console.log("dy_before_adjustZoom:", dy);
        // if we're already locked out, bail immediately:
        if (yZoomPanel.zoomLocked) {
            console.log("zoom locked; skipping")
            return
        }
        // engage the lock and schedule the unlock:
        yZoomPanel.zoomLocked = true
        zoomUnlockTimer.start()

        if (dy === 0) return

        var minZoom     = 0.001
        var maxZoom     = 20.0
        var stepSize    = 0.01
        var sensitivity = 0.01

        // dy positive = zoom in, negative = zoom out
        var deltaZoom = dy * sensitivity

        console.log("▶ adjustZoom: dy=", dy,
                    " deltaZoom=", deltaZoom,
                    " before scaleOfZoomValue=", yZoomPanel.scaleOfZoomValue)

        yZoomPanel.scaleOfZoomValue += deltaZoom

        // clamp & snap
        if (yZoomPanel.scaleOfZoomValue < minZoom) yZoomPanel.scaleOfZoomValue = minZoom
        if (yZoomPanel.scaleOfZoomValue > maxZoom) yZoomPanel.scaleOfZoomValue = maxZoom
        yZoomPanel.scaleOfZoomValue =
                Math.round(yZoomPanel.scaleOfZoomValue/stepSize)*stepSize

        console.log("    → New scaleOfZoomValue =", yZoomPanel.scaleOfZoomValue)

        controlAndMonitor.yZoomFactor = yZoomPanel.scaleOfZoomValue
//        controlAndMonitor.canvasPlot.requestPaint()

        // if you still need to notify C++:
        var msg = {
            objectName:      "zoomInOut",
            zoomValuerecord: yZoomPanel.scaleOfZoomValue
        }
        qmlCommand(JSON.stringify(msg))
        reloadTaggingData()
    }


    function findClosestIndex(target, array) {
        var idx = -1, best = Infinity
        for (var i = 0; i < array.length; ++i) {
            var d = Math.abs(array[i] - target)
            if (d < best) { best = d; idx = i }
        }
        return idx
    }

    function getVoltageForDistance(distance, phase) {
        var distArr = phase==="A"? closestDistancesA
                                 : phase==="B"? closestDistancesB
                                              : closestDistancesC
        var voltArr = phase==="A"? taggingVoltagesA
                                 : phase==="B"? taggingVoltagesB
                                              : taggingVoltagesC
        var i = findClosestIndex(distance, distArr)
        return (i >= 0 ? voltArr[i] : 0)
    }

    onNewListDataTaggingChanged: {
        console.log("▶ onNewListDataTaggingChanged, newlist =", newlistdatatebleA.count);
        if (newlistdatatebleA.count === scatterModel.count) return;
        scatterModel.clear();

        // 1) build an array of your computed positions
        var computed = [];

        for (var i = 0; i < newlistdatatebleA.count; ++i) {
            var item  = newlistdatatebleA.get(i),
            d     = item.list_distanceA,
            vRaw  = parseFloat(item.ampiltudeVol),
            phase = item.list_phaseA,
            num   = item.list_numberA;

            var v = (!isNaN(vRaw) && vRaw !== 0)
                    ? vRaw
                    : getVoltageForDistance(d, phase);
            if (v === 0) continue;

            var px = cL + (d - minAxisX)/(maxAxisX - minAxisX)*cW;
            var py = cT + (1 - (v - minAxisY)/(realMaxYTagging - minAxisY))*cH;

            computed.push({
                              distance: d,
                              voltage:  v,
                              x:        px,
                              y:        py,
                              text:     num,
                              phase:    phase,
                              status:   item.list_statusA,
                              tagInfo:  item.list_detailA
                          });
        }

        // 2) store it so it never becomes undefined later
        lastComputedPositions = computed;

        // 3) append your model (x,y placeholders aren’t used—updateAllTagPositions will overwrite them)
        for (var j = 0; j < computed.length; ++j) {
            var c = computed[j];
            scatterModel.append({
                                    distance:  c.distance,
                                    voltage:   c.voltage,
                                    x:         0,
                                    y:         0,
                                    text:      c.text,
                                    status:    c.status,
                                    phaseABC:  c.phase,
                                    tagInfo:   c.tagInfo
                                });
        }

        // 4) now push that array into updateAllTagPositions
        //        updateAllTagPositions(computed);
        canvasPlot.requestPaint();
        checkCursorProximity();
    }

    function updateAllTagPositions(computed) {
        console.log("updateAllTagPositions:");
        var data = Array.isArray(computed)
                ? computed
                : lastComputedPositions;

        console.log("▶ updateAllTagPositions, items =", data.length);

        // write px/py back into the model
        for (var i = 0; i < data.length; ++i) {
            var c = data[i];
            scatterModel.setProperty(i, "x", c.x);
            scatterModel.setProperty(i, "y", c.y);
        }

        // update any helper arrays you still want
        posXA = []; posYA = [];
        posXB = []; posYB = [];
        posXC = []; posYC = [];
        for (var k = 0; k < data.length; ++k) {
            var c = data[k];
            switch (c.phase) {
            case "A": posXA.push(c.x); posYA.push(c.y); break;
            case "B": posXB.push(c.x); posYB.push(c.y); break;
            case "C": posXC.push(c.x); posYC.push(c.y); break;
            }
        }

        console.log("Phase A pinX:", posXA, "pinY:", posYA);
        console.log("Phase B pinX:", posXB, "pinY:", posYB);
        console.log("Phase C pinX:", posXC, "pinY:", posYC);

        canvasPlot.requestPaint();

    }

    function checkCursorProximity() {
        // 1) map distance → canvas x
        const L = canvasPlot.plotLeft
        const W = canvasPlot.plotWidth
        const x0 = L + (cursor.initdistance - minAxisX) / (maxAxisX - minAxisX) * W

        // 2) ตั้งค่า
        const threshold = 5            // px รอบเคอร์เซอร์
        const binWidth  = 12           // กว้างของถัง px (ปรับได้ 8–20 ตามปริมาณจุด)

        // 3) รีเซ็ตผลลัพธ์
        isCursorActiveA = isCursorActiveB = isCursorActiveC = false
        activeTaggingNumberA = activeTaggingNumberB = activeTaggingNumberC = 0
        activeTaggingDetailA = activeTaggingDetailB = activeTaggingDetailC = ""

        // 4) ทำดัชนีแบบถัง (แคชไว้ในตัวฟังก์ชันเอง) — rebuild เมื่อสภาพเปลี่ยน
        const cacheKey = [
                           scatterModel.count, L, W,
                           minAxisX, maxAxisX,
                           yZoomFactor, canvasPlot.plotHeight
                       ].join("|")

        let idx = checkCursorProximity._index
        if (!idx || idx.key !== cacheKey) {
            const binCount = Math.max(1, Math.ceil(W / binWidth) + 2)
            const bins = new Array(binCount)
            for (let b = 0; b < binCount; ++b) bins[b] = []

            // กระจายทุก tag ลงถังตามตำแหน่ง x ปัจจุบัน
            for (let i = 0; i < scatterModel.count; ++i) {
                const t  = scatterModel.get(i)
                const bx = Math.max(0, Math.min(binCount - 1, Math.floor((t.x - L) / binWidth)))
                bins[bx].push({ x: t.x, phase: t.phaseABC, text: t.text, detail: t.tagInfo })
            }

            idx = { key: cacheKey, bins, binWidth, L, binCount }
            checkCursorProximity._index = idx
            // console.log("rebuilt proximity index, bins =", binCount)
        }

        // 5) หาใกล้สุดในแต่ละเฟสจากถังรอบเคอร์เซอร์
        function nearestInPhase(phase) {
            const bi = Math.max(0, Math.min(idx.binCount - 1, Math.floor((x0 - idx.L) / idx.binWidth)))
            let bestD = Infinity, bestText = 0, bestDetail = "", found = false

            for (let b = Math.max(0, bi - 1); b <= Math.min(idx.binCount - 1, bi + 1); ++b) {
                const arr = idx.bins[b]
                for (let k = 0; k < arr.length; ++k) {
                    const c = arr[k]
                    if (c.phase !== phase) continue
                    const d = Math.abs(c.x - x0)
                    if (d <= threshold && d < bestD) {
                        bestD = d; bestText = c.text; bestDetail = c.detail; found = true
                    }
                }
            }
            return { found, text: bestText, detail: bestDetail }
        }

        const a = nearestInPhase("A")
        const b = nearestInPhase("B")
        const c = nearestInPhase("C")

        isCursorActiveA = a.found; activeTaggingNumberA = a.text; activeTaggingDetailA = a.detail
        isCursorActiveB = b.found; activeTaggingNumberB = b.text; activeTaggingDetailB = b.detail
        isCursorActiveC = c.found; activeTaggingNumberC = c.text; activeTaggingDetailC = c.detail
    }


    // helper stays exactly the same
    function checkProximity(phase, cursorMappedX) {
        console.log("checkProximity:", "phase =", phase, "cursorMappedX =", cursorMappedX)

        var threshold = 5
        var found     = false
        var num       = 0
        var detail    = ""

        for (var i = 0; i < scatterModel.count; ++i) {
            var tag = scatterModel.get(i)
            if (tag.phaseABC !== phase) continue

            if (Math.abs(cursorMappedX - tag.x) <= threshold) {
                found  = true
                num    = tag.text
                detail = tag.tagInfo
                break
            }
        }

        if (phase === "A") {
            isCursorActiveA      = found
            activeTaggingNumberA = num
            activeTaggingDetailA = detail
        } else if (phase === "B") {
            isCursorActiveB      = found
            activeTaggingNumberB = num
            activeTaggingDetailB = detail
        } else { // C
            isCursorActiveC      = found
            activeTaggingNumberC = num
            activeTaggingDetailC = detail
        }

        console.log(`${phase} → isActive: ${found}, Number: ${num}, Detail: ${detail}`)
    }

    function reloadTaggingData() {
        console.log("🔄 reloadTaggingData, rows =", newlistdatatebleA.count, backupLastZoom);

        scatterModel.clear();

        const updateNewZoomValue = zoomValueRecord;
        const newactualMaxY = (maxVoltage + yGraphOffset) / updateNewZoomValue;

        if (newlistdatatebleA.count === 0) {
            // ไม่ต้องทำอะไร
            return;
        }

        // กันหารศูนย์
        const denomX = (maxAxisX - minAxisX) !== 0 ? (maxAxisX - minAxisX) : 1;
//        const denomY = (newactualMaxY - minAxisY) !== 0 ? (newactualMaxY - minAxisY) : 1;
        const denomY = (realMaxYTagging - minAxisY) !== 0 ? (realMaxYTagging - minAxisY) : 1;
        for (let i = 0; i < newlistdatatebleA.count; ++i) {
            const r = newlistdatatebleA.get(i);
            if (!r) continue;

            // ถ้ายังอยากกรองสถานะคงไว้
            if (!r.list_statusA) continue;

            const d     = Number(r.list_distanceA);
            const vRaw  = parseFloat(r.ampiltudeVol); // (สะกดตามที่มีอยู่)
            const phase = r.list_phaseA;
            const num   = r.list_numberA;

            // 1) ค่าที่มีจริง
            let hasExplicit = (!isNaN(vRaw) && vRaw !== 0);

            // 2) ถ้าไม่มี ให้ลองคำนวณจากฟังก์ชัน
            let v = hasExplicit ? vRaw : getVoltageForDistance(d, phase);

            // 3) ถ้าได้ 0/NaN อีก → ก็ยัง “แสดงจุด” โดยปักไว้ที่เส้นฐาน minAxisY
            let zeroValue = false;
            if (isNaN(v) || v === 0) {
                v = minAxisY;  // แสดงที่ฐานกราฟ
                zeroValue = true;
            }

            // map → px/py
            let px = cL + (d - minAxisX) / denomX * cW;
            let py = cT + (1 - (v - minAxisY) / denomY) * cH;
//            let py = cT + (1 - (v - minAxisY) / denomY) * cH;

            // clamp พิกัดกันหลุดขอบ
            px = Math.max(cL, Math.min(cL + cW, px));
            py = Math.max(cT, Math.min(cT + cH, py));

            // debug
            console.log(
              `row ${i}: d=${d} vRaw=${vRaw} v=${v} zero=${zeroValue}`,
              "px:", px, "py:", py,
              "minX:", minAxisX, "maxX:", maxAxisX,
              "minY:", minAxisY, "actMaxY:", newactualMaxY
            );

            // ส่งค่าซูมสำรอง (ถ้าต้องส่งทุกจุดก็ได้ หรือย้ายออกก่อนลูป)
            const backupParameter = `{"objectName":"backupParameter", "yZoomFactor": ${zoomValueRecord}}`;
            qmlCommand(backupParameter);

            // append จุด แม้ voltage จะเป็น 0 เดิมก็ตาม
            scatterModel.append({
                distance:  d,
                voltage:   v,
                x:         px,
                y:         py,
                text:      num,
                status:    true,
                phaseABC:  phase,
                tagInfo:   r.list_detailA,
                zeroValue: zeroValue   // << ธงไว้ใช้สไตลิ่ง
            });
        }

        canvasPlot.requestPaint();
        // ถ้าต้องการคำนวณใกล้เคียงเคอร์เซอร์หลังรีโหลด:
        // checkCursorProximity();
    }

    function removePhasePoints(phase) {
        for (let i = scatterModel.count - 1; i >= 0; --i) {
            const it = scatterModel.get(i);
            if (it && it.phaseABC === phase) {
                scatterModel.remove(i);
            }
        }
        canvasPlot.requestPaint();
    }


//    function reloadTaggingData() {
//        console.log("🔄 reloadTaggingData, rows =", newlistdatatebleA.count,backupLastZoom);
//        scatterModel.clear();
//        var updateNewZoomValue = zoomValueRecord
//        var newactualMaxY = (maxVoltage + yGraphOffset) / updateNewZoomValue
//        if(newlistdatatebleA.count !== 0){
//            console.log("newlistdatatebleA.count:", newlistdatatebleA.count);
//            for (var i = 0; i < newlistdatatebleA.count; ++i) {
//                var r = newlistdatatebleA.get(i);
//                if (!r.list_statusA) continue;

//                var d    = r.list_distanceA,
//                vRaw = parseFloat(r.ampiltudeVol),
//                phase= r.list_phaseA,
//                num  = r.list_numberA;

//                var v = (!isNaN(vRaw) && vRaw !== 0)
//                        ? vRaw
//                        : getVoltageForDistance(d, phase);
//                if (v === 0) continue;

//                var px = cL + (d - minAxisX)/(maxAxisX - minAxisX)*cW;
//                var py = cT + (1 - (v - minAxisY)/(newactualMaxY - minAxisY))*cH;

//                console.log("px:",px,"py:",py,"zoomValueRecord:",zoomValueRecord,"minAxisX:",minAxisX,"maxAxisX:",maxAxisX,"d:",d,"L:",cL,"W:",cW,"T:",cT,"v:",v,"minAxisY:",minAxisY,"AY:",realMaxYTagging,"H:",cH,"maxAxisY:",maxAxisY)
//                let backupParameter = `{"objectName":"backupParameter", "yZoomFactor": ${zoomValueRecord}}`;
//                console.log("backupParameter:", backupParameter);
//                qmlCommand(backupParameter);
//                scatterModel.append({
//                                        distance:  d,
//                                        voltage:   v,
//                                        x:         px,
//                                        y:         py,
//                                        text:      num,
//                                        status:    true,
//                                        phaseABC:  phase,
//                                        tagInfo:   r.list_detailA
//                                    });
//            }
//            canvasPlot.requestPaint();

//        }
//        //        checkCursorProximity();
//    }

    //     function reloadTaggingData() {
    //         // wipe out old helper arrays
    //         console.log("reloadTaggingData:")

    //         const L  = canvasPlot.plotLeft
    //         const T  = canvasPlot.plotTop
    //         const W  = canvasPlot.plotWidth
    //         const H  = canvasPlot.plotHeight
    //         const AY = canvasPlot.actualMaxY

    //         for (let i = 0; i < scatterModel.count; ++i) {
    //             const tag = scatterModel.get(i)
    //             const d   = tag.distance
    //             const v   = tag.voltage
    //             if (d === undefined || v === undefined) continue

    //             // exactly the same mapping you use in onPaint()
    //             const px = L + (d - minAxisX)/(maxAxisX - minAxisX)*W
    //             const py = T + (1 - (v - minAxisY)/(AY - minAxisY))*H
    //             console.log("px:",px,"py:",py,"yZoomFactor:",yZoomFactor,"minAxisX:",minAxisX,"maxAxisX:",maxAxisX,"d:",d,"L:",L,"W:",W,"T:",T,"v:",v,"minAxisY:",minAxisY,"AY:",AY,"H:",H,"maxAxisY:",maxAxisY)
    //             scatterModel.setProperty(i, "x", px)
    //             scatterModel.setProperty(i, "y", py)

    //             // populate per-phase helpers
    //             switch (tag.phaseABC) {
    //             case "A": posXA.push(px); posYA.push(py); break
    //             case "B": posXB.push(px); posYB.push(py); break
    //             case "C": posXC.push(px); posYC.push(py); break
    //             }

    //         }

    //         // now these will log non-empty arrays:
    //         console.log("Phase A pinX:", posXA, "pinY:", posYA)
    //         console.log("Phase B pinX:", posXB, "pinY:", posYB)
    //         console.log("Phase C pinX:", posXC, "pinY:", posYC)
    //         canvasPlot.requestPaint()
    //         checkCursorProximity();
    //     }

    onPlotminAxisXChanged:     { canvasPlot.requestPaint(); updateCursorFromExternal()}
    onPlotmaxAxisXChanged:     { canvasPlot.requestPaint(); updateCursorFromExternal()}
    onPlotminAxisYChanged:     { canvasPlot.requestPaint() }
    onPlotmaxAxisYChanged:     { canvasPlot.requestPaint() }
    onYZoomFactorChanged:  { canvasPlot.requestPaint() }



    Canvas {
        id: canvasPlot
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: 215
        anchors.topMargin: 60
        antialiasing: true
        property int plotLeft:   50
        property int plotRight:  20
        property int plotTop:    10
        property int plotBottom: 25
        property int plotWidth:  width  - plotLeft - plotRight
        property int plotHeight: height - plotTop  - plotBottom
        property bool paintDone: false

        property bool showA: updataStatusOfButtonA
        property bool showB: updataStatusOfButtonB
        property bool showC: updataStatusOfButtonC
        property bool showPatternA: updataStatusOfPatternA
        property bool showPatternB: updataStatusOfPatternB
        property bool showPatternC: updataStatusOfPatternC

        // property alias showA: updataStatusOfButtonA
        // property alias showB: updataStatusOfButtonB
        // property alias showC: updataStatusOfButtonC

        //         property real actualMaxY: actualMaxY

        property int markerSize: 50

        Image { id: imgA; source: "qrc:/images/pinPointerTaggingA.png"; visible: false ;anchors.fill: parent }
        Image { id: imgB; source: "qrc:/images/pinPointerTaggingB.png"; visible: false ;anchors.fill: parent }
        Image { id: imgC; source: "qrc:/images/pinPointerTaggingC.png"; anchors.bottomMargin: 0; visible: false ;anchors.fill: parent }
        Repeater {
            id: repeater
            model: scatterModel
            delegate: PointerTagging {
                number: model.text
                dataReceived: model.status
                phase: model.phaseABC
                width: 50
                height: 50
                x: model.x
                y: model.y
                visible: (model.phaseABC === "A" && updataStatusOfButtonA)
                         || (model.phaseABC === "B" && updataStatusOfButtonB)
                         || (model.phaseABC === "C" && updataStatusOfButtonC)
            }
        }
        // map phase → the correct Image object
        property var pointerImages: ({ "A": imgA, "B": imgB, "C": imgC })

        function mapToPosition(pt) {
            var dx = (pt.x - minAxisX) / (maxAxisX - minAxisX)
            // 🔑 ใช้ realMaxYTagging ตรงนี้ด้วย
            var dy = (pt.y - minAxisY) / (actualMaxY - minAxisY)
            var cx = plotLeft + dx * plotWidth
            var cy = plotTop  + (1 - dy) * plotHeight
            return Qt.point(cx, cy)
        }
//        function mapToPosition(pt) {
//            var dx = (pt.x - minAxisX) / (maxAxisX - minAxisX)
//            var dy = (pt.y - minAxisY) / (actualMaxY - minAxisY)
//            var cx = plotLeft + dx * plotWidth
//            var cy = plotTop  + (1 - dy) * plotHeight
//            return Qt.point(cx, cy)
//        }
        onPaint: {
            console.log("closeDistance:",closeDistance,"CloseVoltage:" ,closeVoltage)


            if ( distanceA.length > 0 && backupDistanceA.length === 0 && distanceB.length > 0 && backupDistanceB.length === 0 && distanceC.length > 0 && backupDistanceC.length === 0) {
                backupDistanceA = distanceA.slice()
                backupPlotdataA = plotdataA.slice()
                backupDistanceB = distanceB.slice()
                backupPlotdataB = plotdataB.slice()
                backupDistanceC = distanceC.slice()
                backupPlotdataC = plotdataC.slice()
            }
            // const ctx = getContext("2d")
            // ctx.reset && ctx.reset()
            const ctx = canvasPlot.getContext("2d")
            ctx.clearRect(0, 0, canvasPlot.width, canvasPlot.height) // ล้างก่อนวาด
            // 1) fill background
            ctx.fillStyle = "#000"
            ctx.fillRect(0, 0, width, height)

            percentPlot = 0
            plotProgressTimer.start()

            // 2) draw axes + grid (your existing code)
            ctx.strokeStyle = "#888"
            ctx.lineWidth   = 1

            // Y axis
            ctx.beginPath()
            ctx.moveTo(plotLeft, plotTop)
            ctx.lineTo(plotLeft, plotTop + plotHeight)
            ctx.stroke()

            // X axis
            ctx.beginPath()
            ctx.moveTo(plotLeft, plotTop + plotHeight)
            ctx.lineTo(plotLeft + plotWidth, plotTop + plotHeight)
            ctx.stroke()


            // Y ticks
            ctx.fillStyle   = "#ccc"
            ctx.font        = "10px sans-serif"
            ctx.textAlign   = "right"
            for (let i=0; i<=5; ++i) {
                let val = minAxisY + (i/5)*(actualMaxY - minAxisY)
                let y   = plotTop + (1 - i/5)*plotHeight
                ctx.fillText(val.toFixed(0), plotLeft - 5, y + 3)
                ctx.beginPath()
                ctx.strokeStyle = "#333"
                ctx.moveTo(plotLeft, y)
                ctx.lineTo(plotLeft + plotWidth, y)
                ctx.stroke()
            }


            // X ticks
            ctx.textAlign = "center"
            for (let i=0; i<=10; ++i) {
                let val = minAxisX + (i/10)*(maxAxisX - minAxisX)
                let x   = plotLeft + (i/10)*plotWidth
                ctx.fillText(val.toFixed(0), x, plotTop + plotHeight + 12)
                ctx.beginPath()
                ctx.strokeStyle = "#222"
                ctx.moveTo(x, plotTop)
                ctx.lineTo(x, plotTop + plotHeight)
                ctx.stroke()
            }

            // Y‐label
            ctx.save()
            ctx.translate(10, height/2)
            ctx.rotate(-Math.PI/2)
            ctx.textAlign = "center"
            ctx.fillStyle = "#ccc"
            ctx.font      = "12px sans-serif"
            ctx.fillText("Voltage (mV)", 0,0)
            ctx.restore()

            // X‐label
            ctx.fillStyle = "#ccc"
            ctx.font      = "12px sans-serif"
            ctx.textAlign = "center"
            ctx.fillText("Distance (Km)", plotLeft + plotWidth/2, height - 5)

            // 3) draw your three phase curves (your existing drawLine calls)…
            console.log("actualMaxY:",actualMaxY, "lastZoomVoltage:",lastZoomVoltage,"realMaxYTagging:",realMaxYTagging);
            function drawLine(distances, values, color) {
                if (!distances.length) return false
                ctx.beginPath()
                ctx.strokeStyle = color
                ctx.lineWidth   = 2
                for (let i=0; i<distances.length; ++i) {
                    const x = plotLeft + (distances[i] - minAxisX)/(maxAxisX - minAxisX)*plotWidth
                    // 🔑 ใช้ realMaxYTagging แทน actualMaxY
//                    const y = plotTop + (1 - (values[i] - fixedMinY) / (fixedMaxY - fixedMinY)) * plotHeight
                    const y = plotTop  + (1 - (values[i] - minAxisY)/(realMaxYTagging - minAxisY))*plotHeight
                    if (i===0) ctx.moveTo(x,y)
                    else       ctx.lineTo(x,y)
                }
                ctx.stroke()
                return true
            }
//            function drawLine(distances, values, color) {
//                if (!distances.length) return false
//                ctx.beginPath()
//                ctx.strokeStyle = color
//                ctx.lineWidth   = 2
//                for (let i=0; i<distances.length; ++i) {
//                    const x = plotLeft + (distances[i] - minAxisX)/(maxAxisX - minAxisX)*plotWidth
//                    const y = plotTop  + (1 - (values[i] - minAxisY)/(actualMaxY - minAxisY))*plotHeight
//                    if (i===0) ctx.moveTo(x,y)
//                    else       ctx.lineTo(x,y)
//                }
//                ctx.stroke()
//                return true
//            }


            console.log("hideAllPhases showA",updataStatusOfButtonA," showB",updataStatusOfButtonB," showC",updataStatusOfButtonC)
            console.log("hideAllPatterns showPatternA",updataStatusOfPatternA," showPatternB",updataStatusOfPatternB," showPatternC",updataStatusOfPatternC)
            // Pattern
            if (showPatternA) drawLine(distancepatternA, plotdatapatternA, "#f7cbac")
            if (showPatternB) drawLine(distancepatternB, plotdatapatternB, "#bc9121")
            if (showPatternC) drawLine(distancepatternC, plotdatapatternC, "#bed6ed")
            console.log("PhaseshowA:",showA," PhaseshowB:",showB," PhaseshowC:",showC)

            // Phase
            if (showA) drawLine(distanceA, plotdataA, "#fd2d1d")
            if (showB) drawLine(distanceB, plotdataB, "#fcff3b")
            if (showC) drawLine(distanceC, plotdataC, "#0088ff")

            console.log("testshow showA",showA," showB",showB," showC",showC)
            console.log("testshow showPatternA",showPatternA," showPatternB",showPatternB," showPatternC",showPatternC)
            // onUpdataStatusOfPatternAChanged: requestPaint()
            // onUpdataStatusOfPatternBChanged: requestPaint()
            // onUpdataStatusOfPatternCChanged: requestPaint()
            // onUpdataStatusOfButtonAChanged: requestPaint()
            // onUpdataStatusOfButtonBChanged: requestPaint()
            // onUpdataStatusOfButtonCChanged: requestPaint()

            // if (updataStatusOfPatternA) {
                // drawLine(distancepatternA, plotdatapatternA, "#f7cbac");
            // } else if (!updataStatusOfPatternA){
            //     drawLine(distancepatternA, plotdatapatternA, "#11ffffff");
            // }
            // if (updataStatusOfPatternB) {
                // drawLine(distancepatternB, plotdatapatternB, "#bc9121");
            // }else if (!updataStatusOfPatternB){
            //     drawLine(distancepatternB, plotdatapatternB, "#11ffffff");
            // }
            // if (updataStatusOfPatternC) {
                // drawLine(distancepatternC, plotdatapatternC, "#bed6ed");
            // }else if (!updataStatusOfPatternC){
            //     drawLine(distancepatternC, plotdatapatternC, "#11ffffff");
            // }

            // if (updataStatusOfButtonA) {
                // drawLine(distanceRawA, voltageRawA, "#fd2d1d")
            // } else if (!updataStatusOfButtonA){
            //     drawLine(distanceRawA, voltageRawA, "#00ffffff")
            // }
            // if (updataStatusOfButtonB) {
                // drawLine(distanceB, plotdataB, "#fcff3b")
            // }else if (!updataStatusOfButtonB){
            //     drawLine(distanceB, plotdataB, "#00ffffff")
            // }
            // if (updataStatusOfButtonC) {
                // drawLine(distanceC, plotdataC, "#0088ff")
            // }else if (!updataStatusOfButtonC){
            //     drawLine(distanceC, plotdataC, "#00ffffff")
            // }



            function hasAllData() {
//                showAllPhases()
                console.log("hasAllData",distanceA.length,distanceB.length,distanceC.length)
                return distanceA.length > 0 && plotdataA.length > 0 &&
                        distanceB.length > 0 && plotdataB.length > 0 &&
                        distanceC.length > 0 && plotdataC.length > 0;
            }
            function suragePhaseAonly() {
                console.log("suragePhaseAonly")
                return distanceA.length > 0 && plotdataA.length > 0;
            }
            function suragePhaseBonly() {
                console.log("suragePhaseBonly")
                return distanceB.length > 0 && plotdataB.length > 0;
            }
            function suragePhaseConly() {
                console.log("suragePhaseConly")
                return distanceC.length > 0 && plotdataC.length > 0;
            }

            function checkAndStartScreenshot() {
                if (alreadyCaptured)
                    return;

                const hasA = isDataAReady && suragePhaseAonly();
                const hasB = isDataBReady && suragePhaseBonly();
                const hasC = isDataCReady && suragePhaseConly();

                if (hasA || hasB || hasC) {
                    console.log("Screenshot timer started due to valid data in one or more phases");
                    alreadyCaptured = true;
                    suragePlot = true;
                    console.log("suragePlot:",suragePlot);

                }
                else{
                    linesDrawn++
                }

                alreadyCaptured=false
                console.log("linesDrawn:",linesDrawn);

            }

            onPlotdataAChanged: checkAndStartScreenshot();
            onPlotdataBChanged: checkAndStartScreenshot();
            onPlotdataCChanged: checkAndStartScreenshot();


            console.log("✅ drawLine completed for", linesDrawn, "series");
            //            qmlCommand(`{"objectName":"drawComplete","count":${linesDrawn}}`);
            console.log("Before_buttonNoCap:", buttonNoCap);
            if(!buttonNoCap){
                console.log("After_buttonNoCap:", buttonNoCap,unscreenshotTimer);
                if(unscreenshotTimer === true){
                    if(remotePopup.state == true || vncPopup.state == true || disconnectPopup.state == true){
                        console.log("After_buttonNoCap:", remotePopup.state,vncPopup.state,disconnectPopup.state);
                        connectForunlockCapture = false
//                        return
                    }else{
                        connectForunlockCapture = true
                    }
                }else if(!unscreenshotTimer){
                    console.log("unscreenshotTimer:", unscreenshotTimer);
                    if(loggingOutPopup.state === true){
                        console.log("loggingOutPopup.state:", loggingOutPopup.state);
                        connectForunlockCapture = false
//                        return
                    }else{
                        connectForunlockCapture = true
                    }
                    console.log("connectForunlockCapture:", connectForunlockCapture);

                }


                showAllPhases()
                console.log("before screenshotTimer",hasAllData(), unscreenshotTimer, connectForunlockCapture,loggingOutPopup.state,suragePlot);
                 if(suragePlot === true){
                    console.log("suragePlot_cap",unscreenshotTimer,connectForunlockCapture,suragePlot);
                    if(unscreenshotTimer === true && connectForunlockCapture === true){
                        console.log("screenshotTimerStart",unscreenshotTimer,hasAllData(),connectForunlockCapture ,linesDrawn);
                        controlAndMonitor.plottingFinished();
                        screenshotTimer.start();
                        console.log("After_screenshotTimerStart:",unscreenshotTimer, connectForunlockCapture);
                    }else if(!unscreenshotTimer && connectForunlockCapture === true){ //VNC
                        showAllPhases()
                        controlAndMonitor.plottingFinished();
                        screenshotTimer.start();
                        console.log("VNC screenshotTimerStop",unscreenshotTimer);
                    }
                    suragePlot = false
                }
                else if(unscreenshotTimer === true && hasAllData() && connectForunlockCapture === true){
                    console.log("screenshotTimerStart",unscreenshotTimer,hasAllData(),connectForunlockCapture ,linesDrawn);
                    if(linesDrawn == 3){
                        linesDrawn = 0;
                        controlAndMonitor.plottingFinished();
                        screenshotTimer.start();
                        console.log("After_screenshotTimerStart:",unscreenshotTimer, connectForunlockCapture);
                     }

                }else if(!unscreenshotTimer && loggingOutPopup.state === false){ //VNC
                    if(linesDrawn == 3){
                        showAllPhases()
                        controlAndMonitor.plottingFinished();
//                      screenshotTimer.stop();
                        screenshotTimer.start();
                        console.log("VNC screenshotTimerStop",unscreenshotTimer);
                        linesDrawn = 0
                    }
                }else{
                    console.log("else_screenshotTimer",hasAllData(), unscreenshotTimer, connectForunlockCapture,loggingOutPopup.state,suragePlot);
                }
            }

//            Qt.callLater(() => { //normal
                             //                controlAndMonitor.plottingFinished();

//                         });
            // Now, whenever you need quick access to the *latest* pin positions for Phase A:
            console.log("actualMaxY_recheck:",actualMaxY,realMaxYTagging)
            reloadTaggingData()
//            buttonNoCap = false
            console.log("End_buttonNoCap:",buttonNoCap)

        }

        // ให้รีเพนท์เมื่อ toggle โชว์/ซ่อน เปลี่ยน
        onShowAChanged: requestPaint()
        onShowBChanged: requestPaint()
        onShowCChanged: requestPaint()
        onShowPatternAChanged: requestPaint()
        onShowPatternBChanged: requestPaint()
        onShowPatternCChanged: requestPaint()

        function hideAllPhases() {
            // ---- ของเดิมทั้งหมดคงไว้ ----
            updataStatusOfButtonA = false
            updataStatusOfButtonB = false
            updataStatusOfButtonC = false
            updataStatusOfPatternA = false
            updataStatusOfPatternB = false
            updataStatusOfPatternC = false

            var updateStatusPatternA = '{"objectName":"updateisGreenBut","updateStatusisGreenAll": false}'
            qmlCommand(updateStatusPatternA);
            console.log("hideAllPhases showA", updataStatusOfButtonA, " showB", updataStatusOfButtonB, " showC", updataStatusOfButtonC)
        }

        function showAllPhases() {
            // showA = showB = showC = false
            updataStatusOfButtonA = true
            updataStatusOfButtonB = true
            updataStatusOfButtonC = true
            updataStatusOfPatternA = true
            updataStatusOfPatternB = true
            updataStatusOfPatternC = true
//            showA = true
//            showB = true
//            showC = true
//            showPatternA = true
//            showPatternB = true
//            showPatternC = true
//            requestPaint()
            var updateStatusPatternA = '{"objectName":"updateisGreenBut","updateStatusAll": '+"true"+'}'
            qmlCommand(updateStatusPatternA);
            console.log("hideAllPhases showA",updataStatusOfButtonA," showB",updataStatusOfButtonB," showC",updataStatusOfButtonC)
            console.log("showA:",showA," showB:",showB," showC:",showC)

        }


        function hideAllPatterns() {
            // ---- ของเดิมทั้งหมดคงไว้ ----
            updataStatusOfPatternA = false
            updataStatusOfPatternB = false
            updataStatusOfPatternC = false

            var updateStatusPatternA = '{"objectName":"updateisGreenBut","updateStatusisGreenAllPattern": false}'
            qmlCommand(updateStatusPatternA);
            console.log("hideAllPatterns showPatternA", updataStatusOfPatternA, " showPatternB", updataStatusOfPatternB, " showPatternC", updataStatusOfPatternC)
        }

        function showAllPatterns() {
            // showPatternA = showPatternB = showPatternC = false
            updataStatusOfPatternA = true
            updataStatusOfPatternB = true
            updataStatusOfPatternC = true

            var updateStatusPatternA = '{"objectName":"updateisGreenBut","updateStatusisGreenAllPattern": '+"true"+'}'
            qmlCommand(updateStatusPatternA);
            console.log("hideAllPatterns showPatternA",updataStatusOfPatternA," showPatternB",updataStatusOfPatternB," showPatternC",updataStatusOfPatternC)
        }
        Component.onCompleted:{
            canvasPlot.requestPaint()
            console.log("yZoomFactor compare to zoomValueRecord:",yZoomFactor,zoomValueRecord)
            reloadTaggingData();
            console.log("actualMaxY_recheck_after_completed:",actualMaxY,yZoomFactor,zoomValueRecord)
        }

        //         Rectangle {
        //             id: cursor
        //             width: 1
        //             height: canvasPlot.height
        //             color: "#ffffff"
        //             visible: true
        //             radius: 1
        //             z: 5

        //             property real startX: 50
        //             property real endX: canvasPlot.width - 20
        //             property double initdistance: (minAxisX + maxAxisX) / 2

        //             function updateCursorPosition() {
        //                 var denom = (maxAxisX - minAxisX)
        //                 if (denom <= 0) return
        //                 let percent = (initdistance - minAxisX) / denom
        //                 percent = Math.max(0, Math.min(1, percent))
        //                 x = startX + percent * (endX - startX)
        //             }

        //             function setCursorToDistance(dist) {
        //                 initdistance = dist
        //                 updateCursorPosition()
        //             }

        //             Component.onCompleted: {
        //                 setCursorToDistance((minAxisX + maxAxisX) / 2)
        //                 // ถ้ามี pending จาก C++ มาก่อนหน้า เคลียร์ให้ตรงนี่เลย
        //                 updateCursorFromExternal()
        //             }

        //             onXChanged: {
        //                 let percent = (x - startX) / (endX - startX)
        //                 percent = Math.max(0, Math.min(1, percent))
        //                 initdistance = minAxisX + percent * (maxAxisX - minAxisX)
        //             }

        //             onInitdistanceChanged: {
        //                 // อัปเดตค่าอื่น ๆ ที่ผูกกับตำแหน่ง
        //                 updateCursorVoltage()
        //                 controlAndMonitor.checkCursorProximity()

        //                 // กัน feedback loop: ถ้าเป็นการตั้งจากภายนอก ไม่ต้องส่งกลับ
        //                 if (_applyingExternalCursor) return

        //                 const msg = {
        //                     objectName: "positionDistance",
        //                     distance:   initdistance.toFixed(2)
        //                 }
        //                 console.log("Position Sent:", JSON.stringify(msg))
        //                 qmlCommand(JSON.stringify(msg))
        //             }

        //             MouseArea {
        //                 id: dragArea
        //                 anchors.fill: parent
        //                 cursorShape: Qt.OpenHandCursor
        //                 drag.axis: Drag.XAxis
        //                 drag.target: cursor
        //                 onPositionChanged: {
        //                     cursor.x = Math.max(cursor.startX, Math.min(cursor.x, cursor.endX))
        //                 }
        //                 onReleased: {
        //                     const released = `{"objectName":"positionDistance","distance":${cursor.initdistance.toFixed(2)}}`
        //                     qmlCommand(released)
        //                     console.log("Cursor Released Distance =", cursor.initdistance.toFixed(2))
        //                 }
        //             }
        //         }


        Rectangle {
            id: cursor
            width: 1
            height: canvasPlot.height
            color: "#ffffff"
            radius: 1
            visible: true
            property real startX: 50
            property real endX: canvasPlot.width - 20
            property double initdistance: (minAxisX + maxAxisX) / 2
            z: 5

            function updateCursorPosition() {
                let percent = (cursor.initdistance - minAxisX) / (maxAxisX - minAxisX);
                percent = Math.max(0, Math.min(1, percent));
                cursor.x = cursor.startX + percent * (cursor.endX - cursor.startX);
            }

            function setCursorToDistance(dist) {
                cursor.initdistance = dist;
                updateCursorPosition();
            }

            Component.onCompleted: {
                setCursorToDistance((minAxisX + maxAxisX) / 2);
                console.log("setCursorToDistance:",minAxisX,maxAxisX)
                initialTimer.start();
            }

            onXChanged: {
                let percent = (cursor.x - cursor.startX) / (cursor.endX - cursor.startX);
                percent = Math.max(0, Math.min(1, percent));
                cursor.initdistance = minAxisX + percent * (maxAxisX - minAxisX);
            }

            //             onInitdistanceChanged: {
            //                 updateCursorVoltage();
            //                 let initialPosition = `{"objectName":"positionDistance", "distance": ${cursor.initdistance.toFixed(2)}}`;
            //                 console.log("Initial Position Sent:", initialPosition);
            //                 qmlCommand(initialPosition);
            //             }
            onInitdistanceChanged: {
                updateCursorVoltage()
                controlAndMonitor.checkCursorProximity()
                let msg = {
                    objectName: "positionDistance",
                    distance:   initdistance.toFixed(2)
                }
                console.log("Position Sent:", JSON.stringify(msg))
                qmlCommand(JSON.stringify(msg))
            }
            Timer {
                id: initialTimer
                interval: 3000
                running: false
                repeat: false
                onTriggered: {
                    let initialPosition = `{"objectName":"positionDistance", "distance": ${cursor.initdistance.toFixed(2)}}`;
                    console.log("initialTimer Position Sent:", initialPosition);
                    qmlCommand(initialPosition);
                }
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                anchors.leftMargin: 0
                anchors.rightMargin: -156
                cursorShape: Qt.OpenHandCursor
                drag.axis: Drag.XAxis
                drag.target: cursor

                onPositionChanged: {
                    cursor.x = Math.max(cursor.startX, Math.min(cursor.x, cursor.endX));
                }

                onReleased: {
                    let released = `{"objectName":"positionDistanceChnage", "distance": ${cursor.initdistance.toFixed(2)}}`;
                    qmlCommand(released);
                    console.log("Cursor Released Distance =", cursor.initdistance.toFixed(2));
                }
            }
        }
    }

    function updateCursorFromExternal(distance) {
        if (typeof distance !== "undefined") {
            const num = parseFloat(distance)
            if (!isFinite(num)) {
                console.log("updateCursorFromExternal: invalid input:", distance)
                return
            }
            pendingCursorDistance = num
            console.log("updateCursorFromExternal: queued =", pendingCursorDistance)
        }

        // ลอง apply ถ้าแกนพร้อมและมี pending
        if (isFinite(minAxisX) && isFinite(maxAxisX) && maxAxisX > minAxisX && !isNaN(pendingCursorDistance)) {
            const safe = Math.max(minAxisX, Math.min(pendingCursorDistance, maxAxisX))
            _applyingExternalCursor = true
            cursor.setCursorToDistance(safe)   // จะอัปเดตทั้ง initdistance และ x
            _applyingExternalCursor = false
            console.log("updateCursorFromExternal: applied →", safe.toFixed(2))
            pendingCursorDistance = NaN
        } else {
            console.log("updateCursorFromExternal: axes not ready; keep pending =", pendingCursorDistance)
        }
    }

    onVisibleChanged: if (visible) updateCursorFromExternal()

    //    function updateCursorFromExternal(distance) {
    //        if (isNaN(distance)) {
    //            console.log("updateCursorFromExternal: Invalid number:", distance);
    //            return;
    //        }

    //        let safeDistance = Math.max(minAxisX, Math.min(distance, maxAxisX));
    //        cursor.setCursorToDistance(safeDistance);
    //        console.log("updateCursorFromExternal → cursor moved to:", safeDistance.toFixed(2));
    //    }


    DataStatusInfo {
        id: dataStatusInfo
        x: 0
        y: 385
        width: 650
        height: 215
    }


    Cursorcontrol {
        id: cursorcontrol
        anchors.fill: parent
        anchors.rightMargin: -2
        anchors.bottomMargin: 0
        anchors.leftMargin: 650
        anchors.topMargin: 383
    }


    Rectangle {
        id: datafilename
        color: "#f2f2f2"
        radius: 5
        border.color: "#9b9b9b"
        anchors.fill: parent
        anchors.rightMargin: 342
        anchors.bottomMargin: 507
        anchors.leftMargin: 354
        anchors.topMargin: 63

        Text {
            id: textdatafilename
            text: fullnameCSV !== "" ? fullnameCSV : fileNameData
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }


    Rectangle {
        id: patternfilename
        color: "#bfbfbf"
        radius: 5
        border.color: "#9b9b9b"

        anchors.fill: parent
        anchors.leftMargin: 688
        anchors.topMargin: 63
        anchors.rightMargin: 8
        anchors.bottomMargin: 507

        // สำคัญ: ไม่ clip เพื่อให้ข้อความยาวแสดงล้นได้เหมือน datafilename
        clip: false
        z: 10

        Text {
            id: textpatternfilename
            text: openFilePattern !== "" ? openFilePattern : ""

            anchors.fill: parent
            anchors.leftMargin: 4
            anchors.rightMargin: 4

            font.pixelSize: 12
            color: "black"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            elide: Text.ElideNone
            wrapMode: Text.NoWrap

            clip: false
        }
    }
    RowLayout {
        id: rowLayout
        x: 50; y: 60
        width: 271; height: 36
        spacing: 8

        SpinBox {
            id: spinBox
            to: 8192
            Layout.fillHeight: true
            Layout.fillWidth: false
            from: minZoomMv
            stepSize: 50
            value: actualMaxY
            editable: true

            onValueModified: {
                pendingYZoomMv = value
                yZoomPanel.scaleOfZoomValue = pendingYZoomMv / 1000.0
                autoSendTimer.restart()   // ถ้ามีการเปลี่ยน -> เริ่มนับใหม่
            }

            contentItem: TextInput {
                text: spinBox.value + " mV"
                font: spinBox.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                readOnly: !spinBox.editable
                validator: IntValidator { bottom: spinBox.from; top: spinBox.to }
                onEditingFinished: {
                    var t = text.replace(/[^0-9]/g, "");
                    if (t.length === 0) return;
                    spinBox.value = parseInt(t);
                }
            }
        }

//        Button {
//            id: applyButton
//            text: qsTr("Enter")
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            Layout.preferredWidth: 120
//            onClicked: {
////                commitSpinZoom();
//                var rawMv = spinBox.value        // เช่น 600
//                pendingYZoomMv = rawMv           // 600
//                yZoomPanel.scaleOfZoomValue = rawMv / 1000.0  // 0.6
//                var payload = {
//                    objectName: "lastZoomVoltage",
//                    valueOfZoom: yZoomPanel.scaleOfZoomValue, // 0.6
//                    lastZoomVoltage: rawMv                    // 600
//                };
//                console.log("payload:", yZoomPanel.scaleOfZoomValue,
//                            "rawMv:", rawMv,
//                            "pendingYZoomMv:", pendingYZoomMv);
//                adjustZoom(rawMv)
//                qmlCommand(JSON.stringify(payload));
//            }

//        }


        // Reset โผล่เมื่อค่าซูมปัจจุบันต่างจาก baseline
        Button {
            id: resetButton
            text: qsTr("Reset")
            Layout.fillWidth: false
            Layout.fillHeight: true

            // โผล่เมื่อค่าปัจจุบันของ SpinBox ไม่เท่ากับ baseline
            visible: spinBox.value !== baselineZoomMv

            onClicked: {
                const targetMv    = baselineZoomMv
                const targetScale = targetMv / 1000.0

                // sync ทั้งหมดกลับ baseline
                pendingYZoomMv = targetMv
                spinBox.value  = targetMv
                yZoomPanel.scaleOfZoomValue = targetScale
                controlAndMonitor.yZoomFactor = targetScale
                controlAndMonitor.canvasPlot && controlAndMonitor.canvasPlot.requestPaint()

                const payload = {
                    objectName:      "lastZoomVoltage",
                    lastZoomVoltage: targetMv,
                    valueOfZoom:     targetScale
                }
                console.log("Reset payload:", JSON.stringify(payload))
                if (typeof qmlCommand === "function")
                    qmlCommand(JSON.stringify(payload))

                typeof reloadTaggingData === "function" && reloadTaggingData()
            }
        }

    }

    Timer {
        id: autoSendTimer
        interval: 3000   // 3 วินาที
        repeat: false
        onTriggered: {
            var rawMv = spinBox.value
            pendingYZoomMv = rawMv
            yZoomPanel.scaleOfZoomValue = rawMv / 1000.0

            var payload = {
                objectName:      "lastZoomVoltage",
                valueOfZoom:     yZoomPanel.scaleOfZoomValue,
                lastZoomVoltage: rawMv
            }
            console.log("Auto payload:", JSON.stringify(payload))
            if (typeof qmlCommand === "function")
                qmlCommand(JSON.stringify(payload))
        }
    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
