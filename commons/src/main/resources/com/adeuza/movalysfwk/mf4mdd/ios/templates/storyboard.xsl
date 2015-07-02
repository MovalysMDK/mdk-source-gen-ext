<?xml version="1.0" encoding="UTF-8"  standalone="no"  ?>
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
<xsl:stylesheet 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- *************************************************
*****  
***** ENTRY POINT:
*****  	/storyboard
*****  
****************************************************** -->

<xsl:output method="xml" indent="yes"/>

 
<xsl:include href="ui/storyboard/scene.xsl"/>
<xsl:include href="ui/storyboard/view-controller.xsl"/>
<xsl:include href="ui/storyboard/formview-controller.xsl"/>
<xsl:include href="ui/storyboard/listview-controller.xsl"/>
<xsl:include href="ui/storyboard/list2Dview-controller.xsl"/>
<xsl:include href="ui/storyboard/workspace-controller.xsl"/>
<xsl:include href="ui/storyboard/multipanel-controller.xsl"/>

<xsl:include href="ui/storyboard/cells/cell-common.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mftextfield.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mftextview.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfsignature.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfnumberpicker.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfwebview.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfposition.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfphotothumbnail.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfsendmailtextfield.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfintegertextfield.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfdoubletextfield.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfbrowseurltextfield.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfcallphonenumber.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-fixedlistcomponent.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-pickerlistcomponent.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfsimplepickerlist.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfenumimage.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfdatepicker.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-fixedlistphotocomponent.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfslider.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfswitch.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-others.xsl"/>
<xsl:include href="ui/storyboard/cells/cell-mfscanner.xsl"/>
<xsl:include href="ui/storyboard/cells/custom-cells.xsl"/>


<xsl:include href="ui/storyboard/navigation-controller.xsl"/>
<xsl:include href="ui/subviews.xsl"/>

<xsl:include href="ui/storyboard/resources.xsl"/>


<xsl:template match="storyboard">
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="6250" systemVersion="13E28" targetRuntime="iOS.CocoaTouch" 
	propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES">
		<xsl:attribute name="initialViewController"><xsl:value-of select="mainController"/></xsl:attribute>
		<!--  xsl:attribute name="initialName"><xsl:value-of select="name"/></xsl:attribute -->
	    <dependencies>
			<!--   deployment defaultVersion="1536" identifier="iOS"/ -->
       		 <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="6244"/>
        	 <capability name="Constraints with non-1.0 multipliers" minToolsVersion="5.1"/>
        	 <capability name="Constraints to layout margins" minToolsVersion="6.0"/>
	    </dependencies>
	    <scenes>
	    	<xsl:apply-templates select="scenes/scene"/>
	    </scenes>
	    <resources>
	    	<xsl:apply-templates select="." mode="gen-resources"/>
	    </resources>
	    <!--   classes>
			<xsl:apply-templates select="." mode="gen-classes"/>
	    </classes-->
	    <simulatedMetricsContainer key="defaultSimulatedMetrics">
	        <simulatedStatusBarMetrics key="statusBar"/>
	        <simulatedOrientationMetrics key="orientation"/>
	        <simulatedScreenMetrics key="destination" type="retina4"/>
	    </simulatedMetricsContainer>
	</document>
</xsl:template>

</xsl:stylesheet>
