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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  extension-element-prefixes="xsi">

	

<!-- *************************************************
*****  
***** ENTRY POINT:
*****  	/storyboard/scenes/*scene/controller[@controllerType='LISTVIEW']/sections/*section/subViews/*subView[customClass='MFDatePicker']
*****  	or
*****  	/xib-container/components/*component[customClass='MFDatePicker']
*****  
****************************************************** -->

<xsl:template match="subView[customClass='MFDatePicker']|component[customClass='MFDatePicker']" mode="subview-runtimeAttributes-generation"  priority="1000">
		<xsl:comment>subView|component[customClass='MFDatePicker']" mode="subview-runtimeAttributes-generation"</xsl:comment>
	
</xsl:template>



<xsl:template match="subView[customClass='MFDatePicker']|component[customClass='MFDatePicker']" mode="subview-outlets-generation"  priority="1000">
	<xsl:comment>subView|component[customClass='MFDatePicker']" mode="subview-outlets-generation"</xsl:comment>
		<!--  xsl:if test="$controllerId!=''">
			<outlet property="delegate">
				<xsl:attribute name="id"><xsl:value-of select="@id"/>-<xsl:value-of select="customClass"/>-SOD</xsl:attribute>
				<xsl:attribute name="destination"><xsl:value-of select="$controllerId"/></xsl:attribute>
			</outlet>
		</xsl:if -->	
</xsl:template>






<!--
	
<xsl:template match="subView[customClass='MFDatePicker']" mode="constraintsForListItem">

	<xsl:param name="controllerId"/>
	<xsl:param name="viewId"/>
	<xsl:param name="posY"/>

		<constraint firstAttribute="centerX"  secondAttribute="centerX">
			<xsl:attribute name="firstItem"><xsl:value-of select="@id"/>-L</xsl:attribute>
			<xsl:attribute name="secondItem"><xsl:value-of select="$viewId"/>-ITM</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="@id" />-centerX-centerX-1</xsl:attribute>
		</constraint>
		<constraint firstAttribute="top"  secondAttribute="top">
			<xsl:attribute name="firstItem"><xsl:value-of select="@id"/>-L</xsl:attribute>
			<xsl:attribute name="secondItem"><xsl:value-of select="$viewId"/>-ITM</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="@id" />-top-top-2</xsl:attribute>
            <xsl:attribute name="constant"><xsl:value-of select="$posY + 5"/></xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
		</constraint>
		
		<constraint firstAttribute="centerX"  secondAttribute="centerX">
			<xsl:attribute name="firstItem"><xsl:value-of select="@id"/>-C</xsl:attribute>
			<xsl:attribute name="secondItem"><xsl:value-of select="$viewId"/>-ITM</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="@id" />-centerX-centerX-3</xsl:attribute>
		</constraint>
		<constraint firstAttribute="top"  secondAttribute="top">
			<xsl:attribute name="firstItem"><xsl:value-of select="@id"/>-C</xsl:attribute>
			<xsl:attribute name="secondItem"><xsl:value-of select="$viewId"/>-ITM</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="@id" />-top-top-4</xsl:attribute>
            <xsl:attribute name="constant"><xsl:value-of select="$posY + 31"/></xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
		</constraint>
		<constraint firstAttribute="leading"  secondAttribute="leading" constant="3">
    	    <xsl:attribute name="multiplier">1</xsl:attribute>
			<xsl:attribute name="firstItem"><xsl:value-of select="@id"/>-L</xsl:attribute>
			<xsl:attribute name="secondItem"><xsl:value-of select="$viewId"/>-ITM</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="@id" />-leading-leading-5</xsl:attribute>
		</constraint>
		<constraint firstAttribute="leading"  secondAttribute="leading" constant="3">
    	    <xsl:attribute name="multiplier">1</xsl:attribute>
			<xsl:attribute name="firstItem"><xsl:value-of select="@id"/>-C</xsl:attribute>
			<xsl:attribute name="secondItem"><xsl:value-of select="$viewId"/>-ITM</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="@id" />-leading-leading-6</xsl:attribute>
		</constraint>
		
	<xsl:apply-templates select="following-sibling::subView[1]" mode="constraintsForListItem">
		<xsl:with-param name="controllerId"><xsl:value-of select="$controllerId"/></xsl:with-param>
		<xsl:with-param name="posY"><xsl:value-of select="$posY + 101"/></xsl:with-param>
		<xsl:with-param name="viewId"><xsl:value-of select="$viewId"/></xsl:with-param>
	</xsl:apply-templates>
	
</xsl:template>

<!- views for a list item ->
<xsl:template match="subView[customClass='MFDatePicker']" mode="viewForListItem">
	<xsl:param name="controllerId"/>
	<xsl:param name="posY"/>

	<view contentMode="scaleToFill" translatesAutoresizingMaskIntoConstraints="NO" customClass="MFLabel">
		<xsl:attribute name="id"><xsl:value-of select="@id"/>-L</xsl:attribute>
	 	<constraints>
        	<constraint firstAttribute="height" constant="21">
	    	    <xsl:attribute name="multiplier">1</xsl:attribute>
            	<xsl:attribute name="id"><xsl:value-of select="@id" />-height-L</xsl:attribute>
        	</constraint>
        </constraints>
		
	</view>
	<view contentMode="scaleToFill" translatesAutoresizingMaskIntoConstraints="NO" customClass="MFDatePicker">
		<xsl:attribute name="id"><xsl:value-of select="@id"/>-C</xsl:attribute>
<!- 		<rect key="frame" x="5" width="{@width}" height="{@height}"> ->
<!- 			<xsl:attribute name="y"><xsl:value-of select="$posY + 23"/></xsl:attribute> ->
	 	<constraints>
        	<constraint firstAttribute="height" constant="{@height}">
	    	    <xsl:attribute name="multiplier">1</xsl:attribute>
            	<xsl:attribute name="id"><xsl:value-of select="@id" />-height-C</xsl:attribute>
        	</constraint>
        </constraints>
		
<!- 		</rect> ->
<!- 		<autoresizingMask key="autoresizingMask" widthSizable="YES" flexibleMaxY="YES"/> ->
		<color key="backgroundColor" white="0.0" alpha="0.0" colorSpace="calibratedWhite"/>
	</view>
			
	<xsl:apply-templates select="following-sibling::subView[1]" mode="viewForListItem">
		<xsl:with-param name="controllerId"><xsl:value-of select="$controllerId"/></xsl:with-param>
		<xsl:with-param name="posY"><xsl:value-of select="$posY + 101"/></xsl:with-param>
	</xsl:apply-templates>
	
</xsl:template>

<!- Compute outlet connection ->
<xsl:template match="subView[customClass='MFDatePicker']" mode="outletConnection">
	<outlet>
		<xsl:attribute name="property"><xsl:value-of select="propertyName"/>Label</xsl:attribute>
		<xsl:attribute name="destination"><xsl:value-of select="@id"/>-L</xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="@id"/>-L-OUT</xsl:attribute>
	</outlet>
	<outlet>
		<xsl:attribute name="property"><xsl:value-of select="propertyName"/></xsl:attribute>
		<xsl:attribute name="destination"><xsl:value-of select="@id"/>-C</xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="@id"/>-C-OUT</xsl:attribute>
	</outlet>
</xsl:template>

<!- Compute cell height ->
<xsl:template match="subView[customClass='MFDatePicker']" mode="computeCellHeightForListItem">
	<xsl:param name="cellHeight"/>
	
	<xsl:if test="count(following-sibling::subView) > 0">
		<!- if following sibling, continue to compute cell height ->
		<xsl:apply-templates select="following-sibling::subView[1]" mode="computeCellHeightForListItem">
			<xsl:with-param name="cellHeight"><xsl:value-of select="$cellHeight + 101"/></xsl:with-param>
		</xsl:apply-templates>
	</xsl:if>
	<xsl:if test="count(following-sibling::subView) = 0">
		<!- if no more following sibling, write height ->
		<xsl:value-of select="$cellHeight + 101"/>
	</xsl:if>
</xsl:template>
-->

</xsl:stylesheet>