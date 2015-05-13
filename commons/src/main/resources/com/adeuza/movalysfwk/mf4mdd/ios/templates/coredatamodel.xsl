<?xml version="1.0" encoding="UTF-8" ?>
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

<xsl:template match="coredatamodel"><model name="" userDefinedModelVersionIdentifier="" type="com.apple.IDECoreDataModeler.DataModel" 
documentVersion="1.0" lastSavedToolsVersion="1811" systemVersion="12C60" minimumToolsVersion="Automatic" 
macOSVersion="Automatic" iOSVersion="Automatic">

	<xsl:apply-templates select="class">
		<xsl:sort select="name"  data-type="text" order="ascending"/>
	</xsl:apply-templates>
	
	<entity name="MObjectToSynchronize" representedClassName="MObjectToSynchronize" syncable="YES">
        <attribute name="identifier" optional="YES" attributeType="Integer 32" defaultValueString="0" syncable="YES"/>
        <attribute name="objectId" optional="YES" attributeType="Integer 32" defaultValueString="0" syncable="YES"/>
        <attribute name="objectName" optional="YES" attributeType="String" syncable="YES"/>
    </entity>
    <entity name="MParameter" representedClassName="MParameter" syncable="YES">
        <attribute name="identifier" optional="YES" attributeType="Integer 32" defaultValueString="0" syncable="YES"/>
        <attribute name="name" optional="YES" attributeType="String" syncable="YES"/>
        <attribute name="value" optional="YES" attributeType="String" syncable="YES"/>
    </entity>
	<!-- Transient configuration -->
    <configuration name="Transient">
	<xsl:apply-templates select="class[transient = 'true']" mode="configuration-transient"> 
		<xsl:sort select="name"  data-type="text" order="ascending"/>
	</xsl:apply-templates>
	</configuration>
    <configuration name="Database">
	<xsl:apply-templates select="class[transient = 'false']" mode="configuration-database"> 
		<xsl:sort select="name"  data-type="text" order="ascending"/>
	</xsl:apply-templates>
		<memberEntity name="MObjectToSynchronize"/>
		<memberEntity name="MParameter"/>
	</configuration>
	<elements>
		<xsl:apply-templates select="class" mode="diagram">
			<xsl:sort select="name"  data-type="text" order="ascending"/>
		</xsl:apply-templates>
		<element name="MObjectToSynchronize" positionX="0" positionY="0" width="0" height="0"/>
        <element name="MParameter" positionX="0" positionY="0" width="0" height="0"/>
	</elements>
</model></xsl:template>

<xsl:template match="class">
<entity>
	<xsl:attribute name="name"><xsl:value-of select="name"/></xsl:attribute>
	<xsl:attribute name="representedClassName"><xsl:value-of select="name"/></xsl:attribute>
	<xsl:attribute name="syncable">YES</xsl:attribute>
	
	<xsl:apply-templates select="identifier/attribute | attribute">
		<xsl:sort select="@name" order="ascending"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="identifier/association | association">
		<xsl:sort select="@name" order="ascending"/>
	</xsl:apply-templates>
   </entity>
</xsl:template>

<xsl:template match="attribute">
 	<attribute>
 		<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
 		<xsl:if test="@nullable = 'true'">
 			<xsl:attribute name="optional">YES</xsl:attribute>
 		</xsl:if>
 		<xsl:if test="@transient = 'true'">
 			<xsl:attribute name="transient">YES</xsl:attribute>
 		</xsl:if>
 		<xsl:attribute name="attributeType"><xsl:value-of select="coredata-type"/></xsl:attribute>
 		<xsl:if test="coredata-default-value">
 			<xsl:attribute name="defaultValueString">
				<xsl:value-of select="coredata-default-value"/>
 			</xsl:attribute>
 		</xsl:if>
 		<xsl:if test="parent::identifier[@is-composite = 'false']">
 			<xsl:attribute name="indexed">YES</xsl:attribute>
 		</xsl:if>
 		<xsl:attribute name="syncable">YES</xsl:attribute>
 	</attribute>
</xsl:template>

<xsl:template match="association">
	<relationship>
		<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
		<xsl:if test="@not-null = 'false' or @optional = 'true' or @transient = 'true'">
		<xsl:attribute name="optional">YES</xsl:attribute>
		</xsl:if>
		<xsl:if test="@transient = 'true'">
 			<xsl:attribute name="transient">YES</xsl:attribute>
 		</xsl:if>
 		<xsl:if test="@type='one-to-many' or @type='many-to-many'">
			<xsl:attribute name="toMany">YES</xsl:attribute>
			<xsl:attribute name="ordered">YES</xsl:attribute> 
		</xsl:if>
		<xsl:if test="@type='many-to-one' or @type='one-to-one'">
			<xsl:if test="@not-null = 'true' or @optional = 'false'">
				<xsl:attribute name="minCount">1</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="maxCount">1</xsl:attribute>
		</xsl:if>
		<xsl:attribute name="deletionRule">
			<xsl:choose>
				<xsl:when test="@opposite-aggregate-type='AGGREGATE'">
					<xsl:text>Nullify</xsl:text>
				</xsl:when>
				<xsl:when test="@opposite-aggregate-type='COMPOSITE'">
					<xsl:text>Cascade</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Nullify</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="destinationEntity"><xsl:value-of select="interface/name"/></xsl:attribute>
		<xsl:if test="@opposite-navigable = 'true'">
			<xsl:attribute name="inverseName"><xsl:value-of select="@opposite-name"/></xsl:attribute>
			<xsl:attribute name="inverseEntity"><xsl:value-of select="interface/name"/></xsl:attribute>
		</xsl:if>
		<xsl:attribute name="syncable">YES</xsl:attribute>
	</relationship>
</xsl:template>

<!-- Transient configuration -->
<xsl:template match="class" mode="configuration-transient">
	<memberEntity>
		<xsl:attribute name="name"><xsl:value-of select="name"/></xsl:attribute>
	</memberEntity>
</xsl:template>

<!-- Database configuration -->
<xsl:template match="class" mode="configuration-database">
	<memberEntity>
		<xsl:attribute name="name"><xsl:value-of select="name"/></xsl:attribute>
	</memberEntity>
</xsl:template>

<!-- Persistent configuration -->
<xsl:template match="class" mode="configuration-persistent">
	<memberEntity>
		<xsl:attribute name="name"><xsl:value-of select="name"/></xsl:attribute>
	</memberEntity>
</xsl:template>

<xsl:template match="class" mode="diagram">

	<element>
		<xsl:attribute name="name"><xsl:value-of select="name"/></xsl:attribute>
		<xsl:attribute name="positionX"><xsl:value-of select="@pos-x"/></xsl:attribute>
		<xsl:attribute name="positionY"><xsl:value-of select="@pos-y"/></xsl:attribute>
		<xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
		<xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
	</element>

</xsl:template>

</xsl:stylesheet>