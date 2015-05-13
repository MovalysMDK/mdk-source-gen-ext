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

<!-- *************************************************
*****  
*****  ENTRY POINT:
*****  
*****  /xib-container
*****  
****************************************************** -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<xsl:output method="xml" indent="yes"/>

	<xsl:include href="ui/subviews.xsl"/>
	
	<xsl:template match="xib-container">
		
		<xsl:variable name="filteredComponentList" select="/xib-container/components/component[(localization='DEFAULT' or localization = 'LIST')]"/>
		<xsl:comment> [xib-fixedlistitem.xsl] xib-container(name=<xsl:value-of select="name"/>) </xsl:comment>
		
		<document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="6250" systemVersion="13E28" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" launchScreen="NO" useTraitCollections="YES">
		    <dependencies>
		        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="6244"/>
		        <capability name="Constraints with non-1.0 multipliers" minToolsVersion="5.1"/>
		        <capability name="Constraints to layout margins" minToolsVersion="6.0"/>
		    </dependencies>
			<objects>
		        <placeholder placeholderIdentifier="IBFilesOwner" 		id="-1" userLabel="File's Owner" /> <!--  customClass="UIApplication"/-->
		       	<placeholder placeholderIdentifier="IBFirstResponder" 	id="-2" userLabel="First Responder" /><!--  customClass="UIResponder"/-->


				<tableViewCell contentMode="scaleToFill" selectionStyle="blue" hidesAccessoryWhenEditing="NO" indentationLevel="1" indentationWidth="0.0" 
				customClass="MFCell1ComponentHorizontal">
					<xsl:attribute name="reuseIdentifier"><xsl:value-of select="name"/></xsl:attribute>
					<xsl:attribute name="customClass"><xsl:value-of select="cellitem-fixedlist-name"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="name"/>-tableViewCell</xsl:attribute>
					<!--  xsl:attribute name="rowHeight"><xsl:value-of select="@frameHeight"/></xsl:attribute -->
					
					<xsl:comment>This absolute positioning is used only for the interface builder of XCode. That will be overwritten by the relative positioning defined by the constaints</xsl:comment>
					<rect key="frame" >
						<xsl:attribute name="width"><xsl:value-of select="@frameWidth"/></xsl:attribute>
						<xsl:attribute name="height"><xsl:value-of select="@frameHeight"/></xsl:attribute>
						<xsl:attribute name="x"><xsl:value-of select="@cellMargin"/></xsl:attribute>
						<xsl:attribute name="y"><xsl:value-of select="@cellMargin"/></xsl:attribute>
					</rect>

		            <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMinY="YES"/>

					<tableViewCellContentView key="contentView" opaque="NO" clipsSubviews="YES" multipleTouchEnabled="YES" contentMode="center">
						<xsl:attribute name="id"><xsl:value-of select="name"/>-content</xsl:attribute>
						<xsl:attribute name="tableViewCell"><xsl:value-of select="name"/>-tableViewCell</xsl:attribute>
						
						<xsl:comment>This absolute positioning is used only for the interface builder of XCode. That will be overwritten by the relative positioning defined by the constaints</xsl:comment>
		                <rect key="frame" y="0.0" x="0.0" >
							<xsl:attribute name="width"><xsl:value-of select="@frameWidth - 2 * @cellMargin"/></xsl:attribute>
							<xsl:attribute name="height"><xsl:value-of select="@frameHeight - 2 * @cellMargin"/></xsl:attribute>
						</rect>
			            <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMinY="YES"/>

		                <subviews>
							<xsl:apply-templates select="$filteredComponentList" mode="subview-generation">
								<xsl:with-param name="controllerId"><xsl:value-of select="@id"/></xsl:with-param>
								<!-- **** => subviews.xsl *** -->
							</xsl:apply-templates>
						</subviews>
						<constraints>
							<xsl:apply-templates select="$filteredComponentList" mode="constraints-generation">
								<xsl:with-param name="cellMargin"><xsl:value-of select="@cellMargin"/></xsl:with-param>
								<xsl:with-param name="containerId"><xsl:value-of select="name"/>-content</xsl:with-param>
								<xsl:with-param name="filterNodeName">localization</xsl:with-param>
								<xsl:with-param name="filterNodeValue">LIST</xsl:with-param>
							</xsl:apply-templates>
						</constraints>
					</tableViewCellContentView>
					<connections>
						<xsl:apply-templates select="$filteredComponentList" mode="outlets-generation" >
							<xsl:with-param name="collection">false</xsl:with-param>
						</xsl:apply-templates>
					</connections>
					
				</tableViewCell>
			</objects>
		</document>
	</xsl:template>
		
	

</xsl:stylesheet>
