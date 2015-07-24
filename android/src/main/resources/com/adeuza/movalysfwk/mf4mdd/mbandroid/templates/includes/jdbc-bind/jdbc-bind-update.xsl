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

<xsl:template name="jdbc-bind-update">
	<xsl:param name="interface"/>
	<xsl:param name="object"/>
	<xsl:param name="statement"/>
	<xsl:param name="posOffset" select="0"/>
	
	<xsl:if test="parent::class or parent::identifier">
	
		<xsl:call-template name="jdbc-bind">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="statement" select="$statement"/>
			<xsl:with-param name="valeur"><xsl:value-of select="$object"/>.<xsl:value-of select="get-accessor"/>()</xsl:with-param>
		</xsl:call-template>
		<xsl:text>;
		</xsl:text>		
	</xsl:if>
	
	<xsl:if test="count(ancestor::association) = 1 and ../@transient = 'false'">
		if ( <xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/>
				<xsl:text>() != null </xsl:text>
			
		<xsl:if test="@unsaved-value">
			<xsl:text> &amp;&amp; </xsl:text>
			<xsl:if test="@primitif = 'true'">
				<xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/>
				<xsl:text>().</xsl:text><xsl:value-of select="get-accessor"/>
				<xsl:text>()</xsl:text> 				
				<xsl:text> != </xsl:text>
				<xsl:value-of select="@unsaved-value"/>
			</xsl:if>
			<xsl:if test="@primitif = 'false'">
				<xsl:text>!</xsl:text>
				<xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/>
				<xsl:text>().</xsl:text><xsl:value-of select="get-accessor"/>
				<xsl:text>().equals(</xsl:text> 				
				<xsl:value-of select="@unsaved-value"/>
				<xsl:text>)</xsl:text>
			</xsl:if> 
		</xsl:if>
			
		<xsl:text>) { </xsl:text>
		<xsl:call-template name="jdbc-bind">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="statement" select="$statement"/>
			<xsl:with-param name="valeur"><xsl:value-of select="$object"/>.<xsl:value-of select="../get-accessor"/>
				<xsl:text>().</xsl:text><xsl:value-of select="get-accessor"/>()</xsl:with-param>
		</xsl:call-template>
		<xsl:text>;</xsl:text>
		} else {
			<xsl:if test="../@optional = 'true'">
				<xsl:value-of select="$statement"/>
				<xsl:text>.bindNull();</xsl:text>
			</xsl:if>
			<xsl:if test="../@optional = 'false'">
				throw new DaoException("Property '<xsl:value-of select="../@name"/>
				<xsl:text>' of object '</xsl:text>
				<xsl:value-of select="$interface/name"/>' is mandatory");
			</xsl:if>
		}
	</xsl:if>
		<xsl:if test="count(ancestor::association) = 2  and ../../@transient = 'false' and ../@transient = 'false'">
		if ( <xsl:value-of select="$object"/>.<xsl:value-of select="../../get-accessor"/>
				<xsl:text>() != null &amp;&amp; </xsl:text><xsl:value-of select="$object"/>.<xsl:value-of select="../../get-accessor"/>().<xsl:value-of select="../get-accessor"/>
				<xsl:text>() != null ) { </xsl:text>
		<xsl:call-template name="jdbc-bind">
			<xsl:with-param name="interface" select="$interface"/>
			<xsl:with-param name="statement" select="$statement"/>
			<xsl:with-param name="valeur"><xsl:value-of select="$object"/>.<xsl:value-of select="../../get-accessor"/>().<xsl:value-of select="../get-accessor"/>
				<xsl:text>().</xsl:text><xsl:value-of select="get-accessor"/>()</xsl:with-param>
		</xsl:call-template>
		<xsl:text>;</xsl:text>
		} else {
			<xsl:if test="../../@optional = 'true'">
				<xsl:value-of select="$statement"/>
				<xsl:text>.bindNull();</xsl:text>
			</xsl:if>
			<xsl:if test="../../@optional = 'false'">
				throw new DaoException("Property '<xsl:value-of select="../@name"/>
				<xsl:text>' of object '</xsl:text>
				<xsl:value-of select="$interface/name"/>.<xsl:value-of select="../get-accessor"/>()' is mandatory");
			</xsl:if>
		}</xsl:if>

</xsl:template>

</xsl:stylesheet>