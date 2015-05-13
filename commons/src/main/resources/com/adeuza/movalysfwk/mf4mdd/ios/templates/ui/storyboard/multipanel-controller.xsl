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

	<xsl:output method="xml" />

	<xsl:template match="controller[@controllerType='MULTIPANEL']" priority="10">

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

			<view key="view" contentMode="scaleToFill">
				<xsl:attribute name="id"><xsl:value-of select="@viewId" /></xsl:attribute>
				<rect key="frame" x="0.0" y="64" width="320" height="504" />
				<autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES" />
				<subviews>
				
					<!-- ********** subview containerView ********* -->
					<xsl:apply-templates select="connections/connection" mode="multipanel-containerview"/>
					
				</subviews>
				<color key="backgroundColor" white="1" alpha="1" colorSpace="calibratedWhite"/>
				
				<!-- *********** constraint for 2 subviews *************** -->
				<constraints>
						<xsl:apply-templates select="sections/section/subViews/subView" mode="constraints-generation">
							<xsl:with-param name="containerId"><xsl:value-of select="@viewId"/></xsl:with-param>
						</xsl:apply-templates>
						
						<xsl:apply-templates select="sections/section/subViews/subView[not(position()=1)]" mode="multipanel-constraints">
							<xsl:with-param name="containerId"><xsl:value-of select="@viewId"/></xsl:with-param>
							<xsl:with-param name="firstViewId"><xsl:value-of select="sections/section/subViews/subView[position()=1]/@id"/></xsl:with-param>
						</xsl:apply-templates>
						
				</constraints>
			</view>
			
			<extendedEdge key="edgesForExtendedLayout"/>
			<simulatedNavigationBarMetrics key="simulatedTopBarMetrics" prompted="NO"/>
		</viewController>

	</xsl:template>


	<xsl:template match="connection" mode="multipanel-containerview">
	
		<xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
		<xsl:variable name="containerViewId"><xsl:value-of select="../../sections/section/subViews/subView[position()=$pos]/@id"/></xsl:variable>
		<xsl:variable name="containerViewPosX"><xsl:value-of select="../../sections/section/subViews/subView[position()=$pos]/@posX"/></xsl:variable>
		<xsl:variable name="containerViewPosY"><xsl:value-of select="../../sections/section/subViews/subView[position()=$pos]/@posY"/></xsl:variable>
		<xsl:variable name="containerViewHeight"><xsl:value-of select="../../sections/section/subViews/subView[position()=$pos]/@height"/></xsl:variable>
		<xsl:variable name="containerViewWidth"><xsl:value-of select="../../sections/section/subViews/subView[position()=$pos]/@width"/></xsl:variable>
		
<!-- 		<xsl:comment> -->
<!-- 			###################### -->
<!-- 			dest id = <xsl:value-of select="destination/@id"/> -->
<!-- 			position = <xsl:value-of select="$pos"/> -->
<!-- 			container id = <xsl:value-of select="$containerViewId"/> -->
<!-- 			###################### -->
<!-- 			subview id = <xsl:value-of select="../../sections/section/subViews/subView[position()=$pos]/@id"/> -->
<!-- 			###################### -->
			
<!-- 		</xsl:comment> -->
			
		<containerView contentMode="scaleToFill" translatesAutoresizingMaskIntoConstraints="NO">
			<xsl:attribute name="id"><xsl:value-of select="$containerViewId"/></xsl:attribute>
			
			<rect key="frame" x="0.0" y="0.0" width="320" height="252">
				<xsl:attribute name="x"><xsl:value-of select="$containerViewPosX"/></xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="$containerViewPosY"/></xsl:attribute>
				<xsl:attribute name="width"><xsl:value-of select="$containerViewWidth"/></xsl:attribute>
				<xsl:attribute name="height"><xsl:value-of select="$containerViewHeight"/></xsl:attribute>
			</rect>
			<autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
			<color key="backgroundColor" white="1" alpha="1" colorSpace="custom" customColorSpace="calibratedWhite"/>
			<connections>
				<segue kind="embed">
					<xsl:attribute name="destination"><xsl:value-of select="destination/@id"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="destination/@id"/><xsl:value-of select="$containerViewId"/></xsl:attribute>
				</segue>
			</connections>
		</containerView>
		
	</xsl:template>

	<xsl:template match="*" mode="multipanel-containerview" priority="-900">
		<xsl:comment> cas non gerer mode="multipanel-containerview"</xsl:comment>
	</xsl:template>
	
	<xsl:template match="subView" mode="multipanel-constraints">
		<xsl:param name="containerId"/>
		<xsl:param name="firstViewId"/>
		
		<!-- height of view == 1th cell height -->
		<constraint firstAttribute="height" secondAttribute="height">
			<xsl:attribute name="secondItem"><xsl:value-of select="@id"/></xsl:attribute>
			<xsl:attribute name="firstItem"><xsl:value-of select="$firstViewId"/></xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="$firstViewId"/>-height-<xsl:value-of select="@id"/>-height</xsl:attribute>
		</constraint>
		
		<xsl:if test="position() = last()">
			<!-- bottom of last view constrains with bottom of view -->
            <constraint firstAttribute="bottom" secondAttribute="bottom">
            	<xsl:attribute name="secondItem"><xsl:value-of select="@id"/></xsl:attribute>
				<xsl:attribute name="firstItem"><xsl:value-of select="$containerId"/></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="$containerId"/>-bottom-<xsl:value-of select="@id"/>-bottom</xsl:attribute>
			</constraint>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="*" mode="multipanel-constraints" priority="-900">
		<xsl:comment> cas non gerer mode="multipanel-constraints"</xsl:comment>
	</xsl:template>
	

</xsl:stylesheet>