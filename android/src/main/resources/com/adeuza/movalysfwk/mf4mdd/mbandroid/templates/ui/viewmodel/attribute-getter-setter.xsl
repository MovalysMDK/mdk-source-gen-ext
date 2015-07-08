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
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
<!-- Generate getter/setter for viewmodel non derived attribute -->
<xsl:template match="attribute" mode="generate-attribute-get-and-set">
	/** 
	 * {@inheritDoc}
	 */
	@Override
	<xsl:text>public </xsl:text>
	<xsl:value-of select="@type-short-name"/>
	<xsl:if test="@contained-type-short-name">
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="@contained-type-short-name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:if>
	<xsl:text> </xsl:text><xsl:value-of select="get-accessor"/><xsl:text>() {&#13;</xsl:text>
	<xsl:text>return this.</xsl:text><xsl:value-of select="@name"/><xsl:text>;&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>

	/** 
	 * {@inheritDoc}
	 */
	@Override
	<xsl:text>public void </xsl:text>
	<xsl:value-of select="set-accessor"/><xsl:text>( </xsl:text><xsl:value-of select="@type-short-name"/>
	<xsl:if test="@contained-type-short-name">
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="@contained-type-short-name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:if>
	<xsl:text> </xsl:text>
	<xsl:value-of  select="parameter-name"/>
	<xsl:text> ) {&#13;</xsl:text>
		
	<xsl:choose>
	
		<xsl:when test="@primitif='true' or @type-name='long' or @type-name='int' or @type-name='double' or @type-name='float' or @enum='true'">
			<xsl:text>this.affect</xsl:text>
			<xsl:choose>
				<xsl:when test="wrapper and not(@enum='true')">
					<xsl:value-of select="@type-short-name-capitalized"/>
				</xsl:when>
				<xsl:when test="@enum='true'">
					<xsl:text>Enum</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@type-name"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>AndNotify(</xsl:text>
		</xsl:when>
	
		<xsl:otherwise>
			<xsl:text>this.affectObjectAndNotify(</xsl:text>
		</xsl:otherwise>
	
	</xsl:choose>
	
	<xsl:text>this.</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>, </xsl:text>
	<xsl:value-of select="parameter-name"/>
	<xsl:text>, KEY_</xsl:text>
	<xsl:value-of select="@name-uppercase"/>
	<xsl:text>);&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>

</xsl:stylesheet>
