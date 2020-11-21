/**
 * 맵 가장자지
 */
var tm_x_s = 14006422.90;
var tm_y_s = 3924977.64;
var tm_x_e = 14581821.92;
var tm_y_e = 4651479.41;
/**
 * 줌 레벨
 */
var default_zoom_level = 7;
/**
 * 초기 위치 주소
 */
var NpmsAddress = "";
/**
 * 중심좌표
 */
var tm_center_x = 14198707.279825;
var tm_center_y = 4269232.193205;

var NpmsMap;
var geocoder = null; // 역지오코딩을 위한 코드
var propertiesMap;
var lonlat;
var panelX, panelY;
var isFirstLoad = true;
var isMoveMap = true;	// 지도 움직임 여뷰
var cropName;
var pestName;
/**
 * 작목리스트
 */
var cropList = new Array();;

/**
 * 작물별 병해충 정보 배열
 */
var kncrPestList = new Array();

/**
 * 전체 OpenAPI 넓이 : 기본 600px
 */
var NpmsOpenAPIWidth = 600;

/**
 * 전체 OpenAPI 넓이 변
 */
function setNpmsOpenAPIWidth( width ) {
	NpmsOpenAPIWidth = width;	
}

/**
 * 지도 움직임 여부 설정
 * @param at
 */
function setMoveMatAt( at ) {
	isMoveMap = at;
}

/**
 * 작목 목록 설정
 */
function setCropList( list ) {
	cropList = list;
}

/**
 * 속성지도 초기 위치를 변경한다.
 */
function setRegion( address , zoomLevel ) {
	geocoder = new google.maps.Geocoder();
	//NpmsAddress = address;
	NpmsAddress = encodeURIComponent(address);
	
	default_zoom_level = zoomLevel;	
}

/**
 * 오픈API - 병해충예측지도 초기화
 */
function actionMapInfo( div_id, dbyhsMdlCode, foreTime ) {
	
	
	var mapDefaultTag = makeMapDefaultTag();
	
	npmsJ('#'+div_id).html(mapDefaultTag);

	var data = "";
	data += "apiKey="+getNpmsOpenApiKey();
	data += "&serviceCode="+getNpmsOpenApiServiceCode();
	//data += "&dbyhsMdlCode="+dbyhsMdlCode;
	//data += "&foreTime="+foreTime;

	npmsJ.ajax({
		type: "get"
		, dataType: "xml"
		, url: getNpmsOpenApiProxyUrl()
		, data: data
		, success: function(xml){
			success_getMapInfo( xml );
		}
		, error: function(xhr, status, error) {
			error_getMapInfo(xhr, status, error);
		}
	});	
}


/**
 * OpenAPI 결과 표출 div 태그 
 * 		npms_api_desc : 지도 검색 폼
 * 		npms_api_map : 지도
 * 		npms_api_risk_desc : 병해충 예측 위험수준
 */
function makeMapDefaultTag() {
	var tag = '\
		<div id="npms_api_desc"></div> \
		<div id="npms_api_map" style="width:'+NpmsOpenAPIWidth+'px; height:' +NpmsOpenAPIWidth +'px;"></div> \
		<div id="npms_api_risk_desc"></div> \
	\
	';
	return tag;
}

/**
 * OpenAPI ajax 처리 후 에러발생시 에러 메시지 표출
 */
function error_getMapInfo(xhr, status, error) {
    alert(error);
}

/**
 * 도움말 창
 */
function openHelp() {
	var url = "http://ncpms.rda.go.kr/npmsAPI/api/openapiForeMapHelp.jsp";
	window.open(url, "ncpms_api_map_help", "toolbar=no, scrollbars=yes, resizable=no, width=630, height=500");
}

/**
 * OpenAPI ajax 처리 후 성공시 작업
 */
