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
	
	<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode ="generate-attributes">
		<xsl:text>/**&#13; * fixedlist on </xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>&#13;*/&#13;</xsl:text>
		<xsl:variable name="attribute" select="concat('attribute-lst', implements/interface/@name)"/>	
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId"><xsl:value-of select="$attribute"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>@FixedListViewModel</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>private </xsl:text>
		<xsl:value-of select="./type/list"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>&gt; lst</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>;&#13;&#13;</xsl:text>
	</xsl:template>
	
	<!-- OLD working -->
	<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-attributes">
		<xsl:text>/**&#13; * selected element on combo </xsl:text>
		<xsl:text>&#13;*/&#13;</xsl:text>
		<xsl:text>@NonClonableViewModel&#13;&#13;</xsl:text>
		<xsl:text>private </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> o</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>;&#13;&#13;</xsl:text>

		<xsl:text>/**&#13; * combo attribute </xsl:text>
		<xsl:text>&#13;*/&#13;</xsl:text>
		<xsl:text>private </xsl:text>
		<xsl:value-of select="./type/list"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>&gt; lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text> = null;&#13;&#13;</xsl:text>
	</xsl:template>
	
	<!-- NEW NOT WORKING -->
	<!-- <xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-attributes">
		<xsl:param name="parentVmType"/>
		
		<xsl:if test="parentVmType != 'LIST_1' and parentVmType != 'LIST_2' and parentVmType != 'LIST_3'">
			<xsl:text>@NonClonableViewModel&#13;&#13;</xsl:text>
			<xsl:text>private </xsl:text>
			<xsl:value-of select="./implements/interface/@name"/>
			<xsl:text> o</xsl:text>
			<xsl:value-of select="./implements/interface/@name"/>
			<xsl:text>;&#13;&#13;</xsl:text>
		</xsl:if>

		<xsl:text>private </xsl:text>
		<xsl:value-of select="./type/list"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>&gt; lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>;&#13;&#13;</xsl:text>
	</xsl:template> -->
	
	<xsl:template match="subvm/viewmodel/external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-attributes">
		<xsl:text>/**&#13; * combo attribute </xsl:text>
		<xsl:text>&#13;*/&#13;</xsl:text>
		<xsl:text>private </xsl:text>
		<xsl:value-of select="./type/list"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>&gt; lst</xsl:text>
		<xsl:value-of select="./implements/interface/@name"/>
		<xsl:text>;&#13;&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="viewmodel[workspace-vm='false']/subvm/viewmodel[type/name='LISTITEM_1' or type/name='LISTITEM_2' or type/name='LISTITEM_3' ]" mode="generate-attributes">
		<xsl:text>/**&#13; * list attribute </xsl:text>
		<xsl:text>&#13;*/&#13;</xsl:text>
		private <xsl:value-of select="./type/list"/>&lt;
		<xsl:value-of select="./entity-to-update/name"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="substring(./name,0,string-length(./name)-3)"/>
		<xsl:text>&gt; lst</xsl:text>
		<xsl:value-of select="./name"/>;
	</xsl:template>

	<xsl:template match="viewmodel" mode="generate-attributes">
		<xsl:text>/**&#13; * view model attribute </xsl:text>
		<xsl:text>&#13;*/&#13;</xsl:text>
		<xsl:text>private </xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> o</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>;&#13;</xsl:text>
	</xsl:template>
	
	
</xsl:stylesheet>
