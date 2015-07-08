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

<xsl:output method="text"/>	

<xsl:template match="class" mode="getter-setter">

	<xsl:for-each select="//*[(name() = 'attribute' or name()= 'association') and not(parent::association)]">
	/** 
	 * {@inheritDoc}
	 * 
<xsl:if test="../implements">	 * @see <xsl:value-of select="../implements/interface/@full-name"/>#<xsl:value-of select="get-accessor"/>()</xsl:if>
<xsl:if test="../../implements">	 * @see <xsl:value-of select="../../implements/interface/@full-name"/>#<xsl:value-of select="get-accessor"/>()</xsl:if>
	 */
	@Override
	public<xsl:text> </xsl:text>
					<xsl:value-of select="@type-short-name"/>
		<xsl:if test="@contained-type-short-name">
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="@contained-type-short-name"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text><xsl:value-of select="get-accessor"/>() {
		<xsl:if test="@derived = 'false' or name() = 'association'">
		return this.<xsl:value-of select="@name"/> ;
		</xsl:if>
		<xsl:if test="@derived = 'true' and name() = 'attribute'">
			<xsl:variable name="derivedGetter"><xsl:value-of select="@name"/><xsl:text>-getter</xsl:text></xsl:variable>
			//@non-generated-start[<xsl:value-of select="$derivedGetter"/>]
			<xsl:choose>
				<xsl:when test="/class/non-generated/bloc[@id=$derivedGetter] != ''">
					<xsl:value-of select="/class/non-generated/bloc[@id=$derivedGetter]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>return </xsl:text><xsl:value-of select="@init"/><xsl:text>;</xsl:text>
				</xsl:otherwise>
			</xsl:choose><xsl:text>
			//@non-generated-end
		</xsl:text></xsl:if>
	}

	/**
	 * {@inheritDoc}
	 * 
<xsl:if test="../implements">	 * @see <xsl:value-of select="../implements/interface/@full-name"/>#<xsl:value-of select="set-accessor"/></xsl:if>
<xsl:if test="../../implements">	 * @see <xsl:value-of select="../../implements/interface/@full-name"/>#<xsl:value-of select="set-accessor"/></xsl:if>
	 <xsl:text>(</xsl:text><xsl:value-of select="@type-name"/><xsl:text>)</xsl:text>
	 */
	@Override
	<xsl:text>public void </xsl:text>
	<xsl:value-of select="set-accessor"/>( <xsl:value-of select="@type-short-name"/>
		<xsl:if test="@contained-type-short-name">
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="@contained-type-short-name"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:value-of  select="parameter-name"/> ) {
		<xsl:if test="(name() = 'attribute' and not(parent::association) and @derived = 'false') or (name()= 'association' and  (@type='many-to-one' or @type='one-to-one') and not(parent::association))">
<!-- 			<xsl:if test="name()= 'attribute'">this.onSetterAttribute(<xsl:value-of select="//implements/interface/@name"/>.ATTRIBUTES.<xsl:value-of select="@name-uppercase"/>);</xsl:if> -->
<!-- 			<xsl:if test="name()= 'association'">this.onSetter(<xsl:value-of select="//implements/interface/@name"/>.ATTRIBUTES.<xsl:value-of select="@cascade-name"/>, this.<xsl:value-of select="@name"/>, <xsl:value-of select="parameter-name"/> );</xsl:if> -->
			this.<xsl:value-of select="@name"/> = <xsl:value-of select="parameter-name"/>;
		</xsl:if>
		<xsl:if test="name() = 'attribute' and not(parent::association) and @derived = 'true'">
<xsl:variable name="derivedGetter"><xsl:value-of select="@name"/><xsl:text>-setter</xsl:text></xsl:variable>
//@non-generated-start[<xsl:value-of select="$derivedGetter"/>]
<xsl:value-of select="/class/non-generated/bloc[@id=$derivedGetter]"/>
<xsl:text>//@non-generated-end</xsl:text>
		</xsl:if>
		<xsl:if test="(name()= 'association' and  (@type='one-to-many' or @type='many-to-many')) and not(parent::association)">
		this.<xsl:value-of select="@name"/> = <xsl:value-of select="parameter-name"/>;</xsl:if>
		
		<xsl:if test="name() = 'association'">
			<xsl:variable name="asso" select="."/>
			<xsl:for-each select="../attribute[parameters/parameter[@name = 'fkidholder-assoname'] = $asso/@name]">
				if ( this.<xsl:value-of select="$asso/@name"/> != null ) {
					this.<xsl:value-of select="@name"/> = this.<xsl:value-of select="$asso/@name"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="$asso/attribute/get-accessor"/>();
				}
				else {
					this.<xsl:value-of select="@name"/> = <xsl:value-of select="@init"/> ;
				}
			</xsl:for-each>
		</xsl:if>
		
		<xsl:variable name="setter" select="concat('setter-', @name)"/>
//@non-generated-start[setter-<xsl:value-of select="@name"/>]
	<xsl:value-of select="/class/non-generated/bloc[@id=$setter]"/>
	<xsl:text>	//@non-generated-end[setter-</xsl:text><xsl:value-of select="@name"/>]
	}
	</xsl:for-each>
	
</xsl:template>
</xsl:stylesheet>
