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

	<xsl:template match="controller[@controllerType='WORKSPACE']" priority="10">

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
				<xsl:attribute name="customClass">MFWorkspaceView</xsl:attribute>
				<rect key="frame" x="0.0" y="64" width="320" height="504" />
				<autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES" />
				<subviews>
					<xsl:apply-templates select="sections/section/subViews/subView" />

				</subviews>
				<color key="backgroundColor" cocoaTouchSystemColor="scrollViewTexturedBackgroundColor" />
				<constraints>
					<xsl:apply-templates select="sections/section/subViews/subView" mode="constraints">
						<xsl:with-param name="controllerId">
							<xsl:value-of select="@viewId" />
						</xsl:with-param>
					</xsl:apply-templates>
				</constraints>

			</view>
<!-- 			<navigationItem key="navigationItem" id="8XU-3u-9nL"> -->
<!-- 				<xsl:attribute name="id"><xsl:value-of select="@navigationItemId"></xsl:value-of></xsl:attribute> -->
<!-- 			</navigationItem> -->
			<userDefinedRuntimeAttributes>
				<userDefinedRuntimeAttribute type="string" keyPath="mf.formDescriptorName">
					<xsl:attribute name="value"><xsl:value-of select="name"/></xsl:attribute>
				</userDefinedRuntimeAttribute>
				<xsl:if test="isInCommentScreen = 'true'">
					<userDefinedRuntimeAttribute type="string" keyPath="mf.commentHTMLFileName">
						<xsl:attribute name="value"><xsl:value-of select="name"/></xsl:attribute>
					</userDefinedRuntimeAttribute>
			    </xsl:if>
			</userDefinedRuntimeAttributes>
			<connections>

				<xsl:variable name="sourceId">
					<xsl:value-of select="@id" />
				</xsl:variable>
				<xsl:for-each select="connections/connection">

					<segue kind="custom" customClass="MFWorkspaceColumnSegue">
						<xsl:attribute name="destination"><xsl:value-of select="destination/@id" /></xsl:attribute>
						<xsl:attribute name="identifier">column<xsl:value-of select="position()" /></xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of select="destination/@id" /><xsl:value-of select="$sourceId" /></xsl:attribute>
					</segue>

				</xsl:for-each>
			</connections>
			<extendedEdge key="edgesForExtendedLayout"/>
		</viewController>

	</xsl:template>


</xsl:stylesheet>