function success_getMapInfo( xml ) {
	var errorMsg      = npmsJ(xml).find("errorMsg").text();
    
    //var dbyhsMdlCode  = npmsJ(xml).find("dbyhsMdlCode").text();
    //var dbyhsMdlNm    = npmsJ(xml).find("dbyhsMdlNm").text();  
    //var fieldCode     = npmsJ(xml).find("fieldCode").text();   
    //var fieldNm       = npmsJ(xml).find("fieldNm").text();     
    //var drveBeginMon  = npmsJ(xml).find("drveBeginMon").text();
    //var drveBeginDe   = npmsJ(xml).find("drveBeginDe").text(); 
    //var drveEndMon    = npmsJ(xml).find("drveEndMon").text();  
    //var drveEndDe     = npmsJ(xml).find("drveEndDe").text();   
    //var drveCycle     = npmsJ(xml).find("drveCycle").text(); 
    //var nowDrveDatetm = npmsJ(xml).find("nowDrveDatetm").text(); 
    //var todayStr      = npmsJ(xml).find("todayStr").text(); 
    //var beginstr      = npmsJ(xml).find("beginstr").text(); 
    //var endStr        = npmsJ(xml).find("endStr").text(); 
    //var foremode        = npmsJ(xml).find("foremode").text(); 
    var dbyhsMdlNm = "가나다라";
    var foremode = "ing";
    
    //alert("todayStr:"+todayStr+" , beginstr:"+beginstr+"   endStr:"+endStr+"      foremode:"+foremode);
            
    //var yyyy = nowDrveDatetm.substring(0,4);
    //var mm   = nowDrveDatetm.substring(4,6);
    //var dd   = nowDrveDatetm.substring(6,8);
    //var hh   = nowDrveDatetm.substring(8,10);
    
    //var yyyy = todayStr.substring(0,4);
    //var mm   = todayStr.substring(4,6);
    //var dd   = todayStr.substring(6,8);
    //var hh   = "00";
    
    
	if( "" != errorMsg ) {
		alert(errorMsg);
	} else {
		var today = new Date();
	    var yyyy = today.getFullYear();
	    var mm   = today.getMonth() + 1;
	    var dd   = today.getDate();
	    if(mm < 10) mm = "0" + mm;
		if(dd < 10) dd = "0" + dd;
	    var NpmsForeDateVal = yyyy +"-"+ mm +"-"+ dd;
	    
		//var defaultKncrCode = "";
		// 작목 리스트를 select 박스르 만듬
		//var knckIdx = 0;
		var kncrSelect = '<select class="custom-select" name="kncrCode" onchange="javascript:changeKncrCode();" style="font-size: xx-large;">';
		
		if( cropList.length > 0 ) {
			for( var i = 0; i < cropList.length; i++ ) {
				npmsJ(xml).find("kncrListData item").each(function(){
			        var kncrCode = npmsJ(this).find("kncrCode").text();
			        if( cropList[ i ] == kncrCode ) {
			        	var kncrNm = npmsJ(this).find("kncrNm").text();
				        kncrNm = unescape(decodeURIComponent(kncrNm));
				        kncrSelect += '<option value="'+kncrCode+'">'+kncrNm+'</option>';
			        }
			        //if( knckIdx == 0 ) defaultKncrCode = kncrCode;
			    });
			}
		} else {
			npmsJ(xml).find("kncrListData item").each(function(){
		        var kncrCode = npmsJ(this).find("kncrCode").text();
		        var kncrNm = npmsJ(this).find("kncrNm").text();
		        kncrNm = unescape(decodeURIComponent(kncrNm));
		        kncrSelect += '<option value="'+kncrCode+'">'+kncrNm+'</option>';
		        //if( knckIdx == 0 ) defaultKncrCode = kncrCode;
		    });
		}
	    kncrSelect += '</select>';
	    
	    
	    var kncrPesdIdx = 0;
		npmsJ(xml).find("pestModelByKncrList item").each(function(){
			var kncrCode               = npmsJ(this).find("kncrCode").text();
			var kncrNm                 = npmsJ(this).find("kncrNm").text();
			var dbyhsMdlCode           = npmsJ(this).find("dbyhsMdlCode").text();
			var dbyhsMdlNm             = npmsJ(this).find("dbyhsMdlNm").text();
			var predictResultValidDyag = npmsJ(this).find("predictResultValidDyag").text();
			var fieldNo                = npmsJ(this).find("fieldNo").text();
			var fieldCode              = npmsJ(this).find("fieldCode").text();
			var drveCycle              = npmsJ(this).find("drveCycle").text();
			var nowDrveDatetm          = npmsJ(this).find("nowDrveDatetm").text();
			var drveBeginMon           = npmsJ(this).find("drveBeginMon").text();
			var drveBeginDe            = npmsJ(this).find("drveBeginDe").text();
			var drveEndMon             = npmsJ(this).find("drveEndMon").text();
			var drveEndDe              = npmsJ(this).find("drveEndDe").text();
			var useeAt                 = npmsJ(this).find("useeAt").text();
			var pestConfigStr          = npmsJ(this).find("pestConfigStr").text();
			
			kncrNm = unescape(decodeURIComponent(kncrNm));
			dbyhsMdlNm = unescape(decodeURIComponent(dbyhsMdlNm));
			pestConfigStr = unescape(decodeURIComponent(pestConfigStr));
			
			fieldCode = trim(fieldCode);
			
			var values = {
				kncrCode               : kncrCode              
				,kncrNm                 : kncrNm                
				,dbyhsMdlCode           : dbyhsMdlCode          
				,dbyhsMdlNm             : dbyhsMdlNm            
				,predictResultValidDyag : predictResultValidDyag
				,fieldNo                : fieldNo               
				,fieldCode              : fieldCode             
				,drveCycle              : drveCycle             
				,nowDrveDatetm          : nowDrveDatetm         
				,drveBeginMon           : drveBeginMon          
				,drveBeginDe            : drveBeginDe           
				,drveEndMon             : drveEndMon            
				,drveEndDe              : drveEndDe             
				,useeAt                 : useeAt                
				,pestConfigStr          : pestConfigStr         
			};
			
			kncrPestList[ kncrPesdIdx ] = new kncrPestClass( values );
			kncrPesdIdx++;
		});
		
		

	    var npms_api_desc = ` \
			<div id="NPMS" style="width:${NpmsOpenAPIWidth}px;"> \
					<div class="d-flex justify-content-between">\
						<div>
						<div id="cropPest" class="h1" align="center" style="font-weight: bold; vertical-align: middle;">감귤,감귤궤양병</div>
						</div>
						<img src="http://ncpms.rda.go.kr/images/api/fore/icon_help_api.gif" style="width:${NpmsOpenAPIWidth*0.2}px; height:${NpmsOpenAPIWidth*0.07}px; border:0px; margin:10px; right: 20px; cursor:pointer;" onclick="javascript:openHelp();" /> \
					</div>\
				<div class="tabelRound"> \
					<table id="oMenuInsertTable" class="grid topLine" border="1" cellSpacing="0" cellPadding="0" name="menuInsertTable"> \
						<colgroup> \
							<col width="50%"/> \
							<col width="50%"/> \
							<col width="50%"/> \
							<col width="50%"/> \
						</colgroup> \
						<tbody> \
						<tr class="d-flex"> \
							<td class="mx-auto">
								<div class="card" style="width: 30rem;">
									<div class="card-body">
										<h5 class="card-title h1" align="center"><strong>작목</strong></h5>
										<div class="card-text">
											${kncrSelect}
										</div>
									</div>
								</div>
							</td> \
							<td class="d-flex mx-auto">
								<div class="card" style="width: 30rem;">
									<div class="card-body">
										<h5 class="card-title h1" align="center"><strong>조회 가능 기간</strong></h5>										
										<div id="info_period_div" class="card-text h1"></div>
									</div>
								</div>
							</td> \
						</tr> \
						<tr class="d-flex"> \
							<td class="d-flex mx-auto">
								<div class="card" style="width: 30rem;">
									<div class="card-body">
										<h5 class="card-title h1" align="center"><strong>병해충명</strong></h5>	
										<div id="dbyhsMdlCode_div" class="card-text"></div>
									</div>
								</div>
							</td> \
							<td class="d-flex mx-auto"> \
								<div class="card" style="width: 30rem;">
									<div class="card-body pa-0">
										<h5 class="card-title h1" align="center"><strong>조회 기간 선택</strong></h5>	
										<div class="card-text">											
											<input type="date" name="NpmsForeDate" value="${NpmsForeDateVal}" style="font-size: xx-large;" onchange="javascript:viewNpmsMap();"> \
											<span id="foreHour" class="h1"></span> 
										</div>
									</div>
								</div>
								<div>

								</div>
							</td> \
						</tr> \
						</tbody> \
					</table> \
				</div> \
			</div> \
		`;
		
		npmsJ('#npms_api_desc').html(npms_api_desc);

		// 지도 초기화
	    if(NpmsAddress =="") {
			initMap();
	    } else {
	    	initAddressMap();
	    }
	    
	    //var npms_map = new NpmsForeMap(fieldCode, dbyhsMdlNm, drveCycle, yyyy, mm, dd, hh, foremode);
	    //npms_map.viewMap();
	    
	    
	}
}

