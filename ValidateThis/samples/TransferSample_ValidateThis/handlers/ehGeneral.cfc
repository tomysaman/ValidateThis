<!--------------------------------------------------------------------
Generated Application: TransferSample
Generated Date: March 19 2007
Generated By: ColdBox Ant Task.
---------------------------------------------------------------------->
<!-----------------------------------------------------------------------
Template : ehGeneral.cfc
Author 	 : Luis Majano
Date     : 3/19/2007 3:28:35 PM
Description :
	This is the main handler for the Transfer sample

Modification History:
3/19/2007 - Created Template
----------------------------------------------------------------------><cfcomponent name="ehGeneral" extends="coldbox.system.eventhandler" output="false">	<cffunction name="onAppInit" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- ON Application Start Here --->
		<!--- Transfer Loaded by Interceptor --->
	</cffunction>	<cffunction name="onRequestStart" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.beans.requestContext">		<!--- On Request Start Code Here --->
		<cfset var rc = event.getCollection()>
		<!--- Set a title for my App--->
		<cfset rc.title = "Coldbox Transfer Sample Application - with ValidateThis">
	</cffunction></cfcomponent>