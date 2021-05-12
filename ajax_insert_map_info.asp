<!-- #include virtual="/_lib/global/unicode.asp" -->
<!-- #include virtual="/_lib/global/func.asp" -->
<!-- #include virtual="/_lib/dsn/dsn.asp" -->
<!-- #include virtual="/_lib/global/ado.asp" -->
<!-- #include virtual="/inc/domain/domainfunc.asp" -->
<!-- #include virtual="/pages/nelab/aspJSON1.17.asp"-->
<%
	Dim jsonstring, mapInfo
	jsonstring			= ckStr(R("mapobj"), 0)
	'mapInfo			= ckStr(R("mapInfo"), 0)

	Set oJSON = New aspJSON

	'Load JSON string
	oJSON.loadJSON(jsonstring)

	'ww oJSON.data("maps")
	'e
	'Get single value
	For Each map In oJSON.data("maps")
	   Set this = oJSON.data("maps").item(map)
	   'Response.Write _
	   ' this.item("mapSeq") & ": " & _
	   ' this.item("mapInfo") & "<br>"
		query = "exec usp_sja_update_nelab_map_info " & this.item("mapSeq")  & ", '"  & this.item("mapInfo") & "' " 
		ww query

		Set rs = getrecordset(query, ne_lab)		
		Set rs = Nothing
	Next

	
	


%>