/**
 * trim 함수
 */
function trim(str) {
	return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}

/**
 * 작물별 병해충 정보 객체
 */
function kncrPestClass( values ) {
	var kncrCode                = values.kncrCode              ;
	var kncrNm                  = values.kncrNm                ;
	var dbyhsMdlCode            = values.dbyhsMdlCode          ;
	var dbyhsMdlNm              = values.dbyhsMdlNm            ;
	var predictResultValidDyag  = values.predictResultValidDyag;
	var fieldNo                 = values.fieldNo               ;
	var fieldCode               = values.fieldCode             ;
	var drveCycle               = values.drveCycle             ;
	var nowDrveDatetm           = values.nowDrveDatetm         ;
	var drveBeginMon            = values.drveBeginMon          ;
	var drveBeginDe             = values.drveBeginDe           ;
	var drveEndMon              = values.drveEndMon            ;
	var drveEndDe               = values.drveEndDe             ;
	var useeAt                  = values.useeAt                ;
	var pestConfigStr           = values.pestConfigStr         ;
	
	this.getKncrCode               = function () { return kncrCode              ; }
	this.getKncrNm                 = function () { return kncrNm                ; }
	this.getDbyhsMdlCode           = function () { return dbyhsMdlCode          ; }
	this.getDbyhsMdlNm             = function () { return dbyhsMdlNm            ; }
	this.getPredictResultValidDyag = function () { return predictResultValidDyag; }
	this.getFieldNo                = function () { return fieldNo               ; }
	this.getFieldCode              = function () { return fieldCode             ; }
	this.getDrveCycle              = function () { return drveCycle             ; }
	this.getNowDrveDatetm          = function () { return nowDrveDatetm         ; }
	this.getDrveBeginMon           = function () { return drveBeginMon          ; }
	this.getDrveBeginDe            = function () { return drveBeginDe           ; }
	this.getDrveEndMon             = function () { return drveEndMon            ; }
	this.getDrveEndDe              = function () { return drveEndDe             ; }
	this.getUseeAt                 = function () { return useeAt                ; }
	this.getPestConfigStr          = function () { return pestConfigStr         ; }
}

