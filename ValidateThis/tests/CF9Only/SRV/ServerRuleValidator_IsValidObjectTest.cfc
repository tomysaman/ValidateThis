<!---
	
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent extends="validatethis.tests.SRV.BaseForServerRuleValidatorTests" output="false">
	
	<cffunction name="beforeTests" access="public" returntype="void">
		<cfscript>
			setupValidUserFixture();
			setupInvalidUserFixture();
			setupValidCompanyFixture();
			setupInvalidCompanyFixture();
			setupNoruleCompanyFixture();
		</cfscript>
	</cffunction>

	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			super.setup();
			SRV = getSRV("IsValidObject");
			needsFacade = true;
			
			// Define Validation Mock Test Values
			parameters={};
			context="*";
			objectValue = {};
			isRequired = true;
			theObjectType="";
			hasObjectType=false;
			
		</cfscript>
	</cffunction>
	
	<cffunction name="configureValidationMock" access="private">
		<cfscript>
			super.configureValidationMock();
			validation.getParameterValue("context","*").returns(context);
			validation.getParameterValue("context").returns(context);
			validation.getParameterValue("objectType").returns(theObjectType);
			validation.hasParameter("objectType").returns(hasObjectType);			
			validation.getParameterValue("objectType","#theObjectType#").returns(theObjectType);
		</cfscript>
	</cffunction>
	
	<cffunction name="setupValidCompanyFixture" access="private">
		<cfscript>
			validCompany = createObject("component","validatethis.tests.Fixture.models.cf9.vtml.Company");
			validCompany.setCompanyName("Adam Drew");
		</cfscript>
	</cffunction>

	<cffunction name="setupInvalidCompanyFixture" access="private">
		<cfscript>
			invalidCompany = createObject("component","validatethis.tests.Fixture.models.cf9.vtml.Company");
			invalidCompany.setCompanyName("A");
		</cfscript>
	</cffunction>

	<cffunction name="setupNoruleCompanyFixture" access="private">
		<cfscript>
			noruleCompany = createObject("component","validatethis.tests.Fixture.models.cf9.norules.Company");
			noruleCompany.setCompanyName("A");
		</cfscript>
	</cffunction>
	
	<cffunction name="setupValidUserFixture" access="private">
		<cfscript>
			validUser = createObject("component","validatethis.tests.Fixture.models.cf9.json.User").init();
			validUser.setUserName("epner81@gmail.com");
		</cfscript>
	</cffunction>
	
	<cffunction name="setupInvalidUserFixture" access="private">
		<cfscript>
			invalidUser = createObject("component","validatethis.tests.Fixture.models.cf9.json.User").init();
			invalidUser.setUserName("");
		</cfscript>
	</cffunction>
	
	<!--- not sure what this test is for
	<cffunction name="validateTestIsReliableWithNoFalsePositives" access="public" returntype="void">
		<cfscript>
			objectValue = {}; // I know an empty struct should fail here. but does it?	
			isRequired=true;

			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	--->
	
	<cffunction name="validateReturnsFalseForNonJSONSimpleValue" access="public" returntype="void">
		<cfscript>
			objectValue = "This is not JSON!";
			failureMessage = "The validation failed because a valid object cannot be a simple value.";	
			
			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
			validation.verifyTimes(1).setFailureMessage(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyStruct" access="public" returntype="void">
		<cfscript>
			objectValue = {};
			failureMessage = "The validation failed because a valid structure cannot be empty.";	
			
			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
			validation.verifyTimes(1).setFailureMessage(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyArray" access="public" returntype="void">
		<cfscript>
			objectValue = [];	
			failureMessage = "The validation failed because a valid array cannot be empty.";	
			
			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
			validation.verifyTimes(1).setFailureMessage(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForTwoInvalidObjectsOfOneObjectTypeInAnArray" access="public" returntype="void">
		<cfscript>			
			invalidCompany2  = duplicate(invalidCompany);
			objectValue = [invalidCompany,invalidCompany2];	
			failureMessage = "The PropertyDesc is invalid: The Company Name must be between 2 and 10 characters long.";	

			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(arrayLen(objectValue)).setIsSuccess(false); 
			debug(validation.debugMock());
			validation.verifyTimes(1).setFailureMessage(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForOneInvalidObjectOfOneObjectTypeInAnArrayOfTwoObjects" access="public" returntype="void">
		<cfscript>			
			objectValue = [validCompany,invalidCompany];	
			failureMessage = "The PropertyDesc is invalid: The Company Name must be between 2 and 10 characters long.";	

			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false);
			validation.verifyTimes(1).setFailureMessage(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidArrayOfOneObjectType" access="public" returntype="void">
		<cfscript>			
			validCompany2 = duplicate(validCompany);
			objectValue = [validCompany,validCompany2];	

			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidArrayMixedObjectTypes" access="public" returntype="void">
		<cfscript>			
			validCompany2 = duplicate(validCompany);
			validUser2 = duplicate(validUser);
			
			objectValue = [validCompany,validUser,validCompany2,validUser2];	

			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
			
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidArrayMixedObjectTypes" access="public" returntype="void">
		<cfscript>			
			invalidCompany2 = duplicate(invalidCompany);
			invalidUser2 = duplicate(invalidUser);
			
			objectValue = [invalidCompany,invalidUser,invalidCompany2,invalidUser2];	

			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(arrayLen(objectValue)).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForValidObjectWithNoValidationParameters" access="public" returntype="void">
		<cfscript>
			objectValue = validCompany;
			
			parameters={};
			
			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsTrueForObjectWithNoRules" access="public" returntype="void">
		<cfscript>
			objectValue = noruleCompany;
			
			parameters={};
			
			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsTrueForValidObjectWithVTML" access="public" returntype="void">
		<cfscript>
			objectValue = validCompany;
			
			parameters={};
			
			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsFalseForInvalidObjectWithVTML" access="public" returntype="void">
		<cfscript>
			objectValue = invalidCompany;
			
			parameters={};
			
			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsTrueForValidObjectWithJSON" access="public" returntype="void">
		<cfscript>
			objectValue = validUser;
			
			parameters={};
			
			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsFalseForInvalidObjectWithJSON" access="public" returntype="void">
		<cfscript>
			objectValue = invalidUser;
			
			parameters={};
			
			configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
</cfcomponent>
