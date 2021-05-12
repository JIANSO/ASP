<!-- #include virtual="/_lib/global/unicode.asp" -->
<!-- #include virtual="/_lib/global/func.asp" -->
<!-- #include virtual="/_lib/dsn/dsn.asp" -->
<!-- #include virtual="/_lib/global/ado.asp" -->
<!-- #include virtual="/inc/domain/domainfunc.asp" -->

<!-- #include virtual="/inc/domain/globalheader.asp" -->
<!-- #include virtual="/inc/domain/domainheader.asp" -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bdc4bbbb45529e33d60012266c095d9c&libraries=services,clusterer,drawing"></script>

</script>
<style type="text/css">
.market_box{display:table !important;width:100%;height:100%;max-width:350px;}
.marker_cst{display:table-cell;width:100%;margin:0;padding:20px 10px;text-align:center;background:transparent;vertical-align:middle;box-sizing:border-box;}
.marker_cst p{margin-top:5px;font-size:12px;word-break:keep-all;line-height:16px;}
</style>
<body>
<p style="margin-top:-12px">
    <em class="link">
        <a href="javascript:void(0);" onclick="window.open('http://fiy.daum.net/fiy/map/CsGeneral.daum', '_blank', 'width=981, height=650')">
            혹시 주소 결과가 잘못 나오는 경우에는 여기에 제보해주세요.
        </a>
    </em>
</p>
<div id="map" style="width:100%;height:350px;"></div>
<p><input type="button" onclick="insertDate();" />
<div id="textDiv"></div>
</body>
<script type="text/javascript">

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

var addr = [
/*
sample

{mapseq: 4, mapaddr:'대전광역시 유성구 어은동 110-2 4층 능률주니어랩어은학원', mapinfo:'' },
	{mapseq: 6, mapaddr:'경기 안양시 만안구 경수대로1201번길 26번지 한일빌딩3층', mapinfo:''},
	{mapseq: 8, mapaddr:'서울 노원구 상계5동	456-126 3층 주니어랩', mapinfo:''},
	{mapseq: 14, mapaddr:'서울 강북구 미아동 838-62 2층 주니어랩', mapinfo:''},
	{mapseq: 21, mapaddr:'전북 전주시 완산구 중화산동2가	748-1번지 2층 주니어랩', mapinfo:''},
	{mapseq: 26, mapaddr:'서울 도봉구 창동 27 주공19단지 상가 2층 211호', mapinfo:''},
	{mapseq: 27, mapaddr:'서울 강서구 화곡6동	1099-12번지 2층', mapinfo:''},
	{mapseq: 30, mapaddr:'경기 수원시 장안구 천천동	527-2 수정프라자 303호', mapinfo:''},
	{mapseq: 31, mapaddr:'서울 영등포구 양평동5가	74-1 3층', mapinfo:''}
*/

];

var txt = '';
var mapdata = [ ];
var mapobj = {};
var mapSeqArr = [];

//
$(function(){
	
	selectAddr();
	

});

function selectAddr(){
	$.ajax({
		type : 'post'
		,data : {}		
		//,contentType: 'application/json; charset=utf-8'
        ,dataType: 'json'
		,url : 'ajax_select_map_info.asp'
		,success : function(e){
			addr = e;
			getAddress(0);
		}
		, error : function(e){
		
		}
	});
}

function getAddress(i){
	var dt = addr["addr"];

	geocoder.addressSearch(dt[i].mapaddr, function(result, status){
		
		 if (status === kakao.maps.services.Status.OK) {	
			mapobj = {mapseq : "", mapInfo : "" };
			
			txt = dt[i].mapseq + ',' + result[0].address_name + ' || ' + result[0].y  + ',' + result[0].x + '<br/>';
			//txt = result[0].address_name + ' || ' + result[0].y  + ',' + result[0].x + '<br/>';
		
			mapobj.mapSeq = dt[i].mapseq;
			mapobj.mapInfo = result[0].y  + ',' + result[0].x;

			mapdata.push(mapobj);

			$("#textDiv").append(txt);

			i++;

			if(i !== dt.length){
				getAddress(i)
			}else{
				insertData();
			}
					
		 }else if(status === kakao.maps.services.Status.ZERO_RESULT){
			i++;
			if(i !== dt.length){
				getAddress(i)
			}else{
				insertData();
			}
		 }	

		


	});   
	
}


function insertData(){
	

	$.ajax({
		type : 'post'
		//,data : "{ 'maps' :" + JSON.stringify(mapdata) + "}"
		,data : { 'mapobj' : "{ maps  :" + JSON.stringify(mapdata) + "}" }
		//,contentType: 'application/json; charset=utf-8'
        ,dataType: 'text'
		,url : 'ajax_insert_map_info.asp'
		,success : function(e){
			console.log(e);
		}
		, error : function(e){
		
		}
	});
}


</script>

</html>