/**
 * 작목 select 박스 변경시 처리작업
 */
function changeKncrCode(){
	var kncrCode = npmsJ('select[name=kncrCode]').val();
	var dbyhsMdlSelectTag = `<select class="custom-select" name="dbyhsMdlcode" onchange="javascript:changeDbyhsMdlcode();" style="font-size: xx-large;">`;
	
	for(var i = 0; i < kncrPestList.length; i++) {
		if( kncrCode == kncrPestList[i].getKncrCode() ) {
			dbyhsMdlSelectTag += '<option value="'+kncrPestList[i].getDbyhsMdlCode()+'">'+kncrPestList[i].getDbyhsMdlNm()+'</option>';
		}
	}
	dbyhsMdlSelectTag += '</select>';
	npmsJ('#dbyhsMdlCode_div').html('');
	npmsJ('#dbyhsMdlCode_div').html(dbyhsMdlSelectTag);
	
	changeDbyhsMdlcode();
	
	npmsJ('select[name=kncrCode]').blur();
}

/**
 * 병해충명 select 박스 변경시 처리작업
 */
function changeDbyhsMdlcode() {
	var kncrCode = npmsJ('select[name=kncrCode]').val();
	var dbyhsMdlcode = npmsJ('select[name=dbyhsMdlcode]').val();
	// npms_api_risk_desc	위험수준설명
	// npms_api_map			예측지도

	for(var i = 0; i < kncrPestList.length; i++) {
		if( kncrCode == kncrPestList[i].getKncrCode() && dbyhsMdlcode == kncrPestList[i].getDbyhsMdlCode() ) {
			var info_period_div_str = kncrPestList[i].getDrveBeginMon()+"\uC6D4 "+kncrPestList[i].getDrveBeginDe()+"\uC77C ~ ";
			info_period_div_str += kncrPestList[i].getDrveEndMon()+"\uC6D4 "+kncrPestList[i].getDrveEndDe()+"\uC77C";
			npmsJ('#info_period_div').html('');
			npmsJ('#info_period_div').html(info_period_div_str);

			cropName = kncrPestList[i].getKncrNm();
			pestName = kncrPestList[i].getDbyhsMdlNm();

			npmsJ('#cropPest').html('');
			npmsJ('#cropPest').html(`${cropName},${pestName}`);

			var pestConfigstr = kncrPestList[i].getPestConfigStr();
			var pestConfigList = pestConfigstr.split("|");
			var descTag = '';
			descTag += '			<div id="NPMS" style="width:'+NpmsOpenAPIWidth+'px;> ';
			descTag += '				<div class="tabelRound"> ';
			descTag += '					<table id="oMenuInsertTable" class="grid topLine" border="1" cellSpacing="0" cellPadding="0" name="menuInsertTable"> ';
			descTag += '						<colgroup> ';
			descTag += '							<col width="33%"/> ';
			descTag += '							<col width="66%"/> ';
			descTag += '						</colgroup> ';
			descTag += '						<tbody> ';
			descTag += '						<tr> ';
			descTag += '							<th class="bgbr"><p class="h1">위험수준</p></th> ';
			descTag += '							<th class="bgbr"><p class="h1">설명</p></th> ';
			descTag += '						</tr> ';
			
			for( var x = 0; x < pestConfigList.length; x++ ) {
				var pestConfig = pestConfigList[ x ].split("!+@+!");
				var riskLevelNm = pestConfig[0];
				var riskDesc = pestConfig[1];
				var colorValue = pestConfig[2];
				if( '' != riskLevelNm ) {
					descTag += '		<tr> ';
					descTag += '			<td align="center" style="text-align:center;background-color:#'+colorValue+';opacity:0.8;filter:alpha(opacity=80);" ><span style="color:#FFFFFF;"><strong class="h2" style="font-weight: bold;">'+riskLevelNm+'</strong></span></td> ';
					descTag += '			<td class="h2">'+riskDesc+'</td> ';
					descTag += '		</tr> ';					
				}
			}

			descTag += '						</tbody> ';
			descTag += '					</table> ';
			descTag += '				</div> ';
			descTag += '			</div> ';
			//alert(descTag);
			npmsJ('#npms_api_risk_desc').html('');
			npmsJ('#npms_api_risk_desc').html(descTag);
			
			
			// var drveCycle = kncrPestList[i].getDrveCycle();
			// console.log(drveCycle)
			// npmsJ('#foreHour').html('');
			
			// if("0" == drveCycle) {
			// 	var hourTag = getHourTag() + "시";
			// 	npmsJ('#foreHour').html(hourTag);
			// }

			break;
		}
	}
	
	npmsJ('select[name=dbyhsMdlcode]').blur();
	
	
	viewNpmsMap();
}

