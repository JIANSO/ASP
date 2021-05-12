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
            Ȥ�� �ּ� ����� �߸� ������ ��쿡�� ���⿡ �������ּ���.
        </a>
    </em>
</p>
<div id="map" style="width:100%;height:350px;"></div>
<p><input type="button" onclick="insertDate();" />
<div id="textDiv"></div>
</body>
<script type="text/javascript">

var mapContainer = document.getElementById('map'), // ������ ǥ���� div 
    mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // ������ �߽���ǥ
        level: 3 // ������ Ȯ�� ����
    };  

// ������ �����մϴ�    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// �ּ�-��ǥ ��ȯ ��ü�� �����մϴ�
var geocoder = new kakao.maps.services.Geocoder();

var addr = [
/*
sample

{mapseq: 4, mapaddr:'���������� ������ ������ 110-2 4�� �ɷ��ִϾ�����п�', mapinfo:'' },
	{mapseq: 6, mapaddr:'��� �Ⱦ�� ���ȱ� ������1201���� 26���� ���Ϻ���3��', mapinfo:''},
	{mapseq: 8, mapaddr:'���� ����� ���5��	456-126 3�� �ִϾ', mapinfo:''},
	{mapseq: 14, mapaddr:'���� ���ϱ� �̾Ƶ� 838-62 2�� �ִϾ', mapinfo:''},
	{mapseq: 21, mapaddr:'���� ���ֽ� �ϻ걸 ��ȭ�굿2��	748-1���� 2�� �ִϾ', mapinfo:''},
	{mapseq: 26, mapaddr:'���� ������ â�� 27 �ְ�19���� �� 2�� 211ȣ', mapinfo:''},
	{mapseq: 27, mapaddr:'���� ������ ȭ��6��	1099-12���� 2��', mapinfo:''},
	{mapseq: 30, mapaddr:'��� ������ ��ȱ� õõ��	527-2 ���������� 303ȣ', mapinfo:''},
	{mapseq: 31, mapaddr:'���� �������� ����5��	74-1 3��', mapinfo:''}
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