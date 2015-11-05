<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	
	
	
	<!-- ************** DEPRECIATED => NOT USED ***************** -->

		
		
<xsl:output method="xml"/>

<!-- Note before editing: maintain alphabetic order of className -->
<xsl:template match="storyboard[scenes/scene/controller/@controllerType='FORMVIEW']" mode="gen-classes">

	<!-- MFUrlTextField -->
	<xsl:if test="count(//subView[customClass='MFPosition']) > 0">
	<class className="MFUrlTextField" superclassName="MFRegularExpressionTextField">
		<source key="sourceIdentifier" type="project" relativePath="./Classes/MFUrlTextField.h"/>
	</class>
	</xsl:if>

	<!-- MFPhoneTextField -->
	<xsl:if test="count(//subView[customClass='MFPhoneTextField']) > 0">
	<class className="MFPhoneTextField" superclassName="MFRegularExpressionTextField">
		<source key="sourceIdentifier" type="project" relativePath="./Classes/MFPhoneTextField.h"/>
	</class>
	</xsl:if>
    
	<!-- MFCell1ComponentHorizontal -->
	<class className="MFCell1ComponentHorizontal" superclassName="MFCellAbstract">
		<source key="sourceIdentifier" type="project" relativePath="./Classes/MFCell1ComponentHorizontal.h"/>
		<relationships>
			<relationship kind="outlet" name="componentView" candidateClass="UIView"/>
			<relationship kind="outlet" name="label" candidateClass="MDKLabel"/>
		</relationships>
	</class>

	<!-- MFCellAbstract -->
	<class className="MFCellAbstract" superclassName="UITableViewCell">
		<source key="sourceIdentifier" type="project" relativePath="./Classes/MFCellAbstract.h"/>
	</class>
	
    <class className="MFCellComponentFixedList" superclassName="MFCellAbstract">
       <source key="sourceIdentifier" type="project" relativePath="./Classes/MFCellComponentFixedList.h"/>
       <relationships>
           <relationship kind="outlet" name="fixedList" candidateClass="MFFixedList"/>
           <relationship kind="outlet" name="label" candidateClass="MDKLabel"/>
       </relationships>
   </class>
   
   <class className="MFCellPhotoFixedList" superclassName="MFCellComponentFixedList">
       <source key="sourceIdentifier" type="project" relativePath="./Classes/MFCellPhotoFixedList.h"/>
       <relationships>
           <relationship kind="outlet" name="fixedList" candidateClass="MFFixedList"/>
           <relationship kind="outlet" name="label" candidateClass="MDKLabel"/>
       </relationships>
   </class>
   
   <class className="MFFixedList" superclassName="MFUIBaseComponent">
       <source key="sourceIdentifier" type="project" relativePath="./Classes/MFFixedList.h"/>
   </class>
   
       <class className="MFCellComponentPickerList" superclassName="MFCellAbstract">
       <source key="sourceIdentifier" type="project" relativePath="./Classes/MFCellComponentPickerList.h"/>
       <relationships>
           <relationship kind="outlet" name="pickerList" candidateClass="MFPickerList"/>
           <relationship kind="outlet" name="label" candidateClass="MDKLabel"/>
       </relationships>
   </class>
   
   <class className="MFPickerList" superclassName="MFUIBaseComponent">
       <source key="sourceIdentifier" type="project" relativePath="./Classes/MFFixedList.h"/>
   </class>
   
   <class className="MFFormBaseViewController" superclassName="MFViewController">
       <source key="sourceIdentifier" type="project" relativePath="./Classes/MFFormBaseViewController.h"/>
       <relationships>
           <relationship kind="outlet" name="tableView" candidateClass="UITableView"/>
       </relationships>
   </class>	
	
	<!-- MFFormViewController -->
	<xsl:if test="count(//controller[@controllerType='FORMVIEW']) > 0">
        <class className="MFFormViewController" superclassName="UITableViewController">
            <source key="sourceIdentifier" type="project" relativePath="./Classes/MFFormViewController.h"/>
        </class>
	</xsl:if>
	
	<!-- MFFormListViewController -->
	<xsl:if test="count(//controller[@controllerType='LISTVIEW']) > 0">
        <class className="MFFormListViewController" superclassName="UITableViewController">
            <source key="sourceIdentifier" type="project" relativePath="./Classes/MFFormListViewController"/>
        </class>
	</xsl:if>
    
    <!-- MDKLabel -->
	<class className="MDKLabel" superclassName="MFUIBaseComponent">
		<source key="sourceIdentifier" type="project" relativePath="MDKLabel"/>
		<!--  relationships>
            <relationship kind="outlet" name="delegate"/>
        </relationships -->
	</class>

 	<!-- MFPosition -->
	<xsl:if test="count(//subView[customClass='MFPosition']) > 0">
        <class className="MFPosition" superclassName="MFUIBaseComponent">
            <source key="sourceIdentifier" type="project" relativePath="./Classes/MFPosition.h"/>
            <!--   relationships>
                <relationship kind="outlet" name="delegate"/>
            </relationships -->
        </class>
	</xsl:if>
	
	<!-- MFPhotoThumbnail -->
	<xsl:if test="count(//subView[customClass='MFPhotoThumbnail']) > 0">
        <class className="MFPhotoThumbnail" superclassName="MFUIBaseComponent">
            <source key="sourceIdentifier" type="project" relativePath="./Classes/MFPhotoThumbnail.h"/>
            <!--  relationships>
                <relationship kind="outlet" name="delegate"/>
            </relationships -->
        </class>
	</xsl:if>

	<!-- MFRegularExpressionTextField -->
	<class className="MFRegularExpressionTextField" superclassName="MFUIBaseComponent">
		<source key="sourceIdentifier" type="project" relativePath="./Classes/MFRegularExpressionTextField.h"/>
	</class>

	<!-- MFTextField -->
	<xsl:if test="count(//subView[customClass='MFTextField']) > 0">
        <class className="MFTextField" superclassName="MFUIBaseComponent">
            <source key="sourceIdentifier" type="project" relativePath="./Classes/MFTextField.h"/>
            <!--  relationships>
                <relationship kind="outlet" name="delegate"/>
            </relationships -->
        </class>
	</xsl:if>
	
	<!-- MFUIBaseComponent -->
	<class className="MFUIBaseComponent" superclassName="UIControl">
		<source key="sourceIdentifier" type="project" relativePath="./Classes/MFUIBaseComponent.h"/>
	</class>
	
	<!-- NSLayoutConstraint 
	<class className="NSLayoutConstraint" superclassName="NSObject">
    	<source key="sourceIdentifier" type="project" relativePath="./Classes/NSLayoutConstraint.h"/>
    </class>
-->
</xsl:template>


<!-- Note before editing: maintain alphabetic order of className -->
<xsl:template match="storyboard[scenes/scene/controller/@controllerType='LISTVIEW']" mode="gen-classes">
</xsl:template>

<!-- Note before editing: maintain alphabetic order of className -->
<xsl:template match="storyboard[scenes/scene/controller/@controllerType='VIEW']" mode="gen-classes">
</xsl:template>

<!-- Note before editing: maintain alphabetic order of className -->
<xsl:template match="storyboard[scenes/scene/controller/@controllerType='NAVIGATION']" mode="gen-classes">
</xsl:template>

<!-- Note before editing: maintain alphabetic order of className -->
<xsl:template match="storyboard[scenes/scene/controller/@controllerType='FIXEDLISTVIEW']" mode="gen-classes">
</xsl:template>

</xsl:stylesheet>