/**
 * 0시 ~ 23시까지 시간 태그를 만
 */
function getHourTag() {
	var tag = '<select name="NpmsHH" onclick="javascript:viewNpmsMap();">';
	for( var i = 0; i < 24; i++ ) {
		if( i < 10 ) {
			tag += '<option value=0'+i+'>0'+i+'</option>';
		} else {
			tag += '<option value='+i+'>'+i+'</option>';
		}
	}
	tag += '</select>';
	return tag;
}

/**
 * 속성지도를 보여줌
 */
function viewNpmsMap() {
	console.log('viewNpm')
	var kncrCode = npmsJ('select[name=kncrCode]').val();
	var dbyhsMdlcode = npmsJ('select[name=dbyhsMdlcode]').val();
	var NpmsForeDate = npmsJ('input[name=NpmsForeDate]').val();
	
	var yyyy = NpmsForeDate.substring(0,4);
	var MM = NpmsForeDate.substring(5,7);
	var dd = NpmsForeDate.substring(8,10);
	var HH = "07";
	
				
	for(var i = 0; i < kncrPestList.length; i++) {
		if( kncrCode == kncrPestList[i].getKncrCode() && dbyhsMdlcode == kncrPestList[i].getDbyhsMdlCode() ) {
			var nowDrveDatetm = kncrPestList[i].getNowDrveDatetm();
			var drveBeginMon = kncrPestList[i].getDrveBeginMon();
			var drveBeginDe = kncrPestList[i].getDrveBeginDe();
			var drveEndMon = kncrPestList[i].getDrveEndMon();
			var drveEndDe = kncrPestList[i].getDrveEndDe();
			
			var pCode = kncrPestList[i].getFieldCode();
			var pName = kncrPestList[i].getDbyhsMdlNm();
			var drveCycle = kncrPestList[i].getDrveCycle();
			// if("0" == drveCycle) {
			// 	HH = npmsJ('select[name=NpmsHH]').val();
			// }
			var ret = checkVaildDate(yyyy, MM, dd, nowDrveDatetm, drveBeginMon, drveBeginDe, drveEndMon, drveEndDe);
			console.log(yyyy,MM,dd)
			console.log(ret)
			if(ret == "ok") {
				
				viewPropertiesMap( pCode, pName, drveCycle, yyyy, MM, dd, HH );
			} else {
				if( isFirstLoad ) {
					isFirstLoad = false;
				} else {
					removePropertiesMap();
					if(ret == "before") {
						alert("\uC815\uBCF4\uC81C\uACF5\uAE30\uAC04 \uC774\uC804\uC785\uB2C8\uB2E4.");
					} else if(ret == "after") {
						alert("\uC815\uBCF4\uC81C\uACF5\uAE30\uAC04\uC774 \uC9C0\uB0AC\uC2B5\uB2C8\uB2E4.");
					} else if(ret == "notYet") {
						alert("해당 날짜에는 병해충 모델이 구현되지 않았습니다..");
					}
				}
				
			}
			
			break;
		}
	}
	
}

