<!-- #include virtual="/_lib/global/unicode.asp" -->
<!-- #include virtual="/_lib/global/func.asp" -->
<!-- #include virtual="/_lib/dsn/dsn.asp" -->
<!-- #include virtual="/_lib/global/ado.asp" -->
<!-- #include virtual="/inc/domain/domainfunc.asp" -->
<!-- #include virtual="/pages/nelab/aspJSON1.17.asp"-->
<%
	
	Dim json, query

	query = "exec usp_sja_select_nelab_map_info "


	
	'Response.write query
	
	
	
	Set rs = getrecordset(query, ne_lab)
	If rs.eof Or rs.bof Then
		rsGet = ""
	Else
		rsGet = rs.getrows
	End If
	rs.close
	Set rs = Nothing

		
		If IsArray(rsGet) Then
		
		rowCnt = ubound(rsGet, 2) '행
		colCnt = ubound(rsGet, 1) '열
			 json = json + "{ ""addr"" : ["
				 For i = 0 To rowCnt
					 json = json + "{"
				
						For j = 0 To colCnt
							If  Not isNull(rsGet(j, i)) Then 
								imsi = Replace(rsGet(j, i), chr(34) , "") '데이터에 들어있는 큰 따옴표 제거 
								imsi = Replace(imsi, chr(39) , "") '작은 따옴표 제거
							Else
								imsi = ""
							End If
							
							' DB에서 가져오는 항목 변경 시 이 부분도 수정되어야 합니다.
							If j = 0 Then
							 keyNm = "mapseq"
							ElseIf j = 1 Then
							 keyNm = "instituteName"
							ElseIf j = 2 Then
							 keyNm = "map"
							ElseIf j = 3 Then
							 keyNm = "mapaddr"
																					
							Else 
							 keyNm = "key" & j							
							End If
						
							 

							json = json + """" & keyNm & """ : """ & imsi & ""","
							
						Next
						json = Mid(json, 1, Len(json) -1)
					 json = json + "}, "
				 Next
				 json = Mid(json, 1, Len(json) -2)
			 json = json + "]}"

		 Else
			json = json + "{""addr"" : [] }"
		 End If


Response.write json



%>
