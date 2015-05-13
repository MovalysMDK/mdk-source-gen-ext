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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ex="http://exslt.org/dates-and-times"
	extension-element-prefixes="ex">

<!-- *************************************************
*****  
***** ENTRY POINT:
*****  	/storyboard/scenes/*scene/controller[@controllerType='VIEW']
*****  
****************************************************** -->


	<xsl:output method="xml" />

	<xsl:template match="controller[@controllerType='VIEW']">

		<xsl:comment>
			#############################
			Controller type = '<xsl:value-of select="@controllerType" />'-<xsl:value-of select="@type" />
			Controller ID = '<xsl:value-of select="@id" />'
			View ID = '<xsl:value-of select="@viewId" />'
			Generation time = <xsl:value-of select="ex:date-time()" />
			#############################
		</xsl:comment>


		<viewController sceneMemberID="viewController">
			<xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
			<xsl:attribute name="customClass"><xsl:value-of select="customClass/name" /></xsl:attribute>
			<xsl:attribute name="storyboardIdentifier"><xsl:value-of select="customClass/name" /></xsl:attribute>

			<layoutGuides>
				<viewControllerLayoutGuide type="top">
					<xsl:attribute name="id"><xsl:value-of select="@id" />-LG-top</xsl:attribute>
				</viewControllerLayoutGuide>
				<viewControllerLayoutGuide type="bottom">
					<xsl:attribute name="id"><xsl:value-of select="@id" />-LG-bottom</xsl:attribute>
				</viewControllerLayoutGuide>
			</layoutGuides>

			<view key="view" contentMode="scaleToFill">
				<xsl:attribute name="id"><xsl:value-of select="@viewId" /></xsl:attribute>
				<rect key="frame" x="0.0" y="64" width="320" height="504" />
				<autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES" />
				<subviews>
					<xsl:apply-templates select="sections/section/subViews/subView" mode="subview-generation" >
						<xsl:with-param name="controllerId"><xsl:value-of select="@id"/></xsl:with-param>
						<!-- **** => subviews.xsl *** -->
					</xsl:apply-templates>
				</subviews>
				<color key="backgroundColor" white="1" alpha="1" colorSpace="calibratedWhite"/>
				<constraints>
					<xsl:apply-templates select="sections/section/subViews/subView" mode="constraints-generation">
						<xsl:with-param name="cellMargin"><xsl:value-of select="@cellMargin"/></xsl:with-param>
						<xsl:with-param name="containerId"><xsl:value-of select="@viewId" /></xsl:with-param>
					</xsl:apply-templates>
				</constraints>
			</view>
			<navigationItem key="navigationItem">
				<xsl:attribute name="id"><xsl:value-of select="@navigationItemId"></xsl:value-of></xsl:attribute>
			</navigationItem>
			<connections>
				<xsl:apply-templates select="sections/section/subViews/subView" mode="outlets-generation" >
					<xsl:with-param name="collection">true</xsl:with-param>
				</xsl:apply-templates>
			</connections>
			<extendedEdge key="edgesForExtendedLayout"  />
		</viewController>
	</xsl:template>
</xsl:stylesheet>