/**
 * 선택된 날짜에 속성지도가 존재하는지 체크
 */
function checkVaildDate(yyyy, MM, dd, nowDrveDatetm, drveBeginMon, drveBeginDe, drveEndMon, drveEndDe) {
	var ret = "";
	
	var beginMon = (drveBeginMon < 10) ? "0"+drveBeginMon : drveBeginMon;
	var beginDe = (drveBeginDe < 10) ? "0"+drveBeginDe : drveBeginDe;
	var endMon = (drveEndMon < 10) ? "0"+drveEndMon : drveEndMon;
	var endDe = (drveEndDe < 10) ? "0"+drveEndDe : drveEndDe;
	
	var today = yyyy + MM + dd;
	var lastRunDay = nowDrveDatetm.substring(0,8);
	var beginDay = yyyy + beginMon + beginDe;
	var endDay = yyyy + endMon + endDe;
	
	if( today < beginDay ) {
		ret = "before";
	} else if( endDay < today ) {
		ret = "after";
	} else if( lastRunDay < today ) {
		ret = "notYet";
	} else {
		ret = "ok";
	}
	
	//alert("today : "+today+"\n lastRunDay : "+lastRunDay+"\n beginDay : "+beginDay+"\n endDay : "+endDay+"\n"+ret);
	
	return ret;
}

/**
 * 주소로 맵 초기화
 */
