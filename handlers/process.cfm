<cfsetting showdebugoutput="false" requestTimeout="600">
<cfparam name="ideeventinfo"> 

<cfif not isXML(ideeventinfo)>
	<cfexit>
</cfif>

<cfset data = xmlParse(ideeventinfo)>
<cfset resource = data.event.ide.projectview.resource>

<cfset location = resource.xmlAttributes.path>
<cflog file="bolt" text="going to parse #location#">

<cfset qp = createObject("component", "qpscanner.cfcs.qpscanner")>
<cfset jre = createObject("component","qpscanner.cfcs.jre-utils").init()/>

<cfset qp.init(jre,location,"wddx",-1,true)>
<cfset res = qp.go()>

<cfscript>
function fixFormat(s) {
	s = trim(s);
	s = replace(s, chr(10), "<br>", "all");
	return s;
}
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response showresponse="true">
<ide>
<view id="queryparam" title="Query Param Scanner" />
<body> 
<![CDATA[ 
<h2>QueryParam Results</h2>
<p>
Total Directories: #res.info.totals.dirCount#<br/>
Total Files: #res.info.totals.fileCount#<br/>
Total Queries: #res.info.totals.queryCount#<br/>
Total Scan Time: #res.info.totals.time#ms<br/>
Total Alerts: #res.info.totals.alertCount#<br/>
</cfoutput>

<cfif res.data.recordCount>
	<table border="1" width="100%">
		<tr bgcolor="#f0f0f0">
			<th>File</th>
			<th>Query Name</th>
			<th>Lines</th>
			<th>SQL</th>
		</tr>
		<cfoutput query="res.data">
		<tr <cfif currentRow mod 2>bgcolor="yellow"</cfif>>
			<td>#filename#</td>
			<td>#queryname#</td>
			<td>#querystartline#-#queryendline#</td>
			<td>#fixFormat(querycode)#</td>
		</tr>
		</cfoutput>
	</table>
</cfif>
]]> 
</body>
</ide>
</response>