function initAddressMap(){
	geocoder = new google.maps.Geocoder();
	
	var address = decodeURIComponent(NpmsAddress);
	
	if (geocoder) {
		geocoder.geocode( { 'address': address}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				var lat = results[0].geometry.location.lat();
				var lon = results[0].geometry.location.lng();
				
				var EPSG900913 = new Proj4js.Proj('EPSG:900913');
				var EPSG4326 = new Proj4js.Proj('EPSG:4326');
				var point900913 = new Proj4js.Point(lon , lat);   //any object will do as long as it has 'x' and 'y' properties
				Proj4js.transform(EPSG4326, EPSG900913, point900913);      //do the transformation.  x and y are modified in place
				
				tm_center_x = point900913.x;
				tm_center_y = point900913.y;
			} else {
				//alert("Geocode was not successful for the following reason: " + status);				
				//alert(address + " \uC8FC\uC18C\uB97C \uCC3E\uC744\20\uC218 \uC5C6\uC2B5\uB2C8\uB2E4.");
				
				console.log("status= " + status);
				console.log("google.maps.GeocoderStatus.OK= " + google.maps.GeocoderStatus.OK);
				console.log(address + " \uC8FC\uC18C\uB97C \uCC3E\uC744\20\uC218 \uC5C6\uC2B5\uB2C8\uB2E4.");
			}
			initMap();
		});
	}
}

/**
 * 맵 초기화
 */
function initMap(){
	var npms_map_options = {
			theme: null,
			controls: [],
			projection: new OpenLayers.Projection("EPSG:900913"),
			displayProjection: new OpenLayers.Projection("EPSG:4326"),
			units: "m",
			controls : [],
			numZoomLevels:21,
			maxResolution: 156543.0339,
			maxExtent: new OpenLayers.Bounds(-20037508.34, -20037508.34, 20037508.34, 20037508.34)
	};
	NpmsMap = new OpenLayers.Map('npms_api_map', npms_map_options);
	
	// 배경지도 추가하기
    var vSAT = new vworld.Layers.Satellite('VSAT');
    if (vSAT != null) {NpmsMap.addLayer(vSAT);};
    // 하이브리드지도 추가하기
    var vHybrid = new vworld.Layers.Hybrid('VHYBRID');
    if (vHybrid != null) {NpmsMap.addLayer(vHybrid);}
    
    NpmsMap.setCenter(new OpenLayers.LonLat(tm_center_x, tm_center_y), default_zoom_level);
    
    
    NpmsMap.addControl(new OpenLayers.Control.Navigation());
    if( true == isMoveMap ) {
    	NpmsMap.getNumZoomLevels = function(){
    		// alert(default_zoom_level);
    		return default_zoom_level - 1;
    	};
    } else {
    	NpmsMap.addControl(new OpenLayers.Control.PanZoomBar());
    }
    
    
    
    NpmsMap.div.oncontextmenu = function(){
        return false;
    };
    
    changeKncrCode();		// 병해충명 select 박스 초기화
}

/**
 * 속성지도를 삭제하고 새로운 속성지도를 올린다.
 */
function viewPropertiesMap( pCode, pName, drveCycle, yyyy, MM, dd, HH ) {
	removePropertiesMap();
	setPropertiesMap( pCode, pName, drveCycle, yyyy, MM, dd, HH );
    addPropertiesMap();
}

/**
 * 속성지도를 불러온다.
 */
function setPropertiesMap( pCode, pName, drveCycle, yyyy, MM, dd, HH ) {
	// 일별모형일 경우 시간을 00시 예측시간만 생성되어 있다.
	if( drveCycle == "1" ) HH = "00";

    var map_url = "http://ncpms.rda.go.kr/cgi-bin/mapserv?pngpath="+pCode+"/"+yyyy+"/"+MM+"/"+yyyy+MM+dd+HH+"/"+pCode+"_"+yyyy+MM+dd+HH+".png";
    
	var map_file = '/usr/tmax/mapserver/npms_map_2011.map';

    propertiesMap = null;
    propertiesMap = new OpenLayers.Layer.WMS( 
        pName, 
        map_url,
        { map: map_file,transparent: 'true',layers: 'world' },
        {isBaseLayer: false,opacity: 0.3}
    );
}

/**
 * 속성지도를 지도에 뿌려준다.
 */
function addPropertiesMap() {
    if( null != propertiesMap ) {
        NpmsMap.addLayer(propertiesMap);
    }
}

function removePropertiesMap() {
    if( null != propertiesMap ) {
        NpmsMap.removeLayer(propertiesMap);
        propertiesMap = null;
    }
}
